-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_temp();
-- ================================
-- SELECT dropallfunction_byname('crm_temp');
CREATE OR REPLACE FUNCTION crm_temp
(
	p_sale_point_id INT,
	p_month varchar,
	-- something
)
RETURNS TABLE
(
		
)
AS $BODY$

BEGIN
	RETURN QUERY
	WITH tmp AS(SELECT F."SalePointId",F."Date",SUM(F."Commission")
	FROM crm_salepoint_get_commision_of_all_user_in_month_v2(p_month) F
	WHERE TO_CHAR(F."Date",'YYYY-MM') = p_month
	AND p_sale_point_id = F."SalePointId"
	GROUP BY F."SalePointId",F."Date"
	)
	SELECT U."FullName", FROM "SalePointPercentLog" SPL LEFT JOIN "User" U ON U."UserId" = ANY (SPL."MainUserId") WHERE 
END;
$BODY$
LANGUAGE plpgsql VOLATILE