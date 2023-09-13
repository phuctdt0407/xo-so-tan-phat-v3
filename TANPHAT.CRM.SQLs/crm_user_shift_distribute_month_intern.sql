-- ================================
-- Author: Phi
-- Description:
-- Created date:
-- SELECT * FROM crm_user_shift_distribute_month_intern(1,'Viet','[{"UserId":42,"TotalShift":28,"TotalAbsent":0,"TotalMakeup":0,"TotalOT":0,"IsMainShift":false}]','[{"SalePointId":1,"MainShift":{"inputShift_1":null,"inputShift_2":42},"ShiftData":[{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-01","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-02","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-03","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-04","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-05","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-06","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-07","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-08","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-09","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-10","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-11","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-12","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-13","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-14","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-15","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-16","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-17","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-18","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-19","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-20","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-21","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-22","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-23","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-24","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-25","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-26","ShiftTypeId":1},{"ShiftId":1,"UserId":42,"DistributeDate":"2023-02-27","ShiftTypeId":1},{"ShiftId":2,"UserId":42,"DistributeDate":"2023-02-28","ShiftTypeId":1}]}]','2023-02');
-- ================================
SELECT dropallfunction_byname('crm_user_shift_distribute_month_intern');
CREATE OR REPLACE FUNCTION crm_user_shift_distribute_month_intern
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_month VARCHAR,
	p_distribute_data TEXT,
	p_attendance_data TEXT
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
	v_att_data JSON := p_attendance_data::JSON;
	ele JSON;
	v_shift_main_id INT;
	shift JSON;
	ala JSON;
BEGIN
	
	FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
		
		IF NOT EXISTS (SELECT 1 FROM "ShiftMain" WHERE "SalePointId" = (ele ->> 'SalePointId')::INT AND "Month" = p_month FOR UPDATE) THEN
			
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
				AND S."ShiftId" = (shift ->> 'ShiftId')::INT  FOR UPDATE) THEN	
			
				INSERT INTO "ShiftDistributeForIntern"(
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
	
	FOR ala IN SELECT * FROM json_array_elements(v_att_data) LOOP
	
		IF NOT EXISTS(SELECT 1 FROM "ShiftAttendance" SA WHERE SA."UserId" = (ala ->> 'UserId')::INT AND SA."DistributeMonth" = p_month  FOR UPDATE) THEN
		
			INSERT INTO "ShiftAttendance"(
				"DistributeMonth",
				"UserId",
				"TotalShift",
				"TotalAbsent",
				"TotalOT",
				"TotalMakeup",
				"IsMainShift",
				"LastActionBy",
				"LastActionByName"
			) VALUES(
				p_month,
				(ala ->> 'UserId')::INT,
				(ala ->> 'TotalShift')::INT,
				(ala ->> 'TotalAbsent')::INT,
				(ala ->> 'TotalOT')::INT,
				(ala ->> 'TotalMakeup')::INT,
				(ala ->> 'IsMainShift')::BOOL,
				p_action_by,
				p_action_by_name
			);
		
		ELSE
		
			UPDATE "ShiftAttendance" SA
			SET
				"TotalShift" = (ala ->> 'TotalShift')::INT,
				"TotalAbsent" = (ala ->> 'TotalAbsent')::INT,
				"TotalOT" = (ala ->> 'TotalOT')::INT,
				"TotalMakeup" = (ala ->> 'TotalMakeup')::INT,
				"IsMainShift" = (ala ->> 'IsMainShift')::BOOL,
				"LastActionDate" = NOW(),
				"LastActionBy" = p_action_by,
				"LastActionByName" = p_action_by_name
			WHERE SA."UserId" = (ala ->> 'UserId')::INT
				AND SA."DistributeMonth" = p_month;
		
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