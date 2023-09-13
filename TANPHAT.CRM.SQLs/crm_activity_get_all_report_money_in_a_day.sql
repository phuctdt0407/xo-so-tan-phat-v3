-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_get_all_report_money_in_a_day('2023-02-12');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_all_report_money_in_a_day');
CREATE OR REPLACE FUNCTION crm_activity_get_all_report_money_in_a_day
(
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"ReturnMoneyId" INT,
	"ShiftDistributeId" INT,
	"SalePointId" INT,
	"ActionDate" DATE,
	"ShiftId" INT,
	"TotalMoneyInADay" INT8
	
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT
		RM."ReturnMoneyId",
		RM."ShiftDistributeId",
		RM."SalePointId",
		RM."ActionDate",
		RM."ShiftId",
		RM."TotalMoneyInDay"
	FROM "ReportMoney" RM
	WHERE RM."ActionDate" = p_date::DATE;
END;
$BODY$
LANGUAGE plpgsql VOLATILE