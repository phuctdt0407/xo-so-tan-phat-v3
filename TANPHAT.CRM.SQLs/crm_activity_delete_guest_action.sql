-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_activity_delete_guest_action(1)
-- ================================
SELECT dropallfunction_byname('crm_activity_delete_guest_action');
CREATE OR REPLACE FUNCTION crm_activity_delete_guest_action 
(
    p_guest_id INT
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

       UPDATE "GuestAction"
			 SET "IsDeleted" = TRUE 
			 WHERE "GuestId" = p_guest_id;

        v_id := 1;
        v_mess := 'Xóa thành công';

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