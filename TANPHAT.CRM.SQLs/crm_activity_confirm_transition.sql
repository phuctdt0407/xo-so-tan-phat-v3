-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_confirm_transition(8, 'HELo', '[{"TransitionId": 17, "ConfirmTrans": 100, "ConfirmTransDup": 133 }]')
-- ================================
SELECT dropallfunction_byname('crm_activity_confirm_transition');
CREATE OR REPLACE FUNCTION crm_activity_confirm_transition
(
	p_user_role_id INT,
	p_note VARCHAR,
	p_list_item TEXT
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
	v_is_leader BOOL;
	v_is_manager BOOL;
	v_name VARCHAR;
	v_user_id INT;
	ele JSON;
BEGIN	
	SELECT UT."IsManager", UT."IsLeader", U."UserId" INTO v_is_manager, v_is_leader, v_user_id
	FROM "UserRole" U JOIN "UserTitle" UT ON U."UserTitleId" = UT."UserTitleId" 
	WHERE U."UserRoleId" = p_user_role_id;
	
	SELECT U."FullName" INTO v_name
	FROM "User" U 
	WHERE U."UserId" = v_user_id;
	
	IF (v_is_leader IS TRUE) THEN
		FOR ele IN SELECT * FROM json_array_elements(p_list_item::JSON) LOOP 		
			UPDATE "Transition"
			SET 
				"ConfirmTrans" = (ele ->> 'ConfirmTrans') :: INT,
				"ConfirmTransDup" = (ele ->> 'ConfirmTransDup') :: INT,
				"ConfirmBy" = v_user_id,
				"ConfirmByName" = v_name,
				"ConfirmDate" = NOW(),
				"ConfirmStatusId" = 2,
				"Note" = p_note
			WHERE 
				"TransitionId" = (ele ->> 'TransitionId') :: INT
				AND "ConfirmStatusId" = 1	;
		END LOOP;
		SELECT v_user_id, 'Xác Nhận Thành Công' INTO v_id, v_mess;

	ELSEIF v_is_manager IS TRUE THEN
		FOR ele IN SELECT * FROM json_array_elements(p_list_item::JSON) LOOP 		
			UPDATE "Transition"
			SET 
				"ConfirmBy" = v_user_id,
				"ConfirmByName" = v_name,
				"ConfirmDate" = NOW(),
				"ConfirmStatusId" = 2,
				"Note" = p_note
			WHERE 
				"TransitionId" = (ele ->> 'TransitionId') :: INT
				AND "ConfirmStatusId" = 1	;
		END LOOP;
		SELECT v_user_id, 'Xác Nhận Thành Công' INTO v_id, v_mess;
	ELSE
		SELECT -1, 'Bạn Không Có Quyền Này' INTO v_id, v_mess;
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




