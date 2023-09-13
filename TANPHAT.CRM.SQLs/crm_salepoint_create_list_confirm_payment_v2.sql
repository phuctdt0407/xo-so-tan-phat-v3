-- ================================
-- Author: Tien
-- Description: CREATE LIST CONFIRM PAYMENT
-- Created date: 29/06/2022

--SELECT * FROM crm_salepoint_create_list_confirm_payment_v2(0,'System_29_06_2022',1,'[{"LotteryDate":"2023-03-30","IsScratchcard":false,"LotteryChannelId":16,"Quantity":33,"LotteryTypeId":1}]','{"UserRoleId":3,"GuestId":4,"ShiftDistributeId":1504}' , '[{"GuestId": 7, "SalePointId": 2,"TotalPrice":9999, "FormPaymentId":1}]' )
-- ================================
SELECT dropallfunction_byname('crm_salepoint_create_list_confirm_payment_v2');
CREATE OR REPLACE FUNCTION crm_salepoint_create_list_confirm_payment_v2
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_guest_id INT DEFAULT NULL,
	p_lottery_data TEXT DEFAULT NULL,
	p_lottery_data_info TEXT DEFAULT NULL,
	p_payment_data TEXT DEFAULT NULL,
	p_order_id INT DEFAULT NULL
)
RETURNS TABLE
(
	"Id" INT,
	"Message" TEXT,
	"OrderId" INT
)
AS $BODY$
DECLARE
	v_id INT := -1;
	v_mess TEXT := 'Dữ liệu chưa';
	v_now TIMESTAMP :=NOW();
	ele JSON;
	v_sale_point_id INT;
	v_shift_dis INT;
BEGIN
	v_sale_point_id := (p_lottery_data_info::JSON->>'SalePointId')::INT;
	v_shift_dis := (p_lottery_data_info::JSON->>'ShiftDistributeId')::INT;
		--Tạo hoá đơn khi chưa có
	IF p_order_id IS NULL THEN
		raise notice 'TH 1';
		INSERT INTO "HistoryOfOrder" (
			"SalePointId",
			"CreatedBy",
			"CreatedByName",
			"CreatedDate",
			"IsDeleted",
			"ShiftDistributeId"
		)
		VALUES (
			v_sale_point_id,
			p_action_by,
			p_action_by_name,
			v_now,
			FALSE,
			v_shift_dis
		) RETURNING "HistoryOfOrderId" INTO p_order_id;
		
	END IF;

  IF p_lottery_data IS NOT NULL THEN
		raise notice 'TH 2';
		--LOTTERY
		SELECT f."Id", f."Message"
		INTO v_id, v_mess
		FROM crm_salepoint_update_cornfirm_item_v2(p_action_by, p_action_by_name, 3, p_lottery_data, NULL, 1, 3 , p_lottery_data_info, p_guest_id, v_now, p_order_id) f ;
		
		IF v_id <= 0 THEN
			RAISE '%', v_mess;
		END IF;
	END IF; 
	
	IF p_payment_data IS NOT NULL THEN
		raise notice 'TH 3';
		--PAYMENT
		SELECT f."Id", f."Message"
		INTO v_id, v_mess
		FROM crm_salepoint_update_cornfirm_item_v2(p_action_by, p_action_by_name, 2, p_payment_data, NULL, 1, 2 , p_lottery_data_info, p_guest_id, v_now, p_order_id) f ;
		IF v_id <= 0 THEN
			RAISE '%', v_mess;
		END IF;
		
	END IF; 
	

	RETURN QUERY
	SELECT v_id, v_mess, p_order_id;

	EXCEPTION WHEN OTHERS THEN
	BEGIN
	v_id := -1;
	v_mess := sqlerrm;


	RETURN QUERY
	SELECT v_id, v_mess, p_order_id;
	END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE

