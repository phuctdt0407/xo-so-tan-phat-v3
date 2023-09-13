-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_list_salepoint_of_leader(0);
-- ================================
SELECT dropallfunction_byname('crm_get_list_salepoint_of_leader');
CREATE OR REPLACE FUNCTION crm_get_list_salepoint_of_leader
(
	p_user_id INT DEFAULT 0,
	p_date TIMESTAMP DEFAULT NOW(),
	p_option INT DEFAULT NULL,
	p_month VARCHAR DEFAULT NULL
)
RETURNS TABLE
(
	"UserId" INT,
	"SalePointId" INT,
	"SalePointName" VARCHAR
)
AS $BODY$
DECLARE
	v_user INT;
	v_trigger INT;
BEGIN
	IF p_month IS NOT NULL THEN
		RETURN QUERY 
		WITH tmp AS (
			SELECT 
				GS."UserId",
				UNNEST(GS."SalePointIds") AS "SalePointId"
			FROM "GroupSalePoint" GS
			WHERE (GS."UserId" = p_user_id OR p_user_id = 0)
				AND GS."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
				AND GS."Option" = 0
				AND GS."CreatedDate" >= ALL(	
					SELECT
						C."CreatedDate"
					FROM "GroupSalePoint" C 
					WHERE C."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
						AND C."UserId" = GS."UserId"
						AND C."Option" = 0
				)
		)
		SELECT 
			G."UserId",
			G."SalePointId",
			SP."SalePointName"
		FROM tmp G 
			JOIN "SalePoint" SP ON SP."SalePointId" = G."SalePointId"
		ORDER BY 
			G."UserId",
			G."SalePointId"; 
		
	ELSE 
	
		SELECT 
			COALESCE(LOF."UserId", 0) INTO v_user
		FROM "LeaderOffLog" LOF 
		WHERE LOF."WorkingDate"::DATE = p_date::DATE
			AND LOF."IsDeleted" IS FALSE;
		
		SELECT 
			LAA."TriggerSalePoint" INTO v_trigger
		FROM "LeaderAttendent" LAA 
		WHERE LAA."CreatedDate"::DATE <= p_date::DATE
			AND LAA."UserId" = v_user
			AND LAA."CreatedDate" >= ALL(
					SELECT 					
						LA."CreatedDate"
					FROM "LeaderAttendent" LA
					WHERE LA."CreatedDate"::DATE <= p_date::DATE
						AND LA."TriggerSalePoint" = LAA."TriggerSalePoint"
			);
		raise notice 'v_trigger: %', v_trigger;
		RETURN QUERY
		WITH tmp AS (
			SELECT 
				GS."UserId",
				UNNEST(GS."SalePointIds") AS "SalePointId"
			FROM "GroupSalePoint" GS
			WHERE (GS."UserId" = p_user_id OR p_user_id = 0)
				AND GS."Option" = COALESCE(p_option, v_trigger, 0)
				AND GS."CreatedDate"::DATE <= p_date::DATE
				AND GS."CreatedDate" >= ALL(
					SELECT 
						GSS."CreatedDate"
					FROM "GroupSalePoint" GSS
					WHERE GSS."CreatedDate"::DATE <= p_date::DATE
						AND GSS."Option" = GS."Option"
				)
		)
		SELECT 
			G."UserId",
			G."SalePointId",
			SP."SalePointName"
		FROM tmp G 
			JOIN "SalePoint" SP ON SP."SalePointId" = G."SalePointId"
		ORDER BY 
			G."UserId",
			G."SalePointId";
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

