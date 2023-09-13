-- ================================
-- Author: Phi
-- Description: Lấy số lượng vé cào còn lại của kho tổng
-- Created date: 25/03/2022
-- SELECT * FROM crm_scratch_card_full();
-- ================================
SELECT dropallfunction_byname('crm_scratch_card_full');
CREATE OR REPLACE FUNCTION crm_scratch_card_full()
RETURNS TABLE
(
	"Data" TEXT
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT array_to_json(ARRAY_AGG(R)) ::TEXT
	FROM (
		SELECT 
			LC."LotteryChannelId",
			LC."ShortName",
			LC."LotteryChannelName",
			SF."TotalRemaining"
		FROM "ScratchcardFull" SF
			JOIN "LotteryChannel" LC ON SF."LotteryChannelId" = LC."LotteryChannelId"
		WHERE SF."AgencyId" = 0
		ORDER BY LC."LotteryChannelTypeId"
	) R;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE