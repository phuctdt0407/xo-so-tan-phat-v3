-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_average_KPI_of_user_by_month('2022-06', 0);
-- ================================
SELECT dropallfunction_byname('crm_user_get_average_KPI_of_user_by_month'); 
CREATE OR REPLACE FUNCTION crm_user_get_average_KPI_of_user_by_month
(
	p_month VARCHAR,
	p_user_id INT DEFAULT 0
)
RETURNS TABLE
(
	"UserId" INT,
	"SalePointId" INT,
	"KPI" NUMERIC,
	"TotalWeek" INT8,
	"AverageKPI" NUMERIC,
	"DataWeek" TEXT
)
AS $BODY$
DECLARE
	v_month DATE := (p_month||'-01')::DATE;
	v_total_month INT := (SELECT 
		date_part('week', date_trunc('month', v_month) + INTERVAL '1 month' - INTERVAL '1 day')
		- date_part('week', date_trunc('month', v_month))
		+1)::INT;
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT 
			ROW_NUMBER() OVER(PARTITION BY K."UserId", K."WeekId", K."SalePointId", K."CriteriaId" ORDER BY K."CreatedDate" DESC) AS "Id",
			K."UserId",
			K."WeekId",
			K."CriteriaId",
			K."SalePointId",
			(K."KPI" * C."Coef") AS "KPI"
		FROM "KPILog" K	
			JOIN "Criteria" C ON K."CriteriaId" = C."CriteriaId"
		WHERE K."IsDeleted" IS FALSE	
			AND K."Month" = p_month
	),
	tmp2 AS (
		SELECT 
			K."UserId",
			K."WeekId",
			K."CriteriaId",
			K."SalePointId",
			K."KPI"
		FROM tmp K
		WHERE K."Id" = 1
			AND (COALESCE(p_user_id, 0) = 0 OR p_user_id = K."UserId")
	),
	tmp3 AS (
		SELECT
			K."UserId",
			K."WeekId",
			K."SalePointId",
			SUM(K."KPI") AS "KPI"
		FROM tmp2 K
		GROUP BY 
			K."UserId",
			K."WeekId",
			K."SalePointId"
	)
	SELECT 
		T."UserId",
		T."SalePointId",
		SUM(T."KPI") AS "KPI",
		COUNT(T."WeekId") AS "TotalWeek",
		ROUND(SUM(T."KPI")::NUMERIC/ v_total_month, 2) AS "AverageKPI",
		(
			SELECT ARRAY_TO_JSON(ARRAY_AGG(R))
			FROM (
				SELECT 
					K.*
				FROM tmp3 K
				WHERE K."UserId" = T."UserId"
					AND K."SalePointId" = T."SalePointId"
			) R
		)::TEXT AS "DataWeek" 
	FROM tmp3 T
	GROUP BY 
		T."UserId",
		T."SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE