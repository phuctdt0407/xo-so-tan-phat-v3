-- ================================
-- Author: Phi
-- Description: Xác nhận hoạt động chuyển nhận, trả ế
-- Created date: 08/04/2022
-- SELECT * FROM crm_activity_confirm_transition_v2(8, 'Hello', '[{"TransitionId": 17, "ConfirmTrans": 100, "ConfirmTransDup": 133 }]')
-- ================================
SELECT dropallfunction_byname('crm_activity_confirm_transition_v2');
CREATE OR REPLACE FUNCTION crm_activity_confirm_transition_v2
(
	p_user_role_id INT,
	p_note VARCHAR,
	p_list_item TEXT,
	p_is_confirm BOOL,
	p_trans_type_id INT,
	p_sale_point_id INT
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
	v_is_staff BOOL;
	v_name VARCHAR;
	v_user_id INT;
	ele JSON;
	v_inventory_id INT;
	v_total INT;
	v_total_dup INT;
	v_total_check INT := 0;
	v_total_dup_check INT := 0;
	v_shift_dis_id INT;
BEGIN	

	SELECT UT."IsStaff", U."UserId" INTO v_is_staff, v_user_id
	FROM "UserRole" U JOIN "UserTitle" UT ON U."UserTitleId" = UT."UserTitleId" 
	WHERE U."UserRoleId" = p_user_role_id;
	
	SELECT U."FullName" INTO v_name
	FROM "User" U 
	WHERE U."UserId" = v_user_id;
	
		IF p_is_confirm IS TRUE THEN
			IF p_trans_type_id = 1 THEN
				FOR ele IN SELECT * FROM json_array_elements(p_list_item::JSON) LOOP 		
					IF ((ele ->> 'IsScratchcard')::BOOL) IS FALSE THEN
						SELECT 
							I."TotalRemaining",
							I."TotalDupRemaining"
						INTO 
							v_total_check,
							v_total_dup_check
						FROM "Inventory" I 
						WHERE I."SalePointId" = p_sale_point_id
							AND I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
							AND I."LotteryDate" = (ele ->> 'LotteryDate')::DATE;
						
						IF(NOT EXISTS (SELECT 1 FROM "Transition" T WHERE T."TransitionId" = (ele ->> 'TransitionId')::INT AND T."ConfirmStatusId" = 1)) THEN
							RAISE 'Yêu cầu đã được xác nhận trước';
						END IF;
						
						IF v_total_check < COALESCE((ele ->> 'TotalTrans')::INT) OR v_total_dup_check < (ele ->> 'TotalTransDup')::INT THEN
							RAISE 'Không đủ vé trong kho hàng';
						END IF;			
					ELSE 
						SELECT 
							I."TotalRemaining"
						INTO 
							v_total_check
						FROM "Scratchcard" I
						WHERE I."SalePointId" = p_sale_point_id
							AND I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
							
						IF(NOT EXISTS (SELECT 1 FROM "Transition" T WHERE T."TransitionId" = (ele ->> 'TransitionId')::INT AND T."ConfirmStatusId" = 1)) THEN
							RAISE 'Yêu cầu đã được xác nhận trước';
						END IF;
						
						IF v_total_check < COALESCE((ele ->> 'TotalTrans')::INT) THEN
							RAISE 'Không đủ vé trong kho hàng';
						END IF;	
						
					END IF;
				END LOOP;
			END IF;
			
			IF p_trans_type_id = 2 THEN
				FOR ele IN SELECT * FROM json_array_elements(p_list_item::JSON) LOOP 		
					IF ((ele ->> 'IsScratchcard')::BOOL) IS FALSE THEN
						SELECT 
							I."TotalRemaining",
							I."TotalDupRemaining"
						INTO 
							v_total_check,
							v_total_dup_check
						FROM "Inventory" I 
						WHERE I."SalePointId" = 0
							AND I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
							AND I."LotteryDate" = (ele ->> 'LotteryDate')::DATE;
						
						IF(NOT EXISTS (SELECT 1 FROM "Transition" T WHERE T."TransitionId" = (ele ->> 'TransitionId')::INT AND T."ConfirmStatusId" = 1)) THEN
							RAISE 'Yêu cầu đã được xác nhận trước';
						END IF;
						
						IF v_total_check < COALESCE((ele ->> 'TotalTrans')::INT) OR v_total_dup_check < (ele ->> 'TotalTransDup')::INT THEN
							RAISE 'Không đủ vé trong kho hàng';
						END IF;
					ELSE 
						SELECT 
							I."TotalRemaining"
						INTO 
							v_total_check
						FROM "Scratchcard" I
						WHERE I."SalePointId" = 0
							AND I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
						IF(NOT EXISTS (SELECT 1 FROM "Transition" T WHERE T."TransitionId" = (ele ->> 'TransitionId')::INT AND T."ConfirmStatusId" = 1)) THEN
							RAISE 'Yêu cầu đã được xác nhận trước';
						END IF;
						
						IF v_total_check < COALESCE((ele ->> 'TotalTrans')::INT) THEN
							RAISE 'Không đủ vé trong kho hàng';
						END IF;	
						
					END IF;
				END LOOP;
			END IF;
		
			FOR ele IN SELECT * FROM json_array_elements(p_list_item::JSON) LOOP 		
				
				UPDATE "Transition"
				SET 
					"ConfirmTrans" = (ele ->> 'TotalTrans')::INT,
					"ConfirmTransDup" = (ele ->> 'TotalTransDup')::INT,
					"ConfirmBy" = v_user_id,
					"ConfirmByName" = v_name,
					"ConfirmDate" = NOW(),
					"ConfirmStatusId" = 2,
					"Note" = p_note
				WHERE "TransitionId" = (ele ->> 'TransitionId')::INT
					AND "ConfirmStatusId" = 1;
					
				IF p_trans_type_id = 1 THEN
					IF ((ele ->> 'IsScratchcard')::BOOL) IS FALSE THEN		
						IF COALESCE((ele ->> 'TotalTrans')::INT, 0) > 0 THEN
					
							UPDATE "Inventory"
							SET
								"TotalRemaining" = "TotalRemaining" - (ele ->> 'TotalTrans')::INT
							WHERE "SalePointId" = p_sale_point_id
								AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
								AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
							
						END IF;
					
						IF COALESCE((ele ->> 'TotalTransDup')::INT, 0) > 0 THEN
						
							UPDATE "Inventory"
							SET
								"TotalDupRemaining" = "TotalDupRemaining" - (ele ->> 'TotalTransDup')::INT
							WHERE "SalePointId" = p_sale_point_id
								AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
								AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
								
						END IF;
						
						IF NOT EXISTS (SELECT 1 FROM "Inventory" WHERE "SalePointId" = 0 
							AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
							AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT) THEN
							
							INSERT INTO "Inventory"(
								"LotteryDate",
								"LotteryChannelId",
								"TotalReceived",
								"TotalRemaining",
								"TotalDupReceived",
								"TotalDupRemaining",
								"SalePointId"
							) VALUES (
								(ele ->> 'LotteryDate')::DATE,
								(ele ->> 'LotteryChannelId')::INT,
								(ele ->> 'TotalTrans')::INT,
								(ele ->> 'TotalTrans')::INT,
								(ele ->> 'TotalTransDup')::INT,
								(ele ->> 'TotalTransDup')::INT,
								0
							);
							
						ELSE 
						
							UPDATE "Inventory" I
							SET
								"TotalReceived" = I."TotalReceived" + (ele ->> 'TotalTrans')::INT,
								"TotalRemaining" = I."TotalRemaining" + (ele ->> 'TotalTrans')::INT,
								"TotalDupReceived" = I."TotalDupReceived" + (ele ->> 'TotalTransDup')::INT,
								"TotalDupRemaining" = I."TotalDupRemaining" + (ele ->> 'TotalTransDup')::INT
							WHERE I."LotteryDate" = (ele ->> 'LotteryDate')::DATE
								AND I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
								AND I."SalePointId" = 0;
						
						END IF;
					ELSE
						UPDATE "Scratchcard"
						SET "TotalRemaining" = "TotalRemaining" - COALESCE((ele ->> 'TotalTrans')::INT, 0)
						WHERE "SalePointId" = p_sale_point_id 
							AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
							
						IF NOT EXISTS (SELECT 1 FROM "Scratchcard" WHERE "SalePointId" = 0 
							AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT) THEN
							
							INSERT INTO "Scratchcard"(
								"LotteryChannelId",
								"TotalReceived",
								"TotalRemaining",
								"SalePointId"
							) VALUES (
								(ele ->> 'LotteryChannelId')::INT,
								(ele ->> 'TotalTrans')::INT,
								(ele ->> 'TotalTrans')::INT,
								0
							);
							
						ELSE 
						
							UPDATE "Scratchcard" I
							SET
								"TotalReceived" = I."TotalReceived" + (ele ->> 'TotalTrans')::INT,
								"TotalRemaining" = I."TotalRemaining" + (ele ->> 'TotalTrans')::INT							
							WHERE I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
								AND I."SalePointId" = 0;
								
						END IF;
					END IF;
					

				
				ELSEIF p_trans_type_id = 2 THEN 
					IF ((ele ->> 'IsScratchcard')::BOOL) IS FALSE THEN	
						IF COALESCE((ele ->> 'TotalTrans')::INT, 0) > 0 THEN
					
							UPDATE "Inventory"
							SET
								"TotalRemaining" = "TotalRemaining" + (ele ->> 'TotalTrans')::INT
							WHERE "SalePointId" = p_sale_point_id
								AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
								AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
								
						
						END IF;
					
						IF COALESCE((ele ->> 'TotalTransDup')::INT, 0) > 0 THEN
						
							UPDATE "Inventory"
							SET
								"TotalDupRemaining" = "TotalDupRemaining" + (ele ->> 'TotalTransDup')::INT
							WHERE "SalePointId" = p_sale_point_id
								AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
								AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
						
								
						END IF;
					
						SELECT "InventoryId", "TotalRemaining", "TotalDupRemaining"
						INTO  v_inventory_id, v_total, v_total_dup
						FROM "Inventory" I
						WHERE I."LotteryDate" = (ele ->> 'LotteryDate')::DATE
							AND I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
							AND I."SalePointId" = 0;
						
						IF v_total >= (ele ->> 'TotalTrans')::INT THEN 
						
							UPDATE "Inventory" I
							SET
								"TotalRemaining" = I."TotalRemaining" -  (ele ->> 'TotalTrans')::INT
							WHERE I."InventoryId" = v_inventory_id;
						
						END IF;
						
						IF v_total_dup >= (ele ->> 'TotalTransDup')::INT THEN 
						
							UPDATE "Inventory" I
							SET
								"TotalDupRemaining" = I."TotalDupRemaining" - (ele ->> 'TotalTransDup')::INT
							WHERE I."InventoryId" = v_inventory_id;
						
						END IF;
					ELSE
					
						UPDATE "Scratchcard"
						SET "TotalRemaining" = "TotalRemaining" + COALESCE((ele ->> 'TotalTrans')::INT, 0)
						WHERE "SalePointId" = p_sale_point_id 
							AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
							
						IF EXISTS (SELECT 1 FROM "Scratchcard" WHERE "SalePointId" = 0 
							AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT) THEN

							UPDATE "Scratchcard" I
							SET
								"TotalReceived" = I."TotalReceived" - (ele ->> 'TotalTrans')::INT,
								"TotalRemaining" = I."TotalRemaining" - (ele ->> 'TotalTrans')::INT							
							WHERE I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
								AND I."SalePointId" = 0;
								
						END IF;
							
					END IF;
				
				ELSEIF p_trans_type_id = 3 THEN
				
					IF COALESCE((ele ->> 'TotalTrans')::INT, 0) > 0 THEN
				
						UPDATE "Inventory"
						SET
							"TotalRemaining" = "TotalRemaining" - (ele ->> 'TotalTrans')::INT
						WHERE "SalePointId" = p_sale_point_id
							AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
							AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
					
					END IF;
				
					IF COALESCE((ele ->> 'TotalTransDup')::INT, 0) > 0 THEN
					
						UPDATE "Inventory"
						SET
							"TotalDupRemaining" = "TotalDupRemaining" - (ele ->> 'TotalTransDup')::INT
						WHERE "SalePointId" = p_sale_point_id
							AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
							AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
					
					END IF;
					
					IF NOT EXISTS (SELECT 1 FROM "Inventory" WHERE "SalePointId" = 0 
						AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
						AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT) THEN
						
						INSERT INTO "Inventory"(
							"LotteryDate",
							"LotteryChannelId",
							"TotalReceived",
							"TotalRemaining",
							"TotalDupReceived",
							"TotalDupRemaining",
							"SalePointId"
						) VALUES (
							(ele ->> 'LotteryDate')::DATE,
							(ele ->> 'LotteryChannelId')::INT,
							(ele ->> 'TotalTrans')::INT,
							(ele ->> 'TotalTrans')::INT,
							(ele ->> 'TotalTransDup')::INT,
							(ele ->> 'TotalTransDup')::INT,
							0
						);
						
					ELSE 
					
						UPDATE "Inventory" I
						SET
							"TotalReceived" = I."TotalReceived" + (ele ->> 'TotalTrans')::INT,
							"TotalRemaining" = I."TotalRemaining" + (ele ->> 'TotalTrans')::INT,
							"TotalDupReceived" = I."TotalDupReceived" + (ele ->> 'TotalTransDup')::INT,
							"TotalDupRemaining" = I."TotalDupRemaining" + (ele ->> 'TotalTransDup')::INT
						WHERE I."LotteryDate" = (ele ->> 'LotteryDate')::DATE
							AND I."LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
							AND I."SalePointId" = 0;
					
					END IF;
				
				ELSE
					
					v_id := -1;
					v_mess := 'Có lỗi xảy ra';
					
				END IF;
			
			END LOOP;
		
		ELSE 
		
			FOR ele IN SELECT * FROM json_array_elements(p_list_item::JSON) LOOP 		
			
				UPDATE "Transition"
				SET
					"ConfirmBy" = v_user_id,
					"ConfirmByName" = v_name,
					"ConfirmDate" = NOW(),
					"ConfirmStatusId" = 3,
					"Note" = p_note
				WHERE "TransitionId" = (ele ->> 'TransitionId')::INT
					AND "ConfirmStatusId" = 1;
					
			END LOOP;	
		
		END IF;
	
		v_id := 1;
		v_mess := 'Xác nhận thành công';

	RETURN QUERY
	SELECT v_id, v_mess;
	
	EXCEPTION WHEN OTHERS THEN
	BEGIN
		v_id := -1;
		v_mess := sqlerrm;

		RETURN QUERY
		SELECT v_id, v_mess;
	END;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE