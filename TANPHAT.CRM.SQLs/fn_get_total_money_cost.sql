-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM fn_get_total_money_cost('2022-12',2);
-- ================================
SELECT dropallfunction_byname('fn_get_total_money_cost');
CREATE OR REPLACE FUNCTION fn_get_total_money_cost
(
	  p_month VARCHAR,
		p_sale_point_id INT
)
RETURNS INT
AS $BODY$
DECLARE
	v_total_price INT;
	v_list_TransitionTypeId INT[] := ARRAY[1, 5, 6, 7];
BEGIN
	v_total_price:= (SELECT 
		SUM(T."TotalPrice")
	FROM "Transaction" T 
	WHERE to_char(T."ActionDate", 'YYYY-MM') = p_month
	AND T."TransactionTypeId" = ANY (v_list_TransitionTypeId)
	AND T."SalePointId" = p_sale_point_id
	GROUP BY to_char(T."ActionDate", 'YYYY-MM'));
	RETURN COALESCE(v_total_price, 0);
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
