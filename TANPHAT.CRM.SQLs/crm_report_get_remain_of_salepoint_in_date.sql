-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_remain_of_salepoint_in_date(1, '2022-03');
-- ================================
SELECT dropallfunction_byname('crm_report_get_remain_of_salepoint_in_date');
CREATE OR REPLACE FUNCTION crm_report_get_remain_of_salepoint_in_date
(
	p_salepoint_id INT,
	p_month VARCHAR
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"LotteryDate" DATE,
	"TotalRemaining" INT,
	"TotalDupRemaining" INT
)
AS $BODY$

BEGIN
	
	RETURN QUERY
	SELECT 
		SP."SalePointId", 
		SP."SalePointName", 
		I."LotteryDate", 
		I."TotalRemaining", 
		I."TotalDupRemaining"
	FROM "SalePoint" SP JOIN "Inventory" I ON SP."SalePointId" = I."SalePointId"
	WHERE TO_CHAR(I."LotteryDate", 'YYYY-MM') = p_month 
		AND (COALESCE(p_salepoint_id, 0) = 0 OR I."SalePointId" = p_salepoint_id)
	ORDER BY SP."SalePointId", I."LotteryDate";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

