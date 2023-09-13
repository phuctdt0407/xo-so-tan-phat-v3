-- ================================
-- Author: Viet
-- Description: Get intern ddl by usertitle
-- Created date: 02/09/2023
-- SELECT * FROM crm_intern_by_title();
-- ================================
SELECT dropallfunction_byname('crm_intern_by_title');
CREATE OR REPLACE FUNCTION crm_intern_by_title
(
)
RETURNS TABLE
(
	"UserId" INT,	
	"UserName" VARCHAR
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
		AND UR."UserTitleId" = 5
		AND U."IsIntern" = TRUE;
END;
$BODY$
LANGUAGE plpgsql VOLATILE