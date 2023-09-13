-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_get_list_sub_agency();
-- ================================
SELECT dropallfunction_byname('crm_activity_get_list_sub_agency');
CREATE OR REPLACE FUNCTION crm_activity_get_list_sub_agency
(

)
RETURNS TABLE
(
		"AgencyId" INT8,
		"AgencyName" VARCHAR,
		"IsActive" BOOL,
		"IsDelete" BOOL,
		"Price" NUMERIC
)
AS $BODY$
BEGIN

	RETURN QUERY
	SELECT 
		S."AgencyId",
		S."AgencyName",
		S."IsActive",
		S."IsDelete",
		S."Price"
	FROM "SubAgency" S
	ORDER BY S."AgencyId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE
