-- ================================
-- Author: Hieu
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_report_update_kpi(1,'dsa','hoc bi benh rui di benh vien kham di',823)
-- ================================
SELECT dropallfunction_byname('crm_report_update_kpi');
CREATE OR REPLACE FUNCTION crm_report_update_kpi
(   
    p_action_by INT,
		p_action_by_name VARCHAR,
		p_note TEXT,
		p_kpi_log_id INT8
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
	UPDATE "KPILog"
		SET
		"ModifyBy" = p_action_by,
		"ModifyByName" = p_action_by_name,
		"Note" = p_note
	WHERE "KPILogId" = p_kpi_log_id;


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
