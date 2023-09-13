-- ================================
-- Author: Hieu
-- Description: 
-- Created date:
-- SELECT * FROM crm_user_update_scratchcard_log(0, 'sytem',19,900,FALSE)
-- ================================
SELECT dropallfunction_byname('crm_user_update_scratchcard_log');
CREATE OR REPLACE FUNCTION crm_user_update_scratchcard_log
(   
    p_action_by INT,
		p_action_by_name VARCHAR,
		p_scratchcard_log_id INT,
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
v_number INT := (SELECT SL."TotalReceived" FROM "ScratchcardLog" SL WHERE SL."ScratchcardLogId" = p_scratchcard_log_id) - p_revision_number;
BEGIN   
	IF p_is_deleted IS FALSE
	THEN
		UPDATE "ScratchcardLog"
		SET
			"TotalReceived" = p_revision_number,
			"ActionBy" = p_action_by,
			"ActionByName" = p_action_by_name,
			"ActionDate" = NOW(),
			"IsActive" = TRUE
		WHERE "ScratchcardLogId" = p_scratchcard_log_id;
		UPDATE "ScratchcardFull" 
		SET 
				"TotalRemaining" = ("TotalRemaining" + v_number),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name,
				"LastActionDate" = NOW()
		WHERE "LotteryChannelId" = (SELECT 
																	SCL."LotteryChannelId"
																FROM "ScratchcardLog" SCL
																LEFT JOIN "ScratchcardFull" SCF
																	ON SCF."LotteryChannelId" = SCL."LotteryChannelId"
																WHERE SCL."ScratchcardLogId"= p_scratchcard_log_id);
		UPDATE "Scratchcard"
			SET 
				"TotalReceived" = ("TotalReceived" - v_number),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name,
				"LastActionDate" = NOW()
		WHERE "SalePointId" = (SELECT 
														 SL."SalePointId"
													 FROM "ScratchcardLog" SL
													 WHERE SL."ScratchcardLogId" = p_scratchcard_log_id
													 LIMIT 1);
	ELSE
		UPDATE "ScratchcardLog"
		SET
			"ActionBy" = p_action_by,
			"ActionByName" = p_action_by_name,
			"ActionDate" = NOW(),
			"IsActive" = FALSE
		WHERE "ScratchcardLogId" = p_scratchcard_log_id;
		UPDATE "ScratchcardFull" 
		SET 
				"TotalRemaining" = ("TotalRemaining" + v_number),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name,
				"LastActionDate" = NOW()
		WHERE "LotteryChannelId" = (SELECT 
																	SCL."LotteryChannelId"
																FROM "ScratchcardLog" SCL
																LEFT JOIN "ScratchcardFull" SCF
																	ON SCF."LotteryChannelId" = SCL."LotteryChannelId"
																WHERE SCL."ScratchcardLogId"= p_scratchcard_log_id);
		UPDATE "Scratchcard"
			SET 
				"TotalReceived" = ("TotalReceived" - v_number),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name,
				"LastActionDate" = NOW()
		WHERE "SalePointId" = (SELECT 
														 SL."SalePointId"
													 FROM "ScratchcardLog" SL
													 WHERE SL."ScratchcardLogId" = p_scratchcard_log_id
													 LIMIT 1);
		END IF;
    
    v_id := 1;
    v_mess := 'Update thanh cong';
		raise notice '%',v_number;
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
