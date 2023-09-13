-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_previous_remaining(924, 9, 1, '2022-05-23');
-- ================================
SELECT dropallfunction_byname('crm_get_previous_remaining');
CREATE OR REPLACE FUNCTION crm_get_previous_remaining
(
	p_shift_dis_id INT,
	p_channel_id INT,
	p_lottery_type_id INT,
	p_date DATE
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
	v_stock_sratch_card INT;
	v_trans INT;
	v_return INT;
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
					
		SELECT 
			("TotalReceived" - (SELECT SUM("Quantity") FROM "SalePointLog" WHERE "ActionDate"::DATE < p_date AND "LotteryTypeId" = 3 AND "SalePointId" = v_salePoint_id))
		INTO v_stock_sratch_card
		FROM "Scratchcard" WHERE "SalePointId" = v_salePoint_id;
		
	ELSE
	
		SELECT SD."ShiftDistributeId" INTO v_shift_bef_dis_id 
		FROM "ShiftDistribute" SD 
		WHERE SD."DistributeDate" = v_date
			AND SD."ShiftId" =  1
			AND SD."SalePointId" =  v_salePoint_id;
						
		SELECT 
			("TotalReceived" - (SELECT SUM("Quantity") FROM "SalePointLog" WHERE "ActionDate"::DATE <= p_date AND "LotteryTypeId" = 3 AND "SalePointId" = v_salePoint_id AND "ShiftDistributeId" <> p_shift_dis_id))
		INTO v_stock_sratch_card
		FROM "Scratchcard" WHERE "SalePointId" = v_salePoint_id;
		
	END IF;
	
	IF p_lottery_type_id <> 3 THEN

		SELECT SF."TotalRemaining", SF."TotalSold" INTO v_pre_stock, v_sold
		FROM "ShiftTransfer" SF 
		WHERE SF."ShiftDistributeId" = v_shift_bef_dis_id 
			AND SF."LotteryChannelId" = p_channel_id 
			AND SF."LotteryTypeId" = p_lottery_type_id 
			AND (SF."LotteryDate" = p_date OR (p_date IS NULL));
			
		WITH tmp AS(
			SELECT 
				T."TransitionTypeId",
				SUM(T."TotalTrans") AS "TotalTrans",
				SUM(T."TotalTransDup") AS "TotalTransDup"
			FROM "Transition" T
			WHERE T."ShiftDistributeId" = v_shift_bef_dis_id 
				AND T."LotteryChannelId" = p_channel_id
				AND T."LotteryDate" = p_date::DATE
				AND T."ConfirmStatusId" = 2
			GROUP BY
				T."TransitionTypeId"
		)	
				
		SELECT (CASE WHEN p_lottery_type_id = 1 THEN SUM(tmp."TotalTrans") ELSE SUM(tmp."TotalTransDup") END)::INT INTO v_trans
		FROM tmp
		WHERE tmp."TransitionTypeId" = 1;
		
		WITH tmp AS(
			SELECT 
				T."TransitionTypeId",
				SUM(T."TotalTrans") AS "TotalTrans",
				SUM(T."TotalTransDup") AS "TotalTransDup"
			FROM "Transition" T
			WHERE T."ShiftDistributeId" = v_shift_bef_dis_id 
				AND T."LotteryChannelId" = p_channel_id
				AND T."LotteryDate" = p_date::DATE
				AND T."ConfirmStatusId" = 2
			GROUP BY
				T."TransitionTypeId"
		)	
				
		SELECT (CASE WHEN p_lottery_type_id = 1 THEN SUM(tmp."TotalTrans") ELSE SUM(tmp."TotalTransDup") END)::INT INTO v_return
		FROM tmp
		WHERE tmp."TransitionTypeId" = 2;
	
	
		SELECT  
			(CASE WHEN p_lottery_type_id = 1 THEN SUM(IL."TotalReceived")
						WHEN p_lottery_type_id = 2 THEN SUM(IL."TotalDupReceived") END) INTO v_invent_log
		FROM "InventoryLog" IL 
		WHERE IL."LotteryChannelId" = p_channel_id 
			AND IL."LotteryDate" = p_date 
			AND IL."SalePointId" = v_salePoint_id;
		
			IF(EXISTS (
					SELECT 1
					FROM "ShiftTransfer" SF 
					WHERE SF."ShiftDistributeId" = v_shift_bef_dis_id AND SF."LotteryChannelId" = p_channel_id AND SF."LotteryTypeId" = p_lottery_type_id AND (SF."LotteryDate" = p_date OR (p_date IS NULL))
				)) THEN
				RETURN(
					SELECT SF."TotalRemaining"
					FROM "ShiftTransfer" SF 
					WHERE SF."ShiftDistributeId" = v_shift_bef_dis_id AND SF."LotteryChannelId" = p_channel_id AND SF."LotteryTypeId" = p_lottery_type_id AND (SF."LotteryDate" = p_date OR (p_date IS NULL))
				);
			ELSEIF v_shift_id = 2 THEN 
				RETURN (
					SELECT (CASE WHEN p_lottery_type_id = 1 THEN I."TotalRemaining"
											 WHEN p_lottery_type_id = 2 THEN I."TotalDupRemaining" ELSE 0 END)
					FROM "Inventory" I
					WHERE I."LotteryChannelId" = p_channel_id
						AND I."LotteryDate" = p_date
						AND I."SalePointId" = v_salePoint_id
					LIMIT 1
				);
			ELSE 
				RETURN (v_invent_log);
			END IF;
	
	ELSE
	
		RETURN (
			SELECT v_stock_sratch_card
		);
	
	END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE

