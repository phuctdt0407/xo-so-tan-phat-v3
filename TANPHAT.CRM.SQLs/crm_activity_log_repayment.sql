-- ================================
-- Author: Phi
-- Description: Ghi nhận nợ cho khách trả
-- Created date: 17/03/2022
-- SELECT * FROM crm_activity_log_repayment();
-- ================================
SELECT dropallfunction_byname('crm_activity_log_repayment');
CREATE OR REPLACE FUNCTION crm_activity_log_repayment
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_sale_point_id INT,
	p_customer_name VARCHAR,
	p_note TEXT,
	p_amount NUMERIC
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
BEGIN
	
	INSERT INTO "Repayment"(
		"CustomerName",
		"Amount",
		"Note",
		"ActionBy",
		"ActionByName",
		"SalePointId"
	) VALUES (
		p_customer_name,
		p_amount,
		p_note,
		p_action_by,
		p_action_by_name,
		p_sale_point_id
	) RETURNING "RepaymentId" INTO v_id;
	
	v_mess := 'Ghi nhận thành công';
	
	RETURN QUERY 
	SELECT 	v_id, v_mess;

	EXCEPTION WHEN OTHERS THEN
	BEGIN				
		v_id := -1;
		v_mess := sqlerrm;
		
		RETURN QUERY 
		SELECT 	v_id, v_mess;
	END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE