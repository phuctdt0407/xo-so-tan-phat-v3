-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM fn_total_commision_user(2,'2023-01',10000);
-- ================================
SELECT dropallfunction_byname('fn_total_commision_user');
CREATE OR REPLACE FUNCTION fn_total_commision_user
(
	p_sale_point_id INT,
	p_month varchar,
	p_total_commision NUMERIC 
)
RETURNS TABLE
(
		"FullName" VARCHAR,
		"Percent" NUMERIC,
		"TotalCommisionUser" NUMERIC
)
AS $BODY$
DECLARE 
	v_temp_main_user_data JSON;
BEGIN
		v_temp_main_user_data:= (SELECT 
																T."MainUserData"
															FROM crm_salepoint_get_percent(p_month) T
															WHERE T."SalePointId" = p_sale_point_id)::JSON;
	RETURN QUERY
	WITH tmp AS
	(
		select 
		* 
		from json_to_recordset(v_temp_main_user_data) as x("UserId" int, "FullName" text, "Percent" NUMERIC)
		 
	)
	SELECT 
		T."FullName"::VARCHAR,
		T."Percent",
		 ROUND(T."Percent"::NUMERIC * p_total_commision,2) AS "TotalCommisionUser"
	FROM tmp T ;

END;
$BODY$
LANGUAGE plpgsql VOLATILE













