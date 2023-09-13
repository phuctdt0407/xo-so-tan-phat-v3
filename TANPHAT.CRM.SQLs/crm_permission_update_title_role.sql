-- ================================
-- Author: Phi
-- Description: Update quyền theo chức danh (vai trò)
-- select * from crm_permission_update_title_role(1, 'Supper Admin', 16, '[{ "RoleId": 155, "IsCheck": true }]')
-- ================================
SELECT dropallfunction_byname('crm_permission_update_title_role');
CREATE OR REPLACE FUNCTION crm_permission_update_title_role
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_title INT,
	p_list_role TEXT
)
	RETURNS TABLE (
		Id INT4,
		Message TEXT
) 
AS $$
DECLARE 
	v_id INT4;
	v_msg TEXT;
	v_list_role JSON;
	v_role JSON;
	v_ischeck BOOL;
	v_role_id INT4;
BEGIN 

	v_list_role := p_list_role::json;
	
	FOR v_role IN SELECT * FROM json_array_elements(v_list_role) ele LOOP
		
		v_ischeck := (v_role->>'IsCheck')::BOOL;
		v_role_id := (v_role->>'RoleId')::INT4;
		
		IF v_ischeck IS TRUE AND NOT EXISTS (SELECT 1 FROM "PermissionRoleTitles" WHERE "PermissionRoleId" = v_role_id AND "UserTitleId" = p_title) THEN
		
			INSERT INTO "PermissionRoleTitles"(
				"PermissionRoleId",
				"UserTitleId",
				"CreatedBy",
				"CreatedByName"
			)
			VALUES(
				v_role_id,
				p_title,
				p_action_by,
				p_action_by_name
			);
			
		ELSEIF v_ischeck IS FALSE AND EXISTS (SELECT 1 FROM "PermissionRoleTitles" WHERE "PermissionRoleId" = v_role_id AND "UserTitleId" = p_title) THEN
			
			DELETE FROM "PermissionRoleTitles" WHERE "PermissionRoleId" = v_role_id AND "UserTitleId" = p_title;
			
		END IF;
		
	END LOOP;
	
	v_id := 1;
	v_msg := 'Update permission successful!';
	
	RETURN QUERY 
	SELECT 	v_id AS "Id", v_msg AS "Message";
					
	EXCEPTION WHEN others THEN
	BEGIN
		v_id := -1;
		v_msg := sqlerrm;	
	END;
	
	RETURN QUERY 
	SELECT 	v_id AS "Id", v_msg AS "Message";
			
END; $$ 
LANGUAGE plpgsql;