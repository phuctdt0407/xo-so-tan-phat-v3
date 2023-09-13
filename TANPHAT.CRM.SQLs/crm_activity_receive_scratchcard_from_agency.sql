-- ================================
-- Author: Phi
-- Description: Nhận vé cào từ đại lý
-- Created date: 24/03/2022
-- SELECT * FROM crm_activity_receive_scratchcard_from_agency();
-- ================================
SELECT dropallfunction_byname('crm_activity_receive_scratchcard_from_agency');
CREATE OR REPLACE FUNCTION crm_activity_receive_scratchcard_from_agency
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT
)
RETURNS TABLE
(
	"Id" INT,
	"Message" TEXT
)
AS $BODY$
DECLARE
	v_id INT := 1;
	v_mess TEXT;
	v_data JSON := p_data::JSON;
	ele JSON;
BEGIN
	
	FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
		
		IF NOT EXISTS(SELECT 1 FROM "ScratchcardFull" SF WHERE SF."AgencyId" = 0 AND (ele ->> 'LotteryChannelId')::INT = SF."LotteryChannelId") THEN
		
			INSERT INTO "ScratchcardFull"(
				"AgencyId",
				"TotalRemaining",
				"LastActionBy",
				"LastActionByName",
				"LotteryChannelId"
			) VALUES(
				0,
				COALESCE((ele ->> 'TotalReceived')::INT, 0),
				p_action_by,
				p_action_by_name,
				(ele ->> 'LotteryChannelId')::INT
			);
		
		ELSE 
		
			UPDATE "ScratchcardFull" SF
			SET
				"TotalRemaining" = "TotalRemaining" + COALESCE((ele ->> 'TotalReceived')::INT, 0),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name,
				"LastActionDate" = NOW()
			WHERE SF."AgencyId" = 0
				AND SF."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
		
		END IF;
	
		INSERT INTO "ScratchcardFullLog"(
			"AgencyId",
			"TotalReceived",
			"ActionBy",
			"ActionByName",
			"LotteryChannelId"
		) VALUES (
			(ele ->> 'AgencyId')::INT,
			COALESCE((ele ->> 'TotalReceived')::INT, 0),
			p_action_by,
			p_action_by_name,
			(ele ->> 'LotteryChannelId')::INT
		);
	
	END LOOP;
	
	v_mess := 'Thao tác thành công';
	
	RETURN QUERY 
	SELECT v_id, v_mess;
	
	EXCEPTION WHEN OTHERS THEN
	BEGIN				
		v_id := -1;
		v_mess := sqlerrm;
		
		RETURN QUERY 
		SELECT 	v_id, v_mess;
	END;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE


