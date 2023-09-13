-- ================================
-- Author: Phi
-- Description:
-- Created date:
-- SELECT * FROM crm_user_shift_distribute_month();
-- ================================
SELECT dropallfunction_byname('crm_user_shift_distribute_month');
CREATE OR REPLACE FUNCTION crm_user_shift_distribute_month
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_month VARCHAR,
	p_distribute_data TEXT
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
	v_data JSON := p_distribute_data::JSON;
	ele JSON;
	v_shift_main_id INT;
	shift JSON;
BEGIN
	
	FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
		
		IF NOT EXISTS (SELECT 1 FROM "ShiftMain" WHERE "SalePointId" = (ele ->> 'SalePointId')::INT AND "Month" = p_month) THEN
			
			INSERT INTO "ShiftMain"(
				"SalePointId",
				"Month",
				"MainUser"
			) VALUES (
				(ele ->> 'SalePointId')::INT,
				p_month,
				(ele ->> 'MainShift')
			) RETURNING "ShiftMainId" INTO v_shift_main_id;
		
		ELSE

			UPDATE "ShiftMain"
			SET
				"MainUser" = (ele ->> 'MainShift')
			WHERE "SalePointId" = (ele ->> 'SalePointId')::INT AND "Month" = p_month
			RETURNING "ShiftMainId" INTO v_shift_main_id;
		
		END IF;
		
		FOR shift IN SELECT * FROM json_array_elements((ele ->> 'ShiftData')::JSON) LOOP
		
			IF NOT EXISTS (SELECT 1 FROM "ShiftDistribute" S WHERE S."SalePointId" = (ele ->> 'SalePointId')::INT 
				AND S."DistributeDate" = (shift ->> 'DistributeDate')::DATE 
				AND S."ShiftId" = (shift ->> 'ShiftId')::INT) THEN	
			
				INSERT INTO "ShiftDistribute"(
					"DistributeDate",
					"SalePointId",
					"ShiftId",
					"UserId",
					"ShiftTypeId",
					"Note",
					"ShiftMainId",
					"ActionBy",
					"ActionByName"
				) VALUES (
					(shift ->> 'DistributeDate')::DATE,
					(ele ->> 'SalePointId')::INT,
					(shift ->> 'ShiftId')::INT,
					(shift ->> 'UserId')::INT,
					(shift ->> 'ShiftTypeId')::INT,
					(shift ->> 'Note'),
					v_shift_main_id,
					p_action_by,
					p_action_by_name
				);
				
			ELSE 
			
				UPDATE "ShiftDistribute" S
				SET
					"UserId" = (shift ->> 'UserId')::INT,
					"Note" = (shift ->> 'Note'),
					"ShiftTypeId" = (shift ->> 'ShiftTypeId')::INT,
					"ActionBy" = p_action_by,
					"ActionByName" = p_action_by_name,
					"ActionDate" = NOW()
				WHERE S."DistributeDate" = (shift ->> 'DistributeDate')::DATE
					AND S."SalePointId" = (ele ->> 'SalePointId')::INT
					AND S."ShiftId" = (shift ->> 'ShiftId')::INT;
				
			END IF;
		
		END LOOP;
		
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