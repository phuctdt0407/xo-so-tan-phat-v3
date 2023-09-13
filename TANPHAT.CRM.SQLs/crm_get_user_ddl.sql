-- ================================
-- Author: Phi
-- Description: User manage
-- Created date: 03/03/2022
-- SELECT * FROM crm_get_user_ddl(0, '2023-02-23');
-- ================================
SELECT dropallfunction_byname('crm_get_user_ddl');
CREATE OR REPLACE FUNCTION crm_get_user_ddl
(
	p_usertitle_id INT,
	p_date TIMESTAMP DEFAULT NOW()
)
RETURNS TABLE
(
	"UserId" INT,
	"Account" VARCHAR,
	"Phone" VARCHAR,
	"FullName" VARCHAR,
	"Email" VARCHAR,
	"IsActive" BOOL,
	"IsDeleted" BOOL,
	"StartDate" DATE,
	"EndDate" DATE,
	"UserTitleId" INT,
	"UserTitleName" VARCHAR,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ListSalePoint" TEXT
)
AS $BODY$ 
BEGIN
	
	RETURN QUERY 
	SELECT 
		U."UserId",
		U."Account",
		U."Phone",
		U."FullName",
		U."Email",
		U."IsActive",
		U."IsDeleted",
		U."StartDate",
		U."EndDate",
		UT."UserTitleId",
		UT."UserTitleName",
		U."SalePointId",
		(SELECT
				S."SalePointName"
			FROM "SalePoint" S 
			LEFT JOIN "User" U1 ON S."SalePointId" = U1."SalePointId"
			WHERE U1."UserId" = U."UserId") AS "SalePointName",
		(CASE WHEN UT."UserTitleId" <> 4 THEN NULL::TEXT 
					ELSE (SELECT JSON_AGG(json_build_object('SalePointId', A."SalePointId", 'SalePointName', A."SalePointName"))::TEXT FROM crm_get_list_salepoint_of_leader(U."UserId", p_date, 0, TO_CHAR(p_date, 'YYYY-MM')) A)::TEXT END) AS "SalePointId"
	FROM "User" U
		JOIN "UserRole" UR ON UR."UserId" = U."UserId"
		JOIN "UserTitle" UT ON UT."UserTitleId" = UR."UserTitleId"
	WHERE (COALESCE(p_usertitle_id, 0) = 0 OR UT."UserTitleId" = p_usertitle_id)
		AND UT."UserTitleId" <> 1
		AND (U."IsActive" IS TRUE OR (U."IsActive" IS FALSE AND U."EndDate" >= p_date))
		AND U."IsActive" IS TRUE
	ORDER BY 
		UT."UserTitleId" DESC,
		U."UserId",
		U."SalePointId" ASC;	
END;
$BODY$
LANGUAGE plpgsql VOLATILE