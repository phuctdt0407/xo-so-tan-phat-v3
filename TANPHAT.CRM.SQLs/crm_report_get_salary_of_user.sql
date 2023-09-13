-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_salary_of_user(-1,'2022-09');
-- ================================
SELECT dropallfunction_byname('crm_report_get_salary_of_user');
CREATE OR REPLACE FUNCTION crm_report_get_salary_of_user
(
	p_user_id INT8,
	p_month varchar
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	"UserTitleId" INT,
	"UserTitleName" VARCHAR,
	"SalaryData" TEXT
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	SELECT F.* FROM crm_get_salary_of_user_by_month_v2(p_month) F
	WHERE F."UserId" = p_user_id or p_user_id = -1 AND F."UserId" <> 0;
END;
$BODY$
LANGUAGE plpgsql VOLATILE