-- ================================
-- Author: Phi
-- Description: Lấy trang đầu tiên đối với quyền
-- SELECT * FROM crm_permission_get_first_page_show(1)
-- ================================
SELECT dropallfunction_byname('crm_permission_get_first_page_show');
CREATE OR REPLACE FUNCTION crm_permission_get_first_page_show
(
	p_user_role_id INT
)
RETURNS TABLE (
	"ActionName" VARCHAR,
	"ControllerName" VARCHAR
) 
AS $BODY$
DECLARE
	v_user_title_id INT := (SELECT "UserTitleId" FROM "UserRole" WHERE "UserRoleId" = p_user_role_id);
BEGIN

	RETURN QUERY
	SELECT 
		PR."ActionName",
		P."ControllerName"
	FROM "PermissionRole" PR
		JOIN "Permission" P ON P."PermissionId" = PR."PermissionId"
		JOIN "PermissionRoleTitles" PTR ON PR."PermissionRoleId" = PTR."PermissionRoleId" AND PTR."UserTitleId" = v_user_title_id
	WHERE PR."IsShowMenu" IS TRUE
	ORDER BY P."Sort" ASC, P."PermissionId" ASC, PR."Sort" ASC, PR."PermissionRoleId" ASC
	LIMIT 1;

END; $BODY$ 
LANGUAGE plpgsql;