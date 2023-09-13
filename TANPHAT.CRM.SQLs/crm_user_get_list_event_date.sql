-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_list_event_date(2022, 5);
-- ================================
SELECT dropallfunction_byname('crm_user_get_list_event_date');
CREATE OR REPLACE FUNCTION crm_user_get_list_event_date
(
	p_year INT,
	p_month INT
)
RETURNS TABLE
(
	"EventDayId" INT,
	"Date" DATE,
	"DateName" VARCHAR
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
		EV."EventDayId",
		EV."Date",
		EV."Note" AS "DateName"
	FROM "EventDay" EV
	WHERE EV."IsDeleted" IS FALSE
		AND EV."Year" = p_year
		AND (COALESCE(p_month, 0) = 0 OR EV."Month" = p_month)
	ORDER BY EV."Date";
END;
$BODY$
LANGUAGE plpgsql VOLATILE