-- ================================
-- Author: Hieu
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_report_update_is_sum_kpi(13, 3, '2023-01',true)
-- ================================
SELECT dropallfunction_byname('crm_report_update_is_sum_kpi');
CREATE OR REPLACE FUNCTION crm_report_update_is_sum_kpi
(   
    p_user_id INT,
		p_week_id INT,
		p_month VARCHAR,
		p_is_deleted bool
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
		IF NOT EXISTS (SELECT 1 FROM "ExemptKpi" E 
										WHERE E."UserId" = p_user_id 
											AND E."WeekId" = p_week_id 
											AND E."Month" = p_month)
		THEN
			INSERT INTO "ExemptKpi" ("UserId", "WeekId", "Month", "IsSumKpi")
			VALUES (p_user_id, p_week_id, p_month, p_is_deleted);
		ELSE
			UPDATE "ExemptKpi"
			SET
				"IsSumKpi" = p_is_deleted
			WHERE "UserId" = p_user_id 
											AND "WeekId" = p_week_id 
											AND "Month" = p_month;
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
