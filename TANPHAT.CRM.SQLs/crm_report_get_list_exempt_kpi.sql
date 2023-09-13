-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_list_exempt_kpi('2023-01');
-- ================================
SELECT dropallfunction_byname('crm_report_get_list_exempt_kpi');
CREATE OR REPLACE FUNCTION crm_report_get_list_exempt_kpi
(
		p_month VARCHAR
)
RETURNS TABLE
(
		"ExemptKpiId" INT8,
		"UserId" INT8,
		"WeekId" INT4,
		"Month" VARCHAR,
		"IsSumKpi" bool
)
AS $BODY$
	
BEGIN

	RETURN QUERY
	SELECT
		E."ExemptKpiId",
		E."UserId",
		E."WeekId",
		E."Month",
		E."IsSumKpi"
	FROM "ExemptKpi" E 
	WHERE E."Month" = p_month;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
