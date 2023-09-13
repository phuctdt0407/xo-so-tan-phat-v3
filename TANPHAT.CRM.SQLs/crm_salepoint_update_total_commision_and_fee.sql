-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_salepoint_update_total_commision_and_fee('2023-01-09',7,200,30);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_update_total_commision_and_fee');
CREATE OR REPLACE FUNCTION crm_salepoint_update_total_commision_and_fee 
(
    	p_date timestamp,
			p_commissionId INT,
			p_commision int8,
			p_fee int8
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
		UPDATE 
			"Commission"
		SET 
		"TotalValue" = p_commision - p_fee,
		"Fee" = p_fee
		WHERE "Date" = p_date::DATE AND "CommissionId" = p_commissionId
		AND "IsDeleted" = FALSE;
		v_id:=1;
		v_mess:='Cập nhật thành công';
		
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