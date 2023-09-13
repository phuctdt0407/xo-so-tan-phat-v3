-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_lottery_return_in_month_v2('2022-03',3);
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_lottery_return_in_month_v2');
CREATE OR REPLACE FUNCTION crm_report_get_total_lottery_return_in_month_v2
(
	p_month VARCHAR,
	p_sale_point_id INT
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"DateReturn" DATE,
	"TotalReturn" INT8
)
AS $BODY$

BEGIN
	RETURN QUERY
	SELECT 
		T."FromSalePointId",
		SP."SalePointName", 
		T."LotteryDate", 
		SUM(T."TotalTrans") AS "TotalTrans"
	FROM "Transition" T
		JOIN "SalePoint" SP ON SP."SalePointId" = T."FromSalePointId"
	WHERE TO_CHAR(T."LotteryDate", 'YYYY-MM') = p_month 
		AND T."TransitionTypeId" = 3
		AND (COALESCE(p_sale_point_id, 0) = 0 OR SP."SalePointId" = p_sale_point_id)
	GROUP BY T."FromSalePointId", T."LotteryDate", SP."SalePointName";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

