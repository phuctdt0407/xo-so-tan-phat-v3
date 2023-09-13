-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_sub_agency_ddl();
-- ================================
SELECT dropallfunction_byname('crm_sub_agency_ddl');
CREATE OR REPLACE FUNCTION crm_sub_agency_ddl
(
)
RETURNS TABLE
(
	"SubAgencyId" INT8,
	"SubAgencyName" VARCHAR
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	SELECT S."AgencyId", S."AgencyName" 
	FROM "SubAgency" S
	WHERE S."IsActive" = TRUE AND S."IsDelete" = FALSE;
END;
$BODY$
LANGUAGE plpgsql VOLATILE