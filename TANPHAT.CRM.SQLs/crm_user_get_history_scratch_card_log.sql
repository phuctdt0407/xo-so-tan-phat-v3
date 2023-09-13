
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_history_scratch_card_log(10,1,'2022-12-19');
-- ================================
SELECT dropallfunction_byname('crm_user_get_history_scratch_card_log');
CREATE OR REPLACE FUNCTION crm_user_get_history_scratch_card_log
(
	p_page_size INT,
	p_page_number INT,
	p_date VARCHAR DEFAULT ''
)
RETURNS TABLE
(
	"ScratchcardLogId" INT4,
	"ActionByName" VARCHAR,
	"ActionDate" VARCHAR,
	"LotteryChannelName" VARCHAR,
	"SalePointName" VARCHAR,
	"TotalReceived" INT4
)
AS $BODY$
DECLARE
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN

	RETURN QUERY
	SELECT
	SL."ScratchcardLogId",
	SL."ActionByName",
	TO_CHAR(SL."ActionDate",'YYYY-MM-DD HH:MM')::VARCHAR(255),
	LC."LotteryChannelName",
	S."SalePointName",
	SL."TotalReceived"
	FROM "ScratchcardLog" SL 
	LEFT JOIN "SalePoint" S ON SL."SalePointId" = S."SalePointId"
	LEFT JOIN "LotteryChannel" LC ON SL."LotteryChannelId" = LC."LotteryChannelId"
	WHERE SL."ActionDate"::DATE = p_date::DATE OR p_date = ''
	OFFSET v_offset_row LIMIT p_page_size;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
