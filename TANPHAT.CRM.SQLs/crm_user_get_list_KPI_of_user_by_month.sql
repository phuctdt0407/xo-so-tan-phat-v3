-- ================================
-- Author: Hieu
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_list_KPI_of_user_by_month('2023-04', 16);
-- ================================
SELECT dropallfunction_byname('crm_user_get_list_KPI_of_user_by_month');
CREATE OR REPLACE FUNCTION crm_user_get_list_KPI_of_user_by_month
(
	p_month VARCHAR,
	p_user_id INT DEFAULT 0
)
RETURNS TABLE
(
	"KPILogId" INT,
	"UserId" INT,
	"FullName" VARCHAR,
	"UserTitleId" INT,
	"WeekId" INT,
	"CriteriaId" INT,
	"CriteriaName" VARCHAR,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"KPI" NUMERIC,
	"CreatedDate" TIMESTAMP
)
AS $BODY$
BEGIN
	RETURN QUERY
-- 	WITH tmp AS (
-- 		SELECT 
-- 			ROW_NUMBER() OVER(PARTITION BY K."UserId" ORDER BY K."CreatedDate" DESC) AS "Id",
-- 			K."KPILogId",
-- 			K."UserId",
-- 			K."KPI",
-- 			K."CreatedDate"
-- 		FROM "KPILog" K
-- 		WHERE K."IsDeleted" IS FALSE
-- 			AND TO_CHAR(K."CreatedDate", 'YYYY-MM') = p_month
-- 	),
-- 	tmp2 AS (
-- 		SELECT 
-- 			U."UserId",
-- 			U."FullName",
-- 			U."TypeUserId"
-- 		FROM "User" U 
-- 			JOIN "UserRole" UR ON U."UserId" = UR."UserId"
-- 		WHERE U."IsDeleted" IS FALSE	
-- 			AND U."IsActive" IS TRUE
-- 			AND UR."UserTitleId" IN (5)
-- 	)
-- 	SELECT 
-- 		U."UserId",
-- 		U."FullName",
-- 		S."KPILogId",
-- 		S."KPI",
-- 		S."CreatedDate"
-- 	FROM tmp2 U
-- 		LEFT JOIN tmp S ON U."UserId" = S."UserId" AND S."Id" = 1
-- 	WHERE (COALESCE(p_user_id, 0) = 0 OR p_user_id = U."UserId")
-- 	ORDER BY
-- 		U."TypeUserId",
-- 		U."UserId";
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
			K."SalePointId",
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
	)
	SELECT 
		K."KPILogId",
		K."UserId",
		K."FullName",
		K."UserTitleId",
		K."WeekId",
		K."CriteriaId",
		K."CriteriaName",
		K."SalePointId",
		(SELECT S."SalePointName" FROM "SalePoint" S WHERE S."SalePointId" = K."SalePointId"),
		K."KPI",
		K."CreatedDate"
	FROM tmp K
	WHERE K."Id" = 1
		AND (COALESCE(p_user_id, 0) = 0 OR p_user_id = K."UserId")
	ORDER BY 
		K."TypeUserId",
		K."UserId",	
		K."CriteriaId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE