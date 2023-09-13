-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_sale_loto_in_date('2022-07');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_sale_loto_in_date');
CREATE OR REPLACE FUNCTION crm_salepoint_get_sale_loto_in_date
(
	p_month VARCHAR,
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
			(p_month||'-'||"I")::DATE AS "Date"
		FROM generate_series(1, v_total_date) AS "I"
	),
	tmp1 AS (
		SELECT
			T."Date",
			SD."UserId",
			U."FullName",
			SD."ShiftId",
			SD."ShiftDistributeId",
			SP."SalePointId",
			(
				SELECT 
					TT."TotalPrice"
				FROM "Transaction" TT
				WHERE TT."Date" = T."Date"
					AND TT."TransactionTypeId" = 3
					AND TT."IsDeleted" IS FALSE
					AND TT."UserId" = SD."UserId"
					AND TT."ShiftDistributeId" = SD."ShiftDistributeId"
				LIMIT 1
			)::NUMERIC AS "TotalPrice"
		FROM tmp T
			JOIN "SalePoint" SP ON SP."IsDeleted" IS FALSE AND SP."IsActive" IS TRUE
			LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = SP."SalePointId" AND SD."DistributeDate" = T."Date"::DATE
			LEFT JOIN "User" U ON SD."UserId" = U."UserId"
		WHERE (SP."SalePointId" = p_sale_point_id OR p_sale_point_id = 0)
		ORDER BY 
			T."Date",
			SD."ShiftId"
	),
	tmp2 AS (
		SELECT
			T."Date",
			T."SalePointId",
			SUM(COALESCE(T."TotalPrice", 0)) AS "AllTotalPrice",
			array_to_json(ARRAY_AGG(TO_JSONB(T.*)))::TEXT AS "Data"
		FROM tmp1 T
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

