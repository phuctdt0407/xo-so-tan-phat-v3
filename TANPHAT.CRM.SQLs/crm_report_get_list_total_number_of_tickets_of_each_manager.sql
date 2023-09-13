-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_list_total_number_of_tickets_of_each_manager('2023-04');
-- ================================
SELECT dropallfunction_byname('crm_report_get_list_total_number_of_tickets_of_each_manager');
CREATE OR REPLACE FUNCTION crm_report_get_list_total_number_of_tickets_of_each_manager
(
		p_month VARCHAR
)
RETURNS TABLE
(
		"FullName" VARCHAR,
		"LotteryDate" DATE,
		"SalePointId" INT,
		"TotalReceived" INT8,
		"ManagerId" INT
)
AS $BODY$
BEGIN

	RETURN QUERY
	WITH tmp AS
	(
			SELECT
				I."LotteryDate",
				I."SalePointId",
				SUM(I."TotalDupReceived") + SUM(I."TotalReceived") AS "TotalReceived",
				(SELECT FN."ManagerId" FROM crm_sale_point_manage_v2(I."LotteryDate") FN
					WHERE FN."SalePointId" = I."SalePointId" AND FN."ManagerId" IS NOT NULL
					LIMIT 1) AS "ManagerId"
			FROM "InventoryLog" I 
			WHERE TO_CHAR( I."LotteryDate", 'YYYY-MM' ) = p_month
			GROUP BY 
				I."LotteryDate",
				I."SalePointId"
	)
	SELECT
		U."FullName",
		T.*
	FROM tmp T 
	LEFT JOIN "User" U ON U."UserId" = T."ManagerId"
	GROUP BY 
		T."LotteryDate",
		T."SalePointId",
		T."ManagerId",
		T."TotalReceived",
		U."FullName";
END;
$BODY$
LANGUAGE plpgsql VOLATILE
