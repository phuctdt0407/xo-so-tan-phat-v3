-- ================================
-- Author: Phi
-- Description: Đổi mật khẩu
-- Created date: 25/02/2022
-- SELECT * FROM getlist(crm_auth_change_password);
-- ================================
SELECT dropallfunction_byname('crm_auth_change_password');
CREATE OR REPLACE FUNCTION crm_auth_change_password
(
	p_user_id INT,
	p_current_password VARCHAR,
	p_new_password VARCHAR
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
	v_log_content VARCHAR;
BEGIN

	SELECT 
		U."UserId"
	INTO
		v_id
	FROM "User" U
	WHERE U."UserId" = p_user_id AND U."Password" = p_current_password
		AND U."IsActive" IS TRUE AND U."IsDeleted" IS FALSE;
	
	IF COALESCE(v_id, 0) <> 0 THEN
		
		UPDATE "User"
		SET
			"Password" = p_new_password
		WHERE "UserId" = v_id;
		
		v_log_content := 'Mật khẩu cũ: '||p_current_password||', Mật khẩu mới: '||p_new_password;
		INSERT INTO "AuthLog"(
			"UserId",
			"ActionType",
			"LogContent"
		) VALUES(
			v_id,
			'Đổi mật khẩu',
			v_log_content
		);
		
		v_mess := 'Đổi mật khẩu thành công';
		
	ELSE
		
		v_mess := 'Mật khẩu cũ không đúng';
	
	END IF;
	
	RETURN QUERY 
	SELECT COALESCE(v_id, 0), v_mess;

END;
$BODY$
LANGUAGE plpgsql VOLATILE