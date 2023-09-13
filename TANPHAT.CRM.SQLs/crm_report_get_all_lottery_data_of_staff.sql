-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_all_lottery_data_of_staff('2023-03');
-- ================================
SELECT dropallfunction_byname('crm_report_get_all_lottery_data_of_staff');
CREATE OR REPLACE FUNCTION crm_report_get_all_lottery_data_of_staff
(
	p_month TEXT
)
RETURNS TABLE
(
	"TotalProfitInAMonth" TEXT
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	with tmp AS(
		SELECT SUM(SPL."TotalValue") AS "TotalLotteryValue" FROM "SalePointLog" SPL 
			WHERE TO_CHAR(SPL."LotteryDate",'YYYY-MM') = p_month AND "LotteryTypeId" = 1
	), tmp2 AS(
		SELECT SPL."TotalValue" AS "TotalSratchLotteryValue" FROM "SalePointLog" SPL 
			WHERE TO_CHAR(SPL."LotteryDate",'YYYY-MM') = p_month AND "LotteryTypeId" = 3
	), tmp3 AS(
		SELECT SUM(T."Price") AS "TotalVietlot" FROM "Transaction" T 
			WHERE TO_CHAR(T."Date",'YYYY-MM') = p_month AND T."TransactionTypeId" = 2
	), tmp4 AS(
		SELECT SUM(T."Price") AS "TotalLoto" FROM "Transaction" T 
			WHERE TO_CHAR(T."Date",'YYYY-MM') = p_month AND T."TransactionTypeId" = 3
	)
	SELECT json_build_object('TotalVietlot',T."TotalVietlot")::TEXT FROM tmp3 T
	UNION
	SELECT json_build_object('TotalLotteryValue',T."TotalLotteryValue")::TEXT FROM tmp T
	UNION 
	SELECT json_build_object('TotalSratchLotteryValue',T."TotalSratchLotteryValue")::TEXT FROM tmp2 T
	UNION
	SELECT json_build_object('TotalLoto',T."TotalLoto")::TEXT FROM tmp4 T;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE