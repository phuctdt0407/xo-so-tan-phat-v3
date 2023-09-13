-- ================================
-- Author: Phi
-- Description: Lấy danh sách điểm bán
-- Created date: 02/03/2022
-- SELECT * FROM crm_sale_point_ddl();
-- ================================
SELECT dropallfunction_byname('crm_sale_point_ddl');
CREATE OR REPLACE FUNCTION crm_sale_point_ddl()
RETURNS TABLE
(
	"Id" INT,
	"Name" VARCHAR
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT
		S."SalePointId",
		S."SalePointName"
	FROM "SalePoint" S 
	WHERE S."IsActive" IS TRUE
	ORDER BY S."SalePointId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE