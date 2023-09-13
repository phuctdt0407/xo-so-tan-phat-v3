-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_update_reward_lottery(now()::DATE,8278,'{566160,888127}','{31,32}')
-- ================================
SELECT dropallfunction_byname('crm_update_reward_lottery');
CREATE OR REPLACE FUNCTION crm_update_reward_lottery 
(
    p_date DATE,
		p_check INT,
		p_promotioncode TEXT,
		p_promotioncode_id Text
)
RETURNS TABLE
(
    "Message" TEXT
)
AS $BODY$
DECLARE
    v_id INT;
    v_mess TEXT;
    ele JSON;
    v_time TIMESTAMP := NOW();
-- 		v_code_id int[];
BEGIN
		UPDATE 
		"SalePointLog"
		SET
		"PromotionCode" =p_promotioncode::INT[],
		"PromotionCodeId" = p_promotioncode_id::INT[]
-- 		"IsUsed" = TRUE
		WHERE "SalePointLogId" = p_check;
		Update
			"PromotionCode"
		SET 
			"IsUsed" = true
		WHERE "PromotionCodeId" = ANY(p_promotioncode_id::INT[]);
		v_mess := 'Đã thêm mã trúng thưởng';
    EXCEPTION WHEN OTHERS THEN
    BEGIN
        v_mess := sqlerrm;
        RETURN QUERY
        SELECT v_mess;
    END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE