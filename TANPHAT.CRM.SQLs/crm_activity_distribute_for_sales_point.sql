-- ================================
-- Author: Phi
-- Description: Chia vé cho điểm bán
-- Created date: 01/03/2022
-- SELECT * FROM crm_activity_distribute_for_sales_point();
-- ================================
SELECT dropallfunction_byname('crm_activity_distribute_for_sales_point');
CREATE OR REPLACE FUNCTION crm_activity_distribute_for_sales_point
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
	v_last_received INT;
	v_last_received_dup INT;
	re RECORD;
	v_flag INT := 0;
BEGIN
	
	CREATE TEMP TABLE dataTotal ON COMMIT DROP AS (
		SELECT 
			(dt ->> 'AgencyId') :: INT AS "AgencyId",
			(dt ->> 'LotteryChannelId') :: INT AS "LotteryChannelId",
			(dt ->> 'SalePointId') :: INT AS "SalePointId",
			(dt ->> 'TotalReceived') :: INT AS "TotalReceived" ,
			(dt ->> 'TotalDupReceived') :: INT AS "TotalDupReceived"
		FROM json_array_elements(v_data) dt 
	);
-- 	WITH tmp AS(
-- 		SELECT
-- 			dt."AgencyId", 
-- 			dt."LotteryChannelId",
-- 			SUM(dt."TotalReceived") AS "TotalReceived",
-- 			SUM(dt."TotalDupReceived") AS "TotalDupReceived"
-- 		FROM dataTotal dt
-- 		GROUP BY 
-- 			dt."AgencyId", 
-- 			dt."LotteryChannelId"
-- 	),
-- 	tmp2 AS(
-- 		SELECT 
-- 			dt."AgencyId",
-- 			dt."LotteryChannelId",
-- 			SUM(dt."TotalReceived") AS "TotalReceived",
-- 			SUM(dt."TotalDupReceived") AS "TotalDupReceived"
-- 		FROM "InventoryLog" dt
-- 		WHERE dt."LotteryDate" = p_lottery_date::DATE 
-- 		GROUP BY 
-- 			dt."AgencyId",
-- 			dt."LotteryChannelId"
-- 	),
-- 	tmp3 AS(
-- 		SELECT 
-- 			IF."AgencyId",
-- 			IF."LotteryChannelId",
-- 			IF."TotalRemaining"
-- 		FROM "InventoryFull" IF
-- 		WHERE IF."LotteryDate" = p_lottery_date::DATE 
-- 	),
-- 	tmp4 AS(
-- 		SELECT
-- 			tmp3."TotalRemaining" - (tmp."TotalReceived" + tmp."TotalDupReceived" - COALESCE(tmp2."TotalReceived", 0) - COALESCE(tmp2."TotalDupReceived", 0)) AS "Remain"
-- 		FROM tmp
-- 			JOIN tmp3 ON tmp."AgencyId" = tmp3."AgencyId" AND tmp."LotteryChannelId" = tmp3."LotteryChannelId"
-- 			LEFT JOIN tmp2 ON tmp."AgencyId" = tmp2."AgencyId" AND tmp."LotteryChannelId" = tmp2."LotteryChannelId"
-- 	)
-- 	SELECT COUNT(*) INTO v_flag
-- 	FROM tmp4
-- 	WHERE "Remain" < 0;
	
	v_flag := 0;
	
	IF(v_flag <= 0) THEN
		FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
			IF NOT EXISTS (SELECT 1 FROM "InventoryLog" WHERE "LotteryDate" = p_lottery_date::DATE 
				AND "AgencyId" = (ele ->> 'AgencyId')::INT 
				AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
				AND "SalePointId" = (ele ->> 'SalePointId')::INT) THEN	
				
				INSERT INTO "InventoryLog"(
					"LotteryDate",
					"LotteryChannelId",
					"AgencyId",
					"SalePointId",
					"TotalReceived",
					"TotalDupReceived",
					"ActionBy",
					"ActionByName"
				) VALUES (
					p_lottery_date::DATE,
					(ele ->> 'LotteryChannelId')::INT,
					(ele ->> 'AgencyId')::INT,
					(ele ->> 'SalePointId')::INT,
					COALESCE((ele ->> 'TotalReceived')::INT, 0),
					COALESCE((ele ->> 'TotalDupReceived')::INT, 0),
					p_action_by,
					p_action_by_name
				);
				--Cập nhật report vé thường
				IF COALESCE((ele ->> 'TotalReceived')::INT, 0) > 0 THEN 
					WITH shiftTran AS (
						SELECT 
							SF."ShiftDistributeId",
							SF."ShiftId",
							SF."UserId"
						FROM "ShiftTransfer" SF
						WHERE SF."LotteryDate" = p_lottery_date::DATE 
							AND SF."SalePointid" = (ele ->> 'SalePointId')::INT
						GROUP BY SF."ShiftDistributeId", SF."ShiftId", SF."UserId"
					)
					INSERT INTO "ShiftTransfer"(
						"ShiftId",
						"UserId",
						"ShiftDistributeId",
						"LotteryChannelId",
						"LotteryTypeId",
						"ActionBy",
						"ActionByName",
						"ActionDate",
						"LotteryDate",
						"TotalStocks",
						"TotalReceived",
						"TotalTrans",
						"TotalReturns",
						"TotalRemaining",
						"TotalSold",
						"TotalSoldMoney",
						"TotalRetail",
						"TotalRetailMoney",
						"TotalWholesale",
						"TotalWholesaleMoney",
						"SalePointid"
					)
					SELECT
						S."ShiftId",
						S."UserId",
						S."ShiftDistributeId",
						(ele ->> 'LotteryChannelId')::INT,
						1,
						p_action_by,
						p_action_by_name,
						NOW(),
						p_lottery_date::DATE,
						(ele ->> 'TotalReceived')::INT,
						0,
						0,
						0,
						(ele ->> 'TotalReceived')::INT,
						0,
						0,
						0,
						0,
						0,
						0,
						(ele ->> 'SalePointId')::INT
					FROM shiftTran S;
				END IF;
				-- Cập nhật report vé trùng
				IF COALESCE((ele ->> 'TotalDupReceived')::INT, 0) > 0 THEN 
					WITH shiftTran AS (
						SELECT 
							SF."ShiftDistributeId",
							SF."ShiftId",
							SF."UserId"
						FROM "ShiftTransfer" SF
						WHERE SF."LotteryDate" = p_lottery_date::DATE 
							AND SF."SalePointid" = (ele ->> 'SalePointId')::INT
						GROUP BY SF."ShiftDistributeId", SF."ShiftId", SF."UserId"
					)
					INSERT INTO "ShiftTransfer"(
						"ShiftId",
						"UserId",
						"ShiftDistributeId",
						"LotteryChannelId",
						"LotteryTypeId",
						"ActionBy",
						"ActionByName",
						"ActionDate",
						"LotteryDate",
						"TotalStocks",
						"TotalReceived",
						"TotalTrans",
						"TotalReturns",
						"TotalRemaining",
						"TotalSold",
						"TotalSoldMoney",
						"TotalRetail",
						"TotalRetailMoney",
						"TotalWholesale",
						"TotalWholesaleMoney",
						"SalePointid"
					)
					SELECT
						S."ShiftId",
						S."UserId",
						S."ShiftDistributeId",
						(ele ->> 'LotteryChannelId')::INT,
						2,
						p_action_by,
						p_action_by_name,
						NOW(),
						p_lottery_date::DATE,
						(ele ->> 'TotalDupReceived')::INT,
						0,
						0,
						0,
						(ele ->> 'TotalDupReceived')::INT,
						0,
						0,
						0,
						0,
						0,
						0,
						(ele ->> 'SalePointId')::INT
					FROM shiftTran S;
				END IF;
				
				UPDATE "InventoryFull"
				SET
					"TotalRemaining" = "TotalRemaining" - (COALESCE((ele ->> 'TotalReceived')::INT, 0) + COALESCE((ele ->> 'TotalDupReceived')::INT, 0))
				WHERE "LotteryDate" = p_lottery_date::DATE 
					AND "AgencyId" = (ele ->> 'AgencyId')::INT 
					AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;

			ELSE 
				
				SELECT 
					COALESCE(F."TotalReceived", 0), COALESCE(F."TotalDupReceived", 0)
				INTO 
					v_last_received, v_last_received_dup
				FROM "InventoryLog" F 
				WHERE F."LotteryDate" = p_lottery_date::DATE 
					AND F."AgencyId" = (ele ->> 'AgencyId')::INT
					AND F."SalePointId" = (ele ->> 'SalePointId')::INT
					AND F."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
								
				IF COALESCE((ele ->> 'TotalReceived')::INT, 0) >= 0 THEN
					UPDATE "ShiftTransfer" 
					SET "TotalStocks" = "TotalStocks" - v_last_received + COALESCE((ele ->> 'TotalReceived')::INT, 0),
							"TotalRemaining" = "TotalRemaining" - v_last_received + COALESCE((ele ->> 'TotalReceived')::INT, 0)
					WHERE "LotteryDate" = p_lottery_date::DATE 
						AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
						AND "SalePointid" = (ele ->> 'SalePointId')::INT
						AND "LotteryTypeId" = 1;
				END IF;
				
				IF COALESCE((ele ->> 'TotalDupReceived')::INT, 0) >= 0 THEN
					UPDATE "ShiftTransfer" 
					SET "TotalStocks" = "TotalStocks" - v_last_received_dup + COALESCE((ele ->> 'TotalDupReceived')::INT, 0),
							"TotalRemaining" = "TotalRemaining" - v_last_received_dup + COALESCE((ele ->> 'TotalDupReceived')::INT, 0)
					WHERE "LotteryDate" = p_lottery_date::DATE 
						AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
						AND "SalePointid" = (ele ->> 'SalePointId')::INT
						AND "LotteryTypeId" = 1;
				END IF;

				UPDATE "InventoryFull"
				SET
					"TotalRemaining" = "TotalRemaining" + v_last_received + v_last_received_dup - (COALESCE((ele ->> 'TotalReceived')::INT, 0) + COALESCE((ele ->> 'TotalDupReceived')::INT, 0))
				WHERE "LotteryDate" = p_lottery_date::DATE 
					AND "AgencyId" = (ele ->> 'AgencyId')::INT 
					AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
			
				UPDATE "InventoryLog" F
				SET
					"TotalReceived" = COALESCE((ele ->> 'TotalReceived')::INT, 0),
					"TotalDupReceived" = COALESCE((ele ->> 'TotalDupReceived')::INT, 0),
					"ActionBy" = p_action_by,
					"ActionByName" = p_action_by_name,
					"ActionDate" = NOW()
				WHERE F."LotteryDate" = p_lottery_date::DATE 
					AND F."AgencyId" = (ele ->> 'AgencyId')::INT
					AND F."SalePointId" = (ele ->> 'SalePointId')::INT
					AND F."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
					
			END IF;
		
		END LOOP;
		
		FOR re IN
		WITH tmp AS (
			SELECT
				"LotteryChannelId",
				SUM("TotalReceived") AS "TotalReceived",
				SUM("TotalDupReceived") AS "TotalDupReceived",
				"SalePointId"
			FROM "InventoryLog"
			WHERE "LotteryDate" = p_lottery_date::DATE
			GROUP BY 
				"LotteryChannelId",
				"SalePointId"
		)
		SELECT t."LotteryChannelId", t."TotalReceived", t."TotalDupReceived", t."SalePointId"  FROM tmp t LOOP
		
			IF NOT EXISTS (SELECT 1 FROM "Inventory" WHERE "LotteryDate" = p_lottery_date::DATE 
				AND "LotteryChannelId" = re."LotteryChannelId"
				AND "SalePointId" = re."SalePointId") THEN
		
				INSERT INTO "Inventory"(
					"LotteryDate",
					"LotteryChannelId",
					"TotalReceived",
					"TotalRemaining",
					"TotalDupReceived",
					"TotalDupRemaining",
					"SalePointId"
				) VALUES (
					 p_lottery_date::DATE,
					 re."LotteryChannelId",
					 re."TotalReceived",
					 re."TotalReceived",
					 re."TotalDupReceived",
					 re."TotalDupReceived",
					 re."SalePointId"
				);
			
			ELSE 
			
				UPDATE "Inventory" I
				SET
					"TotalReceived" = re."TotalReceived",
					"TotalRemaining" = I."TotalRemaining" - (I."TotalReceived" - re."TotalReceived"),
					"TotalDupReceived" = re."TotalDupReceived",
					"TotalDupRemaining" = I."TotalDupRemaining" - (I."TotalDupReceived" - re."TotalDupReceived")
				WHERE I."LotteryDate" = p_lottery_date::DATE 
					AND I."LotteryChannelId" = re."LotteryChannelId"
					AND I."SalePointId" = re."SalePointId";
			
			END IF;
		
		END LOOP;
		v_mess := 'Thao tác thành công';

	ELSE
		v_id := -1;
		v_mess := 'Dữ liệu cần được cập nhật';
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