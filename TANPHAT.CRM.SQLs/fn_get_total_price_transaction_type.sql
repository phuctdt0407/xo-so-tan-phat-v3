-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM fn_get_total_price_transaction_type('2023-01', 9, 1);
-- ================================
SELECT dropallfunction_byname('fn_get_total_price_transaction_type');
CREATE OR REPLACE FUNCTION fn_get_total_price_transaction_type
(
		p_month VARCHAR,
		p_transaction_type_id INT,
		p_sale_point_id INT
)
RETURNS INT
AS $BODY$
DECLARE
	v_total_price_transaction INT8;
BEGIN
	v_total_price_transaction := (SELECT 
																	SUM(T."TotalPrice")
																FROM "Transaction" T 
																WHERE T."TransactionTypeId" = p_transaction_type_id
																AND T."SalePointId" = p_sale_point_id
																AND TO_CHAR(T."Date",'YYYY-MM') = p_month);
	RETURN COALESCE(	v_total_price_transaction,0);
	
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
