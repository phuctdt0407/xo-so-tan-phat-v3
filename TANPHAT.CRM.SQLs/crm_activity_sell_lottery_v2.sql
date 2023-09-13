-- ================================
-- Author: Phi
-- Description: Vé bán
-- Created date: 07/03/2022
-- SELECT * FROM crm_activity_sell_lottery_v2();
-- ================================
SELECT dropallfunction_byname('crm_activity_sell_lottery_v2');
CREATE OR REPLACE FUNCTION crm_activity_sell_lottery_v2
(
	p_shift_dis_id INT,
	p_user_role_id INT,
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT,
	p_guest_id INT DEFAULT NULL
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
	v_data JSON := p_data::JSON;
	v_sale_point_id INT;
	v_user_id INT;
	ele JSON;
	v_shift_dis_id INT;
	v_is_super_admin BOOL;
	v_is_manager BOOL;
	v_is_staff BOOL;
	v_check INT := 0;
BEGIN
	
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
	
			INSERT INTO "SalePointLog"(
				"SalePointId",
				"LotteryDate",
				"LotteryChannelId",
				"Quantity",
				"LotteryTypeId",
				"LotteryPriceId",
				"TotalValue",
				"ActionBy",
				"ActionByName",
				"ShiftDistributeId",
				"GuestId",
				"FourLastNumber"
			) VALUES(
				v_sale_point_id,
				(CASE WHEN (ele ->> 'LotteryTypeId')::INT = 3 THEN NULL::DATE ELSE (ele ->> 'LotteryDate')::DATE END),
				(ele ->> 'LotteryChannelId')::INT,
				(ele ->> 'Quantity')::INT,
				(ele ->> 'LotteryTypeId')::INT,
				(ele ->> 'LotteryPriceId')::INT,
				(SELECT (CASE WHEN (ele ->> 'Quantity')::INT >= 110 AND (ele ->> 'LotteryPriceId')::INT = 6 THEN  CEIL((ele ->> 'Quantity')::INT * LP."Price") + ((ele ->> 'Quantity')::INT /100) ELSE CEIL((ele ->> 'Quantity')::INT * LP."Price") END) FROM "LotteryPrice" LP WHERE LP."LotteryPriceId" = (ele ->> 'LotteryPriceId')::INT),
				p_action_by,
				p_action_by_name,
				v_shift_dis_id,
				COALESCE(p_guest_id,NULL),
				(ele->>'FourLastNumber')::VARCHAR
			);
			
			IF (ele ->> 'LotteryTypeId')::INT = 1 THEN 
			
				UPDATE "Inventory"
				SET
					"TotalRemaining" = "TotalRemaining" - (ele ->> 'Quantity')::INT
				WHERE "SalePointId" = v_sale_point_id
					AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
					AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
				RETURNING "TotalRemaining" INTO v_check;
				
				IF v_check < 0 THEN
					RAISE 'Số lượng vé đã thay đổi không đủ vé để bán';
				END IF;
			
			ELSEIF (ele ->> 'LotteryTypeId')::INT = 2 THEN
			
				UPDATE "Inventory"
				SET
					"TotalDupRemaining" = "TotalDupRemaining" - (ele ->> 'Quantity')::INT
				WHERE "SalePointId" = v_sale_point_id
					AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
					AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
				RETURNING "TotalDupRemaining" INTO v_check;
				
				IF v_check < 0 THEN
					RAISE 'Số lượng vé đã thay đổi không đủ vé để bán';
				END IF;
			
			ELSE
			
				UPDATE "Scratchcard"
				SET
					"TotalRemaining" = "TotalRemaining" - (ele ->> 'Quantity')::INT
				WHERE "SalePointId" = v_sale_point_id
					AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT
				RETURNING "TotalRemaining" INTO v_check;
				
				IF v_check < 0 THEN
					RAISE 'Số lượng vé đã thay đổi không đủ vé để bán';
				END IF;
					
			
			END IF;
			
	
		END LOOP;
	
		v_id := v_sale_point_id;
		v_mess := 'Lưu thành công';
	
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