-- ================================
-- Author: Phi
-- Description: Vé bán
-- Created date: 07/03/2022
-- SELECT * FROM crm_activity_sell_lottery();
-- ================================
SELECT dropallfunction_byname('crm_activity_sell_lottery');
CREATE OR REPLACE FUNCTION crm_activity_sell_lottery
(
	p_user_role_id INT,
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
	v_id INT;
	v_mess TEXT;
	v_data JSON := p_data::JSON;
	v_sale_point_id INT;
	v_user_id INT;
	ele JSON;
	v_shift_dis_id INT;
BEGIN
	
	SELECT 
		UR."UserId" INTO v_user_id
	FROM "UserRole" UR WHERE UR."UserRoleId" = p_user_role_id;
	
	SELECT
		SD."SalePointId", SD."ShiftDistributeId" INTO v_sale_point_id, v_shift_dis_id
	FROM "ShiftDistribute" SD WHERE SD."UserId" = v_user_id AND SD."DistributeDate" = NOW()::DATE;
	
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
				"ShiftDistributeId",
				"ActionBy",
				"ActionByName"
			) VALUES(
				v_sale_point_id,
				(ele ->> 'LotteryDate')::DATE,
				(ele ->> 'LotteryChannelId')::INT,
				(ele ->> 'Quantity')::INT,
				(ele ->> 'LotteryTypeId')::INT,
				(ele ->> 'LotteryPriceId')::INT,
				(SELECT CEIL((ele ->> 'Quantity')::INT * LP."Price") FROM "LotteryPrice" LP WHERE LP."LotteryPriceId" = (ele ->> 'LotteryPriceId')::INT),
				v_shift_dis_id,
				p_action_by,
				p_action_by_name
			);
			
			IF (ele ->> 'LotteryTypeId')::INT = 1 THEN 
			
				UPDATE "Inventory"
				SET
					"TotalRemaining" = "TotalRemaining" - (ele ->> 'Quantity')::INT
				WHERE "SalePointId" = v_sale_point_id
					AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
					AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
			
			ELSEIF (ele ->> 'LotteryTypeId')::INT = 2 THEN
			
				UPDATE "Inventory"
				SET
					"TotalDupRemaining" = "TotalDupRemaining" - (ele ->> 'Quantity')::INT
				WHERE "SalePointId" = v_sale_point_id
					AND "LotteryDate" = (ele ->> 'LotteryDate')::DATE
					AND "LotteryChannelId" = (ele ->> 'LotteryChannelId')::INT;
			
			ELSE
			
				UPDATE "Scratchcard"
				SET
					"TotalRemaining" = "TotalRemaining" - (ele ->> 'Quantity')::INT
				WHERE "SalePointId" = v_sale_point_id;
			
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