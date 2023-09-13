-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_inventory_inday_of_all_salepoint_v2('2022-03',1);
-- ================================
SELECT dropallfunction_byname('crm_get_inventory_inday_of_all_salepoint_v2');
CREATE OR REPLACE FUNCTION crm_get_inventory_inday_of_all_salepoint_v2
(
	p_month VARCHAR, -- YYYY-MM
	p_sale_point_id INT
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"LotteryDate" DATE,
	"TotalReceived" INT8,
	"TotalRemaining" INT8,
	"TotalDupReceived" INT8,
	"TotalDupRemaining" INT8
)
AS $BODY$
BEGIN

	RETURN QUERY
	WITH tmp AS(
		SELECT
			I."SalePointId",
			I."LotteryDate",
			SUM(I."TotalReceived") "TotalReceived", 
			SUM(I."TotalRemaining") "TotalRemaining", 
			SUM(I."TotalDupReceived") "TotalDupReceived", 
			SUM(I."TotalDupRemaining") "TotalDupRemaining" 
		FROM "Inventory" I
		WHERE TO_CHAR(I."LotteryDate",'YYYY-MM') = p_month
		AND I."LotteryDate" BETWEEN (date_trunc('MONTH',(p_month || '-01')::DATE)::DATE) AND NOW()::DATE
			AND (COALESCE(p_sale_point_id, 0) = 0 OR I."SalePointId" = p_sale_point_id)
		GROUP BY I."SalePointId", I."LotteryDate"
	)
	SELECT 
		SP."SalePointId",
		SP."SalePointName",
		A."LotteryDate",
		A."TotalReceived",
		A."TotalRemaining",
		A."TotalDupReceived",
		A."TotalDupRemaining"			
	FROM "SalePoint" SP 
		JOIN tmp A ON SP."SalePointId" = A."SalePointId";
		 
END;
$BODY$
LANGUAGE plpgsql VOLATILE

