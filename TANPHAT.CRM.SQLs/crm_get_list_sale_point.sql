-- ================================
-- Author: Phi
-- Description: Lấy danh sách điểm bán
-- Created date: 02/03/2022
-- SELECT * FROM crm_get_list_sale_point();
-- ================================
SELECT dropallfunction_byname('crm_get_list_sale_point');
CREATE OR REPLACE FUNCTION crm_get_list_sale_point(
	p_id INT DEFAULT 0
)
RETURNS TABLE
(
	"Id" INT,
	"Name" VARCHAR,
	"IsActive" BOOLEAN,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"FullAddress" VARCHAR,
	"Note" VARCHAR
)
AS $BODY$
BEGIN
	RETURN QUERY 
	SELECT
		S."SalePointId",
		S."SalePointName",
		S."IsActive",
		COALESCE(S."ModifyBy", S."ActionBy"),
		COALESCE(S."ModifyByName", S."ActionByName"),
		S."FullAddress",
		S."Note"
	FROM "SalePoint" S 
	WHERE	S."IsDeleted" IS FALSE  
		AND (p_id = 0 OR p_id= "SalePointId") 
	ORDER BY S."SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE