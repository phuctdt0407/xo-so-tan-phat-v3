-- ================================
-- Author: Phi
-- Description: Lấy ĐĐL đại lý
-- Created date: 01/03/2022
-- SELECT * FROM crm_agency_ddl();
-- ================================
SELECT dropallfunction_byname('crm_agency_ddl');
CREATE OR REPLACE FUNCTION crm_agency_ddl()
RETURNS TABLE
(
	"Id" INT,
	"Name" VARCHAR,
	"IsActive" BOOLEAN
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		A."AgencyId",
		A."AgencyName",
		A."IsActive"
	FROM "Agency" A
	WHERE A."IsDeleted" IS FALSE
	ORDER BY A."AgencyId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE