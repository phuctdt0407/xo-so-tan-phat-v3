-- ================================
-- Author: Hieu
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_shift_of_all_user_in_month_v3('2023-04');	
-- api này còn phải qua tầng business xử lý nha. 
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_shift_of_all_user_in_month_v3');
CREATE OR REPLACE FUNCTION crm_report_get_total_shift_of_all_user_in_month_v3
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	--"ShiftTypeId" INT,
	--"ShiftTypeName" VARCHAR,
	"SalePointId" INT,
	"Quantity" INT8,
	"Sum" INT8,
	"MainSalePointId" INT4
)
AS $BODY$
DECLARE
	v_event INT :=(SELECT 
			COUNT(E."Date") 
		FROM "EventDay" E
		WHERE TO_CHAR(E."Date", 'YYYY-MM') = p_month
			AND E."IsDeleted" IS FALSE AND E."Date"::DATE<= NOW()::DATE);
BEGIN
	raise notice 'v_event: %',v_event;
	RETURN QUERY
	WITH tmpSDD AS (
		SELECT 
			SD."UserId", 
			SD."ShiftTypeId",
			ST."ShiftTypeName",
			SD."SalePointId",
			COUNT(SD."ShiftTypeId") AS "Quantity"
		FROM "ShiftDistribute" SD 
		JOIN "ShiftType" ST ON SD."ShiftTypeId" = ST."ShiftTypeId"
		WHERE SD."IsActive" IS TRUE 
		AND
			CASE WHEN TO_CHAR(NOW(),'YYYY-MM') = p_month
				THEN
					TO_CHAR(SD."DistributeDate",'YYYY-MM-DD') <= TO_CHAR(NOW(),'YYYY-MM-DD')
					AND TO_CHAR(SD."DistributeDate",'YYYY-MM') = TO_CHAR(NOW(),'YYYY-MM')
				ELSE
					TO_CHAR(SD."DistributeDate",'YYYY-MM') = p_month 
				END 
		GROUP BY SD."UserId", SD."ShiftTypeId", ST."ShiftTypeName",
			SD."SalePointId"),
		tmp2 AS(
			SELECT COUNT(1) AS "DaysInAMonth"
			FROM   generate_series(date ('2023-03'||'-01')::DATE, (date_trunc('month', ('2023-03'||'-10')::date) + interval '1 month' - interval '1 day')::date, '1 day') day
		),tmp3 AS
		(
			SELECT 
				U."UserId",
				U."FullName",
				SDD."ShiftTypeId",
				SDD."ShiftTypeName",
				SDD."SalePointId",
				COALESCE(SDD."Quantity",0) AS "Quantity"
			FROM "User" U JOIN tmpSDD SDD ON U."UserId" = SDD."UserId"
			ORDER BY U."UserId"
		),
		tmp4 AS
		(
			SELECT 
				T3."UserId",
				SUM(T3."Quantity") AS "Sum",
				U."SalePointId"
			FROM tmp3 T3 
			LEFT JOIN "User" U ON U."UserId" = T3."UserId"
			GROUP BY T3."UserId",U."SalePointId"
		)
				SELECT 
					T3."UserId",
					T3."FullName",
					--T3."ShiftTypeId",
					--T3."ShiftTypeName",
					T3."SalePointId",
					SUM(COALESCE(T3."Quantity"+ v_event,v_event))::INT8 AS "Quantity",
					(T4."Sum"+v_event)::INT8,
					T4."SalePointId" AS "MainSalePointId"
				FROM tmp3 T3 
				LEFT JOIN tmp4 T4 ON T3."UserId" = T4."UserId"
				WHERE T4."SalePointId" IS NOT NULL
				GROUP BY 
					T3."UserId",
					T3."FullName",
					T3."SalePointId",
					T4."Sum",
					T4."SalePointId"
				ORDER BY 
					T3."UserId",
					T3."SalePointId";


END;
$BODY$
LANGUAGE plpgsql VOLATILE