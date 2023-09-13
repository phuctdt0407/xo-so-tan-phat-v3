-- ================================
-- Author: Quang
-- Description: tổng kết ca
-- Created date: 22/03/2022
-- Version: 1.0.0
-- SELECT * FROM crm_activity_shift_transfer(5,5,'QUANG','[{"TotalReceived": 300,"TotalRemaining":200,"LotteryChannelId": 1,"LotteryDate": "2022-03-22","TotalDupReceived":150,"TotalDupRemaining":50},{"TotalReceived": 300,"TotalRemaining":200,"LotteryChannelId": 2,"LotteryDate": "2022-03-22","TotalDupReceived":150,"TotalDupRemaining":50}]');
-- ================================
SELECT dropallfunction_byname('crm_activity_shift_transfer');
CREATE OR REPLACE FUNCTION crm_activity_shift_transfer
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
	v_shift_id INT;
BEGIN
	
	SELECT 
		UR."UserId" INTO v_user_id
	FROM "UserRole" UR WHERE UR."UserRoleId" = p_user_role_id;
	
	SELECT
		SD."SalePointId", SD."ShiftDistributeId", SD."ShiftId" INTO v_sale_point_id, v_shift_dis_id, v_shift_id
	FROM "ShiftDistribute" SD 
	WHERE SD."UserId" = v_user_id 
		AND SD."DistributeDate" = NOW()::DATE;
		
	IF COALESCE(v_sale_point_id, 0) > 0 THEN
	
		FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
	
			INSERT INTO "ShiftTransfer"(
				"ShiftId",
				"UserId",
				"TotalReceived",
				"TotalRemaining",
				"LotteryChannelId",
				"LotteryDate",
				"ActionBy",
				"ActionByName",
				"ActionDate",
				"TotalDupReceived",
				"TotalDupRemaining",
				"SalePointid"
			) VALUES (
				v_shift_id,
				v_user_id,
				(ele ->> 'TotalReceived')::INT,
				(ele ->> 'TotalRemaining')::INT,
				(ele ->> 'LotteryChannelId')::INT,
				(ele ->> 'LotteryDate')::DATE,
				p_action_by,
				p_action_by_name,
				NOW(),
				(ele ->> 'TotalDupReceived')::INT,
				(ele ->> 'TotalDupRemaining')::INT,
				v_sale_point_id
			) RETURNING "ShiftTransferId" INTO v_id;	
			
		END LOOP;

		v_mess := 'Ghi nhận chuyển ca thành công';
	
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