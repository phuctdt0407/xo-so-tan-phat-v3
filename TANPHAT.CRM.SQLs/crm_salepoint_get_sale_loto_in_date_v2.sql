-- ================================
-- Author: Hieu
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_sale_loto_in_date_v2('2023-04',2);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_sale_loto_in_date_v2');
CREATE OR REPLACE FUNCTION crm_salepoint_get_sale_loto_in_date_v2
(
	p_month VARCHAR,
	p_transaction_type INT,
	p_sale_point_id INT DEFAULT 0
	
)
RETURNS TABLE
(
	"Date" DATE,
	"SalePointId" INT,
	"AllTotalPrice" NUMERIC,
	"Data" TEXT
)
AS $BODY$
DECLARE 
	v_total_date INT := (SELECT date_part('days', (date_trunc('month', (p_month||'-01')::DATE) + INTERVAL '1 month - 1 day'))) :: INT;
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT
			('2023-04'||'-'||"I")::DATE AS "Date"
		FROM generate_series(1, 30) AS "I"
	),
	tmp1 AS (
		SELECT
			T."Date",
			SD."UserId",
			U."FullName",
			SD."ShiftId",
			SD."ShiftDistributeId",
			SP."SalePointId"
		FROM tmp T
			JOIN "SalePoint" SP ON SP."IsDeleted" IS FALSE AND SP."IsActive" IS TRUE
			LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = SP."SalePointId" AND SD."DistributeDate" = T."Date"::DATE
			LEFT JOIN "User" U ON SD."UserId" = U."UserId"
		WHERE (SP."SalePointId" = 0 OR 0 = 0)
		ORDER BY 
			T."Date",
			SD."ShiftId"
	),tmp1_1 AS(
		SELECT 
			TT."TotalPrice",
			TT."Date"
		FROM tmp T
		LEFT JOIN "Transaction" TT ON TT."Date" = T."Date"
		JOIN "SalePoint" SP ON SP."IsDeleted" IS FALSE AND SP."IsActive" IS TRUE
		LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = SP."SalePointId" AND SD."DistributeDate" = T."Date"::DATE
			AND TT."TransactionTypeId" = 2
			AND TT."IsDeleted" IS FALSE
-- 					AND TT."UserId" = SD."UserId"
			AND TT."ShiftDistributeId" = SD."ShiftDistributeId"
		GROUP BY TT."TotalPrice", TT."Date"
	),tmp1_1A AS(
	SELECT SUM(T."TotalPrice")::NUMERIC,T."Date" FROM tmp1_1 T GROUP BY T."Date"
	)
		SELECT 
					TT."TransactionId",
					TT."Date"
		FROM tmp T
		LEFT JOIN "Transaction" TT ON TT."Date" = T."Date"
		JOIN "SalePoint" SP ON SP."IsDeleted" IS FALSE AND SP."IsActive" IS TRUE
		LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = SP."SalePointId" AND SD."DistributeDate" = T."Date"::DATE
			AND TT."TransactionTypeId" = 2
			AND TT."IsDeleted" IS FALSE
-- 					AND TT."UserId" = SD."UserId"
			AND TT."ShiftDistributeId" = SD."ShiftDistributeId"
		GROUP BY TT."TransactionId", TT."Date"
		ORDER BY TT."TransactionId" DESC
		LIMIT 1
	),
	tmp1_3 AS(
	SELECT 
	T."Date",
			T."UserId",
			T."FullName",
			T."ShiftId",
			T."ShiftDistributeId",
			T."SalePointId"
			FROM tmp1 T LEFT JOIN tmp1_1 TT ON TT."Date" = T."Date" LEFT JOIN tmp1_2 TTT ON TTT."Date" = T."Date")
	
		SELECT
			T."Date",
			T."SalePointId",
			SUM(COALESCE(T."TotalPrice", 0)) AS "AllTotalPrice",
			array_to_json(ARRAY_AGG(TO_JSONB(T.*)))::TEXT AS "Data"
		FROM tmp1_3 T
		GROUP BY
			T."Date",
			T."SalePointId"
	)
	SELECT 
		T."Date",
		T."SalePointId",
		T."AllTotalPrice",
		T."Data"
	FROM tmp2 T
	ORDER BY 
		T."SalePointId",
		T."Date";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

