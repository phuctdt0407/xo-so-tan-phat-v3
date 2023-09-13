-- ================================
-- Author: Hieu
-- Description:
-- Created date:
-- SELECT * FROM fn_user_KPI_of_user_by_month('2023-01', 3);
-- ================================
SELECT dropallfunction_byname('fn_user_KPI_of_user_by_month');
CREATE OR REPLACE FUNCTION fn_user_KPI_of_user_by_month
(
	p_month VARCHAR,
	p_user_id INT 
)
RETURNS NUMERIC
AS $BODY$
DECLARE 
	v_Total_KPI NUMERIC;
BEGIN

	WITH tmp AS (
		SELECT 
			ROW_NUMBER() OVER(PARTITION BY K."UserId", K."WeekId", K."SalePointId", K."CriteriaId" ORDER BY K."CreatedDate" DESC) AS "Id",
			K."KPILogId",
			K."UserId",
			U."FullName",
			UR."UserTitleId",
			K."WeekId",
			K."CriteriaId",
			C."CriteriaName",
			U."SalePointId",
			SP."SalePointName",
			K."KPI",
			K."CreatedDate",
			U."TypeUserId"
		FROM "KPILog" K	
			JOIN "Criteria" C ON K."CriteriaId" = C."CriteriaId"
			JOIN "User" U ON K."UserId" = U."UserId"
			JOIN "UserRole" UR ON U."UserId" = UR."UserId"
			LEFT JOIN "SalePoint" SP ON SP."SalePointId" = K."SalePointId"
		WHERE K."IsDeleted" IS FALSE	
			AND K."Month" = p_month
	), tmp1 AS
	(
			SELECT 
				K."UserId",
				K."WeekId",
				SUM(COALESCE( K."KPI",0)) AS "TotalKpiInweek"
			FROM tmp K
			WHERE K."Id" = 1
				AND p_user_id = K."UserId" 
			GROUP BY K."WeekId",K."UserId"
	)
	SELECT 
		ROUND(SUM(T1."TotalKpiInweek")/ COUNT(T1."WeekId") ,2) INTO v_Total_KPI
	FROM tmp1 T1
	WHERE T1."TotalKpiInweek" > 0
	GROUP BY T1."UserId"::NUMERIC;
	RETURN ROUND( COALESCE(v_Total_KPI,0),2);
END;
$BODY$
LANGUAGE plpgsql VOLATILE