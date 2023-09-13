-- ================================
-- Author: Phi
-- Description: Lấy dữ liệu nhận vé từ đại lý
-- Created date: 01/03/2022
-- SELECT * FROM crm_activity_get_data_receive_from_agency('2023-04-06');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_data_receive_from_agency');
CREATE OR REPLACE FUNCTION crm_activity_get_data_receive_from_agency
(
	p_lottery_date TIMESTAMP
)
RETURNS TABLE
(
	"AgencyId" INT,
	"LotteryChannelId" INT,
	"TotalReceived" INT,
	"TotalRemaining" INT,
	"IsBlocked" BOOL
)
AS $BODY$
BEGIN	
	
	RETURN QUERY 
	SELECT 
		I."AgencyId",
		I."LotteryChannelId",
		I."TotalReceived",
		I."TotalRemaining",
		I."LotteryDate" < NOW()::DATE AS "IsBlocked"
	FROM "InventoryFull" I
	WHERE I."LotteryDate" = p_lottery_date::DATE;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE