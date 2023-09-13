-- ================================
-- Author: Quang
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_update_date_off_of_leader(0 ,'System', 1, '[{"LeaderOffLogId": 3, "WorkingDate": "2022-07-11", "UserId": 2, "Note": "TESSSSSSSSSSSSSSSSSSSSS"}]')
-- ================================
SELECT dropallfunction_byname('crm_update_date_off_of_leader');
CREATE OR REPLACE FUNCTION crm_update_date_off_of_leader 
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_action_type INT,
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
	v_time TIMESTAMP := NOW();
BEGIN
	--INSERT
	IF p_action_type = 1 THEN 
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			
				UPDATE "LeaderOffLog" 
				SET 
					"IsDeleted" = TRUE,
					"ActionBy" = p_action_by,
					"ActionByName" = p_action_by_name,
					"ActionDate" = v_time
				WHERE 
					"WorkingDate" = (ele->>'WorkingDate')::DATE;
				
--			IF NOT EXISTS (SELECT 1 FROM "LeaderOffLog" L WHERE L."WorkingDate" = (ele->>'WorkingDate')::DATE AND L."IsDeleted" IS FALSE) THEN 
				INSERT INTO "LeaderOffLog"(
					"WorkingDate",
					"UserId",
					"Note",
					"ActionBy",
					"ActionByName",
					"ActionDate",
					"IsDeleted"
				)
				VALUES(
					(ele->>'WorkingDate')::DATE,
					(ele->>'UserId')::INT,
					(ele->>'Note')::VARCHAR,
					p_action_by,
					p_action_by_name,
					v_time,
					FALSE
				) RETURNING "LeaderOffLogId" INTO v_id;
			
--			ELSE
--				RAISE 'Ngày % đã có một trưởng nhóm xin off', TO_CHAR((ele->>'WorkingDate')::DATE, 'DD/MM/YYYY');
--			END IF;			
		END LOOP;
		
		v_mess := 'Thêm thành công';
		
	--UPDATE
	ELSEIF p_action_type = 2 THEN
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			-- DO SOMETHING
		END LOOP;
		
		v_id := 1;
		v_mess := 'Cập nhật thành công';
		
	--DELETE
	ELSEIF p_action_type = 3 THEN
	
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "LeaderOffLog"
			SET 
				"IsDeleted" = TRUE,
				"ActionBy" = p_action_by,
				"ActionByName" = p_action_by_name,
				"ActionDate" = v_time
			WHERE 
				"LeaderOffLogId" = (ele->>'LeaderOffLogId')::INT;
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