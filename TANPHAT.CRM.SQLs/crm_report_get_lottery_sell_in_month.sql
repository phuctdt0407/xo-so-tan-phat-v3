-- ================================
-- Author: Tien
-- Description: 
-- Created date: 20-06-2022
-- SELECT * FROM crm_report_get_lottery_sell_in_month('2022-06');
-- ================================
SELECT dropallfunction_byname('crm_report_get_lottery_sell_in_month');
CREATE OR REPLACE FUNCTION crm_report_get_lottery_sell_in_month
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"VT" TEXT,
	"VTr" TEXT,
	"VC" TEXT,
	"Lotto" TEXT,
	"Vietlot" TEXT,
	"SUM" TEXT,	
	"SUMF" TEXT,
	"Month" VARCHAR
)
AS $BODY$
DECLARE
	v_last_date DATE := ((p_month||'-01' )::date  + interval '1 month' - interval '1 day')::date;
	v_pre_last_date DATE := ((p_month||'-01' )::date - interval '1 day')::date;

BEGIN
	RETURN QUERY
	
		WITH tmp AS(
			SELECT 
				SPL."SalePointId",
				SPL."ActionDate" :: DATE,
				SPL."LotteryTypeId",
				SUM(SPL."Quantity") AS "TotalQuatity",
				SUM(SPL."TotalValue") AS "TotalValue",
				COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryPriceId"= 1),0) AS "Retail",
				COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryPriceId"<> 1),0) AS "Wholesale",
				COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryPriceId"= 1),0) AS "TotalRetail",
				COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryPriceId"<> 1),0) AS "TotalWholesale"
			FROM "SalePointLog" SPL 
			WHERE TO_CHAR("ActionDate",'YYYY-MM')= p_month
			GROUP BY SPL."SalePointId", SPL."ActionDate":: DATE, SPL."LotteryTypeId"
			ORDER BY SPL."SalePointId", SPL."ActionDate":: DATE, SPL."LotteryTypeId"
		), 
		doanhthulotto_vietlot AS (
			SELECT
				T."SalePointId",
				T."TransactionTypeId",
				T."ActionDate" :: DATE,
				SUM(T."Quantity") AS "TotalQuatity",
				SUM(T."TotalPrice") AS "TotalValue"
			FROM "Transaction" T
			WHERE TO_CHAR("ActionDate",'YYYY-MM')= p_month AND (T."TransactionTypeId" = 3 OR T."TransactionTypeId" = 2)
			GROUP BY T."SalePointId", T."TransactionTypeId", T."ActionDate":: DATE
			ORDER BY T."SalePointId", T."TransactionTypeId", T."ActionDate":: DATE
		),
		doanhthulotto AS (
			SELECT array_to_json(array_agg(ta))::TEXT AS "Lotto"
			FROM (
				SELECT * FROM doanhthulotto_vietlot
				WHERE "TransactionTypeId" = 3
			) ta
		),
		doanhthuvietlot AS (
			SELECT array_to_json(array_agg(ta))::TEXT AS "Vietlot"
			FROM (
				SELECT * FROM doanhthulotto_vietlot
				WHERE "TransactionTypeId" = 2
			) ta
		),
		tmp1 AS(
			SELECT array_to_json(array_agg(tm))::TEXT AS "VT"
			FROM (
				SELECT * FROM tmp
				WHERE "LotteryTypeId" = 1
			) tm 
		),
		tmp2 AS(
			SELECT array_to_json(array_agg(tm))::TEXT AS "VTr"
			FROM (
				SELECT * FROM tmp
				WHERE "LotteryTypeId" = 2
			) tm 
		),
		tmp3 AS(
			SELECT array_to_json(array_agg(tm))::TEXT AS "VC"
			FROM (
				SELECT * FROM tmp
				WHERE "LotteryTypeId" = 3
			) tm 
		),
		tmp4 AS(
			SELECT array_to_json(array_agg(sm))::TEXT AS "SUM"
			FROM (
				SELECT					
					tm."SalePointId",
					tm."ActionDate",
					SUM(tm."TotalQuatity") AS "TotalQuatity",
					SUM(tm."TotalValue") AS "TotalValue",
					SUM(tm."Wholesale") AS "Wholesale",
					SUM(tm."Retail") AS "Retail",
					SUM(tm."TotalWholesale") AS "TotalWholesale",
					SUM(tm."TotalRetail") AS "TotalRetail"
				FROM tmp tm
				GROUP BY
					tm."SalePointId", tm."ActionDate":: DATE
				ORDER BY
					tm."SalePointId", tm."ActionDate":: DATE
			) sm 
		),
		tmp5 AS(
			SELECT array_to_json(array_agg(sm))::TEXT AS "SUMF"
			FROM (
				SELECT					
					tm."SalePointId",
					SUM(tm."TotalQuatity") AS "TotalQuatity",
					SUM(tm."TotalValue") AS "TotalValue",
					SUM(tm."Wholesale") AS "Wholesale",
					SUM(tm."Retail") AS "Retail",
					SUM(tm."TotalWholesale") AS "TotalWholesale",
					SUM(tm."TotalRetail") AS "TotalRetail"
				FROM tmp tm
				GROUP BY
					tm."SalePointId"
				ORDER BY
					tm."SalePointId"
			) sm 
		)
		SELECT 
			tmp1."VT",
			tmp2."VTr",
			tmp3."VC",
			doanhthulotto."Lotto",
			doanhthuvietlot."Vietlot",
			tmp4."SUM",
			tmp5."SUMF",
			p_month
		FROM tmp1, tmp2, tmp3, tmp4, tmp5, doanhthulotto, doanhthuvietlot;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;