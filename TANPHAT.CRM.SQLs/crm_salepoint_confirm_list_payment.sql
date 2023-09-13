-- ================================
-- Author: Tien
-- Description: Confirm list payment
-- Created date: 01/07/2022
-- SELECT * FROM crm_salepoint_confirm_list_payment(0, 'System_DEV', 2, '[{"ConfirmLogId": 3},{"ConfirmLogId": 4}]' )
-- ================================
SELECT dropallfunction_byname('crm_salepoint_confirm_list_payment');
CREATE OR REPLACE FUNCTION crm_salepoint_confirm_list_payment
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_confirm_type INT,
	p_data TEXT
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
	v_data JSON := p_data ::JSON;
	ele JSON;
	v_check INT;
	v_confirm_status INT;
BEGIN
	FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
		SELECT 
			"ConfirmLogId",
			"ConfirmStatusId"
		INTO
			v_check,
			v_confirm_status
		FROM "ConfirmLog"
		WHERE "ConfirmLogId" = (ele ->>'ConfirmLogId')::INT;
		
		IF COALESCE(v_check,0) =0 THEN
			RAISE 'Không tồn tại ConfirmLogId';
		ELSEIF COALESCE(v_confirm_status,1) <> 1 THEN
			RAISE 'Yêu cầu đã được thao tác';
		ELSE
			SELECT
				f."Id",
				f."Message"
			INTO
				v_id,
				v_mess
			FROM crm_salepoint_update_cornfirm_item(p_action_by, p_action_by_name, 0,'',v_check,p_confirm_type,9999) f;
		
		END IF;
   
  END LOOP;

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

