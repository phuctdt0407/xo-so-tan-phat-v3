-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_list_target();
-- ================================
SELECT dropallfunction_byname('crm_user_get_list_target');
CREATE OR REPLACE FUNCTION crm_user_get_list_target
(
)
RETURNS TABLE
(
	"ResponsibilityLottery" TEXT,
	"TargetVietlott" TEXT,
	"TargetLottery" TEXT,
	"TargetKPI" TEXT,
	"TargetKPILeader" TEXT
)
AS $BODY$
BEGIN
	RETURN QUERY
	WITH tmp AS(
		SELECT 
			TD."TargetDataTypeId",
			TD."FromValue" AS "minTarget",
			TD."ToValue" AS "maxTarget",
			TD."Value" AS "commission"
		FROM "TargetData" TD
		WHERE TD."IsDeleted" IS FALSE
	),
	tmp2 AS (
		SELECT ARRAY_TO_JSON(ARRAY_AGG(R))::TEXT AS "ResponsibilityLottery"
		FROM (
			SELECT
				T."minTarget",
				T."maxTarget",
				T."commission"
			FROM tmp T
			WHERE T."TargetDataTypeId" = 1
			ORDER BY T."minTarget"
		) R
	),
	tmp3 AS (
		SELECT ARRAY_TO_JSON(ARRAY_AGG(R))::TEXT AS "TargetVietlott"
		FROM (
			SELECT
				T."minTarget",
				T."maxTarget",
				T."commission"
			FROM tmp T
			WHERE T."TargetDataTypeId" = 2
			ORDER BY T."minTarget"
		) R
	),
	tmp4 AS (
		SELECT ARRAY_TO_JSON(ARRAY_AGG(R))::TEXT AS "TargetLottery"
		FROM (
			SELECT
				T."minTarget",
				T."maxTarget",
				T."commission"
			FROM tmp T
			WHERE T."TargetDataTypeId" = 3
			ORDER BY T."minTarget"
		) R
	),
	tmp5 AS (
		SELECT ARRAY_TO_JSON(ARRAY_AGG(R))::TEXT AS "TargetKPI"
		FROM (
			SELECT
				T."minTarget",
				T."maxTarget",
				T."commission"
			FROM tmp T
			WHERE T."TargetDataTypeId" = 4
			ORDER BY T."minTarget"
		) R
	),
	tmp6 AS (
		SELECT ARRAY_TO_JSON(ARRAY_AGG(R))::TEXT AS "TargetKPILeader"
		FROM (
			SELECT
				T."minTarget",
				T."maxTarget",
				T."commission"
			FROM tmp T
			WHERE T."TargetDataTypeId" = 5
			ORDER BY T."minTarget"
		) R
	)
	SELECT
		tmp2."ResponsibilityLottery",
		tmp3."TargetVietlott",
		tmp4."TargetLottery",
		tmp5."TargetKPI",
		tmp6."TargetKPILeader"
	FROM tmp2, tmp3, tmp4, tmp5, tmp6;
END;
$BODY$
LANGUAGE plpgsql VOLATILE