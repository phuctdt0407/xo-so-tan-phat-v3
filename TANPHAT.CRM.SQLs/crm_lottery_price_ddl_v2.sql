-- ================================
-- Author: Phi
-- Description: Lấy ĐĐL loại vé số để tính tiền
-- Edited date: 29/03/2022
-- SELECT * FROM crm_lottery_price_ddl_v2(0);
-- ================================
SELECT dropallfunction_byname('crm_lottery_price_ddl_v2');
CREATE OR REPLACE FUNCTION crm_lottery_price_ddl_v2(
	p_lottery_type_id INT
)
RETURNS TABLE
(
	"LotteryPriceId" INT,
	"LotteryPriceName" VARCHAR,
	"Price" NUMERIC,
	"Value" FLOAT4,
	"Step" INT,
	"LotteryTypeIds" VARCHAR
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		LP."LotteryPriceId",
		LP."LotteryPriceName",
		LP."Price",
		LP."Value",
		LP."Step",
		LP."LotteryTypeIds"::VARCHAR
	FROM "LotteryPrice" LP
	WHERE COALESCE(p_lottery_type_id, 0) = 0 OR p_lottery_type_id = ANY(LP."LotteryTypeIds")
	ORDER BY LP."LotteryPriceId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE