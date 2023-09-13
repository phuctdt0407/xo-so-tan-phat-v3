-- ================================
-- Author: Viet
-- Description: Lấy dữ liệu chia vé cho đại lí nhỏ 
-- Created date: 24/03/2023
-- SELECT * FROM crm_activity_get_data_distribute_for_sup_agency('2023-03-24');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_data_distribute_for_sup_agency');
CREATE OR REPLACE FUNCTION crm_activity_get_data_distribute_for_sup_agency
(
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"AgencyId" INT,
	"SupAgencyId" INT,
	"LotteryChannelId" INT,
	"TotalReceived" INT8,
	"TotalDupReceived" INT8
)
AS $BODY$
BEGIN	
	
	RETURN QUERY 
	SELECT 
		IL."AgencyId",
		IL."SupAgencyId",
		IL."LotteryChannelId",
		COALESCE(IL."TotalReceived", 0) AS "TotalReceived",
		COALESCE(IL."TotalDupReceived", 0) AS "TotalDupReceived"
	FROM "InventoryForSupAgency" IL
	WHERE IL."Date"::DATE = p_date::DATE;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE