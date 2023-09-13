-- ================================
-- Author: Phi
-- Description: User manage
-- Created date: 03/03/2022
-- SELECT * FROM crm_user_get_list(100,1,0);
-- ================================
SELECT dropallfunction_byname('crm_user_get_list');
CREATE OR REPLACE FUNCTION crm_user_get_list
(
	p_page_size INT, 
	p_page_number INT,
	p_usertitle_id INT
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"TotalCount" INT8,
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
	"BasicSalary" INT8,
	"Address" VARCHAR,
	"BankAccount" VARCHAR,
	"NumberIdentity" VARCHAR,
	"IsIntern" BOOL
)
AS $BODY$
DECLARE 
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN
	
	RETURN QUERY 
	WITH tmp AS(
		SELECT
			ROW_NUMBER() OVER(PARTITION BY BS."UserId" ORDER BY BS."CreatedDate" DESC) AS "Id",
			BS."UserId",
			BS."Salary"
		FROM "BasicSalary" BS
	),
	tmp2 AS (
		SELECT * 
		FROM tmp 
		WHERE tmp."Id" = 1
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY U."UserId") "RowNumber",
		COUNT(1) OVER() AS "TotalCount",
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
		COALESCE(T."Salary", 0) AS "BasicSalary",
		U."Address",
		U."BankAccount",
		U."NumberIdentity",
		U."IsIntern"
	FROM "User" U
		JOIN "UserRole" UR ON UR."UserId" = U."UserId"
		JOIN "UserTitle" UT ON UT."UserTitleId" = UR."UserTitleId"
		LEFT JOIN tmp2 T ON T."UserId" = U."UserId"
	WHERE (COALESCE(p_usertitle_id, 0) = 0 OR UT."UserTitleId" = p_usertitle_id)
		AND UT."UserTitleId" <> 1
-- 		AND U."IsActive" IS TRUE
-- 		AND U."IsIntern" IS FALSE
	ORDER BY 
		U."IsActive" DESC,
		UR."UserTitleId",
		U."SalePointId",
		U."UserId"
	OFFSET v_offset_row LIMIT 100000;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE