-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_activity_update_price_for_guest(72,1.5,25.5)
-- ================================
SELECT dropallfunction_byname('crm_activity_update_price_for_guest');
CREATE OR REPLACE FUNCTION crm_activity_update_price_for_guest 
(
    p_guest_id INT,
		p_scratch_price DECIMAL,
		p_whole_sale_price DECIMAL
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
   
		Update "Guest"
		Set 
			"WholesalePrice" = p_whole_sale_price,
			"ScratchPrice" = p_scratch_price
		WHERE "GuestId" = p_guest_id;
		
		INSERT INTO 
			"MarketPrice" 
		VALUES 
		(
			NOW(),
			p_whole_sale_price,
			p_scratch_price,
			p_guest_id,
			(SELECT "FullName" FROM "Guest" WHERE "GuestId" = p_guest_id),
			(SELECT "Phone" FROM "Guest" WHERE "GuestId" = p_guest_id)
		);
		v_id := 1;
		v_mess := 'Cập nhật giá tiền thành công';
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