-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_remain_of_all_salepoint_in_date();
-- ================================
SELECT dropallfunction_byname('crm_report_get_remain_of_all_salepoint_in_date');
CREATE OR REPLACE FUNCTION crm_report_get_remain_of_all_salepoint_in_date
()
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"TotalRemainingTheNorth" INT8,
	"TotalRemainingTheCentral" INT8,
	"TotalRemainingTheSouth" INT8
)
AS $BODY$

BEGIN
	
	RETURN QUERY
	WITH Total AS (
	SELECT 
		SP."SalePointId", 
		SP."SalePointName", 
		SUM(I."TotalRemaining" + I."TotalDupRemaining") FILTER (WHERE L."RegionId" = 1) AS "TotalRemainingTheNorth",
		SUM(I."TotalRemaining" + I."TotalDupRemaining") FILTER (WHERE L."RegionId" = 3) AS "TotalRemainingTheCentral",
		SUM(I."TotalRemaining" + I."TotalDupRemaining") FILTER (WHERE L."RegionId" = 2) AS "TotalRemainingTheSouth"
	FROM "SalePoint" SP JOIN "Inventory" I ON SP."SalePointId" = I."SalePointId"
	LEFT JOIN "LotteryChannel" L ON L."LotteryChannelId" = I."LotteryChannelId"
	LEFT JOIN "Region" R ON R."RegionId" = L."RegionId"
	WHERE TO_CHAR(I."LotteryDate", 'YYYY-MM-DD') :: DATE = NOW()::DATE 
	--		OR TO_CHAR(I."LotteryDate", 'YYYY-MM-DD') :: DATE = (NOW() + INTERVAL '1 DAY')::DATE ) 
	GROUP BY SP."SalePointId", SP."SalePointName"
	ORDER BY SP."SalePointId")
	SELECT 
		SP."SalePointId", 
		SP."SalePointName",
		COALESCE( T."TotalRemainingTheNorth",0) AS "TotalRemainingTheNorth",
		COALESCE(T."TotalRemainingTheCentral",0) AS "TotalRemainingTheCentral",
		COALESCE( T."TotalRemainingTheSouth",0) AS "TotalRemainingTheSouth"
	FROM "SalePoint" SP LEFT JOIN Total T ON SP."SalePointId" = T."SalePointId"
	WHERE SP."IsActive" IS TRUE
	ORDER BY SP."SalePointId";	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

