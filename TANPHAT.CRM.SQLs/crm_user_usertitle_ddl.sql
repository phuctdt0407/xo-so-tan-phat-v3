-- ================================
-- Author: Phi
-- Description: Lấy danh sách các chức vụ
-- Created date: 03/03/2022
-- SELECT * FROM crm_user_usertitle_ddl(TRUE);
-- ================================
SELECT dropallfunction_byname('crm_user_usertitle_ddl');
CREATE OR REPLACE FUNCTION crm_user_usertitle_ddl(
	p_get_full BOOLEAN DEFAULT FALSE
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
		"UserTitleId",
		"UserTitleName"
	FROM "UserTitle"
	WHERE p_get_full IS TRUE OR "UserTitleId" <> 1
	ORDER BY "UserTitleId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE