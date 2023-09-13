-- ================================
-- Author: Phi
-- Description: Lấy danh sách quyền theo chức danh (vai trò)
-- SELECT * FROM crm_auth_get_permission(12)
-- ================================
SELECT dropallfunction_byname('crm_auth_get_permission');
CREATE OR REPLACE FUNCTION crm_auth_get_permission
(
	p_user_role_id INT
)
RETURNS TABLE(
	"RoleDisplayName" VARCHAR,
	"RoleName" VARCHAR,
	"ActionName" VARCHAR,
	"IsShowMenu" BOOL,
	"PermissionName" VARCHAR,
	"ControllerName" VARCHAR,
	"CssIcon" TEXT,
	"IsSubMenu" BOOL,
	"Sort" INT
) 
AS $$
DECLARE
	v_user_title_id INT := (SELECT "UserTitleId" FROM "UserRole" WHERE "UserRoleId" = p_user_role_id);
	v_array_title INT[] := (SELECT "SubUserTitleId" FROM "UserRole" WHERE "UserRoleId" = p_user_role_id);
BEGIN 
	v_array_title := array_append(v_array_title, v_user_title_id);
	RETURN QUERY
  SELECT DISTINCT
		PR."RoleDisplayName",
		PR."RoleName",
		PR."ActionName",
		PR."IsShowMenu",
		P."PermissionName",
		P."ControllerName",
		P."CssIcon",
		PR."IsSubMenu",
		PR."Sort"
	FROM "PermissionRoleTitles" PRT
		JOIN "PermissionRole" PR ON PR."PermissionRoleId" = PRT."PermissionRoleId"
		JOIN "Permission" P ON P."PermissionId" = PR."PermissionId"
	WHERE PRT."UserTitleId" = ANY(v_array_title)
		AND PR."IsDelete" IS FALSE
		AND PR."IsActive" IS TRUE
	ORDER BY PR."Sort";
	
END; $$ 
LANGUAGE plpgsql;