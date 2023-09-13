-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_transiton_type_offset('2023-01');
-- ================================
SELECT dropallfunction_byname('crm_report_get_transiton_type_offset');
CREATE OR REPLACE FUNCTION crm_report_get_transiton_type_offset
(
	 p_month VARCHAR
)
RETURNS TABLE
(
		"SalePointName" VARCHAR,
		"SalePointId" INT4,
		"TransitionDate" DATE,
		"TransferTicket" INT8,
		"TicketsReceived" INT8,
		"Offset" INT8
		
)
AS $BODY$
DECLARE

BEGIN

	RETURN QUERY
	WITH tmp AS(
			SELECT
				S."SalePointName",
				S."SalePointId",
				T."TransitionDate"::DATE,
				COALESCE( SUM(T."TotalTrans") FILTER (WHERE T."TransitionTypeId" = 1),0) AS "TransferTicket",
				COALESCE( SUM(T."TotalTrans") FILTER (WHERE T."TransitionTypeId" = 2),0) AS "TicketsReceived"
			FROM "Transition" T 
			LEFT JOIN "SalePoint" S ON T."FromSalePointId" = S."SalePointId" OR T."ToSalePointId" = S."SalePointId"
			WHERE --T."TransitionDate"::DATE = p_day::DATE
			--AND 
			TO_CHAR(T."TransitionDate",'YYYY-MM') = p_month
			GROUP BY 
				T."TransitionTypeId",
				S."SalePointName",
				S."SalePointId",
				T."TransitionDate"::DATE
			ORDER BY S."SalePointId"
	)
	SELECT
		T."SalePointName",
		T."SalePointId",
		T."TransitionDate"::DATE,
		SUM(T."TransferTicket")::INT8 AS "TransferTicket",
		SUM(T."TicketsReceived")::INT8 AS "TicketsReceived",
		(SUM(T."TransferTicket") - SUM(T."TicketsReceived"))::INT8 AS "Offset"
	FROM tmp T 
	GROUP BY 
		T."SalePointId", 
		T."SalePointName",
		T."TransitionDate"::DATE
	ORDER BY 
		T."SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE
