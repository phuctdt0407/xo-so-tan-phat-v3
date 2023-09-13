-- ================================
-- Author: Vinh
-- Description: Lấy dữ liệu chia vé cào cho dai ly con
-- Created date: 29/04/2023
-- SELECT * FROM crm_activity_get_data_distribute_scratchcard_for_sub_agency();
-- ================================
SELECT dropallfunction_byname('crm_activity_get_data_distribute_scratchcard_for_sub_agency');
CREATE OR REPLACE FUNCTION crm_activity_get_data_distribute_scratchcard_for_sub_agency()
RETURNS TABLE
(
	"AgencyId" INT,
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
		S."AgencyId",
		SP."AgencyName",
		S."TotalReceived",
		S."TotalRemaining",
		S."LotteryChannelId",
		LC."LotteryChannelName",
		LC."ShortName"
	FROM "ScratchcardForSubAgency" S
		JOIN "SubAgency" SP ON SP."AgencyId" = S."AgencyId"
		JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = S."LotteryChannelId"
	ORDER BY S."AgencyId", LC."LotteryChannelTypeId", LC."LotteryChannelId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE