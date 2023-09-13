-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_user_delete_shift_of_intern(224)
-- ================================
SELECT dropallfunction_byname('crm_user_delete_shift_of_intern');
CREATE OR REPLACE FUNCTION crm_user_delete_shift_of_intern 
(
    p_shift_distribute_id INT8
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

			UPDATE "ShiftDistributeForIntern"
			SET "IsActive" = False
			WHERE "ShiftDistributeId" = p_shift_distribute_id;
				
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