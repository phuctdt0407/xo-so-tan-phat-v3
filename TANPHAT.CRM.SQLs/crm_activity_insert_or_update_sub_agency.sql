-- ================================
-- Author: Hieu
-- Description: 
-- Created date:
-- SELECT * FROM crm_activity_insert_or_update_sub_agency('haha',FALSE,FALSE,111.00)
-- ================================
SELECT dropallfunction_byname('crm_activity_insert_or_update_sub_agency');
CREATE OR REPLACE FUNCTION crm_activity_insert_or_update_sub_agency
(   
		p_agency_name VARCHAR,
		p_is_activity BOOLEAN DEFAULT TRUE,
		p_is_deleted BOOLEAN DEFAULT FALSE,
		p_price FLOAT DEFAULT 0,
		p_agency_id INT DEFAULT 0
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

	IF p_agency_id = 0
	THEN
		INSERT INTO "SubAgency" ("AgencyName", "Price")
		VALUES (p_agency_name, p_price);
	ELSE
		UPDATE "SubAgency"
			SET 
				"AgencyName" = p_agency_name,
				"Price" = p_price,
				"IsActive" = p_is_activity,
				"IsDelete" = p_is_deleted
		WHERE "AgencyId" = p_agency_id;
	END IF;
		
    
    v_id := 1;
    v_mess := 'Update successful';
   RETURN QUERY   
SELECT
    v_id,
    v_mess;

   EXCEPTION WHEN OTHERS THEN    
			BEGIN        
				v_id := -1;        
				v_mess := sqlerrm;        
	 RETURN QUERY        
			SELECT 
				v_id, 
				v_mess;    
	 END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
