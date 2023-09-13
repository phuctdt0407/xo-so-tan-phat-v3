-- ================================
-- Author: Hieu
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_user_update_total_first(1,'test',1,99999)
-- ================================
SELECT dropallfunction_byname('crm_user_update_total_first');
CREATE OR REPLACE FUNCTION crm_user_update_total_first
(   
		p_action_by INT,
		p_action_by_name VARCHAR,
		p_user_id INT,
		p_total_first INT8
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
	UPDATE "User"
	SET
		"TotalFirst" = p_total_first,
		"ModifyBy" = p_action_by,
		"ModifyByName" = p_action_by_name
	WHERE "UserId" = p_user_id;
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
