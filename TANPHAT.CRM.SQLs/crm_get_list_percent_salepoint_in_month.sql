-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_list_percent_salepoint_in_month('2023-0');
-- ================================
SELECT dropallfunction_byname('crm_get_list_percent_salepoint_in_month');
CREATE OR REPLACE FUNCTION crm_get_list_percent_salepoint_in_month
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"SalePointId" INT,
	"MainUserId" INT[],
	"PercentMainUserId" NUMERIC[]
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
		SPL."SalePointId",
		SPL."MainUserId",
		SPL."PercentMainUserId"
	FROM "SalePointPercentLog" SPL 
	WHERE SPL."ActionDate"::DATE <= (date_trunc('month', (p_month||'-01')::DATE) + INTERVAL '1 month - 1 day')::DATE
		AND SPL."ActionDate" >= ALL(
			SELECT
				T."ActionDate"
			FROM "SalePointPercentLog" T
			WHERE T."ActionDate"::DATE <= (date_trunc('month', (p_month||'-01')::DATE) + INTERVAL '1 month - 1 day')::DATE
				AND T."SalePointId" = SPL."SalePointId"
		);
END;
$BODY$
LANGUAGE plpgsql VOLATILE

