-- ================================
-- Author: Phi
-- Description: Ghi nhận chuyển vé, trả ế
-- Created date: 08/03/2022
-- SELECT * FROM crm_insert_transition_log_v2();
-- ================================
SELECT dropallfunction_byname('crm_insert_transition_log_v2');
CREATE OR REPLACE FUNCTION crm_insert_transition_log_v2
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_user_role_id INT,
	p_tran_data TEXT,
	p_tran_type_id INT,
	p_shift_dis_id INT,
	p_manager_id INT
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
	v_data JSON := p_tran_data::JSON;
	v_sale_point_id INT;
	v_shift_dis_id INT;
	v_user_id INT;
	ele JSON;
	v_inventory_id INT;
	v_total INT;
	v_total_dup INT;
	v_is_super_admin BOOL;
	v_is_manager BOOL;
	v_is_staff BOOL;
BEGIN
	
-- 	SELECT 
-- 		UR."UserId" INTO v_user_id
-- 	FROM "UserRole" UR WHERE UR."UserRoleId" = p_user_role_id;
-- 	
-- 	SELECT
-- 		SD."SalePointId" INTO v_sale_point_id
-- 	FROM "ShiftDistribute" SD WHERE SD."UserId" = v_user_id AND SD."DistributeDate" = NOW()::DATE;

	SELECT 
		f."IsSuperAdmin",
		f."IsManager",
		f."IsStaff",
		f."SalePointId",
		f."ShiftDistributeId"
	INTO v_is_super_admin, v_is_manager, v_is_staff, v_sale_point_id, v_shift_dis_id
	FROM fn_get_shift_info(p_user_role_id) f;
	
	IF COALESCE(v_sale_point_id, 0) > 0 THEN
	
		FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
		
			IF p_tran_type_id = 1 THEN 
			
				INSERT INTO "Transition"(
					"LotteryDate",
					"LotteryChannelId",
					"FromSalePointId",
					"ToSalePointId",
					"TotalTrans",
					"TotalTransDup",
					"TransitionDate",
					"TransitionTypeId",
					"ActionBy",
					"ActionByName",
					"ShiftDistributeId",
					"ManagerId",
					"ConfirmStatusId"
				) VALUES(
					(ele ->> 'LotteryDate')::DATE,
					(ele ->> 'LotteryChannelId')::INT,
					v_sale_point_id,
					0,
					COALESCE((ele ->> 'TotalTrans')::INT, 0),
					COALESCE((ele ->> 'TotalTransDup')::INT, 0),
					NOW(),
					1,
					p_action_by,
					p_action_by_name,
					v_shift_dis_id,
					p_manager_id,
					1
				);
				
				IF COALESCE((ele ->> 'TotalTrans')::INT, 0) > 0 THEN
				
					UPDATE "Inventory"
					SET
						"TotalRemaining" = "TotalRemaining" - (ele ->> 'TotalTrans')::INT
					WHERE "SalePointId" = v_sale_point_id
						AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
						AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
				
				END IF;
			
				IF COALESCE((ele ->> 'TotalTransDup')::INT, 0) > 0 THEN
				
					UPDATE "Inventory"
					SET
						"TotalDupRemaining" = "TotalDupRemaining" - (ele ->> 'TotalTransDup')::INT
					WHERE "SalePointId" = v_sale_point_id
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
				
				v_id := v_sale_point_id;
				v_mess := 'Chuyển vé thành công';
			
			ELSEIF p_tran_type_id = 2 THEN
			
				INSERT INTO "Transition"(
					"LotteryDate",
					"LotteryChannelId",
					"FromSalePointId",
					"ToSalePointId",
					"TotalTrans",
					"TotalTransDup",
					"TransitionDate",
					"TransitionTypeId",
					"ActionBy",
					"ActionByName",
					"ShiftDistributeId",
					"ManagerId",
					"ConfirmStatusId"
				) VALUES(
					(ele ->> 'LotteryDate')::DATE,
					(ele ->> 'LotteryChannelId')::INT,
					0,
					v_sale_point_id,
					COALESCE((ele ->> 'TotalTrans')::INT, 0),
					COALESCE((ele ->> 'TotalTransDup')::INT, 0),
					NOW(),
					2,
					p_action_by,
					p_action_by_name,
					v_shift_dis_id,
					p_manager_id,
					1
				);
				
				IF COALESCE((ele ->> 'TotalTrans')::INT, 0) > 0 THEN
				
					UPDATE "Inventory"
					SET
						"TotalRemaining" = "TotalRemaining" + (ele ->> 'TotalTrans')::INT
					WHERE "SalePointId" = v_sale_point_id
						AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
						AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
				
				END IF;
			
				IF COALESCE((ele ->> 'TotalTransDup')::INT, 0) > 0 THEN
				
					UPDATE "Inventory"
					SET
						"TotalDupRemaining" = "TotalDupRemaining" + (ele ->> 'TotalTransDup')::INT
					WHERE "SalePointId" = v_sale_point_id
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
			
				v_id := v_sale_point_id;
				v_mess := 'Nhận vé thành công';
		
			ELSEIF p_tran_type_id = 3 THEN
				
				INSERT INTO "Transition"(
					"LotteryDate",
					"LotteryChannelId",
					"FromSalePointId",
					"ToSalePointId",
					"TotalTrans",
					"TotalTransDup",
					"TransitionDate",
					"TransitionTypeId",
					"ActionBy",
					"ActionByName",
					"ShiftDistributeId",
					"ManagerId",
					"ConfirmStatusId"
				) VALUES(
					(ele ->> 'LotteryDate')::DATE,
					(ele ->> 'LotteryChannelId')::INT,
					v_sale_point_id,
					0,
					COALESCE((ele ->> 'TotalTrans')::INT, 0),
					COALESCE((ele ->> 'TotalTransDup')::INT, 0),
					NOW(),
					3,
					p_action_by,
					p_action_by_name,
					v_shift_dis_id,
					p_manager_id,
					1
				);
				
				IF COALESCE((ele ->> 'TotalTrans')::INT, 0) > 0 THEN
				
					UPDATE "Inventory"
					SET
						"TotalRemaining" = "TotalRemaining" - (ele ->> 'TotalTrans')::INT
					WHERE "SalePointId" = v_sale_point_id
						AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
						AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
				
				END IF;
			
				IF COALESCE((ele ->> 'TotalTransDup')::INT, 0) > 0 THEN
				
					UPDATE "Inventory"
					SET
						"TotalDupRemaining" = "TotalDupRemaining" - (ele ->> 'TotalTransDup')::INT
					WHERE "SalePointId" = v_sale_point_id
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
				
				v_id := v_sale_point_id;
				v_mess := 'Trả ế thành công';
			
			ELSE
			
				v_id := 0;
				v_mess := 'Xảy ra lỗi';
			
			END IF;
	
		END LOOP;

	ELSE 
 
		v_id := 0;
		v_mess := 'Nhân viên không trong ca làm việc';
 
	END IF;
	
	RETURN QUERY 
	SELECT 	v_id, v_mess;
	
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