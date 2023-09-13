-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_sale_of_vietlott_in_date();
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_sale_of_vietlott_in_date');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_sale_of_vietlott_in_date
(
	p_date TIMESTAMP DEFAULT NOW(),
	p_sale_point_id INT DEFAULT 0
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"SalePointData" TEXT,
	"SumData" NUMERIC,
	"RealData" NUMERIC,
	"IsEqual" BOOL
)
AS $BODY$
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT	
			SP."SalePointId",
			SP."SalePointName"
		FROM "SalePoint" SP 
		WHERE SP."IsActive" IS TRUE
			AND SP."IsDeleted" IS FALSE
			AND (p_sale_point_id = 0 OR SP."SalePointId" = p_sale_point_id)
	),
	tmp1 AS (
		SELECT 
			T."SalePointId",
			T."ShiftDistributeId",
			SD."ShiftId",
			T."UserId",
			T."TotalPrice"
		FROM "Transaction" T
			JOIN "ShiftDistribute" SD ON SD."ShiftDistributeId" = T."ShiftDistributeId"
		WHERE T."TransactionTypeId" = 2
			AND T."Date" = p_date::DATE
			AND T."IsDeleted" IS FALSE
	),
	tmp2 AS (
		SELECT 
			T."SalePointId",
			T."ShiftDistributeId",
			T."UserId",
			T."TotalPrice"
		FROM "Transaction" T
		WHERE T."TransactionTypeId" = 10
			AND T."Date" = p_date::DATE
			AND T."IsDeleted" IS FALSE
	),
	tmp3 AS (
		SELECT
			SP.*,
			(
				SELECT array_to_json(array_agg(R))
				FROM (
					SELECT 
						SD."SalePointId",
						SD."ShiftDistributeId",
						SD."ShiftId",
						SD."UserId",
						U."FullName",
						T."TotalPrice"
					FROM "ShiftDistribute" SD
						JOIN "User" U ON SD."UserId" = U."UserId"
						LEFT JOIN tmp1 T ON SD."UserId" = T."UserId" AND SD."ShiftDistributeId" = T."ShiftDistributeId"
					WHERE SD."SalePointId" = SP."SalePointId"
						AND SD."DistributeDate" = p_date::DATE
				) R
			)::TEXT AS "SalePointData",
			(
				SELECT 
					SUM(T."TotalPrice")
				FROM tmp1 T
				WHERE T."SalePointId" = SP."SalePointId"
			)::NUMERIC AS "SumData",
			(
				SELECT T."TotalPrice" FROM tmp2 T WHERE T."SalePointId" = SP."SalePointId"
			)::NUMERIC AS "RealData",
			(
				SELECT SUM(T."TotalPrice") FROM tmp1 T WHERE T."SalePointId" = SP."SalePointId"
			)::NUMERIC AS "TotalSalePoint"
		FROM tmp SP
	)
	SELECT
		T."SalePointId",
		T."SalePointName",
		T."SalePointData",
		T."SumData",
		T."RealData",
		(CASE WHEN COALESCE(T."RealData", 0) = COALESCE(T."TotalSalePoint", 0) THEN TRUE ELSE FALSE END) AS "IsEqual"
	FROM tmp3 T;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

