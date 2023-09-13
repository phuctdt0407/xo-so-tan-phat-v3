-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_lottery_return_in_month('2022-03');
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_lottery_return_in_month');
CREATE OR REPLACE FUNCTION crm_report_get_total_lottery_return_in_month
(
	p_month VARCHAR
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
	FROM "Transition" T, "SalePoint" SP
	WHERE TO_CHAR(T."LotteryDate", 'YYYY-MM') = p_month 
		AND T."TransitionTypeId" = 3
		AND SP."SalePointId" = T."FromSalePointId"
	GROUP BY T."FromSalePointId", T."LotteryDate", SP."SalePointName";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

