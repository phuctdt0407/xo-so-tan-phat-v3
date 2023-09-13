-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_total_sale_of_sale_point_by_shiftdis(1, 163);
-- ===============================
SELECT dropallfunction_byname('crm_get_total_sale_of_sale_point_by_shiftdis');
CREATE OR REPLACE FUNCTION crm_get_total_sale_of_sale_point_by_shiftdis
(
	p_salepoint_id INT,
	p_shift_dis_id INT
)
RETURNS TABLE
(
	"SalePointId" INT,
	"LotteryTypeId" INT,
	"LotteryChannelId" INT,
	"LotteryDate" DATE,
	"Quantity" INT,
	"TotalSoldMoney" NUMERIC,
	"TotalRetail" INT,
	"TotalRetailMoney" NUMERIC,
	"TotalWholesale" INT,
	"TotalWholesaleMoney" NUMERIC,
	"ShiftDistributeId" INT,
	"ShiftId" INT
)
AS $BODY$
DECLARE
	v_quantity INT;
	v_total_money NUMERIC;
BEGIN
RETURN QUERY
	SELECT 
		SPL."SalePointId",
		SPL."LotteryTypeId",
		SPL."LotteryChannelId",
		SPL."LotteryDate",
		SUM(SPL."Quantity") ::INT, 
		SUM(SPL."TotalValue"),
		SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryPriceId" = 1 OR SPL."LotteryPriceId" = 10)  :: INT AS "TotalRetail",
		SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryPriceId" = 1 OR SPL."LotteryPriceId" = 10) AS "TotalRetailMoney",
		SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryPriceId" != 1 AND SPL."LotteryPriceId" != 10) :: INT AS "TotalWholesale",
		SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryPriceId" != 1 AND SPL."LotteryPriceId" != 10) AS "TotalWholesaleMoney",
		SPL."ShiftDistributeId",
		SD."ShiftId"
	FROM "SalePointLog" SPL
		JOIN "ShiftDistribute" SD ON SD."ShiftDistributeId" = SPL."ShiftDistributeId"
	WHERE SPL."SalePointId" = p_salepoint_id
		AND SPL."IsDeleted" IS FALSE
		AND SPL."ShiftDistributeId" = p_shift_dis_id
	GROUP BY SPL."SalePointId", SPL."LotteryTypeId", SPL."LotteryChannelId", SPL."LotteryDate", SPL."ShiftDistributeId", SD."ShiftId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

