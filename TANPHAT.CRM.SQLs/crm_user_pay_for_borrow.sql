-- ================================
-- Author: Quang
-- Description: 
-- Created date:
-- SELECT * FROM crm_user_pay_for_borrow(0 ,'System', 3, '{"ManagerBorrowId": 6, "Note": "Phi trả nợ 12/12", "FormPaymentId": 1, "Price": 100000, "UserId": 10}')
-- ================================
SELECT dropallfunction_byname('crm_user_pay_for_borrow');
CREATE OR REPLACE FUNCTION crm_user_pay_for_borrow 
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
	ele JSON := p_data::JSON;
	v_time TIMESTAMP := NOW();
BEGIN
	--INSERT
	IF p_action_type = 1 THEN 
		
		INSERT INTO "ManagerBorrow"(
			"UserId",
			"FormPaymentId",
			"Price",
			"CreatedBy",
			"CreatedByName",
			"CreatedDate",
			"Note",
			"IsDeleted",
			"IsPay"
		)
		VALUES(
			(ele->>'UserId')::INT,
			COALESCE((ele->>'FormPaymentId')::INT, 1),
			(ele->>'Price')::NUMERIC,
			p_action_by,
			p_action_by_name,
			v_time,
			(ele->>'Note')::VARCHAR,
			FALSE,
			TRUE			
		)RETURNING "ManagerBorrowId" INTO v_id;
				
		v_mess := 'Thêm thành công';
		
	--UPDATE
	ELSEIF p_action_type = 2 THEN
		--DO SOMETHING
		
		v_id := 1;
		v_mess := 'Cập nhật thành công';
		
	--DELETE
	ELSEIF p_action_type = 3 THEN
	
		IF (ele->>'ManagerBorrowId')::INT IS NOT NULL THEN
		
			UPDATE "ManagerBorrow"
			SET	
				"IsDeleted" = TRUE,
				"CreatedBy" = p_action_by,
				"CreatedByName" = p_action_by_name,
				"CreatedDate" = v_time
			WHERE "ManagerBorrowId" = (ele->>'ManagerBorrowId')::INT;
			
			v_id := 1;
			v_mess := 'Xóa thành công';
		ELSE 
			RAISE 'Không có gì để xoá';
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