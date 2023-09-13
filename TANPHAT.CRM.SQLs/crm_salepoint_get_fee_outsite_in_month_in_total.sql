-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_fee_outsite_in_month_in_total('2023-05',1);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_fee_outsite_in_month_in_total');
CREATE OR REPLACE FUNCTION crm_salepoint_get_fee_outsite_in_month_in_total
(
	p_month VARCHAR,
	p_salepoint_id int8
)
RETURNS TABLE
(
	"Month" VARCHAR,
	"UserId" INT,
	"FullName" VARCHAR,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"Data" TEXT,
	"TotalPrice" NUMERIC
)
AS $BODY$
DECLARE 
	v_total_date INT := (SELECT date_part('days', (date_trunc('month', (p_month||'-01')::DATE) + INTERVAL '1 month - 1 day'))) :: INT;
BEGIN
	RETURN QUERY
	WITH tmp0 AS (
		SELECT 
			T."SalePointId",
			T."SalePointName"
		FROM crm_get_list_salepoint_of_leader(0) T
	),
	tmp AS (
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
			SP."SalePointName",
			json_agg(json_build_object('Note',TT."Note",'TotalPrice',TT."TotalPrice"))::TEXT AS "Data",
			SUM(TT."TotalPrice")::NUMERIC AS "TotalPrice"
		FROM tmp T
			JOIN "ShiftDistribute" SD ON SD."DistributeDate" = T."Date"::DATE
			JOIN "User" U ON SD."UserId" = U."UserId"
			JOIN tmp0 SP ON SD."SalePointId" = SP."SalePointId"
			LEFT JOIN "Transaction" TT ON TT."Date" = T."Date" 
					AND TT."TransactionTypeId" = 1
					AND TT."IsDeleted" IS FALSE
					AND TT."UserId" = SD."UserId"
					AND TT."ShiftDistributeId" = SD."ShiftDistributeId"
		GROUP BY 
			TT."TransactionTypeId",
			T."Date",
			SD."UserId",
			U."FullName",
			SD."ShiftId",
			SD."ShiftDistributeId",
			SD."SalePointId",
			SP."SalePointName"
		ORDER BY 
			T."Date",
			SD."ShiftId"
	)
	SELECT 
		p_month,
		T."UserId",
		T."FullName",
		T."SalePointId",
		T."SalePointName",
		array_agg(T."Data") ::TEXT,
		SUM(T."TotalPrice")
	FROM tmp1 T
	WHERE T."SalePointId" = p_salepoint_id
	GROUP BY T."UserId",T."FullName",T."SalePointId",T."SalePointName"
	ORDER BY 
		T."SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

