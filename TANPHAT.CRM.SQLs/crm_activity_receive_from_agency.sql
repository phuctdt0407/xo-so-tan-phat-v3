-- ================================
-- Author: Phi
-- Description: Nhận vé từ đại lý
-- Created date: 28/02/2022
-- SELECT * FROM crm_activity_receive_from_agency();
-- ================================
SELECT dropallfunction_byname('crm_activity_receive_from_agency');
CREATE OR REPLACE FUNCTION crm_activity_receive_from_agency
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_lottery_date TIMESTAMP,
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
	
		IF NOT EXISTS (SELECT 1 FROM "InventoryFull" WHERE "LotteryDate" = p_lottery_date::DATE AND "AgencyId" = (ele ->> 'AgencyId')::INT AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT) THEN	
			
			INSERT INTO "InventoryFull"(
				"LotteryDate",
				"LotteryChannelId",
				"AgencyId",
				"TotalReceived",
				"TotalRemaining",
				"ActionBy",
				"ActionByName"
			) VALUES (
				p_lottery_date::DATE,
				(ele ->> 'LotteryChannelId')::INT,
				(ele ->> 'AgencyId')::INT,
				COALESCE((ele ->> 'TotalReceived')::INT, 0),
				COALESCE((ele ->> 'TotalReceived')::INT, 0),
				p_action_by,
				p_action_by_name
			);
			
		ELSE 

			UPDATE "InventoryFull" F
			SET
				"TotalReceived" =  COALESCE((ele ->> 'TotalReceived')::INT, 0),
				"TotalRemaining" = "TotalRemaining" - ("TotalReceived" - COALESCE((ele ->> 'TotalReceived')::INT, 0)),
				"ActionBy" = p_action_by,
				"ActionByName" = p_action_by_name,
				"ActionDate" = NOW()
			WHERE F."LotteryDate" = p_lottery_date::DATE 
				AND F."AgencyId" = (ele ->> 'AgencyId')::INT
				AND F."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
			
		END IF;
	
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