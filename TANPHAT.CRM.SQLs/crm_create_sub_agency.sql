-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_create_sub_agency('dailimeocon',1200)
-- ================================
SELECT dropallfunction_byname('crm_create_sub_agency');
CREATE OR REPLACE FUNCTION crm_create_sub_agency 
(
   p_agency_name varchar,
	 p_price DECIMAL
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
		INSERT INTO "SubAgency"
		("AgencyName","Price")
		VALUES (p_agency_name,p_price);
		v_mess := 'Tạo mới thành công';
		v_id := 1;
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