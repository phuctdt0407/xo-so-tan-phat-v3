-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_history_scratch_card_full_log(10,1,'');
-- ================================
SELECT dropallfunction_byname('crm_user_get_history_scratch_card_full_log');
CREATE OR REPLACE FUNCTION crm_user_get_history_scratch_card_full_log
(
	p_page_size INT,
	p_page_number INT,
	p_date VARCHAR DEFAULT ''
)
RETURNS TABLE
(
	"ScratchcardFullLogId" INT4,
	"AgencyName" VARCHAR,
	"ActionByName" VARCHAR,
	"ActionDate" VARCHAR,
	"TotalReceive" INT4,
	"LotteryChannelName" VARCHAR
)
AS $BODY$
DECLARE
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN

	RETURN QUERY
	SELECT
		SFL."ScratchcardFullLogId",
		A."AgencyName",
		SFL."ActionByName",
		TO_CHAR(SFL."ActionDate",'YYYY-MM-DD HH:MM')::VARCHAR(255),
		SFL."TotalReceived",
		LC."LotteryChannelName"
	FROM "ScratchcardFullLog" SFL 
	LEFT JOIN "Agency" A ON SFL."AgencyId" = A."AgencyId"
	LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = SFL."LotteryChannelId"
	WHERE SFL."ActionDate"::DATE = p_date::DATE OR p_date = ''
	ORDER BY SFL."ScratchcardFullLogId" 
	OFFSET v_offset_row LIMIT p_page_size;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
