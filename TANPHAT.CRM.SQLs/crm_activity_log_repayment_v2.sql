-- ================================
-- Author: Phi
-- Description: Ghi nhận nợ cho khách trả
-- Edited date: 31/03/2022
-- SELECT * FROM crm_activity_log_repayment_v2();
-- ================================
SELECT dropallfunction_byname('crm_activity_log_repayment_v2');
CREATE OR REPLACE FUNCTION crm_activity_log_repayment_v2
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_sale_point_id INT,
	p_customer_name VARCHAR,
	p_note TEXT,
	p_amount NUMERIC,
	p_user_role_id INT
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
	v_sale_point_id INT;
	v_shift_dis_id INT;
	v_is_super_admin BOOL;
	v_is_manager BOOL;
	v_is_staff BOOL;
BEGIN
	
	SELECT 
		f."IsSuperAdmin",
		f."IsManager",
		f."IsStaff",
		f."SalePointId",
		f."ShiftDistributeId"
	INTO v_is_super_admin, v_is_manager, v_is_staff, v_sale_point_id, v_shift_dis_id
	FROM fn_get_shift_info(p_user_role_id) f;
		
	IF COALESCE(v_sale_point_id, 0) > 0 THEN
		
		INSERT INTO "Repayment"(
			"CustomerName",
			"Amount",
			"Note",
			"ActionBy",
			"ActionByName",
			"SalePointId",
			"ShiftDistributeId"
		) VALUES (
			p_customer_name,
			p_amount,
			p_note,
			p_action_by,
			p_action_by_name,
			v_sale_point_id,
			v_shift_dis_id
		) RETURNING "RepaymentId" INTO v_id;
		v_mess := 'Ghi nhận thành công';
		
	ELSE 
 
		v_id := 0;
		v_mess := 'Nhân viên không trong ca làm việc';
 
	END IF;
	
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