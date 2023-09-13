-- ================================
-- Author: Phi
-- Description: Lấy dữ liệu chia vé cào cho điểm bán
-- Created date: 25/03/2022
-- SELECT * FROM crm_activity_get_data_distribute_scratchcard_for_sale_point();
-- ================================
SELECT dropallfunction_byname('crm_activity_get_data_distribute_scratchcard_for_sale_point');
CREATE OR REPLACE FUNCTION crm_activity_get_data_distribute_scratchcard_for_sale_point()
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"TotalReceived" INT,
	"TotalRemaining" INT,
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"ShortName" VARCHAR
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		S."SalePointId",
		SP."SalePointName",
		S."TotalReceived",
		S."TotalRemaining",
		S."LotteryChannelId",
		LC."LotteryChannelName",
		LC."ShortName"
	FROM "Scratchcard" S
		JOIN "SalePoint" SP ON SP."SalePointId" = S."SalePointId"
		JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = S."LotteryChannelId"
	ORDER BY S."SalePointId", LC."LotteryChannelTypeId", LC."LotteryChannelId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE