-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_previous_remaining_v3(12575, 12, 1, '2023-02-21','2023-02-21',22);
-- ================================
SELECT dropallfunction_byname('crm_get_previous_remaining_v3');
CREATE OR REPLACE FUNCTION crm_get_previous_remaining_v3
(
	p_shift_dis_id INT,
	p_channel_id INT,
	p_lottery_type_id INT,
	p_lottery_date DATE,
	p_date DATE,
	p_user_role INT
)
RETURNS INT
AS $BODY$
DECLARE
	v_shift_id INT;
	v_shift_bef_dis_id INT;
	v_salePoint_id INT;
	v_date DATE;
	v_pre_stock INT;
	v_invent_log INT;
	v_sold INT;
	v_stock_sratch_card INT8;
	v_trans INT;
	v_return INT;
	omgjson json := (SELECT F."ScratchcardData"::TEXT FROM crm_activity_sell_get_data_v5(p_shift_dis_id,p_user_role,p_date) F)::JSON;
	omgjson2 json := (SELECT F."TodayData"::TEXT FROM crm_activity_sell_get_data_v5(p_shift_dis_id,p_user_role,p_date) F)::JSON;
	i json;
BEGIN
	IF p_lottery_type_id = 3 THEN 
		SELECT SD."ShiftId", SD."SalePointId", SD."DistributeDate" INTO v_shift_id, v_salePoint_id,v_date
		FROM "ShiftDistribute" SD 
		WHERE SD."ShiftDistributeId" = p_shift_dis_id;
		FOR i IN SELECT * FROM json_array_elements(omgjson) LOOP 
		IF ((i->>'LotteryChannelId')::INT = p_channel_id) THEN
		SELECT i->>'TotalRemaining' INTO v_stock_sratch_card;
		END IF;
		END LOOP;
	ELSE
		SELECT SD."ShiftId", SD."SalePointId", SD."DistributeDate" INTO v_shift_id, v_salePoint_id,v_date
		FROM "ShiftDistribute" SD 
		WHERE SD."ShiftDistributeId" = p_shift_dis_id;
		FOR i IN SELECT * FROM json_array_elements(omgjson2) LOOP 
		IF ((i->>'LotteryChannelId')::INT = p_channel_id) THEN
		SELECT i->>'TotalRemaining' INTO v_stock_sratch_card;
		END IF;
		END LOOP;
	END IF;
	RETURN v_stock_sratch_card;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

