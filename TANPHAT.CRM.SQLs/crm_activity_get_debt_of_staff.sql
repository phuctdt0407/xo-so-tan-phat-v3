-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_get_debt_of_staff(5);
-- ================================
SELECT dropallfunction_byname('crm_activity_get_debt_of_staff');
CREATE OR REPLACE FUNCTION crm_activity_get_debt_of_staff
(
	p_user_title_id INT
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	"TotalDebt" DECIMAL,
	"PayedDebt" DECIMAL,
	"UserTitleId" INT,
	"SalePointId" INT,
	"SalePointName" VARCHAR
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	with tmp AS(
		SELECT D."UserId", SUM(D."TotalDebt") AS "TotalDebt"  FROM "Debt" D 
		WHERE D."IsAdded" IS TRUE
		GROUP BY D."UserId"
	),tmp2 AS(
		SELECT D."UserId", D."PayedDebt" AS "PayedDebt"  FROM "Debt" D 
		GROUP BY D."UserId", D."PayedDebt", D."DebtId"
		ORDER BY D."DebtId" DESC LIMIT 1	
	)
	SELECT
		U."UserId",
		U."FullName",
		T."TotalDebt" :: DECIMAL,
		T2."PayedDebt" :: DECIMAL,
		UR."UserTitleId",
		U."SalePointId",
		S."SalePointName"
	FROM "User" U 
		LEFT JOIN tmp T ON T."UserId" = U."UserId"
		LEFT JOIN tmp2 T2 ON T2."UserId" = U."UserId"
		LEFT JOIN "UserRole" UR ON UR."UserId" = U."UserId"
		LEFT JOIN "SalePoint" S ON S."SalePointId" = U."SalePointId"
	WHERE UR."UserTitleId" = p_user_title_id;
END;
$BODY$
LANGUAGE plpgsql VOLATILE