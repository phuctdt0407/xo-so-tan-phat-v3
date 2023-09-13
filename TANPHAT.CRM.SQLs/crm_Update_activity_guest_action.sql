-- ================================
-- Author: Hieu
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_update_activity_guest_action(0,'haha','1,2')
-- ================================
SELECT dropallfunction_byname('crm_update_activity_guest_action');
CREATE OR REPLACE FUNCTION crm_update_activity_guest_action
(   
    p_action_by INT4,
		p_action_by_name VARCHAR,
		p_arr_guest_action_id TEXT
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
arr integer[];
i integer;
BEGIN   
	arr := string_to_array(p_arr_guest_action_id, ',');
	FOR i IN 1..array_length(arr, 1)
	LOOP 
	
		UPDATE "GuestAction"
		SET
			"ModifyBy" = p_action_by,
			"ModifyByName" = p_action_by_name,
			"ModifyDate" = NOW(),
			"IsDeleted"= TRUE
		WHERE "GuestActionId" = i;
  END LOOP;
    v_id := 1;
    v_mess := 'Update thanh cong';
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
