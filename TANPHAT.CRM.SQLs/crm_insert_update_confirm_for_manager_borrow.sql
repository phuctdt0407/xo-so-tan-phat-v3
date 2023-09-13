-- ================================
-- Author: Quang
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_insert_update_confirm_for_manager_borrow(0 ,'System', 2, '{"ConfirmLogId": 342, "DataForConfirm": [{"FormPaymentId": 1, "Price": 100000}],"Note": "TESST", "UserId": 10}')
-- ================================
SELECT dropallfunction_byname('crm_insert_update_confirm_for_manager_borrow');
CREATE OR REPLACE FUNCTION crm_insert_update_confirm_for_manager_borrow 
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_action_type INT,
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
	v_check INT;
	ele JSON := (p_data::JSON);
	elele JSON;
	v_data TEXT;
	v_user_id INT;
	v_time TIMESTAMP := NOW();
BEGIN
	--INSERT
	IF p_action_type = 1 THEN 
		INSERT INTO "ConfirmLog" (
			"Data",
			"ActionDate",
			"ActionBy",
			"ActionByName",
			"ConfirmStatusId",
			"ConfirmFor",
			"DataActionInfo"
		) VALUES (
			ele::TEXT,
			v_time,
			p_action_by,
			p_action_by_name,
			1,
			5,
			(ele->>'UserId')::TEXT
		) RETURNING "ConfirmLogId" INTO v_id;
				
		v_mess := 'Thêm thành công';
		
	--UPDATE
	ELSEIF p_action_type = 2 THEN
		
		SELECT 
			CL."ConfirmStatusId",  
			CL."Data",
			CL."DataActionInfo"::INT
		INTO
			v_check,
			v_data,
			v_user_id
		FROM "ConfirmLog" CL
		WHERE CL."ConfirmLogId" = (ele->>'ConfirmLogId')::INT;
		
		IF v_check = 1 THEN
			UPDATE "ConfirmLog"
			SET
				"ConfirmStatusId" = 2,
				"ConfirmDate" = v_time
			WHERE "ConfirmLogId" = (ele->>'ConfirmLogId')::INT;
 	
			FOR elele IN SELECT * FROM json_array_elements(((v_data::JSON)->>'DataForConfirm')::JSON) LOOP
				INSERT INTO "ManagerBorrow"(
					"UserId",
					"FormPaymentId",
					"Price",
					"CreatedBy",
					"CreatedByName",
					"CreatedDate",
					"Note",
					"IsDeleted"
				)
				VALUES(
					v_user_id,
					(elele->>'FormPaymentId')::INT,
					(elele->>'Price')::NUMERIC,
					p_action_by,
					p_action_by_name,
					v_time,
					((v_data::JSON)->>'Note')::VARCHAR,
					FALSE
				);	
			END LOOP;
						
		ELSE 
			RAISE 'Yêu cầu đã được xác nhận trước đó';
		END IF;
		
		v_id := 1;
		v_mess := 'Xác nhận thành công';
		
	--DELETE
	ELSEIF p_action_type = 3 THEN
	
		SELECT 
			CL."ConfirmStatusId",  
			CL."Data",
			CL."DataActionInfo"::INT
		INTO
			v_check,
			v_data,
			v_user_id
		FROM "ConfirmLog" CL
		WHERE CL."ConfirmLogId" = (ele->>'ConfirmLogId')::INT;
		
		IF v_check = 1 THEN
			UPDATE "ConfirmLog"
			SET
				"ConfirmStatusId" = 3,
				"ConfirmDate" = v_time
			WHERE "ConfirmLogId" = (ele->>'ConfirmLogId')::INT;
		ELSE 
			RAISE 'Yêu cầu đã được xác nhận trước đó';
		END IF;
		
		v_id := 1;
		v_mess := 'Huỷ thành công';
		
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