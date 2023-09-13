-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_list_unit_ddl(1);
-- ================================
SELECT dropallfunction_byname('crm_get_list_unit_ddl');
CREATE OR REPLACE FUNCTION crm_get_list_unit_ddl
(
	p_unit_id INT DEFAULT 0
)
RETURNS TABLE
(
	"UnitId" INT,
	"UnitName" VARCHAR
)
AS $BODY$

BEGIN
	RETURN QUERY
	SELECT 
		U."UnitId",
		U."UnitName"
	FROM "Unit" U 
	WHERE COALESCE(p_unit_id, 0) = 0 OR U."UnitId" = p_unit_id
	ORDER BY U."UnitId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE