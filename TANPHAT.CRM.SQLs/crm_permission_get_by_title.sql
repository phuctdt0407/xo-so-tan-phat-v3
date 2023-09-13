-- ================================
-- Author: Phi
-- Description: Lấy danh sách quyền theo chức danh (vai trò)
-- SELECT * FROM crm_permission_get_by_title(2)
-- ================================
SELECT dropallfunction_byname('crm_permission_get_by_title');
CREATE OR REPLACE FUNCTION crm_permission_get_by_title
(
	p_title INT4
)
RETURNS TABLE (
	"RoleId" INT4,
	"RoleName" VARCHAR,
	"PermissionId" INT4,
	"PermissionName" VARCHAR,
	"ControllerName" VARCHAR,
	"IsCheck" BOOL
) 
AS $BODY$
BEGIN 
	
	RETURN QUERY
	SELECT 
		PR."PermissionRoleId",
		COALESCE(PR."RoleDisplayName", PR."RoleName"),
		P."PermissionId",
		P."PermissionName",
		P."ControllerName",
		(CASE WHEN PTR."PermissionRoleId" IS NULL THEN FALSE ELSE TRUE END)
	FROM "PermissionRole" PR
		JOIN "Permission" P ON P."PermissionId" = PR."PermissionId"
		LEFT JOIN "PermissionRoleTitles" PTR ON PR."PermissionRoleId" = PTR."PermissionRoleId" AND PTR."UserTitleId" = p_title
		JOIN "UserTitle" UT ON UT."UserTitleId" = p_title
	WHERE PR."IsDelete" IS FALSE
		AND PR."IsActive" IS TRUE
	ORDER BY 
		P."Sort" ASC, 
		P."PermissionId" ASC, 
		PR."Sort" ASC, 
		PR."PermissionRoleId" ASC; 
			
END; 
$BODY$ 
LANGUAGE plpgsql;