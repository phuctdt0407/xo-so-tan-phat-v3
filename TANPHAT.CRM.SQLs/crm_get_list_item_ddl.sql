-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_list_item_ddl(1);
-- ================================
SELECT dropallfunction_byname('crm_get_list_item_ddl');
CREATE OR REPLACE FUNCTION crm_get_list_item_ddl
(
	p_item_id INT DEFAULT 0
)
RETURNS TABLE
(
	"ItemId" INT,
	"ItemName" VARCHAR,
	"UnitId" INT,
	"UnitName" VARCHAR,
	"Price" INT,
	"Quotation" INT,
	"TypeOfItemId" INT,
	"TypeName" VARCHAR
)
AS $BODY$

BEGIN
	RETURN QUERY
	SELECT 
		I."ItemId",
		I."ItemName",
		I."UnitId",
		U."UnitName",
		I."Price",
		I."Quotation",
		I."TypeOfItemId",
		TI."TypeName"
	FROM "Item" I
		JOIN "Unit" U ON I."UnitId" = U."UnitId"
		JOIN "TypeOfItem" TI ON I."TypeOfItemId" = TI."TypeOfItemId"
	WHERE COALESCE(p_item_id, 0) = 0 OR I."ItemId" = p_item_id AND I."IsActive" IS TRUE
	ORDER BY I."TypeOfItemId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE