-- ================================
-- Author: Phi
-- Description: Ghi nhận chuyển vé, trả ế
-- Editted date: 08/04/2022
-- SELECT * FROM crm_insert_transition_log_v3();
-- ================================
SELECT dropallfunction_byname('crm_insert_transition_log_v3');
CREATE OR REPLACE FUNCTION crm_insert_transition_log_v3
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
					"ConfirmStatusId",
					"IsScratchcard"
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
					1,
					COALESCE((ele ->> 'IsScratchcard')::BOOL, FALSE)
				);
				
				v_id := v_sale_point_id;
				v_mess := 'Tạo yêu cầu chuyển vé thành công';
			
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
					"ConfirmStatusId",
					"IsScratchcard"
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
					1,
					COALESCE((ele ->> 'IsScratchcard')::BOOL, FALSE)
				);
				
				v_id := v_sale_point_id;
				v_mess := 'Tạo yêu cầu nhận vé thành công';
		
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
					"ConfirmStatusId",
					"IsScratchcard"
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
					1,
					COALESCE((ele ->> 'IsScratchcard')::BOOL, FALSE)
				);
				
				v_id := v_sale_point_id;
				v_mess := 'Tạo yêu cầu trả ế thành công';
			
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