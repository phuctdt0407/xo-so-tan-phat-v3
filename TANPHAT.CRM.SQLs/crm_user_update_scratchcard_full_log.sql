-- ================================
-- Author: Hieu
-- Description: 
-- Created date:
-- SELECT * FROM crm_user_update_scratchcard_full_log(1,'tes', 16,300,TRUE)
-- ================================
SELECT dropallfunction_byname('crm_user_update_scratchcard_full_log');
CREATE OR REPLACE FUNCTION crm_user_update_scratchcard_full_log
(   
    p_action_by INT,
		p_action_by_name VARCHAR,
		p_scratchcard_full_log_id INT,
		p_revision_number INT,
		p_is_deleted BOOLEAN
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
v_number INT := (SELECT SFL."TotalReceived" FROM "ScratchcardFullLog" SFL WHERE SFL."ScratchcardFullLogId"= p_scratchcard_full_log_id) - p_revision_number;
BEGIN   
	IF p_is_deleted IS FALSE
	THEN
		UPDATE "ScratchcardFullLog"
		SET
				"ActionBy" = p_action_by,
				"ActionByName" = p_action_by_name,
				"TotalReceived" = p_revision_number,
				"IsActive" = TRUE,
				"ActionDate" = NOW()
		WHERE "ScratchcardFullLogId"= p_scratchcard_full_log_id;
		UPDATE "ScratchcardFull" 
			SET 
				"TotalRemaining" = ("TotalRemaining" - v_number),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name,
				"LastActionDate" = NOW()
		WHERE "LotteryChannelId" = (SELECT 
																	SCFL."LotteryChannelId"
																FROM "ScratchcardFullLog" SCFL
																LEFT JOIN "ScratchcardFull" SCF
																	ON SCF."LotteryChannelId" = SCFL."LotteryChannelId"
																WHERE SCFL."ScratchcardFullLogId"= p_scratchcard_full_log_id);
	ELSE
		UPDATE "ScratchcardFullLog"
		SET
				"ActionBy" = p_action_by,
				"ActionByName" = p_action_by_name,
				"IsActive" = FALSE,
				"ActionDate" = NOW()
		WHERE "ScratchcardFullLogId"= p_scratchcard_full_log_id;
		UPDATE "ScratchcardFull" 
			SET 
				"TotalRemaining" = ("TotalRemaining" - v_number),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name,
				"LastActionDate" = NOW()
		WHERE "LotteryChannelId" = (SELECT 
																	SCFL."LotteryChannelId"
																FROM "ScratchcardFullLog" SCFL
																LEFT JOIN "ScratchcardFull" SCF
																	ON SCF."LotteryChannelId" = SCFL."LotteryChannelId"
																WHERE SCFL."ScratchcardFullLogId"= p_scratchcard_full_log_id);
		END IF;
    
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
