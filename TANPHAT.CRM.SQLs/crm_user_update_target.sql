-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_update_target(1,'Quang', 1, '[{"FromValue": 2000, "ToValue": 2000, "Value": 1200000 },{"FromValue": 2000, "ToValue": 3000, "Value": 2200000 }]')
-- ================================
SELECT dropallfunction_byname('crm_user_update_target');
CREATE OR REPLACE FUNCTION crm_user_update_target
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_target_type_id INT,
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
	ele JSON;
	A INT[] := '{}' ::INT[];
	v_time TIMESTAMP := NOW();
	v_value_index INT;
BEGIN
	FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
		
		IF NOT EXISTS (
			SELECT 1 FROM "TargetData" T 
			WHERE T."TargetDataTypeId" = p_target_type_id 
				AND T."FromValue" = (ele->>'FromValue')::INT 
				AND T."ToValue" = (ele->>'ToValue')::INT
				AND T."Value" = (ele->>'Value')::NUMERIC
				AND T."IsDeleted" IS FALSE
		) THEN 
			-- Insert nếu chưa có
			INSERT INTO "TargetData"(
				"TargetDataTypeId",
				"FromValue",
				"ToValue",
				"Value",
				"IsDeleted",
			  "CreatedBy",
				"CreatedByName",
				"CreatedDate"
			)
			VALUES(
				p_target_type_id,
				(ele->>'FromValue')::INT,
				(ele->>'ToValue')::INT,
				(ele->>'Value')::NUMERIC,
				FALSE,
				p_action_by,
				p_action_by_name,
				v_time
			) RETURNING "TargetDataId" INTO v_value_index;
			
			SELECT array_append(A, v_value_index) INTO A;
			
		ELSE
			--Thêm id của số đã có vào mảng tạm
			SELECT T."TargetDataId" INTO v_value_index 
			FROM "TargetData" T
			WHERE T."TargetDataTypeId" = p_target_type_id 
				AND T."FromValue" = (ele->>'FromValue')::INT 
				AND T."ToValue" = (ele->>'ToValue')::INT
				AND T."Value" = (ele->>'Value')::NUMERIC
				AND T."IsDeleted" IS FALSE;
				
			SELECT array_append(A, v_value_index) INTO A;
						
		END IF;
		
	END LOOP;
	
	UPDATE "TargetData"
	SET "IsDeleted" = TRUE
	WHERE "TargetDataTypeId" = p_target_type_id
		AND "TargetDataId" <> ALL(A)
		AND "IsDeleted" IS FALSE;
	
	v_id := 1;
	v_mess := 'Cập nhật thành công';
	
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