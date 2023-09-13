-- ================================
-- Author: Phi
-- Description: Ghi nhận vé trúng thưởng
-- Created date: 22/03/2022
-- SELECT * FROM crm_activity_insert_winning();
-- ================================
SELECT dropallfunction_byname('crm_activity_insert_winning');
CREATE OR REPLACE FUNCTION crm_activity_insert_winning
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_user_role_id INT,
	p_winning_type_id INT,
	p_lottery_number VARCHAR,
	p_lottery_channel_id INT,
	p_quantity INT,
	p_winning_price NUMERIC,
	p_from_sale_point_id INT
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
	v_user_id INT;
	v_sale_point_id INT;
	v_shift_dis_id INT;
	v_is_super_admin BOOL;
	v_is_manager BOOL;
	v_is_staff BOOL;
BEGIN

-- 	SELECT 
-- 		UR."UserId" INTO v_user_id
-- 	FROM "UserRole" UR WHERE UR."UserRoleId" = p_user_role_id;
-- 	
-- 	SELECT
-- 		SD."SalePointId", SD."ShiftDistributeId" INTO v_sale_point_id, v_shift_dis_id
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

		INSERT INTO "Winning"(
			"WinningTypeId",
			"LotteryNumber",
			"LotteryChannelId",
			"Quantity",
			"WinningPrice",
			"FromSalePointId",
			"SalePointId",
			"ShiftDistributeId",
			"ActionBy",
			"ActionByName"
		) VALUES(
			p_winning_type_id,
			p_lottery_number,
			p_lottery_channel_id,
			p_quantity,
			p_winning_price,
			p_from_sale_point_id,
			v_sale_point_id,
			v_shift_dis_id,
			p_action_by,
			p_action_by_name
		) RETURNING "WinningId" INTO v_id;
	
		v_mess := 'Ghi nhận thành công';
		
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