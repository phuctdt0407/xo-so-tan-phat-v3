-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_activity_update_price_for_lottery_of_sub_agency(1,1234,'2023-03-04')
-- ================================
SELECT dropallfunction_byname('crm_activity_update_price_for_lottery_of_sub_agency');
CREATE OR REPLACE FUNCTION crm_activity_update_price_for_lottery_of_sub_agency 
(
    p_agency_id INT,
		p_price decimal,
		p_date timestamp
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
		UPDATE "SubAgency"
		SET "Price" = p_price,
		"ModifiedDate" = p_date 
		WHERE "AgencyId" = p_agency_id;
    v_id:= 1;
		v_mess:='Sửa giá thành công';
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