-- ================================
-- Author: Phi
-- Description: Get user ddl by usertitle
-- Created date: 03/03/2022
-- SELECT * FROM crm_user_by_title(0);
-- ================================
SELECT dropallfunction_byname('crm_user_by_title');
CREATE OR REPLACE FUNCTION crm_user_by_title
(
	p_usertitle_id INT
)
RETURNS TABLE
(
	"Id" INT,
	"Name" VARCHAR
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		U."UserId",
		U."FullName"
	FROM "User" U
		JOIN "UserRole" UR ON UR."UserId" = U."UserId"
		JOIN "UserTitle" UT ON UT."UserTitleId" = UR."UserTitleId"
	WHERE U."IsActive" IS TRUE
		AND (COALESCE(p_usertitle_id, 0) = 0 OR UT."UserTitleId" = p_usertitle_id);
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE