-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_transiton_type_ofset('2023-01-12');
-- ================================
SELECT dropallfunction_byname('crm_report_get_transiton_type_ofset');
CREATE OR REPLACE FUNCTION crm_report_get_transiton_type_ofset
(
	 p_day VARCHAR
)
RETURNS TABLE
(
		"SalePointName" VARCHAR,
		"SalePointId" INT4,
		"TransferTicket" INT8,
		"TicketsReceived" INT8,
		"Offset" INT8
		
)
AS $BODY$
DECLARE

BEGIN

	RETURN QUERY
	SELECT
		S."SalePointName",
		S."SalePointId",
		SUM(T."TotalTrans") FILTER (WHERE T."TransitionTypeId" = 1) AS "TransferTicket",
		SUM(T."TotalTrans") FILTER (WHERE T."TransitionTypeId" = 2) AS "TicketsReceived",
		("TransferTicket" - "TicketsReceived") AS "Offset"
	FROM "Transition" T 
	LEFT JOIN "SalePoint" S ON T."FromSalePointId" = S."SalePointId" OR T."ToSalePointId" = S."SalePointId"
	WHERE T."TransitionDate"::DATE <= p_day::DATE
	AND TO_CHAR(T."TransitionDate",'YYYY-MM') = TO_CHAR(p_day::DATE,'YYYY-MM')
  GROUP BY 
		T."TransitionTypeId",
		S."SalePointName",
		S."SalePointId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
