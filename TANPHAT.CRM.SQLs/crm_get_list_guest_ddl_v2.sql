-- ================================
-- Author: Viet
-- Description:27-03-2023
-- Created date:
-- SELECT * FROM crm_get_list_guest_ddl_v2(0,0);
-- ================================
SELECT dropallfunction_byname('crm_get_list_guest_ddl_v2');
CREATE OR REPLACE FUNCTION crm_get_list_guest_ddl_v2
(
	p_sale_point_id INT DEFAULT 0,
	p_guest_id INT DEFAULT 0
)
RETURNS TABLE
(
	"GuestId" INT,
	"FullName" VARCHAR,
	"Phone" VARCHAR,
	"SalePointId" INT,
-- 	"WholesalePriceId" INT,
	"WholesalePrice" NUMERIC,
-- 	"ScratchPriceId" INT,
	"ScratchPrice" NUMERIC,
	"Debt" NUMERIC,
	"CanBuyWholesale" BOOL
)
AS $BODY$

BEGIN
	RETURN QUERY
	WITH tmp AS (
-- 		SELECT
-- 			GA."GuestId",
-- 			GA."SalePointId",
-- 			SUM((CASE WHEN GA."GuestActionTypeId" = 1 THEN GA."TotalPrice" 
-- 								WHEN GA."GuestActionTypeId" = 2 OR GA."GuestActionTypeId" = 3 THEN -GA."TotalPrice"
-- 								ELSE 0 END)) AS "Debt"
-- 		FROM "GuestAction" GA
-- 		GROUP BY
-- 			GA."GuestId",
-- 			GA."SalePointId"
		SELECT 
			SPL."GuestId",
			SPL."SalePointId",
			SUM(SPL."TotalValue") AS "Debt"
		FROM "SalePointLog" SPL
		WHERE (SPL."GuestId" IS NOT NULL AND SPL."GuestId" <> 0)
		GROUP BY 
			SPL."SalePointId",
			SPL."GuestId"
	),
	tmp2 AS (
		SELECT
			GA."GuestId",
			GA."SalePointId",
			COALESCE((SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 2)), 0) - COALESCE((SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 3)), 0) AS "Debt"
		FROM "GuestAction" GA
		GROUP BY
			GA."GuestId",
			GA."SalePointId"
	)
	SELECT 
		G."GuestId",
		G."FullName",
		G."Phone",
		G."SalePointId",
-- 		G."WholesalePriceId",
		G."WholesalePrice" AS "WholesalePrice",
-- 		G."ScratchPriceId",
		G."ScratchPrice" AS "ScratchPrice",
		COALESCE(T."Debt", 0) - COALESCE(TT."Debt", 0) AS "Debt",
		(CASE WHEN G."WholesalePriceId" IS NOT NULL AND G."ScratchPriceId" IS NOT NULL THEN TRUE ELSE FALSE END) AS "CanBuyWholesale"
	FROM "Guest" G
		LEFT JOIN "LotteryPrice" LT ON G."WholesalePriceId" = LT."LotteryPriceId"
		LEFT JOIN "LotteryPrice" LT2 ON G."ScratchPriceId" = LT2."LotteryPriceId"
		LEFT JOIN tmp T ON T."GuestId" = G."GuestId" AND T."SalePointId" = G."SalePointId"
		LEFT JOIN tmp2 TT ON TT."GuestId" = G."GuestId" AND TT."SalePointId" = G."SalePointId"
	WHERE (COALESCE(p_guest_id, 0) = 0 OR G."GuestId" = p_guest_id)
		AND (COALESCE(p_sale_point_id, 0) = 0 OR G."SalePointId" = p_sale_point_id)
	ORDER BY G."FullName";
END;
$BODY$
LANGUAGE plpgsql VOLATILE