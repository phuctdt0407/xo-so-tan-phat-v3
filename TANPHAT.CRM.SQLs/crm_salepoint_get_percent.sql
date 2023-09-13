-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_percent('2023-01');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_percent');
CREATE OR REPLACE FUNCTION crm_salepoint_get_percent
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"MainUserData" TEXT
)
AS $BODY$
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT
			SP."SalePointId",
			SP."SalePointName"
		FROM "SalePoint" SP 
		WHERE SP."IsDeleted" IS FALSE
			AND SP."IsActive" IS TRUE
	),
	tmp1 AS (
		SELECT 	
			T."SalePointId",
			T."MainUserId",
			T."PercentMainUserId"
		FROM crm_get_list_percent_salepoint_in_month(p_month) T
	)
	SELECT
		SP."SalePointId",
		SP."SalePointName",
		--TRANSLATE(COALESCE(S."MainUserId", '{}'::INT[])::TEXT, '{}', '[]') AS "MainUserId",
		COALESCE((
			SELECT 
				array_to_json(array_agg(json_build_object(
					'UserId',
					I,
					'FullName',
					(SELECT U."FullName" FROM "User" U WHERE U."UserId" = I)::VARCHAR,
					'Percent',
					(S."PercentMainUserId"[array_position(S."MainUserId"::TEXT[], I::TEXT)])::NUMERIC		
				)))
			FROM UNNEST(S."MainUserId") I
		)::TEXT, '[]') AS "MainUserId"
		--TRANSLATE(COALESCE(S."PercentMainUserId", '{}'::NUMERIC[])::TEXT, '{}', '[]') AS "PercentMainUserId"
	FROM tmp SP
		LEFT JOIN tmp1 S ON SP."SalePointId" = S."SalePointId" 
	ORDER BY SP."SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

