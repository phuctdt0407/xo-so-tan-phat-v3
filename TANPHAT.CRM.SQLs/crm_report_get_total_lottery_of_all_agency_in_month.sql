-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_lottery_of_all_agency_in_month('2022-03');
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_lottery_of_all_agency_in_month');
CREATE OR REPLACE FUNCTION crm_report_get_total_lottery_of_all_agency_in_month
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"AgencyId" INT,
	"AgencyName" VARCHAR,
	"ActionDate" DATE,
	"TotalReceived" INT8,
	"TotalDupReceived" INT8
)
AS $BODY$
BEGIN
RETURN QUERY
-- 	SELECT 
-- 		I."AgencyId",
-- 		A."AgencyName", 
-- 		I."ActionDate"::DATE,
-- 		SUM(I."TotalReceived") AS "TotalReceived", 
-- 		SUM(I."TotalDupReceived") AS "TotalDupReceived"
-- 	FROM "InventoryLog" I, "Agency" A
-- 	WHERE TO_CHAR(I."ActionDate", 'YYYY-MM') = p_month
-- 		AND A."AgencyId" = I."AgencyId"
-- 	GROUP BY I."AgencyId", A."AgencyName", I."ActionDate"::DATE
-- 	ORDER BY  I."AgencyId";
	SELECT 
		I."AgencyId",
		A."AgencyName", 
		I."LotteryDate"::DATE,
		SUM(I."TotalReceived") AS "TotalReceived", 
		0 :: INT8
	FROM "InventoryFull" I, "Agency" A
	WHERE TO_CHAR(I."LotteryDate", 'YYYY-MM') = p_month
		AND A."AgencyId" = I."AgencyId"
	GROUP BY I."AgencyId", A."AgencyName", I."LotteryDate"::DATE
	ORDER BY  I."AgencyId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

