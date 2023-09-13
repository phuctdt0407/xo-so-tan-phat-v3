-- ================================
-- Author: Phi
-- Description: Cấp lại mật khẩu mới cho tài khoản, chức năng quên mật khẩu
-- Created date: 25/02/2022
-- SELECT * FROM getlist(crm_auth_forgot_password);
-- ================================
SELECT dropallfunction_byname('crm_auth_forgot_password');
CREATE OR REPLACE FUNCTION crm_auth_forgot_password
(
	p_email VARCHAR,
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
	v_old_password VARCHAR;
	v_log_content VARCHAR;
BEGIN
	
	SELECT U."UserId", U."Password" 
	INTO v_id, v_old_password 
	FROM "User" U 
	WHERE U."IsActive" IS TRUE AND U."IsDeleted" IS FALSE
		AND LOWER("Email") = LOWER(p_email);
	
	IF COALESCE(v_id, 0) <> 0 THEN
		
		UPDATE "User"
		SET
			"Password" = p_new_password
		WHERE "UserId" = v_id;
		
		v_log_content := 'Mật khẩu cũ: '||v_old_password||', Mật khẩu cấp lại: '||p_new_password;
		INSERT INTO "AuthLog"(
			"UserId",
			"ActionType",
			"LogContent"
		) VALUES(
			v_id,
			'Cấp lại mật khẩu',
			v_log_content
		);
		
		v_mess := 'Cấp lại mật khẩu mới thành công';
		
	ELSE
		
		v_mess := 'Email không tồn tại trong hệ thống';
	
	END IF;
	
	RETURN QUERY 
	SELECT COALESCE(v_id, 0), v_mess;

END;
$BODY$
LANGUAGE plpgsql VOLATILE