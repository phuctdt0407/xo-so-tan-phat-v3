-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_target_master();
-- ================================
SELECT dropallfunction_byname('crm_user_get_target_master');
CREATE OR REPLACE FUNCTION crm_user_get_target_master
(
	p_user_title_id INT DEFAULT 0
)
RETURNS TABLE
(
	"TargetMasterLevelData" TEXT,
	"TargetMasterLevel" TEXT,
	"TargetKPI" TEXT,
	"TargetKPILeader" TEXT
)
AS $BODY$

BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT 
			C."CriteriaId",
			C."CriteriaName",
			C."UserTitleId"
		FROM "Criteria" C
		WHERE (C."UserTitleId" = p_user_title_id OR p_user_title_id = 0)
		ORDER BY
			C."UserTitleId",
			C."CriteriaId"
	),
	tmp2 AS (
		SELECT
			T."CriteriaId",
			T."UserTitleId",
			array_to_json(
				array_agg(
					TO_JSONB(TM.*)
				)	
			) AS "TargetMaster"
		FROM tmp T
			JOIN "TargetMaster" TM ON T."CriteriaId" = TM."CriteriaId"
		GROUP BY 
			T."CriteriaId",
			T."UserTitleId"
	),
	tmp3 AS (
		SELECT DISTINCT 
			TM."LevelId", 
			T."UserTitleId",
			TM."TargetMasterName"
		FROM tmp T
			JOIN "TargetMaster" TM ON T."CriteriaId" = TM."CriteriaId"
		ORDER BY 
			TM."LevelId"
	),
	tmp4 AS (
		SELECT
			array_to_json(array_agg(R))::TEXT AS "TargetMasterLevelData"
		FROM (
			SELECT T.* 
			FROM tmp2 T
			ORDER BY 
				T."UserTitleId",
				T."CriteriaId"
		) R
	),
	tmp5 AS (
		SELECT
			array_to_json(array_agg(R))::TEXT AS "TargetMasterLevel"
		FROM (
			SELECT * FROM tmp3
		) R 
	),
	tmp6 AS (
		SELECT 
			T."TargetKPI",
			T."TargetKPILeader"
		FROM crm_user_get_list_target() T
	)
	SELECT 
		tmp4."TargetMasterLevelData",
		tmp5."TargetMasterLevel",
		tmp6."TargetKPI",
		tmp6."TargetKPILeader"
	FROM tmp4
		JOIN tmp5 ON TRUE
		JOIN tmp6 ON TRUE;	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

