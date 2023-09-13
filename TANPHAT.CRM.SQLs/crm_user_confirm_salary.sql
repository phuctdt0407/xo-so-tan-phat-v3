-- ================================
-- Author: Quang
-- Description: 
-- Created date:
-- SELECT * FROM crm_user_confirm_salary(0 ,'System', '[{"UserId": 0, "SalaryData": "Vietllot 1/71", "Month": "2022-08"}]')
-- ================================
SELECT dropallfunction_byname('crm_user_confirm_salary');
CREATE OR REPLACE FUNCTION crm_user_confirm_salary 
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT,
	p_action_type INT DEFAULT 1
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
	ele JSON;
	v_time TIMESTAMP := NOW();
BEGIN
	--INSERT
	IF p_action_type = 1 THEN 
	
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			
			IF (ele ->> 'SalaryConfirmId')::INT IS NOT NULL THEN 
				UPDATE "SalaryConfirm"
				SET
					"ModifyBy" = p_action_by,
					"ModifyByName" = p_action_by_name,
					"ModifyDate" = v_time,
					"Data" = COALESCE((ele ->> 'SalaryData')::TEXT, "Data")
				WHERE "SalaryConfirmId" = (ele ->> 'SalaryConfirmId')::INT;			
			ELSEIF NOT EXISTS (
				SELECT 1 FROM "SalaryConfirm" SC
				WHERE SC."UserId" = (ele ->> 'UserId')::INT 
					AND SC."Month" = (ele ->> 'Month')::VARCHAR
					AND SC."IsDeleted" IS FALSE
			) THEN
				INSERT INTO "SalaryConfirm"(
					"UserId",
					"Month",
					"Data",
					"CreatedBy",
					"CreatedByName",
					"CreatedDate",
					"IsDeleted"
				)
				VALUES(
					(ele ->> 'UserId')::INT,
					(ele ->> 'Month')::VARCHAR,
					(ele ->> 'SalaryData')::TEXT,
					p_action_by,
					p_action_by_name,
					v_time,
					FALSE
				);
			
			END IF; 
			
		END LOOP;
		
		v_id := 1;
		v_mess := 'cập nhật thành công';
		
	--DELETE
	ELSEIF p_action_type = 3 THEN
	
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "SalaryConfirm"
			SET
				"ModifyBy" = p_action_by,
				"ModifyByName" = p_action_by_name,
				"ModifyDate" = v_time,
				"IsDeleted" = TRUE
			WHERE "SalaryConfirmId" = (ele ->> 'SalaryConfirmId')::INT;			
		END LOOP;
		
		v_id := 1;
		v_mess := 'Xóa thành công';
		
	END IF;
	
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