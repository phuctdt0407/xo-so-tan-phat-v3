-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_sale_vietlott_in_date('2022-07');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_sale_vietlott_in_date');
CREATE OR REPLACE FUNCTION crm_salepoint_get_sale_vietlott_in_date
(
	p_month VARCHAR,
	p_sale_point_id INT DEFAULT 0
)
RETURNS TABLE
(
	"Date" DATE,
	"UserId" INT,
	"FullName" VARCHAR,
	"ShiftId" INT,
	"ShiftDistributeId" INT,
	"SalePointId" INT,
	"TotalPrice" NUMERIC
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
			SD."SalePointId",
			(
				SELECT 
					TT."TotalPrice"
				FROM "Transaction" TT
				WHERE TT."Date" = T."Date"
					AND TT."TransactionTypeId" = 2
					AND TT."IsDeleted" IS FALSE
					AND TT."UserId" = SD."UserId"
					AND TT."ShiftDistributeId" = SD."ShiftDistributeId"
				LIMIT 1
			)::NUMERIC AS "TotalPrice"
		FROM tmp T
			JOIN "ShiftDistribute" SD ON (SD."SalePointId" = p_sale_point_id OR p_sale_point_id =0) AND SD."DistributeDate" = T."Date"::DATE
			JOIN "User" U ON SD."UserId" = U."UserId"
		ORDER BY 
			T."Date",
			SD."ShiftId"
	),
	tmp2 AS (
		SELECT
			T."Date",
			T."UserId",
			U."FullName",
			NULL::INT AS "ShiftId",
			NULL::INT AS "ShiftDistributeId",
			T."SalePointId",
			T."TotalPrice"
		FROM "Transaction" T
			JOIN "User" U ON T."UserId" = U."UserId"
		WHERE T."TransactionTypeId" = 10
			AND TO_CHAR(T."Date", 'YYYY-MM') = p_month
			AND T."IsDeleted" IS FALSE
			AND (T."SalePointId" = p_sale_point_id OR p_sale_point_id = 0)
			
	),
	tmp3 AS (
		SELECT 
			* 
		FROM tmp1
		UNION ALL
		SELECT 
			* 
		FROM tmp2	
	)
	SELECT 
		T.*
	FROM tmp3 T
	ORDER BY 
		T."SalePointId",
		T."Date",
		T."ShiftId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

