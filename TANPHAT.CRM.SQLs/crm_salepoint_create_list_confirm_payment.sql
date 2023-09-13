-- ================================
-- Author: Tien
-- Description: CREATE LIST CONFIRM PAYMENT
-- Created date: 29/06/2022

--SELECT * FROM crm_salepoint_create_list_confirm_payment(0,'System_29_06_2022',1,'[{"LotteryDate": null, "IsScratchcard": true, "LotteryChannelId": 1000,  "Quantity": -9999,  "LotteryTypeId": 3, "LotteryPriceId": 1}]','{"UserRoleId":2,"GuestId":-1,"ShiftDistributeId":430}' , '[{"GuestId": 7, "SalePointId": 2,"TotalPrice":9999, "FormPaymentId":1}]' )
-- ================================
SELECT dropallfunction_byname('crm_salepoint_create_list_confirm_payment');
CREATE OR REPLACE FUNCTION crm_salepoint_create_list_confirm_payment
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_guest_id INT DEFAULT NULL,
	p_lottery_data TEXT DEFAULT NULL,
	p_lottery_data_info TEXT DEFAULT NULL,
	p_payment_data TEXT DEFAULT NULL
)
RETURNS TABLE
(
	"Id" INT,
	"Message" TEXT
)
AS $BODY$
DECLARE
	v_id INT := -1;
	v_mess TEXT := 'Dữ liệu chưa';
	v_now TIMESTAMP :=NOW();
	ele JSON;
BEGIN
  IF p_lottery_data IS NOT NULL THEN
		--LOTTERY
		SELECT f."Id", f."Message"
		INTO v_id, v_mess
		FROM crm_salepoint_update_cornfirm_item(p_action_by, p_action_by_name,3, p_lottery_data, NULL, 1, 3 ,p_lottery_data_info,p_guest_id,v_now) f ;
		
		IF v_id <= 0 THEN
			RAISE '%', v_mess;
		END IF;
	END IF; 
	
	IF p_payment_data IS NOT NULL THEN
		--PAYMENT
		SELECT f."Id", f."Message"
		INTO v_id, v_mess
		FROM crm_salepoint_update_cornfirm_item(p_action_by, p_action_by_name,2, p_payment_data, NULL, 1, 2 ,NULL,p_guest_id,v_now) f ;
		IF v_id <= 0 THEN
			RAISE '%', v_mess;
		END IF;
		
	END IF; 
	

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

