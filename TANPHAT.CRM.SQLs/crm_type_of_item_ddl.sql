-- ================================
-- Author: Phi
-- Description: Lấy danh sách các chức vụ
-- Created date: 03/03/2022
-- SELECT * FROM crm_type_of_item_ddl();
-- ================================
SELECT dropallfunction_byname('crm_type_of_item_ddl');
CREATE OR REPLACE FUNCTION crm_type_of_item_ddl()
RETURNS TABLE
(
	"TypeOfItemId" INT,
	"TypeName" VARCHAR
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT
		TI."TypeOfItemId",
		TI."TypeName"
	FROM "TypeOfItem" TI
	ORDER BY TI."TypeOfItemId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE