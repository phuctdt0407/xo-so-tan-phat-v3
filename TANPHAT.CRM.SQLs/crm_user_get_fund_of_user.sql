-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_fund_of_user(2022);
-- TRUNCATE "Commission" RESTART IDENTITY
-- ================================
SELECT dropallfunction_byname('crm_user_get_fund_of_user');
CREATE OR REPLACE FUNCTION crm_user_get_fund_of_user
(
	p_year INT 
)
RETURNS TABLE
(
	"UserId" INT,
	"Data" TEXT
)
AS $BODY$
DECLARE
DECLARE
	F RECORD;
	i INT;
	n INT;
	v_array INT[];
	v_commision NUMERIC;
BEGIN
	--Lấy quỹ hoa hồng
	CREATE TEMP TABLE CommissionData (
		"Id" SERIAL,
		"SalePointId" INT,
		"UserId" INT,
		"Date" DATE,
		"TotalCommision" NUMERIC
	)
	ON COMMIT DROP;
	
	FOR F IN (
		SELECT 
			C."ListStaff",
			C."TotalValue",
			C."Date",
			C."SalePointId"
		FROM "Commission" C 
		WHERE C."IsDeleted" IS FALSE
	) LOOP			
		v_array := translate(F."ListStaff"::TEXT, '[]','{}')::INT[];
		n := array_length(v_array, 1);
		v_commision := ROUND(F."TotalValue" / 3 / n, 0);
		
		FOR i IN 1..n LOOP
			
			INSERT INTO CommissionData(
				"SalePointId",
				"UserId",
				"Date",
				"TotalCommision"
			)
			VALUES(
				F."SalePointId",
				v_array[i],
				F."Date",
				v_commision
			);
			END LOOP;
				
	END LOOP;
	
	RETURN QUERY
	--Lấy danh sách user
	WITH tmp0 AS (
		SELECT 
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."ListSalePoint",
			SP."SalePointName"
		FROM crm_get_user_ddl(0, (p_year||'-01-01')::TIMESTAMP) U
			LEFT JOIN "SalePoint" SP ON SP."SalePointId" = U."SalePointId" 
		WHERE U."UserTitleId" IN (4, 5)
	),
	--Lấy danh sách tồn đầu năm
	tmp AS (
		SELECT 
			C."UserId",
			SUM(C."TotalCommision") AS "TotalCommision"
		FROM tmp0 U
			LEFT JOIN CommissionData C ON U."UserId" = C."UserId"
		WHERE TO_CHAR(C."Date", 'YYYY')::INT < p_year
		GROUP BY
			C."UserId"
	),
	--Lấy danh sách trả trước năm đang lấy
	tmp1 AS (
		SELECT 
			T."UserId",
			SUM(T."TotalPrice") AS "TotalPrice"
		FROM "Transaction" T
		WHERE T."IsDeleted" IS FALSE
			AND T."TransactionTypeId" = 11
			AND TO_CHAR(T."Date", 'YYYY')::INT < p_year
		GROUP BY 
			T."UserId"
	),
	--Lấy tổng bảo hiểm
	tmp2 AS (
		SELECT 
			SC."UserId",
			SUM(((SC."Data"::JSON)->>'Insure')::NUMERIC) AS "TotalInsure"
		FROM "SalaryConfirm" SC
		WHERE SUBSTRING(SC."Month", 1, 4)::INT < p_year
			AND SC."IsDeleted" IS FALSE
		GROUP BY 
			SC."UserId"
	),
	--Lấy tổng tiền tồn đầu năm
	tmp3 AS (
		SELECT 
			U."UserId",
			U."FullName",
			(CASE WHEN p_year = 2023
				THEN
						(SELECT U1."TotalFirst" FROM "User" U1 WHERE U."UserId" = U1."UserId")
				WHEN p_year > 2023
				THEN
					(SELECT U1."TotalFirst" FROM "User" U1 WHERE U."UserId" = U1."UserId") + COALESCE(C."TotalCommision", 0) / 2 + COALESCE(A."TotalInsure", 0) * 2 - COALESCE(T."TotalPrice", 0)
				END) AS "TotalFirst"

		FROM tmp0 U
			LEFT JOIN tmp C ON C."UserId" = U."UserId"
			LEFT JOIN tmp1 T ON U."UserId" = T."UserId"
			LEFT JOIN tmp2 A ON A."UserId" = U."UserId"
	),
	--Lấy danh sách hoa hồng năm đang truy vấn
	tmp4 AS (
		SELECT 
			C."UserId",
			TO_CHAR(C."Date", 'YYYY-MM') AS "Month",
			SUM(C."TotalCommision") AS "TotalCommision"
		FROM tmp0 U
			LEFT JOIN CommissionData C ON U."UserId" = C."UserId"
		WHERE TO_CHAR(C."Date", 'YYYY')::INT = p_year
		GROUP BY
			C."UserId",
			TO_CHAR(C."Date", 'YYYY-MM')
	),
	--Lấy danh sách bảo hiểm trong năm đang truy vấn
	tmp5 AS (
		SELECT 
			SC."UserId",
			SC."Month",
			SUM(((SC."Data"::JSON)->>'Insure')::NUMERIC) AS "Insure"
		FROM "SalaryConfirm" SC
		WHERE SUBSTRING(SC."Month", 1, 4)::INT = p_year
			AND SC."IsDeleted" IS FALSE
		GROUP BY 
			SC."UserId",
			SC."Month"
	),
	--Lấy danh sách trả trong năm đang lấy
	tmp6 AS (
		SELECT 
			T."UserId",
			array_to_json(array_agg(json_build_object(
				'TransactionId',
				T."TransactionId",
				'Date',
				T."Date",
				'Price',
				T."TotalPrice",
				'Note',
				T."Note"
			))) AS "ListDataReturn",
			SUM(T."TotalPrice") AS "TotalPriceHavePay"
		FROM "Transaction" T
		WHERE T."IsDeleted" IS FALSE
			AND T."TransactionTypeId" = 11
			AND TO_CHAR(T."Date", 'YYYY')::INT = p_year
		GROUP BY 
			T."UserId"
	),
	tmp7 AS (
		SELECT
			TO_CHAR((p_year||'-'||T."Data"||'-01')::DATE, 'YYYY-MM') AS "Month"
		FROM (
			SELECT
				*
			FROM generate_series(1, 12) "Data"
		) T
	),
	tmp8 AS (
		SELECT
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."ListSalePoint",
			U."SalePointName",
			array_to_json(array_agg(json_build_object(
				'Month',
				M."Month",
				'Insure',
				COALESCE(I."Insure" * 2, 0),
				'CommissionHavePay',
				COALESCE(D."TotalCommision" / 2, 0),
				'CommissionExtra',
				COALESCE(D."TotalCommision" / 2, 0)
			))) AS "DataMonth",
			SUM(COALESCE(I."Insure", 0) * 2 + COALESCE(D."TotalCommision", 0) / 2) AS "TotalExtra"
		FROM tmp0 U
			LEFT JOIN tmp7 M ON TRUE
			LEFT JOIN tmp4 D ON M."Month" = D."Month" AND U."UserId" = D."UserId"
			LEFT JOIN tmp5 I ON I."Month" = M."Month" AND U."UserId" = I."UserId"
		GROUP BY
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."ListSalePoint",
			U."SalePointName"
	),
	tmp9 AS (
		SELECT
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."SalePointName",
			U."ListSalePoint",
			P."TotalFirst",
			U."DataMonth",
			U."TotalExtra",
			COALESCE(L."TotalPriceHavePay", 0) AS "TotalPriceHavePay",
			COALESCE(P."TotalFirst", 0) + COALESCE(U."TotalExtra", 0) - COALESCE(L."TotalPriceHavePay", 0) AS "TotalPriceRemain",
			L."ListDataReturn"		
		FROM tmp8 U 
			LEFT JOIN tmp3 P ON P."UserId" = U."UserId"
			LEFT JOIN tmp6 L ON L."UserId" = U."UserId"		
		ORDER BY 
			U."UserTitleId" DESC,
			U."SalePointId",
			U."UserId"
	)
	SELECT
		R."UserId",
		TO_JSONB(R.*)::TEXT AS "Data"
	FROM tmp9 R;
	
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

