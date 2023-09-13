-- ================================
-- Author: Hieu
-- Description: 
-- Created date:
-- SELECT * FROM crm_activity_update_isdeleted_salepoint_log(1,'222',2,1,'11',12,'2023-02-24')
-- ================================
SELECT dropallfunction_byname('crm_activity_update_isdeleted_salepoint_log');
CREATE OR REPLACE FUNCTION crm_activity_update_isdeleted_salepoint_log
(   
    p_action_by INT,
		p_action_by_name VARCHAR,
		p_count INT,
		p_salepoint_id INT,
		p_number VARCHAR,
		p_lottery_channel_id INT,
		p_day TIMESTAMP
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
v_lenght_number INT := LENGTH(p_number);
BEGIN   
 		v_id := -1;
    v_mess := 'Update khong thanh cong';

	IF p_count < (SELECT 
									COUNT(*)
								FROM "SalePointLog" S
								WHERE (S."LotteryDate" BETWEEN (p_day::DATE - INTERVAL'5 day') AND p_day::DATE )
										AND right(S."FourLastNumber", p_count_number) = right(p_number, p_count_number)
										AND right(S."FourLastNumber", p_count_number+1) != right(p_number, p_count_number+1)
										AND S."IsDeleted" = FALSE
										AND S."SalePointId" = p_salepoint_id
										AND S."LotteryChannelId" = p_lottery_channel_id
					LIMIT 1)
	THEN
		FOR ele IN  1..(p_count) LOOP
			WITH tmp AS
			(		SELECT 
						S."SalePointLogId"
					FROM "SalePointLog" S
					WHERE (S."LotteryDate" BETWEEN (p_day::DATE - INTERVAL'5 day') AND p_day::DATE )
							AND right(S."FourLastNumber", v_lenght_number) = p_number
							AND right(S."FourLastNumber", v_lenght_number+1) != p_number
							AND S."IsDeleted" = FALSE
							AND S."SalePointId" = p_salepoint_id
							AND S."LotteryChannelId" = p_lottery_channel_id
					LIMIT 1
			)
		
			UPDATE "SalePointLog"
				SET 
					"IsDeleted" = TRUE,
					"ActionBy" = p_action_by,
					"ActionByName" = p_action_by_name
			 WHERE "SalePointLogId" = (SELECT * FROM tmp);
		END LOOP;

    v_id := 1;
    v_mess := 'Update thanh cong';
	ELSE
		v_id := -1;
    v_mess := 'Update khong thanh cong';
	END IF;
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
