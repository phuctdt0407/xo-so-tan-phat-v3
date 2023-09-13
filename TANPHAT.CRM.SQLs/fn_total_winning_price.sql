-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM fn_total_winning_price('2023-01',6,1);
-- ================================
SELECT dropallfunction_byname('fn_total_winning_price');
CREATE OR REPLACE FUNCTION fn_total_winning_price
(
		p_month VARCHAR,
		p_winning_type_id INT,
		p_sale_point_id INT8
)
RETURNS INT8
AS $BODY$
DECLARE
	v_total_winning_price INT;
BEGIN

	v_total_winning_price := (SELECT 
															SUM(W."WinningPrice") 
														FROM "Winning" W
														WHERE W."WinningTypeId" = p_winning_type_id AND W."SalePointId" = p_sale_point_id 
														AND to_char(W."ActionDate", 'YYYY-MM')  = p_month
														GROUP BY W."SalePointId");
	RETURN COALESCE(v_total_winning_price,0);		
														
END;
$BODY$
LANGUAGE plpgsql VOLATILE
