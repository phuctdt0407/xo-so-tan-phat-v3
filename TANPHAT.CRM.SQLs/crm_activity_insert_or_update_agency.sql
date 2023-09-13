-- ================================
-- Author: Hieu
-- Description: 
-- Created date:
-- SELECT * FROM crm_activity_insert_or_update_agency('haha1',11,FALSE,TRUE)
-- ================================
SELECT dropallfunction_byname('crm_activity_insert_or_update_agency');
CREATE OR REPLACE FUNCTION crm_activity_insert_or_update_agency
(   
		p_agency_name VARCHAR,
		p_agency_id INT DEFAULT 0,
		p_is_activity BOOL DEFAULT TRUE,
		p_is_deleted BOOL DEFAULT FALSE
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
		INSERT INTO "Agency" ("AgencyName")
		VALUES (p_agency_name);
	ELSE
		UPDATE "Agency"
			SET 
				"AgencyName" = p_agency_name,
				"IsActive" = p_is_activity,
				"IsDeleted" = p_is_deleted
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
