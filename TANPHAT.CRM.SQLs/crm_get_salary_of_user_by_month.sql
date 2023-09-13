-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_salary_of_user_by_month('2022-07');
-- ================================
SELECT dropallfunction_byname('crm_get_salary_of_user_by_month');
CREATE OR REPLACE FUNCTION crm_get_salary_of_user_by_month
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	"UserTitleId" INT,
	"UserTitleName" VARCHAR,
	"SalaryData" TEXT
)
AS $BODY$
DECLARE
	v_total_date INT := (SELECT date_part('days', (date_trunc('month', (p_month||'-01')::DATE) + INTERVAL '1 month - 1 day'))) :: INT;
	v_union DECIMAL;
	v_rice DECIMAL;
	v_insure DECIMAL;
	v_sale_loto DECIMAL;
	v_overtime DECIMAL;
	v_event DECIMAL;
	v_l30 DECIMAL;
	v_l60 DECIMAL;
	v_l90 DECIMAL;
	v_time TIMESTAMP := NOW();
	v_salary_leader NUMERIC;
	v_coef_leader NUMERIC;
	v_employee INT := 5;
	v_leader INT := 4;
	v_hr INT := 6;
BEGIN
	
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
	
	v_union := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 1)::NUMERIC;									--Công đoàn
	v_rice := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 2)::NUMERIC;										--Tiền cơm
	v_insure := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 3)::NUMERIC;									--bảo hiểm
	v_sale_loto := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 4)::NUMERIC;							--loto
	v_overtime := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 5)::NUMERIC;								--tăng ca
	v_event := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 6)::NUMERIC;									--lễ
	v_l30 := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 7)::NUMERIC;										--tăng ca 30ph
	v_l60 := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 8)::NUMERIC;										--tăng ca 60ph
	v_l90 := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 9)::NUMERIC;										--tăng ca 90ph;
	v_salary_leader := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 10)::NUMERIC;					--Lương cơ bản trưởng nhóm;
	v_coef_leader := (SELECT C."Price" FROM ConstData C WHERE C."ConstId" = 11)::NUMERIC;						--Hệ số lương cơ bản trưởng nhóm;
		
	RETURN QUERY
	WITH tmp00 AS (
		SELECT 
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."ListSalePoint",
			SP."SalePointName"
		FROM crm_get_user_ddl(0, (p_month||'-01')::TIMESTAMP) U
			LEFT JOIN "SalePoint" SP ON SP."SalePointId" = U."SalePointId" 
	),
	--Lấy doanh số bán vé
	tmp0 AS (
		SELECT 
			T."UserId",
			T."Average"
		FROM crm_report_average_lottery_sell_of_user_to_current_date(p_month, 0, 0) T
	),
	--Lấy lương trưởng nhóm
	tmp01 AS (
		SELECT 
			GS."UserId",
			ARRAY_LENGTH(GS."SalePointIds", 1) AS "Length"
		FROM "GroupSalePoint" GS
		WHERE GS."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
			AND GS."Option" = 0
			AND GS."CreatedDate" >= ALL(	
				SELECT
					C."CreatedDate"
				FROM "GroupSalePoint" C 
				WHERE C."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
					AND C."UserId" = GS."UserId"
					AND C."Option" = 0
			)
	),
	--Lấy lương căn bản 1 ngày của tất cả nhân viên
	tmp AS (
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
	),
	--Lấy danh sách ca đã làm tới thời điểm hiện tại
	tmp1 AS (
		SELECT
			ROW_NUMBER() OVER(PARTITION BY SD."UserId" ORDER BY SD."DistributeDate", SD."ShiftId") AS "Id",
			SD."UserId",
			SD."ShiftDistributeId",
			SD."DistributeDate",
			SD."ShiftId",
			SD."SalePointId"
		FROM "ShiftDistribute" SD 
		WHERE TO_CHAR(SD."DistributeDate", 'YYYY-MM') = p_month
			AND ((SD."DistributeDate" :: DATE) :: TIMESTAMP + (((CASE WHEN SD."ShiftId" = 1 THEN '6' ELSE '13' END)||' hour') :: INTERVAL))  <= v_time
		GROUP BY
			SD."UserId",
			SD."ShiftDistributeId",
			SD."DistributeDate",
			SD."ShiftId",
			SD."SalePointId"
		ORDER BY 
			SD."UserId", 
			SD."DistributeDate", 
			SD."ShiftId"
	),	
	--Lấy bảng TargetData
	tmp2 AS (
		SELECT 
			TD."TargetDataTypeId",
			TD."FromValue",
			TD."ToValue",
			TD."Value"
		FROM "TargetData" TD
		WHERE TD."IsDeleted" IS FALSE
	),
	-- Lấy danh sách lương làm thêm giờ/ thưởng/ phạt /Nọ
	tmp3 AS (
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
			AND (T."ShiftDistributeId" = ANY(SELECT SD."ShiftDistributeId" FROM tmp1 SD)
				OR T."ShiftDistributeId" IS NULL AND TO_CHAR(T."ActionDate", 'YYYY-MM') = p_month)
	),
	--Tính các loại thưởng
	tmp4 AS (
		SELECT 
			T."UserId",
			COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 2), 0) AS "SaleOfVietlott", 															--Doanh thu vietlot
			COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 3), 0) AS "SaleOfLoto",																		--Doanh thu loto
			COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 4), 0) AS "Punish",																				--Phạt
			COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 5), 0) AS "Advance",																			--Ứng lương
			COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 6 AND T."TypeNameId" NOT IN (4,5,6)), 0) AS "Overtime",		--Làm lố giờ loại khác
			COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 7), 0) AS "Award",																				--Thưởng
			COALESCE(SUM("TotalPrice") FILTER(WHERE T."TransactionTypeId" = 8), 0) AS "Debt",																					--Nợ
			COALESCE(COUNT(1) FILTER(WHERE T."TransactionTypeId" = 6 AND T."TypeNameId" = 4), 0) AS "L30",														--làm lố 30p
			COALESCE(COUNT(1) FILTER(WHERE T."TransactionTypeId" = 6 AND T."TypeNameId" = 5), 0) AS "L60",														--làm lố 60p
			COALESCE(COUNT(1) FILTER(WHERE T."TransactionTypeId" = 6 AND T."TypeNameId" = 6), 0) AS "L90"															--làm lố 90p
		FROM tmp3 T
		GROUP BY 
			T."UserId"
	),
	--Lấy danh sách ngày lễ
	tmp5 AS(
		SELECT 
			E."Date"
		FROM "EventDay" E
		WHERE TO_CHAR(E."Date", 'YYYY-MM') = p_month
			AND E."IsDeleted" IS FALSE
	),
	--Lấy các giá trị cần thiết
	tmp6 AS (
		SELECT 
			U."UserId",
			U."FullName",
			U."SalePointId",
			U."SalePointName",
			U."ListSalePoint",
			U."UserTitleId",
			UT."UserTitleName",
			(CASE WHEN U."UserTitleId" <> v_leader THEN COALESCE(B."Salary", 0) ELSE (SELECT L."Length" FROM tmp01 L WHERE L."UserId" = U."UserId" )::NUMERIC * v_salary_leader * v_coef_leader END) AS "BaseSalary",
			(CASE WHEN U."UserTitleId" NOT IN (v_leader, v_hr) THEN COALESCE(B."SalaryOneDate", 0) ELSE 0 END) AS "SalaryOneDate", 
			(CASE WHEN U."UserTitleId" NOT IN (v_leader, v_hr) THEN COALESCE(B."SalaryOneDateSub", 0) ELSE 0 END) AS "SalaryOneDateSub",
			COALESCE(P."L30", 0) AS "L30",
			COALESCE(P."L60", 0) AS "L60",
			COALESCE(P."L90", 0) AS "L90",
			COALESCE(P."SaleOfVietlott", 0) AS "SaleOfVietlott",											--Doanh thu vietlot
			COALESCE(P."SaleOfLoto", 0) AS "SaleOfLoto",															--Doanh thu loto
			COALESCE(P."Punish", 0) AS "Punish",																			--Phạt
			COALESCE(P."Advance",	0) AS "Advance",																		--Ứng lương
			COALESCE(P."Overtime", 0) AS "Overtime",																	--Làm lố giờ loại khác
			COALESCE(P."Award",	0) AS "Award",																				--Thưởng
			COALESCE(P."Debt", 0) AS "Debt",																					--Nợ
			COALESCE(T."Average", 0) AS "Average"																			--Doanh số
		FROM tmp00 U
			JOIN "UserTitle" UT ON U."UserTitleId" = UT."UserTitleId"
			LEFT JOIN tmp B ON U."UserId" = B."UserId"
			LEFT JOIN tmp4 P ON P."UserId" = U."UserId"
			LEFT JOIN tmp0 T ON T."UserId" = U."UserId"
		WHERE U."UserTitleId" IN (v_employee, v_leader, v_hr)											--Chỉ lấy nhân viên, trưởng nhóm và nhân sự
		ORDER BY 
			U."UserTitleId",
			U."UserId"
	),
	--Tính số công
	tmp7 AS (
		SELECT
			SD."UserId",
			(SUM((CASE WHEN SD."Id" <= v_total_date THEN (CASE WHEN E."Date" IS NULL THEN 1 ELSE v_event END) ELSE 0 END) + (CASE WHEN (SD."Id" = v_total_date) THEN 1 ELSE 0 END)))::NUMERIC AS "TotalNormal",
			SUM((CASE WHEN SD."Id" > v_total_date THEN (CASE WHEN E."Date" IS NULL THEN 1 ELSE v_event END) ELSE 0 END)) ::NUMERIC AS "TotalSub"
		FROM tmp1 SD
			LEFT JOIN tmp S ON S."UserId" = SD."UserId"
			LEFT JOIN tmp5 E ON SD."DistributeDate" = E."Date"
		GROUP BY 
			SD."UserId"
	),
	--Lấy list "KPI"
	tmpf8 AS (
		SELECT 	
			K."UserId",
			ROUND(SUM(K."AverageKPI")/COUNT(K."AverageKPI"), 2) AS "KPI"
		FROM crm_user_get_average_KPI_of_user_by_month(p_month, 0) K
		GROUP BY
			K."UserId"
	),
	tmp8 AS (
		SELECT 	
			U."UserId",
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
		FROM tmp00 U
			LEFT JOIN tmpf8 K ON K."UserId" = U."UserId"
			LEFT JOIN tmp2 T
				ON (T."TargetDataTypeId" = 4 
					AND (COALESCE(K."KPI", 0) > T."FromValue" AND COALESCE(K."KPI", 0) <= T."ToValue")
					AND U."UserTitleId" = v_employee)
				OR (T."TargetDataTypeId" = 5 
					AND (COALESCE(K."KPI", 0) > T."FromValue" AND COALESCE(K."KPI", 0) <= T."ToValue") 
					AND U."UserTitleId" = v_leader)
		WHERE U."UserTitleId" IN (v_leader, v_employee)
	),
	--QUY đổi các "TargetData" và tính bảo hiểm
	tmp9 AS (
		SELECT 
			U.*,
			COALESCE((
				SELECT ((SC."Data"::JSON)->>'Insure') 
				FROM "SalaryConfirm" SC 
				WHERE U."UserId" = SC."UserId" 
					AND SC."IsDeleted" IS FALSE 
					AND SC."Month" = p_month
			)::NUMERIC ,U."BaseSalary" * v_insure, 0) AS "Insure",														--Bảo hiểm
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
					ELSE (SELECT L."Length" FROM tmp01 L WHERE L."UserId" = U."UserId" )::NUMERIC * v_salary_leader 
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
			LEFT JOIN tmp2 T ON T."TargetDataTypeId" = 3 AND (ROUND(U."Average", 0)::NUMERIC BETWEEN T."FromValue"::NUMERIC AND T."ToValue"::NUMERIC)

	),
	--Lấy hoa hồng nhân viên
	tmp10 AS (
		SELECT 
			C."UserId",
			SUM(C."TotalCommision")::NUMERIC / 2 AS "TotalCommission"			 --Trả 1/2 hoa hồng
		FROM crm_salepoint_get_commision_of_all_user_in_month(p_month) C
		GROUP BY C."UserId"
	), 
	--Tính lương chính
	tmp11 AS (
		SELECT
			U.*,
			COALESCE(S."TotalNormal", 0) AS "TotalNormal",
			COALESCE(S."TotalSub", 0) AS "TotalSub",
			(CASE WHEN U."UserTitleId" NOT IN (v_leader, v_hr) 
				THEN (
					U."SalaryOneDate" * COALESCE(S."TotalNormal", 0)
					+ U."SalaryOneDateSub" * COALESCE(S."TotalSub", 0)
					+ U."L30" * v_l30
					+ U."L60" * v_l60
					+ U."L90" * v_l90
				) 
				ELSE U."BaseSalary" END) AS "MainSalary",																																							--Lương chính
			((COALESCE(S."TotalNormal", 0) + COALESCE(S."TotalSub", 0)) * v_rice) AS "PriceForLunch",																--Tiền cơm
			COALESCE((
				SELECT ((SC."Data"::JSON)->>'PriceUnion') 
				FROM "SalaryConfirm" SC
				WHERE U."UserId" = SC."UserId" 
					AND SC."IsDeleted" IS FALSE 
					AND SC."Month" = p_month
			)::NUMERIC, v_union) AS "PriceUnion",
			COALESCE(K."KPI", 0) AS "KPI",
			COALESCE(K."KPICoafficient", 0) AS "KPICoafficient",
			COALESCE(C."TotalCommission", 0) AS "TotalCommission"	--Hoa hồng
		FROM tmp9 U
			LEFT JOIN tmp7 S ON U."UserId" = S."UserId"
			LEFT JOIN tmp8 K ON K."UserId" = U."UserId"
			LEFT JOIN tmp10 C ON C."UserId" = U."UserId"
	),
	--Tính lương thực lãnh
	tmp12 AS (
		SELECT
			U.*,
			v_sale_loto * U."SaleOfLoto" AS "OnePercentLoto",
			(U."MainSalary" + U."PriceForLunch" + U."KPICoafficient" * (U."ReponsibilityLottery" + U."VietlottLottery" + U."TraditionalLottery" + v_sale_loto * U."SaleOfLoto")) AS "TotalSalary",
			(U."MainSalary" + U."PriceForLunch" + U."KPICoafficient" * (U."ReponsibilityLottery" + U."VietlottLottery" + U."TraditionalLottery" + v_sale_loto * U."SaleOfLoto") - U."Advance" + U."TotalCommission" + U."Award" - U."Punish" - U."Insure" - U."PriceUnion" - U."Debt" ) AS "RealSalary" 
		FROM tmp11 U 
	),
	--Làm tròn
	tmp13 AS (
		SELECT 
			(SELECT SC."SalaryConfirmId" FROM "SalaryConfirm" SC WHERE SC."UserId" = T."UserId" AND SC."Month" = p_month)::INT AS "SalaryConfirmId",
			T."UserId",
			T."FullName",
			T."UserTitleId",
			T."UserTitleName",
			T."SalePointId",
			T."SalePointName",
			T."ListSalePoint",
			ROUND(T."KPI", 2) AS "KPI",
			ROUND(T."L30", 0) AS "L30",
			ROUND(T."L60", 0) AS "L60",
			ROUND(T."L90", 0) AS "L90",
			ROUND(T."Debt", 2) AS "Debt",
			ROUND(T."Award", 2) AS "Award",
			ROUND(T."Insure", 2) AS "Insure",
			ROUND(T."Punish", 2) AS "Punish",
			ROUND(T."Advance", 2) AS "Advance",
			ROUND(T."Average", 2) AS "Average",
			ROUND(T."Overtime", 2) AS "Overtime",
			ROUND(T."TotalSub", 0) AS "TotalSub",
			ROUND(T."BaseSalary", 2) AS "BaseSalary",
			ROUND(T."MainSalary", 2) AS "MainSalary",
			ROUND(T."PriceUnion", 2) AS "PriceUnion",
			ROUND(T."RealSalary", 2) AS "RealSalary",
			ROUND(T."SaleOfLoto", 2) AS "SaleOfLoto",
			ROUND(T."TotalNormal", 0) AS "TotalNormal",
			ROUND(T."TotalSalary", 2) AS "TotalSalary",
			ROUND(T."PriceForLunch", 2) AS "PriceForLunch",
			ROUND(T."SalaryOneDate", 2) AS "SalaryOneDate",
			ROUND(T."KPICoafficient", 2) AS "KPICoafficient",
			ROUND(T."OnePercentLoto", 2) AS "OnePercentLoto",
			ROUND(T."SaleOfVietlott", 2) AS "SaleOfVietlott",
			ROUND(T."TotalCommission", 2) AS "TotalCommission",
			ROUND(T."VietlottLottery", 2) AS "VietlottLottery",
			ROUND(T."SalaryOneDateSub", 2) AS "SalaryOneDateSub",
			ROUND(T."TraditionalLottery", 2) AS "TraditionalLottery",
			ROUND(T."ReponsibilityLottery", 2) AS "ReponsibilityLottery"
		FROM tmp12 T
		UNION
		SELECT
			NULL AS "SalaryConfirmId",
			0 AS "UserId",
			'Tổng Cộng' AS "FullName",
			0 AS "UserTitleId",
			NULL AS "UserTitleName",
			0 AS "SalePointId",
			NULL AS "SalePointName",
			NULL "ListSalePoint",
			ROUND(SUM(T."KPI"), 2) AS "KPI",
			ROUND(SUM(T."L30"), 0) AS "L30",
			ROUND(SUM(T."L60"), 0) AS "L60",
			ROUND(SUM(T."L90"), 0) AS "L90",
			ROUND(SUM(T."Debt"), 2) AS "Debt",
			ROUND(SUM(T."Award"), 2) AS "Award",
			ROUND(SUM(T."Insure"), 2) AS "Insure",
			ROUND(SUM(T."Punish"), 2) AS "Punish",
			ROUND(SUM(T."Advance"), 2) AS "Advance",
			ROUND(SUM(T."Average"), 2) AS "Average",
			ROUND(SUM(T."Overtime"), 2) AS "Overtime",
			ROUND(SUM(T."TotalSub"), 0) AS "TotalSub",
			ROUND(SUM(T."BaseSalary"), 2) AS "BaseSalary",
			ROUND(SUM(T."MainSalary"), 2) AS "MainSalary",
			ROUND(SUM(T."PriceUnion"), 2) AS "PriceUnion",
			ROUND(SUM(T."RealSalary"), 2) AS "RealSalary",
			ROUND(SUM(T."SaleOfLoto"), 2) AS "SaleOfLoto",
			ROUND(SUM(T."TotalNormal"), 0) AS "TotalNormal",
			ROUND(SUM(T."TotalSalary"), 2) AS "TotalSalary",
			ROUND(SUM(T."PriceForLunch"), 2) AS "PriceForLunch",
			ROUND(SUM(T."SalaryOneDate"), 2) AS "SalaryOneDate",
			ROUND(SUM(T."KPICoafficient"), 2) AS "KPICoafficient",
			ROUND(SUM(T."OnePercentLoto"), 2) AS "OnePercentLoto",
			ROUND(SUM(T."SaleOfVietlott"), 2) AS "SaleOfVietlott",
			ROUND(SUM(T."TotalCommission"), 2) AS "TotalCommission",
			ROUND(SUM(T."VietlottLottery"), 2) AS "VietlottLottery",
			ROUND(SUM(T."SalaryOneDateSub"), 2) AS "SalaryOneDateSub",
			ROUND(SUM(T."TraditionalLottery"), 2) AS "TraditionalLottery",
			ROUND(SUM(T."ReponsibilityLottery"), 2) AS "ReponsibilityLottery"
		FROM tmp12 T
	)
	SELECT 
		T."UserId",
		T."FullName",
		T."UserTitleId",
		T."UserTitleName",
		TO_JSONB(T.*)::TEXT AS "SalaryData"
	FROM tmp13 T
	ORDER BY 
		T."SalePointId",
		T."UserId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE