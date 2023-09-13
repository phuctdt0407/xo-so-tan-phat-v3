-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_pre_shift_distribute_id_transfer_dup_remaining(212, 16);
-- ================================
SELECT dropallfunction_byname('crm_get_pre_shift_distribute_id_transfer_dup_remaining');
CREATE OR REPLACE FUNCTION crm_get_pre_shift_distribute_id_transfer_dup_remaining
(
	p_shift_dis_id INT,
	p_channel_id INT
)
RETURNS INT
AS $BODY$
DECLARE
	v_shift_id INT;
	v_shift_bef_dis_id INT;
	v_salePoint_id INT;
	v_date DATE;
BEGIN
	SELECT SD."ShiftId", SD."SalePointId", SD."DistributeDate" INTO v_shift_id, v_salePoint_id, v_date
	FROM "ShiftDistribute" SD 
	WHERE SD."ShiftDistributeId" = p_shift_dis_id;
	IF v_shift_id = 1 THEN
		SELECT SD."ShiftDistributeId" INTO v_shift_bef_dis_id
		FROM "ShiftDistribute" SD 
		WHERE SD."DistributeDate" = (v_date - INTERVAL '1 DAY') :: DATE
			AND SD."ShiftId" =  2
			AND SD."SalePointId" =  v_salePoint_id;
	ELSE
		SELECT SD."ShiftDistributeId" INTO v_shift_bef_dis_id 
		FROM "ShiftDistribute" SD 
		WHERE SD."DistributeDate" = v_date
			AND SD."ShiftId" =  1
			AND SD."SalePointId" =  v_salePoint_id;
	END IF;
	RETURN(
	SELECT SF."TotalDupRemaining" AS "TotalDupRemaining"
	FROM "ShiftTransfer" SF 
	WHERE SF."ShiftDistributeId" = v_shift_bef_dis_id AND SF."LotteryChannelId" = p_channel_id);
END;
$BODY$
LANGUAGE plpgsql VOLATILE

