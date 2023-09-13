-- ================================
-- Author: Phi
-- Description: Check login
-- Created date: 23/02/2022
-- SELECT * FROM crm_auth_checklogin('phivuong','PZjxNbuatOY+fTXMK8Z4Fw==','','');
-- ================================
SELECT dropallfunction_byname('crm_auth_checklogin');
CREATE OR REPLACE FUNCTION crm_auth_checklogin
(
	p_account VARCHAR,
	p_password VARCHAR,
	p_mac_address VARCHAR,
	p_ip_address VARCHAR
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
	--
	v_user_role_id INT;
	v_sale_point_id INT;
	v_shift_dis_id INT;
BEGIN
	
	SELECT 
		U."UserId"
	INTO
		v_id
	FROM "User" U
	WHERE (LOWER(U."Email") = LOWER(p_account) OR LOWER(U."Account") = LOWER(p_account)) AND U."Password" = p_password
		AND U."IsActive" IS TRUE AND U."IsDeleted" IS FALSE;
	
	IF COALESCE(v_id, 0) <> 0 THEN
		
		SELECT UR."UserRoleId" INTO v_user_role_id
		FROM "UserRole" UR
		WHERE UR."UserId" = v_id;
		
		SELECT 
			"SalePointId",
			"ShiftDistributeId"
		INTO 
			v_sale_point_id,
			v_shift_dis_id
		FROM fn_get_shift_info(v_user_role_id);
		
		INSERT INTO "AuthLog"(
			"UserId",
			"ActionType",
			"LogContent",
			"SalePointId",
			"ShiftDistributeId"
		) VALUES(
			v_id,
			'Đăng nhập',
			'Đăng nhập thành công',
			v_sale_point_id,
			v_shift_dis_id
		);
		
		v_mess := 'Đăng nhập thành công';
		
	ELSE
		
		v_mess := 'Sai tên đăng nhập hoặc mậu khẩu';
	
	END IF;
	
	RETURN QUERY 
	SELECT COALESCE(v_id, -1), v_mess;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE