-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_sale_point_insert_or_update_fee_outsite('[{"SalePointId":"","Note":"chuyển khoản","TypeNameId":3,"TransactionId":21987,"Price":4050000}]')
-- ================================
SELECT dropallfunction_byname('crm_sale_point_insert_or_update_fee_outsite');
CREATE OR REPLACE FUNCTION crm_sale_point_insert_or_update_fee_outsite
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
	v_time TIMESTAMP := NOW();
	v_id INT;
	v_mess TEXT;
	ele JSON;
BEGIN

	-- Thêm
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
				"ActionBy",
				"ActionByName",
				"ActionDate",
				"Date"
			)
			VALUES(
				1,
				(ele->>'Note')::VARCHAR,
				(ele->>'Quantity')::INT,
				(ele->>'Price')::NUMERIC,
				((ele->>'Price')::NUMERIC * (ele->>'Quantity')::INT) :: NUMERIC,
				(ele->>'SalePointId')::INT,
				(ele->>'ShiftDistributeId')::INT,
				FALSE,
				COALESCE((ele->>'UserId')::INT, p_action_by),
				(ele->>'TypeNameId')::INT,
				p_action_by,
				p_action_by_name,
				v_time,
				v_time::DATE
			);
		END LOOP;
		v_id := 1;
		v_mess := 'Thêm thành công';
	--Sửa
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
				"ModifyBy" = p_action_by,
				"ModifyByName" = p_action_by_name,
				"ModifyDate"= v_time
			WHERE "TransactionId" = (ele->>'TransactionId') :: INT;
		END LOOP;
		v_id := 1;
		v_mess := 'Cập nhật thành công';
	--Xóa
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