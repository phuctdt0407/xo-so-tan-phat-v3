-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_salepoint_delete_staff_in_commission_winning(18)
-- ================================
SELECT dropallfunction_byname('crm_salepoint_delete_staff_in_commission_winning');
CREATE OR REPLACE FUNCTION crm_salepoint_delete_staff_in_commission_winning 
(
		p_commissionId INT8
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
    UPDATE 
			"Commission"
		SET
			"IsDeleted" = TRUE
		WHERE "IsDeleted" = FALSE AND "CommissionId" = p_commissionId;
		v_id:=1;
		v_mess:='Xóa thành công';
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