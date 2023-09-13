-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_inventory_inmonth_of_all_salepoint('2022-03');
-- ================================
SELECT dropallfunction_byname('crm_get_inventory_inmonth_of_all_salepoint');
CREATE OR REPLACE FUNCTION crm_get_inventory_inmonth_of_all_salepoint
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"SalePointId" int4, 
	"SalePointName" varchar, 
	"TotalReceived" int8, 
	"TotalRemaining" int8, 
	"TotalDupReceived" int8, 
	"TotalDupRemaining" int8
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
			SP."SalePointId",
			SP."SalePointName",
			A."TotalReceived",
			A."TotalRemaining",
			A."TotalDupReceived",
			A."TotalDupRemaining"			
	FROM "SalePoint" SP LEFT JOIN (
		SELECT
			I."SalePointId",
			SUM(I."TotalReceived") "TotalReceived", 
			SUM(I."TotalRemaining") "TotalRemaining", 
			SUM(I."TotalDupReceived") "TotalDupReceived", 
			SUM(I."TotalDupRemaining") "TotalDupRemaining" 
		FROM "Inventory" I
		WHERE TO_CHAR(I."LotteryDate",'YYYY-MM') = p_month
		GROUP BY I."SalePointId") A ON SP."SalePointId" = A."SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

