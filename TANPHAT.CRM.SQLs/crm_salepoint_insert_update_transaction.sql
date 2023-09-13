-- ================================
-- Author: Quang
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_salepoint_insert_update_transaction(0 ,'System', 1, 2, '[{"TransactionId": 1, "Note": "Vietllot 1/7", "Price": 2200000, "SalePointId": 3, "ShiftDistributeId": 100, "UserId": 2, "TypeNameId": 3, "Date": "2022-09-01"}]')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_insert_update_transaction');
CREATE OR REPLACE FUNCTION crm_salepoint_insert_update_transaction 
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_action_type INT,
	p_transaction_type_id INT,
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
	ele JSON;
	v_time TIMESTAMP := NOW();
BEGIN
	--INSERT
	IF p_action_type = 1 THEN 
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			INSERT INTO "Transaction"(
				"TransactionTypeId",
				"Note",
				"Quantity",
				"Price",
				"TotalPrice",
				"SalePointId",
				"ShiftDistributeId",
				"IsDeleted",
				"UserId",
				"TypeNameId",
				"Date",
				"ActionBy",
				"ActionByName",
				"ActionDate"
			)
			VALUES(
				p_transaction_type_id,
				(ele->>'Note')::VARCHAR,
				COALESCE((ele->>'Quantity')::INT, 1),
				(ele->>'Price')::NUMERIC,
				(COALESCE((ele->>'Price')::NUMERIC,0) * COALESCE((ele->>'Quantity')::INT,1)) :: NUMERIC,
				COALESCE((ele->>'SalePointId')::INT, (SELECT U."SalePointId" FROM "User" U WHERE U."UserId" = (ele->>'UserId')::INT)::INT),
				(ele->>'ShiftDistributeId')::INT,
				FALSE,
				COALESCE((ele->>'UserId')::INT, p_action_by),
				(ele->>'TypeNameId')::INT,
				COALESCE((ele->>'Date')::DATE, v_time::DATE),
				p_action_by,
				p_action_by_name,
				v_time
			) RETURNING "TransactionId" INTO v_id;
		END LOOP;
		
		v_mess := 'Thêm thành công';
		
	--UPDATE
	ELSEIF p_action_type = 2 THEN
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "Transaction" SET 
				"Note" = COALESCE((ele->>'Note')::VARCHAR, "Note"),
				"Quantity" = COALESCE((ele->>'Quantity')::INT, "Quantity"),
				"Price" =  COALESCE((ele->>'Price')::NUMERIC, "Price"),
				"TotalPrice" = COALESCE((COALESCE((ele->>'Price')::NUMERIC, "Price") * COALESCE((ele->>'Quantity')::INT, "Quantity")) :: NUMERIC, "TotalPrice"),
				"SalePointId" = COALESCE((ele->>'SalePointId')::INT, "SalePointId"),
				"ShiftDistributeId" = COALESCE((ele->>'ShiftDistributeId')::INT, "ShiftDistributeId"),
				"UserId" = COALESCE((ele->>'UserId')::INT, "UserId"),
				"TypeNameId" = COALESCE((ele->>'TypeNameId')::INT, "TypeNameId"),
				"Date" = COALESCE((ele->>'Date')::DATE, "Date"),
				"ModifyBy" = p_action_by,
				"ModifyByName" = p_action_by_name,
				"ModifyDate"= v_time
			WHERE "TransactionId" = (ele->>'TransactionId') :: INT;
		END LOOP;
		
		v_id := 1;
		v_mess := 'Cập nhật thành công';
		
	--DELETE
	ELSEIF p_action_type = 3 THEN
	
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "Transaction" SET 
				"IsDeleted" = TRUE,
				"ModifyBy" = p_action_by,
				"ModifyByName" = p_action_by_name,
				"ModifyDate"= v_time
			WHERE "TransactionId" = (ele->>'TransactionId') :: INT;
		END LOOP;
		
		v_id := 1;
		v_mess := 'Xóa thành công';
		
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