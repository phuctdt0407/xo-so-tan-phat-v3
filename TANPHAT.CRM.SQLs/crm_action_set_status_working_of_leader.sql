-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_action_set_status_working_of_leader(5, 1, FALSE, '2022-02-08' )
-- ================================
SELECT dropallfunction_byname('crm_action_set_status_working_of_leader');
CREATE OR REPLACE FUNCTION crm_action_set_status_working_of_leader
(
	p_user_id INT,
	p_user_role INT,
	p_status BOOL,
	p_date DATE
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
	v_is_manager BOOL;
	v_is_super_admin BOOL;
	v_action_by INT;
	v_action_by_name VARCHAR;
BEGIN
	SELECT 
		U."UserId",
		U."FullName",
		UT."IsSuperAdmin",
		UT."IsManager"
		INTO v_action_by, v_action_by_name, v_is_super_admin, v_is_manager
	FROM "UserRole" UR 
		JOIN "User" U ON UR."UserId" = U."UserId"
		JOIN "UserTitle" UT ON UT."UserTitleId" = UR."UserTitleId"
	WHERE UR."UserRoleId" = p_user_role;
	
	IF(v_is_super_admin IS TRUE OR v_is_manager IS TRUE) THEN
		IF(EXISTS(SELECT * FROM "LeaderAttendent" LA WHERE LA."UserId" = p_user_id)) THEN		
			-- Cập nhật trạng thái
			UPDATE "LeaderAttendent" 
			SET "IsWorking" = p_status
			WHERE "UserId" = p_user_id;
			
			-- Cập nhật log

			IF(p_status IS FALSE) THEN
				INSERT INTO "LeaderOffLog"("WorkingDate", "UserId", "ActionBy", "ActionByName", "ActionDate")
				VALUES(p_date, p_user_id, v_action_by, v_action_by_name, NOW());
			ELSE 
				DELETE FROM "LeaderOffLog"
				WHERE "WorkingDate" = p_date
				AND "UserId" = p_user_id;
			END IF;
			SELECT 1, 'Cập nhật thành công' INTO v_id, v_mess;
		ELSE
			SELECT 0, 'Mã quản lý không hợp lệ' INTO v_id, v_mess;
		END IF;
	ELSE
		SELECT 0, 'Bạn không có quyền này' INTO v_id, v_mess;
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

