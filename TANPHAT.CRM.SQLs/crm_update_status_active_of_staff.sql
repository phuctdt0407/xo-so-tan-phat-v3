-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_update_status_active_of_staff(32, 'Vit',6,false )
-- ================================
SELECT dropallfunction_byname('crm_update_status_active_of_staff');
CREATE OR REPLACE FUNCTION crm_update_status_active_of_staff 
(
    p_action_by INT,
    p_action_by_name VARCHAR,
    p_user_id INT,
		p_toggle BOOl
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
    
		UPDATE "User"
		SET "IsActive" = p_toggle WHERE "UserId" = p_user_id;
		v_id := 1;
		v_mess := 'Cập nhật thành công';

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