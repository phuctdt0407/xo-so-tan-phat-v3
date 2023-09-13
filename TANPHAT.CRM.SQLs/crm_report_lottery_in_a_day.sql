-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_report_lottery_in_a_day(6,'2023-04-04',2);


-- ================================
SELECT dropallfunction_byname('crm_report_lottery_in_a_day');
CREATE OR REPLACE FUNCTION crm_report_lottery_in_a_day
(
	p_sale_point_id INT,
	p_date TIMESTAMP,
	p_shift_id INT8
)
RETURNS TABLE
(
	"Data" text
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	with tmp AS(SELECT
		RL.* 
	FROM "ReportLottery" RL
	LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = RL."LotteryChannelId"
	WHERE RL."Date" = p_date AND (RL."ShiftId" = p_shift_id or p_shift_id = 0) AND RL."SalePointId" = p_sale_point_id 
	ORDER BY RL."LotteryDate",LC."LotteryChannelTypeId")
	SELECT array_to_json(array_agg(json_build_object(
		'ReportLotteryId',
		T."ReportLotteryId",
		'ShiftId',
		T."ShiftId",
		'Date',
		T."Date",
		'LotteryChannelId',
		T."LotteryChannelId",
		'SalePointId',
		T."SalePointId",
		'Stock',
		T."Stock",
		'SoldRetail',
		T."SoldRetail",
		'Remaining',
		T."Remaining",
		'LotteryTypeId',
		T."LotteryTypeId",
		'Transfer',
		T."Transfer",
		'Received',
		T."Received",
		'LotteryDate',
		T."LotteryDate",
		'OrdinalNum',
		T."OrdinalNum",
		'SoldRetailMoney',
		T."SoldRetailMoney",
		'SoldWholeSale',
		T."SoldWholeSale",
		'SoldWholeSaleMoney',
		T."SoldWholeSaleMoney",
		'ReceivedDup',
		T."ReceivedDup",
		'TransferDup',
		T."TransferDup",
		'RemainingDup',
		T."RemainingDup",
		'StockDup',
		T."StockDup",
		'SoldRetailDup',
		T."SoldRetailDup",
		'SoldRetailMoneyDup',
		T."SoldRetailMoneyDup",
		'SoldWholeSaleDup',
		T."SoldWholeSaleDup",
		'SoldWholeSaleMoneyDup',
		T."SoldWholeSaleMoneyDup"
	)))::TEXT AS "Data" FROM tmp T;
END;
$BODY$
LANGUAGE plpgsql VOLATILE