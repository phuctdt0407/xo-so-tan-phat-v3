-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_lottery_of_all_agency_in_day(3,'2023-03');
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_lottery_of_all_agency_in_day');
CREATE OR REPLACE FUNCTION crm_report_get_total_lottery_of_all_agency_in_day
(
	p_agency_id INT,
	p_month VARCHAR
)
RETURNS TABLE
(
	"AgencyId" INT,
	"Info" TEXT
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
WITH tmp AS(
		SELECT 
			I."AgencyId",
			A."AgencyName",
			LC."LotteryChannelId",
			LC."LotteryChannelName", 
			I."LotteryDate"::DATE,
			LC."ShortName",
			SUM(I."TotalReceived") AS "Total"
		FROM "InventoryFull" I, "Agency" A, "LotteryChannel" LC
	WHERE I."LotteryDate" BETWEEN (date_trunc('month', (p_month || '-01')::date))::DATE AND (date_trunc('month', (p_month|| '-01')::date) + interval '1 month' - interval '1 day')::DATE
		AND A."AgencyId" = I."AgencyId"
		AND LC."LotteryChannelId" = I."LotteryChannelId"
		AND A."AgencyId" = p_agency_id
	GROUP BY I."AgencyId", A."AgencyName", I."LotteryDate"::DATE, I."TotalReceived",LC."LotteryChannelId",LC."LotteryChannelName"
	ORDER BY   I."LotteryDate" DESC,LC."LotteryChannelId" DESC
	)
		SELECT 
			T."AgencyId", 
			array_to_json(array_agg(json_build_object( 
				'LotteryId',
				T."LotteryChannelId",
				'LotteryChannelName',
				T."LotteryChannelName", 
				'ShortName',
				T."ShortName",
				'LotteryDate',
				T."LotteryDate"::DATE,
				'Quantity',
				T."Total"
			)))::TEXT AS "AgencyInfo"
		FROM tmp T GROUP BY T."AgencyId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

