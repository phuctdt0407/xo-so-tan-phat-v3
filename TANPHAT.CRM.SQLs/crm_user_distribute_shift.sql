-- ================================
-- Author: Phi
-- Description: Chia ca làm việc
-- Created date: 02/03/2022
-- SELECT * FROM crm_user_distribute_shift();
-- ================================
SELECT dropallfunction_byname('crm_user_distribute_shift');
CREATE OR REPLACE FUNCTION crm_user_distribute_shift
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_sale_point_id INT,
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
	
		IF NOT EXISTS (SELECT 1 FROM "ShiftDistribute" S WHERE S."SalePointId" = p_sale_point_id 
			AND S."DistributeDate" = (ele ->> 'DistributeDate')::DATE 
			AND S."ShiftId" = (ele ->> 'ShiftId')::INT) THEN	
			
			INSERT INTO "ShiftDistribute"(
				"DistributeDate",
				"SalePointId",
				"ShiftId",
				"UserId",
				"ShiftTypeId",
				"ActionBy",
				"ActionByName"
			) VALUES (
				(ele ->> 'DistributeDate')::DATE,
				p_sale_point_id,
				(ele ->> 'ShiftId')::INT,
				(ele ->> 'UserId')::INT,
				1,
				p_action_by,
				p_action_by_name
			);
			
		ELSE 
		
			UPDATE "ShiftDistribute" S
			SET
				"UserId" = (ele ->> 'UserId')::INT,
				"ActionBy" = p_action_by,
				"ActionByName" = p_action_by_name,
				"ActionDate" = NOW()
			WHERE S."DistributeDate" = (ele ->> 'DistributeDate')::DATE
				AND S."SalePointId" = p_sale_point_id
				AND S."ShiftId" = (ele ->> 'ShiftId')::INT;
			
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