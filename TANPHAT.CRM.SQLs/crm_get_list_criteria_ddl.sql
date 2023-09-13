-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_list_criteria_ddl(4);
-- ================================
SELECT dropallfunction_byname('crm_get_list_criteria_ddl');
CREATE OR REPLACE FUNCTION crm_get_list_criteria_ddl
(
	p_user_title_id INT DEFAULT 0
)
RETURNS TABLE
(
	"CriteriaId" INT,
	"CriteriaName" VARCHAR,
	"Coef" NUMERIC,
	"MaxValue" NUMERIC,
	"UserTitleId" INT
)
AS $BODY$

BEGIN
	RETURN QUERY
	SELECT
		C."CriteriaId",
		C."CriteriaName",
		C."Coef",
		C."MaxValue",
		C."UserTitleId"
	FROM "Criteria" C
	WHERE C."IsActive" IS TRUE
		AND (C."UserTitleId" = p_user_title_id OR p_user_title_id = 0)
	ORDER BY
		C."UserTitleId",
		C."CriteriaId";	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

