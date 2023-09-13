-- ================================
-- Author: Phi
-- Description: Lấy dữ liệu chia vé cho điểmn bán
-- Created date: 01/03/2022
-- SELECT * FROM crm_activity_get_data_distribute_for_sales_point('2022-03-18');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_data_distribute_for_sales_point');
CREATE OR REPLACE FUNCTION crm_activity_get_data_distribute_for_sales_point
(
	p_lottery_date TIMESTAMP
)
RETURNS TABLE
(
	"AgencyId" INT,
	"SalePointId" INT,
	"LotteryChannelId" INT,
	"TotalReceived" INT,
	"TotalDupReceived" INT
)
AS $BODY$
BEGIN	
	
	RETURN QUERY 
	SELECT 
		IL."AgencyId",
		IL."SalePointId",
		IL."LotteryChannelId",
		COALESCE(IL."TotalReceived", 0) AS "TotalReceived",
		COALESCE(IL."TotalDupReceived", 0) AS "TotalDupReceived"
	FROM "InventoryLog" IL
	WHERE IL."LotteryDate" = p_lottery_date::DATE;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE