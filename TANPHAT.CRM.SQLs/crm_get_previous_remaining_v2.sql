-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_previous_remaining_v2(14064, 42, 1, '2023-03-04', '2023-03-04');
-- ================================
SELECT dropallfunction_byname('crm_get_previous_remaining_v2');
CREATE OR REPLACE FUNCTION crm_get_previous_remaining_v2
(
	p_shift_dis_id INT,
	p_channel_id INT,
	p_lottery_type_id INT,
	p_lottery_date DATE,
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
		
		WITH tmp AS(
			SELECT 
				T."TransitionTypeId",
				T."TotalTrans",
				T."TotalTransDup"
			FROM "Transition" T
			WHERE T."LotteryChannelId" = p_channel_id
				AND T."TransitionDate"::DATE = p_date::DATE
				AND T."ConfirmStatusId" = 2
				AND (T."FromSalePointId" = v_salePoint_id OR T."ToSalePointId" = v_salePoint_id)
				AND T."IsScratchcard" IS TRUE
		)
		SELECT 
			(CASE WHEN p_lottery_type_id = 3 THEN 
				SUM(tmp."TotalTrans") FILTER(WHERE tmp."TransitionTypeId" = 1) ELSE 
				SUM(0) FILTER(WHERE tmp."TransitionTypeId" = 1) END)::INT,
			(CASE WHEN p_lottery_type_id = 3 THEN 
				SUM(tmp."TotalTrans") FILTER(WHERE tmp."TransitionTypeId" = 2) ELSE 
				SUM(0) FILTER(WHERE tmp."TransitionTypeId" = 2) END)::INT 
		INTO v_trans, v_return
		FROM tmp;
					
		SELECT 
			("TotalRemaining" + COALESCE((SELECT SUM("Quantity") FROM "SalePointLog" WHERE ("ActionDate"::DATE BETWEEN p_date::DATE AND NOW()::DATE)  AND "LotteryTypeId" = 3 AND "SalePointId" = v_salePoint_id AND "IsDeleted" IS FALSE AND "LotteryChannelId" = p_channel_id), 0) + COALESCE(v_trans, 0) - COALESCE(v_return, 0))
		INTO v_stock_sratch_card
		FROM "Scratchcard" 
		WHERE "SalePointId" = v_salePoint_id AND "LotteryChannelId" = p_channel_id;
		
		WITH tmp AS(
			SELECT 
				T."TransitionTypeId",
				T."TotalTrans",
				T."TotalTransDup"
			FROM "Transition" T
			WHERE T."LotteryChannelId" = p_channel_id
				AND T."LotteryDate" = p_lottery_date::DATE
				AND T."TransitionDate"::DATE < p_date::DATE
				AND T."ConfirmStatusId" = 2
				AND (T."FromSalePointId" = v_salePoint_id OR T."ToSalePointId" = v_salePoint_id)
				AND T."IsScratchcard" IS FALSE
		)
		SELECT 
			(CASE WHEN p_lottery_type_id = 1 THEN 
				SUM(tmp."TotalTrans") FILTER(WHERE tmp."TransitionTypeId" = 1) ELSE 
				SUM(tmp."TotalTransDup") FILTER(WHERE tmp."TransitionTypeId" = 1) END)::INT,
			(CASE WHEN p_lottery_type_id = 1 THEN 
				SUM(tmp."TotalTrans") FILTER(WHERE tmp."TransitionTypeId" = 2) ELSE 
				SUM(tmp."TotalTransDup") FILTER(WHERE tmp."TransitionTypeId" = 2) END)::INT 
		INTO v_trans, v_return
		FROM tmp;	
		
		SELECT
			SUM(SL."Quantity") INTO v_sold
		FROM "SalePointLog" SL 
		WHERE "ActionDate"::DATE < p_date
 			AND SL."LotteryChannelId" = p_channel_id 
 			AND SL."LotteryTypeId" = p_lottery_type_id 
 			AND SL."LotteryDate" = p_lottery_date
			AND SL."SalePointId" = v_salePoint_id
			AND SL."IsDeleted" IS FALSE;
		
		
	ELSE
	
		WITH tmp AS(
			SELECT 
				T."TransitionTypeId",
				T."TotalTrans",
				T."TotalTransDup"
			FROM "Transition" T
			WHERE T."ShiftDistributeId" <> p_shift_dis_id
				AND T."LotteryChannelId" = p_channel_id
				AND T."TransitionDate"::DATE <= p_date::DATE
				AND T."ConfirmStatusId" = 2
				AND (T."FromSalePointId" = v_salePoint_id OR T."ToSalePointId" = v_salePoint_id)
				AND T."IsScratchcard" IS TRUE
		)
		SELECT 
			(CASE WHEN p_lottery_type_id = 3 THEN 
				SUM(tmp."TotalTrans") FILTER(WHERE tmp."TransitionTypeId" = 1) ELSE 
				SUM(0) FILTER(WHERE tmp."TransitionTypeId" = 1) END)::INT,
			(CASE WHEN p_lottery_type_id = 3 THEN 
				SUM(tmp."TotalTrans") FILTER(WHERE tmp."TransitionTypeId" = 2) ELSE 
				SUM(0) FILTER(WHERE tmp."TransitionTypeId" = 2) END)::INT 
		INTO v_trans, v_return
		FROM tmp;
		
		SELECT 
			("TotalReceived" - COALESCE((SELECT SUM("Quantity") FROM "SalePointLog" WHERE "ActionDate"::DATE <= p_date AND "LotteryTypeId" = 3 AND "SalePointId" = v_salePoint_id AND "ShiftDistributeId" <> p_shift_dis_id AND "IsDeleted" IS FALSE AND "LotteryChannelId" = p_channel_id), 0) - COALESCE(v_trans, 0) + COALESCE(v_return, 0))
		INTO v_stock_sratch_card
		FROM "Scratchcard" WHERE "SalePointId" = v_salePoint_id AND "LotteryChannelId" = p_channel_id;
	
		WITH tmp AS(
			SELECT 
				T."TransitionTypeId",
				T."TotalTrans",
				T."TotalTransDup"
			FROM "Transition" T
			WHERE T."ShiftDistributeId" <> p_shift_dis_id
				AND T."LotteryChannelId" = p_channel_id
				AND T."LotteryDate" = p_lottery_date::DATE
				AND T."TransitionDate"::DATE <= p_date::DATE
				AND T."ConfirmStatusId" = 2
				AND (T."FromSalePointId" = v_salePoint_id OR T."ToSalePointId" = v_salePoint_id)
				AND T."IsScratchcard" IS FALSE
		)
		SELECT 
			(CASE WHEN p_lottery_type_id = 1 THEN 
				SUM(tmp."TotalTrans") FILTER(WHERE tmp."TransitionTypeId" = 1) ELSE 
				SUM(tmp."TotalTransDup") FILTER(WHERE tmp."TransitionTypeId" = 1) END)::INT,
			(CASE WHEN p_lottery_type_id = 1 THEN 
				SUM(tmp."TotalTrans") FILTER(WHERE tmp."TransitionTypeId" = 2) ELSE 
				SUM(tmp."TotalTransDup") FILTER(WHERE tmp."TransitionTypeId" = 2) END)::INT
		INTO v_trans, v_return
		FROM tmp;
		
		SELECT
			SUM(SL."Quantity") INTO v_sold
		FROM "SalePointLog" SL 
		WHERE SL."ShiftDistributeId" <> p_shift_dis_id
			AND "ActionDate"::DATE <= p_date
 			AND SL."LotteryChannelId" = p_channel_id 
 			AND SL."LotteryTypeId" = p_lottery_type_id 
 			AND SL."LotteryDate" = p_lottery_date
			AND SL."SalePointId" = v_salePoint_id
			AND SL."IsDeleted" IS FALSE;
						
	
		
	END IF;
	
	IF p_lottery_type_id <> 3 THEN

		SELECT  
			(CASE WHEN p_lottery_type_id = 1 THEN SUM(IL."TotalReceived")
						WHEN p_lottery_type_id = 2 THEN SUM(IL."TotalDupReceived") END) INTO v_invent_log
		FROM "InventoryLog" IL 
		WHERE IL."LotteryChannelId" = p_channel_id 
			AND IL."LotteryDate" = p_lottery_date 
			AND IL."SalePointId" = v_salePoint_id;

		-- RAISE NOTICE 'v_invent_log: %, v_sold: %, v_trans: %, v_return: %', v_invent_log, v_sold, v_trans, v_return;
		RETURN COALESCE(v_invent_log, 0) - COALESCE(v_sold, 0) - COALESCE(v_trans, 0) + COALESCE(v_return, 0);
		
	ELSE
	
		RETURN (
			SELECT v_stock_sratch_card
		);
	
	END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE

