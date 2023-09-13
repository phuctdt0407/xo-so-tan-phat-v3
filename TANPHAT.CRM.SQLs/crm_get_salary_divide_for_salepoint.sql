-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_salary_divide_for_salepoint('2022-06');
-- ================================
SELECT dropallfunction_byname('crm_get_salary_divide_for_salepoint');
CREATE OR REPLACE FUNCTION crm_get_salary_divide_for_salepoint
(
	p_month VARCHAR
)
RETURNS TABLE
(
 	"Data" TEXT
)
AS $BODY$
DECLARE
		v_total_date INT := (SELECT date_part('days', (date_trunc('month', (p_month||'-01')::DATE) + INTERVAL '1 month - 1 day'))) :: INT;
		v_user RECORD;
		v_row JSON;
		v_total INT;
		v_time TIMESTAMP := NOW();
		v_sub INT;
		v_shift_dis INT;
		v_employee INT := 5;
		v_leader INT := 4;
		v_sale_point_id INT;
		v_date DATE;
		v_normal_price NUMERIC;
		v_sub_price NUMERIC;
		v_rice DECIMAL;
		v_overtime DECIMAL;
		v_event DECIMAL;
		v_salary_leader NUMERIC;
		v_coef_leader NUMERIC;
		v_KPI NUMERIC;
		v_sale_loto NUMERIC;
		v_type_name_0 VARCHAR := '"Lương thường"';
		v_type_name_1 VARCHAR := '"Lương tăng ca"';
		v_type_name_2 VARCHAR := '"Lương thưởng"';
		v_type_name_3 VARCHAR := '"Lương cộng thêm"';
		v_shift_id INT;
BEGIN
	--Bảng tạm chứa số tiền chi lương mỗi điểm bán
	CREATE TEMP TABLE SPoint ON COMMIT DROP AS (
		SELECT 
			SP."SalePointId",
			0::NUMERIC AS "TotalSalary",
			0::NUMERIC AS "TotalSalarySub",
			0::NUMERIC AS "TotalPriceForLunch",
			0::NUMERIC AS "TotalPriceTarget",
			'[]'::TEXT AS "LogData"
		FROM "SalePoint" SP
		WHERE SP."IsDeleted" IS FALSE
			AND SP."IsActive" IS TRUE
	);
	--Bảng tạm chứa danh sách ca làm
	CREATE TEMP TABLE ShiftD ON COMMIT DROP AS(
		SELECT 
			SD."ShiftDistributeId",
			SD."UserId",
			SD."SalePointId",
			SD."ShiftId",
			SD."DistributeDate"
		FROM "ShiftDistribute" SD
		WHERE TO_CHAR(SD."DistributeDate", 'YYYY-MM') = p_month
			AND ((SD."DistributeDate" :: DATE) :: TIMESTAMP + (((CASE WHEN SD."ShiftId" = 1 THEN '6' ELSE '13' END)||' hour') :: INTERVAL))  <= v_time
	);
	--Lấy các hằng số
	CREATE TEMP TABLE ConstData ON COMMIT DROP AS (
		SELECT
			A."ConstId",
			A."Price"
		FROM "Constant" A
		WHERE A."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
			AND A."CreatedDate" >= ALL(	
				SELECT
					C."CreatedDate"
				FROM "Constant" C 
				WHERE C."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
					AND C."ConstId" = A."ConstId"
			)
	);
	
	v_sale_loto := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 4)::NUMERIC;							--loto
	v_rice := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 2)::NUMERIC;										--Tiền cơm
	v_overtime := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 5)::NUMERIC;								--tăng ca
	v_event := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 6)::NUMERIC;									--lễ
	v_salary_leader := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 10)::NUMERIC;					--Lương cơ bản trưởng nhóm;
	v_coef_leader := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 11)::NUMERIC;						--Hệ số lương cơ bản trưởng nhóm;
	
	--Lấy các khoản lương của user
	CREATE TEMP TABLE KPIData ON COMMIT DROP AS (
		WITH tmp0 AS (
			SELECT 	
				K."UserId",
				ROUND(SUM(K."AverageKPI")/(CASE WHEN COUNT(K."AverageKPI") = 0 THEN 1 ELSE COUNT(K."AverageKPI") END), 2) AS "KPI"
			FROM crm_user_get_average_KPI_of_user_by_month(p_month, 0) K
			GROUP BY
				K."UserId"
		),
		tmp1 AS(
			SELECT 
				U."UserId",
				U."UserTitleId"
			FROM crm_get_user_ddl(0, (p_month||'-01')::TIMESTAMP) U
				LEFT JOIN "SalePoint" SP ON SP."SalePointId" = U."SalePointId"
		),
		tmp2 AS (
			SELECT 
				TD."TargetDataTypeId",
				TD."FromValue",
				TD."ToValue",
				TD."Value"
			FROM "TargetData" TD
			WHERE TD."IsDeleted" IS FALSE
		),
		--Doanh số nhân viên
		tmp3 AS (
			SELECT 
				T."UserId",
				T."Average"
			FROM crm_report_average_lottery_sell_of_user_to_current_date(p_month, 0, 0) T
		),
		-- Lấy danh sách lương làm thêm giờ/ thưởng/ phạt /Nọ
		tmp4 AS (
			SELECT 
				T."TransactionId",
				T."TotalPrice",
				T."UserId",
				T."ShiftDistributeId",
				T."SalePointId",
				T."TransactionTypeId",
				T."TypeNameId"
			FROM "Transaction" T 
			WHERE T."IsDeleted" IS FALSE
				AND (T."ShiftDistributeId" = ANY(SELECT SD."ShiftDistributeId" FROM ShiftD SD)
					OR T."ShiftDistributeId" IS NULL AND TO_CHAR(T."ActionDate", 'YYYY-MM') = p_month)
		),
		--Tính các loại thưởng
		tmp5 AS (
			SELECT 
				T."UserId",
				COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 2), 0) AS "SaleOfVietlott", 															--Doanh thu vietlot
				COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 3), 0) AS "SaleOfLoto"																	--Doanh thu loto
			FROM tmp4 T
			GROUP BY 
				T."UserId"
		),
		--Quy đổi hệ số 
		tmp6 AS (
			SELECT 	
				U."UserId",
				U."UserTitleId",
				COALESCE(A."Average", 0) AS "Average",
				COALESCE(S."SaleOfVietlott", 0) AS "SaleOfVietlott",
				COALESCE(S."SaleOfLoto", 0) AS "SaleOfLoto",
				COALESCE(K."KPI", 0) AS "KPI",
				(CASE
					WHEN U."UserTitleId" = v_employee AND COALESCE(K."KPI", 0)> (SELECT MAX(C."ToValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 4)::NUMERIC 
						THEN (SELECT MAX(C."Value") FROM tmp2 C WHERE C."TargetDataTypeId" = 4)::NUMERIC
					WHEN U."UserTitleId" = v_employee AND COALESCE(K."KPI", 0) < (SELECT MIN(C."FromValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 4)::NUMERIC
						THEN 0
					WHEN U."UserTitleId" = v_leader AND COALESCE(K."KPI", 0) > (SELECT MAX(C."ToValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 5)::NUMERIC 
						THEN (SELECT MAX(C."Value") FROM tmp2 C WHERE C."TargetDataTypeId" = 5)::NUMERIC
					WHEN U."UserTitleId" = v_leader AND COALESCE(K."KPI", 0) < (SELECT MIN(C."FromValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 5)::NUMERIC
						THEN 0
					ELSE T."Value" END ) AS "KPICoafficient"
			FROM tmp1 U
				LEFT JOIN tmp3 A ON U."UserId" = A."UserId"
				LEFT JOIN tmp5 S ON U."UserId" = S."UserId"
				LEFT JOIN tmp0 K ON K."UserId" = U."UserId"
				LEFT JOIN tmp2 T
					ON (T."TargetDataTypeId" = 4 
						AND (COALESCE(K."KPI", 0) > T."FromValue" AND COALESCE(K."KPI", 0) <= T."ToValue") 
						AND U."UserTitleId" = v_employee)
					OR (T."TargetDataTypeId" = 5 
						AND (COALESCE(K."KPI", 0) > T."FromValue" AND COALESCE(K."KPI", 0) <= T."ToValue")
						AND U."UserTitleId" = v_leader)
			WHERE U."UserTitleId" IN (v_leader, v_employee)
		),
		tmp7 AS (
			SELECT 
				U.*,
				(
					CASE 
						WHEN U."UserTitleId" <> v_leader THEN
						(
							CASE
								WHEN U."Average" > (SELECT MAX(C."ToValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 1)::NUMERIC 
									THEN (SELECT MAX(C."Value") FROM tmp2 C WHERE P."TargetDataTypeId" = 1)::NUMERIC
								WHEN U."Average" < (SELECT MIN(C."FromValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 1)::NUMERIC
									THEN 0
								ELSE P."Value" 
							END
						)
						ELSE 0
					END
				) AS "ReponsibilityLottery",
				(CASE
					WHEN U."SaleOfVietlott" > (SELECT MAX(C."ToValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 2)::NUMERIC 
						THEN (SELECT MAX(C."Value") FROM tmp2 C WHERE T."TargetDataTypeId" = 2)::NUMERIC
					WHEN U."SaleOfVietlott" < (SELECT MIN(C."FromValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 2)::NUMERIC
						THEN 0
					ELSE V."Value" END) AS "VietlottLottery",
				(CASE
					WHEN U."Average" > (SELECT MAX(C."ToValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 3)::NUMERIC 
						THEN (SELECT MAX(C."Value") FROM tmp2 C WHERE C."TargetDataTypeId" = 3)::NUMERIC
					WHEN U."Average" < (SELECT MIN(C."FromValue") FROM tmp2 C WHERE C."TargetDataTypeId" = 3)::NUMERIC
						THEN 0
					ELSE T."Value" END) AS "TraditionalLottery"
			FROM tmp6 U 
				LEFT JOIN tmp2 P ON P."TargetDataTypeId" = 1 AND (ROUND(U."Average", 0)::NUMERIC BETWEEN P."FromValue"::NUMERIC AND P."ToValue"::NUMERIC)
				LEFT JOIN tmp2 V ON V."TargetDataTypeId" = 2 AND (ROUND(U."SaleOfVietlott", 0)::NUMERIC BETWEEN V."FromValue"::NUMERIC AND V."ToValue"::NUMERIC)
				LEFT JOIN tmp2 T ON T."TargetDataTypeId" = 3 AND (ROUND(U."Average", 0)::NUMERIC BETWEEN T."FromValue" AND T."ToValue")
		)
		SELECT 
			U.*,
			(U."KPICoafficient" * (U."ReponsibilityLottery" + U."VietlottLottery" + U."TraditionalLottery" + v_sale_loto * U."SaleOfLoto")) AS "TotalAward"
		FROM tmp7 U
	);
		
	--bảng tạm chứa lương cơ bản mỗi nhân viên
	CREATE TEMP TABLE BSalary ON COMMIT DROP AS (
		SELECT 
			B."UserId", 
			B."CreatedDate",
			B."Salary",
			B."Salary"::NUMERIC / v_total_date AS "SalaryOneDate",
			B."Salary"::NUMERIC / v_total_date * v_overtime AS "SalaryOneDateSub"
		FROM "BasicSalary" B
		WHERE B."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
			AND B."CreatedDate" >= ALL(
				SELECT T."CreatedDate"
				FROM "BasicSalary" T 
				WHERE T."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
					AND T."UserId" = B."UserId"
			)
		ORDER BY 
			B."UserId"
	);
	
	FOR v_user IN (
		SELECT 
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."ListSalePoint"
		FROM crm_get_user_ddl(0, (p_month||'-01')::TIMESTAMP) U
			LEFT JOIN "SalePoint" SP ON SP."SalePointId" = U."SalePointId"
	) LOOP
			
		-- Nhân viên
		IF v_user."UserTitleId" = v_employee THEN 
		
			--Lương cơ bản 1 ngày 
			SELECT 
				B."SalaryOneDate",
				B."SalaryOneDateSub"
			INTO 
				v_normal_price,
				v_sub_price
			FROM BSalary B
			WHERE B."UserId" = v_user."UserId";
		
			--Tổng số ca đã làm
			SELECT
				COUNT(1) INTO v_total
			FROM "ShiftDistribute" SD 
			WHERE TO_CHAR(SD."DistributeDate", 'YYYY-MM') = p_month
				AND ((SD."DistributeDate" :: DATE) :: TIMESTAMP + (((CASE WHEN SD."ShiftId" = 1 THEN '6' ELSE '13' END)||' hour') :: INTERVAL))  <= v_time
				AND SD."UserId" = v_user."UserId";
			
			--Lấy số ca tăng ca
			v_sub := v_total - v_total_date;

			--Nếu có tăng ca thì cập nhật lại số ca trong vòng lặp và cộng thêm một công
			IF v_sub >= 0 THEN 
				v_total := v_total_date;
								
				UPDATE SPoint 
				SET 
					"TotalSalary" = "TotalSalary" + v_normal_price,
					"TotalPriceForLunch" = "TotalPriceForLunch" + v_rice,
					"LogData" = ("LogData"::JSONB || ('{"UserId": '||v_user."UserId"||',"Salary": '||v_normal_price||',"PriceForLunch": '||v_rice||',"TypeId": '||3||',"TypeName": '||v_type_name_3||'}')::JSONB)::TEXT
 				WHERE "SalePointId" = v_user."SalePointId";
				
			END IF;
			
			--Lặp qua số ca thường
			WHILE v_total > 0 LOOP
				
				SELECT 
					SD."ShiftDistributeId",
					SD."DistributeDate",
					SD."SalePointId",
					SD."ShiftId"
				INTO 
					v_shift_dis,
					v_date,
					v_sale_point_id,
					v_shift_id
				FROM ShiftD SD
				WHERE SD."UserId" = v_user."UserId"		
					AND SD."SalePointId" = v_user."SalePointId" 
				ORDER BY 
					SD."DistributeDate",
					SD."ShiftId"
				LIMIT 1;
				
				--Nếu ko tồn tại ca làm
				IF v_shift_dis IS  NULL THEN 
					SELECT 
						SD."ShiftDistributeId",
						SD."DistributeDate",
						SD."SalePointId",
						SD."ShiftId"
					INTO 
						v_shift_dis,
						v_date,
						v_sale_point_id,
						v_shift_id
					FROM ShiftD SD
					WHERE SD."UserId" = v_user."UserId"		
					ORDER BY 
						SD."DistributeDate",
						SD."ShiftId"
					LIMIT 1;
				END IF;
				
				--Xoá khỏi bảng tạm
				DELETE FROM ShiftD WHERE ShiftD."ShiftDistributeId" = v_shift_dis;
				--Tính tiền cho điểm bán
				UPDATE SPoint 
				SET "TotalSalary" = "TotalSalary" + v_normal_price
							* (CASE WHEN EXISTS(SELECT 1 FROM "EventDay" E WHERE E."Date" = v_date	AND E."IsDeleted" IS FALSE) THEN v_event ELSE 1 END),
						"TotalPriceForLunch" = "TotalPriceForLunch" + v_rice,
						"LogData" = ("LogData"::JSONB || ('{"UserId": '||v_user."UserId"||',"Salary": '|| v_normal_price
							* (CASE WHEN EXISTS(SELECT 1 FROM "EventDay" E WHERE E."Date" = v_date	AND E."IsDeleted" IS FALSE) THEN v_event ELSE 1 END)||',"PriceForLunch": '||v_rice||',"TypeId": '||0||',"TypeName": '||v_type_name_0||',"ShiftId": '||v_shift_id||',"DistributeDate": "'||v_date||'"}')::JSONB)::TEXT
 				WHERE "SalePointId" = v_sale_point_id;
							
				--Cập nhật lại giá trị lặp
				v_total := v_total - 1;
				
				--Xoá các giá trị 
				v_shift_dis := NULL;	
				v_date := NULL;
				v_sale_point_id := NULL;	
				v_shift_id := NULL;		
								
			END LOOP;
			
			--Lặp qua số ca tăng ca 
			WHILE v_sub > 0 LOOP
			
				--Lấy id ca làm không phải ca của điểm bán gốc
				SELECT 
					SD."ShiftDistributeId",
					SD."DistributeDate",
					SD."SalePointId",
					SD."ShiftId"
				INTO 
					v_shift_dis,
					v_date,
					v_sale_point_id,
					v_shift_id
				FROM ShiftD SD
				WHERE SD."UserId" = v_user."UserId"		
					AND SD."SalePointId" <> v_user."SalePointId" 
				ORDER BY 
					SD."DistributeDate",
					SD."ShiftId"
				LIMIT 1;
				
				--Nếu ko tồn tại ca làm
				IF v_shift_dis IS  NULL THEN 
					SELECT 
						SD."ShiftDistributeId",
						SD."DistributeDate",
						SD."SalePointId",
						SD."ShiftId"
					INTO 
						v_shift_dis,
						v_date,
						v_sale_point_id,
						v_shift_id
					FROM ShiftD SD
					WHERE SD."UserId" = v_user."UserId"	
						AND SD."SalePointId" = v_user."SalePointId" 
					ORDER BY 
						SD."DistributeDate",
						SD."ShiftId"
					LIMIT 1;
				END IF;
				
				--Xoá khỏi bảng tạm
				DELETE FROM ShiftD WHERE ShiftD."ShiftDistributeId" = v_shift_dis;
				--Tính tiền cho điểm bán
				UPDATE SPoint 
				SET "TotalSalarySub" = "TotalSalarySub" + v_sub_price
							* (CASE WHEN EXISTS(SELECT 1 FROM "EventDay" E WHERE E."Date" = v_date AND E."IsDeleted" IS FALSE) THEN v_event ELSE 1 END),
						"TotalPriceForLunch" = "TotalPriceForLunch" + v_rice,
						"LogData" = ("LogData"::JSONB || ('{"UserId": '||v_user."UserId"||',"Salary": '|| v_sub_price
							* (CASE WHEN EXISTS(SELECT 1 FROM "EventDay" E WHERE E."Date" = v_date AND E."IsDeleted" IS FALSE) THEN v_event ELSE 1 END)||',"PriceForLunch": '||v_rice||',"TypeId": '||1||',"TypeName": '||v_type_name_1||',"ShiftId": '||v_shift_id||',"DistributeDate": "'||v_date||'"}')::JSONB)::TEXT
				WHERE "SalePointId" = v_sale_point_id;
				
			
				--Cập nhật lại giá trị lặp
				v_sub := v_sub - 1;
				
				--Xoá các giá trị 
				v_shift_dis := NULL;	
				v_date := NULL;
				v_sale_point_id := NULL;	
				v_shift_id := NULL;
			END LOOP;
		
			IF (SELECT D."TotalAward" FROM KPIData D WHERE D."UserId" = v_user."UserId")::NUMERIC > 0 THEN 
			--Trả thưởng target
				UPDATE SPoint 
				SET 
					"TotalPriceTarget" = "TotalPriceTarget" + COALESCE((SELECT D."TotalAward" FROM KPIData D WHERE D."UserId" = v_user."UserId")::NUMERIC, 0),
					"LogData" = ("LogData"::JSONB || ('{"UserId": '||v_user."UserId"||',"Salary": '|| COALESCE((SELECT D."TotalAward" FROM KPIData D WHERE D."UserId" = v_user."UserId")::NUMERIC, 0) ||',"TypeId": '||2||',"TypeName": '||v_type_name_2||'}')::JSONB)::TEXT
				WHERE "SalePointId" = v_user."SalePointId"; 
			END IF;
						
		--Trưởng nhóm
		ELSEIF v_user."UserTitleId" = v_leader THEN
			
			v_KPI := (SELECT D."KPICoafficient" FROM KPIData D WHERE D."UserId" = v_user."UserId")::NUMERIC;
			FOR v_row IN SELECT json_array_elements((v_user."ListSalePoint")::JSON) LOOP
			
				UPDATE SPoint
				SET 
					"TotalSalary" = "TotalSalary" + v_salary_leader * v_coef_leader,
					"TotalPriceTarget" = v_KPI * v_salary_leader,
					"LogData" = ("LogData"::JSONB || 
											('{"UserId": '||v_user."UserId"||',"Salary": '||v_salary_leader * v_coef_leader||',"TypeId": '||0||',"TypeName": '||v_type_name_0||'}')::JSONB ||
											('{"UserId": '||v_user."UserId"||',"Salary": '|| v_KPI * v_salary_leader ||',"TypeId": '||2||',"TypeName": '||v_type_name_2||'}')::JSONB)::TEXT
				WHERE "SalePointId" = (v_row->>'SalePointId')::INT; 
				
			END LOOP;
		
		END IF;
			
	END LOOP; 
	

	RETURN QUERY 
	SELECT
		TO_JSONB(T.*)::TEXT
	FROM SPoint T;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

