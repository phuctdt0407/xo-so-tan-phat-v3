-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_leader_attendent();
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_leader_attendent');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_leader_attendent
(
	p_date TIMESTAMP DEFAULT NOW()
)
RETURNS TABLE
(
	"GroupSalePointData" TEXT,
	"LeaderAttendentData" TEXT
)
AS $BODY$
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT 
			LA."CreatedDate",
			(SELECT json_agg(value order by (value->>'UserId')::INT)
			FROM json_array_elements(json_agg(json_build_object('UserId', LA."UserId", 'FullName', U."FullName", 'TriggerSalePoint', LA."TriggerSalePoint")::JSON)))::TEXT AS "ListLeader"
		FROM "LeaderAttendent" LA 
			JOIN "User" U ON LA."UserId" = U."UserId"
		GROUP BY 
			LA."CreatedDate"
		HAVING LA."CreatedDate" >= ALL(
			SELECT 
				LAA."CreatedDate"
			FROM "LeaderAttendent" LAA
			GROUP BY LAA."CreatedDate"
		)
	),
	tmp1 AS (
		SELECT 
			ROW_NUMBER() OVER(PARTITION BY GS."Option" ORDER BY GS."CreatedDate" DESC) AS "Id",
			GS.*
		FROM "GroupSalePoint" GS
		WHERE GS."Option" <= json_array_length((SELECT T."ListLeader" FROM tmp T LIMIT 1)::JSON)
			AND GS."CreatedDate"::DATE <= NOW()::DATE
	),
	tmp2 AS (
		SELECT 
			T."GroupSalePointId",
			T."UserId",
			U."FullName",
-- 			(
-- 					SELECT 
-- 						array_to_json(array_agg(
-- 								(
-- 									'{"SalePointId": ' 
-- 									|| "SPId"
-- 									||',"SalePointName": "'
-- 									||(SELECT SP."SalePointName" FROM "SalePoint" SP WHERE SP."SalePointId" = "SPId")::TEXT
-- 									||'"}'
-- 								)::JSONB
-- 							)
-- 						)::TEXT
-- 					FROM UNNEST(T."SalePointIds") AS "SPId"
-- 			)::TEXT AS "SalePointIds",
			TRANSLATE(T."SalePointIds"::TEXT, '{}', '[]') AS "SalePointIds",
			T."Option"
		FROM tmp1 T
			JOIN "User" U ON T."UserId" = U."UserId"
		WHERE T."Id" = ANY(SELECT generate_series(0, json_array_length((SELECT T."ListLeader" FROM tmp T LIMIT 1)::JSON))) 
		ORDER BY 
			T."Option",
			T."UserId"
	),
	tmp3 AS (
		SELECT 
			array_to_json(array_agg(T.*))::TEXT AS "GroupSalePointData"
		FROM tmp2 T
	),
	tmp4 AS (
		SELECT 
			T."ListLeader"::TEXT AS "LeaderAttendentData"
		FROM tmp T
	)
	SELECT 
		tmp3."GroupSalePointData",
		tmp4."LeaderAttendentData"
	FROM tmp3 JOIN tmp4 ON TRUE;
END;
$BODY$
LANGUAGE plpgsql VOLATILE


