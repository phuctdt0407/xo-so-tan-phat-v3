-- ================================
-- Author: Phi
-- Description: Get user session info 
-- Created date: 2022-02-24
-- SELECT * FROM crm_user_get_session_info(4);
-- ================================
SELECT dropallfunction_byname('crm_user_get_session_info');
CREATE OR REPLACE FUNCTION crm_user_get_session_info
(
	p_user_id INT
)
RETURNS TABLE
(
	"UserId" INT,
	"UserRoleId" INT,
	"Account" VARCHAR,
	"FullName" VARCHAR,
	"Email" VARCHAR,
	"UserTitleId" INT,
	"UserTitleName" VARCHAR,
	"SubUserTitle" TEXT,
	"IsSuperAdmin" BOOL,
	"IsManager" BOOL,
	"IsStaff" BOOL,
	"SalePointId" INT,
	"ShiftDistributeId" INT
)
AS $BODY$
DECLARE
	v_user_role_id INT;
	v_user_title_id INT;
	v_user_title_name VARCHAR;
	v_sub_user_title INT[];
BEGIN
	
	SELECT 
		UR."UserRoleId",
		UT."UserTitleId",
		UT."UserTitleName",
		UR."SubUserTitleId" 
	INTO v_user_role_id, v_user_title_id, v_user_title_name, v_sub_user_title
	FROM "UserRole" UR 
		JOIN "UserTitle" UT ON UT."UserTitleId" = UR."UserTitleId"
	WHERE UR."UserId" = p_user_id;
	
	RETURN QUERY 
	WITH tmp AS(
		SELECT * FROM fn_get_shift_info(v_user_role_id)
	)
	SELECT 
		p_user_id,
		v_user_role_id,
		U."Account",
		U."FullName",
		U."Email",
		v_user_title_id,
		v_user_title_name,
		(
			CASE WHEN array_length(v_sub_user_title, 1) > 0 THEN
				(SELECT
					array_to_json(array_agg(
						(	
							SELECT 
								json_build_object(
									'UserTitleId',
									A,
									'UserTitleName',
									UT."UserTitleName"
								)
							FROM "UserTitle" UT 
							WHERE UT."UserTitleId" = A 
						)::JSON
					))
				FROM UNNEST(v_sub_user_title) A)::TEXT
			ELSE
				'[]'
			END
		)::TEXT AS "SubUserTitle",
		t."IsSuperAdmin",
		t."IsManager",
		t."IsStaff",
		t."SalePointId",
		t."ShiftDistributeId"
	FROM "User" U
		JOIN tmp t ON t."UserId" = U."UserId"
	WHERE U."IsActive" IS TRUE AND U."IsDeleted" IS FALSE AND U."UserId" = p_user_id;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE