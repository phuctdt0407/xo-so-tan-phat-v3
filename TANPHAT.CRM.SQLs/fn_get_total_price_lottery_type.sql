-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM fn_get_total_price_lottery_type('2022-12',1,1,1);
-- ================================
SELECT dropallfunction_byname('fn_get_total_price_lottery_type');
CREATE OR REPLACE FUNCTION fn_get_total_price_lottery_type
(
	p_month  VARCHAR,
	p_sale_point_id INT,
	p_lottery_price_id INT,
	p_lottery_type_id INT
)
RETURNS INT8
AS $BODY$
DECLARE
	v_total_price_regular_ticket INT;
BEGIN
	v_total_price_regular_ticket := (SELECT 
																			SUM(SP."TotalValue")
																		FROM "SalePointLog" SP 
																		WHERE SP."LotteryTypeId" = p_lottery_type_id
																		AND SP."SalePointId" = p_sale_point_id
																		AND to_char(SP."ActionDate" , 'YYYY-MM') =  p_month
																		AND SP."LotteryPriceId" = p_lottery_price_id
																		GROUP BY SP."LotteryTypeId");
	RETURN COALESCE(v_total_price_regular_ticket,0);
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
