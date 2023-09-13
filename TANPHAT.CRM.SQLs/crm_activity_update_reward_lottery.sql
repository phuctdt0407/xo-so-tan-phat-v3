-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_activity_update_reward_lottery(1,'e',5,'[cailist,ok]')
-- ================================
SELECT dropallfunction_byname('crm_activity_update_reward_lottery');
CREATE OR REPLACE FUNCTION crm_activity_update_reward_lottery 
(
    p_region_id INT,
		p_promotion_text TEXT,
		p_step INT,
		p_lottery_channel_list TEXT
)
RETURNS TABLE
(
    "Id" INT,
    "Message" TEXT
)
AS $BODY$
DECLARE
    v_id INT;
    v_mess TEXT;
    ele JSON;
    v_time TIMESTAMP := NOW();
BEGIN
    
		INSERT INTO "Promotion" ("RegionId","PromotionText","LotteryChannelList","Step")
		VALUES (p_region_id,p_promotion_text,p_lottery_channel_list,p_step);
		v_id:=1;
		v_mess:='Thêm Thành Công';
    RETURN QUERY
    SELECT v_id, v_mess;

    EXCEPTION WHEN OTHERS THEN
    BEGIN
        v_id := -1;
        v_mess := sqlerrm;
        RETURN QUERY
        SELECT v_id, v_mess;
    END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE