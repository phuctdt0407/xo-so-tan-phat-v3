-- ================================
-- Author: Phi
-- Description: Update shift
-- Created date: 03/03/2022
-- SELECT * FROM crm_user_update_shift();
-- ================================
SELECT dropallfunction_byname('crm_user_update_shift');
CREATE OR REPLACE FUNCTION crm_user_update_shift
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_distribute_date TIMESTAMP,
	p_sale_point_id INT,
	p_shift_id INT,
	p_user_id INT,
	p_shift_type_id INT,
	p_note TEXT
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
	
	UPDATE "ShiftDistribute"
	SET
		"IsActive" = FALSE,
		"ActionBy" = p_action_by,
		"ActionByName" = p_action_by_name,
		"ActionDate" = NOW()
	WHERE "DistributeDate" = p_distribute_date::DATE
		AND "SalePointId" = p_sale_point_id
		AND "ShiftId" = p_shift_id;
		
	INSERT INTO "ShiftDistribute"(
		"DistributeDate",
		"SalePointId",
		"ShiftId",
		"UserId",
		"ActionBy",
		"ActionByName",
		"ShiftTypeId",
		"Note"
	) VALUES (
		p_distribute_date::DATE,
		p_sale_point_id,
		p_shift_id,
		p_user_id,
		p_action_by,
		p_action_by_name,
		p_shift_type_id,
		p_note
	) RETURNING "ShiftDistributeId" INTO v_id;
	
	v_mess := 'Cập nhật ca làm việc thành công';
	
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