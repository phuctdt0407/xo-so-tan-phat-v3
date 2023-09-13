-- ================================
-- Author: Phi
-- Description: Chia vé cào cho điểm bán
-- Created date: 25/03/2022
-- SELECT * FROM crm_activity_distribute_scratchcard_for_sales_point(2,'DEV_TEST','[{"SalePointId":1,"TotalReceived":3,"LotteryChannelId":1000},{"SalePointId":1,"TotalReceived":1,"LotteryChannelId":1001},{"SalePointId":2,"TotalReceived":2,"LotteryChannelId":1000}]');
-- ================================
SELECT dropallfunction_byname('crm_activity_distribute_scratchcard_for_sales_point');
CREATE OR REPLACE FUNCTION crm_activity_distribute_scratchcard_for_sales_point
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
	v_total INT8 := 0;
	v_store INT;
	v_check INT := 0;
BEGIN
	
	CREATE TEMP TABLE tmpTable (
		"LotteryChannelId" INT,
		"TotalReceived" INT
	)
	ON COMMIT DROP;
	
	FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
		INSERT INTO tmpTable("LotteryChannelId", "TotalReceived")
		VALUES ((ele ->> 'LotteryChannelId')::INT, COALESCE((ele ->> 'TotalReceived')::INT, 0));
	END LOOP;
	
	WITH tmp AS (
		SELECT 
			"LotteryChannelId",
			"TotalRemaining"
		FROM "ScratchcardFull"
		WHERE "AgencyId" = 0
	),
	tmp2 AS (
		SELECT
			T."LotteryChannelId",
			SUM(T."TotalReceived") AS "TotalReceived"
		FROM tmpTable T
		GROUP BY T."LotteryChannelId"
	)
	
	SELECT 
		COUNT(1) INTO v_check
	FROM tmp2 T
		JOIN tmp X ON T."LotteryChannelId" = X."LotteryChannelId"
	WHERE T."TotalReceived" > X."TotalRemaining";
	

	IF v_check = 0 THEN
		FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
			IF NOT EXISTS (SELECT 1 FROM "Scratchcard" WHERE "SalePointId" = (ele ->> 'SalePointId')::INT AND "LotteryChannelId" =(ele ->> 'LotteryChannelId')::INT) THEN	
				
				INSERT INTO "Scratchcard"(
					"TotalReceived",
					"TotalRemaining",
					"SalePointId",
					"LastActionBy",
					"LastActionByName",
					"LotteryChannelId"
				) VALUES (
					COALESCE((ele ->> 'TotalReceived')::INT, 0),
					COALESCE((ele ->> 'TotalReceived')::INT, 0),
					(ele ->> 'SalePointId')::INT,
					p_action_by,
					p_action_by_name,
					(ele ->> 'LotteryChannelId')::INT
				);
				
			ELSE 

				UPDATE "Scratchcard" S
				SET
					"TotalReceived" = S."TotalReceived" + COALESCE((ele ->> 'TotalReceived')::INT, 0),
					"TotalRemaining" = S."TotalRemaining" + COALESCE((ele ->> 'TotalReceived')::INT, 0),
					"LastActionBy" = p_action_by,
					"LastActionByName" = p_action_by_name,
					"LastActionDate" = NOW()
				WHERE S."SalePointId" = (ele ->> 'SalePointId')::INT AND S."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
					
			END IF;
			
			INSERT INTO "ScratchcardLog"(
				"SalePointId",
				"TotalReceived",
				"ActionBy",
				"ActionByName",
				"LotteryChannelId"
			) VALUES(
				(ele ->> 'SalePointId')::INT,
				(ele ->> 'TotalReceived')::INT,
				p_action_by,
				p_action_by_name,
				(ele ->> 'LotteryChannelId')::INT
			);
			
			UPDATE "ScratchcardFull" 
			SET 
				"TotalRemaining" = "TotalRemaining" - COALESCE((ele ->> 'TotalReceived')::INT, 0),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name,
				"LastActionDate" = NOW()
			WHERE "AgencyId" = 0 AND "LotteryChannelId" =(ele ->> 'LotteryChannelId')::INT;
			
		END LOOP;
			
		v_mess := 'Thao tác thành công';
	ELSE 
		v_mess := 'Thao tác không thành công';
		v_id := -1;
	END IF;
	
	
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