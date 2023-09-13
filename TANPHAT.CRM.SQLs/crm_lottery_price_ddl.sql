-- ================================
-- Author: Phi
-- Description: Lấy ĐĐL loại vé số để tính tiền
-- Created date: 14/03/2022
-- SELECT * FROM crm_lottery_price_ddl();
-- ================================
SELECT dropallfunction_byname('crm_lottery_price_ddl');
CREATE OR REPLACE FUNCTION crm_lottery_price_ddl()
RETURNS TABLE
(
	"LotteryPriceId" INT,
	"LotteryPriceName" VARCHAR,
	"Price" NUMERIC,
	"Value" FLOAT4,
	"Step" INT
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		LP."LotteryPriceId",
		LP."LotteryPriceName",
		LP."Price",
		LP."Value",
		LP."Step"
	FROM "LotteryPrice" LP
	ORDER BY LP."LotteryPriceId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE