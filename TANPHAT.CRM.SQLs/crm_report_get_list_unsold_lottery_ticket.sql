-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_list_unsold_lottery_ticket('2023-03');
-- ================================
SELECT dropallfunction_byname('crm_report_get_list_unsold_lottery_ticket');
CREATE OR REPLACE FUNCTION crm_report_get_list_unsold_lottery_ticket
(
		p_month VARCHAR
)
RETURNS TABLE
(
		"SalePointId" INT,
		"SalePointName" VARCHAR,
		"LotteryDate" DATE,
		"TotalRemaining" INT8
) 
AS $BODY$

BEGIN
	
	RETURN QUERY
	SELECT
		I."SalePointId",
		COALESCE( S."SalePointName",'Kho') AS "SalePointName",
		I."LotteryDate",
		(SUM(I."TotalRemaining") + SUM(I."TotalDupRemaining")) AS "TotalRemaining"
	FROM "Inventory" I 
	LEFT JOIN "SalePoint" S ON I."SalePointId" = S."SalePointId"
	WHERE 
		TO_CHAR(I."LotteryDate", 'YYYY-MM') = p_month
		AND I."SalePointId" > 0
	GROUP BY 
		I."LotteryDate",
		I."SalePointId",
		S."SalePointName"
	ORDER BY I."LotteryDate";
		
END;
$BODY$
LANGUAGE plpgsql VOLATILE
