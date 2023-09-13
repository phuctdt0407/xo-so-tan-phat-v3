-- ================================
-- Author: Phi
-- Description: Lấy dữ liệu nhận vé cào từ đại lý
-- Created date: 25/03/2022
-- SELECT * FROM crm_activity_get_data_receive_scratchcard_from_agency('2022-06-07');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_data_receive_scratchcard_from_agency');
CREATE OR REPLACE FUNCTION crm_activity_get_data_receive_scratchcard_from_agency(
	p_date TIMESTAMP 
)
RETURNS TABLE
(
	"AgencyId" INT,
	"TotalReceived" INT8,
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"ShortName" VARCHAR,
	"LastActionBy" INT,
	"LastActionByName" VARCHAR
)
AS $BODY$
BEGIN	
	
	RETURN QUERY 
		WITH tmp AS (
		SELECT 
			SF."AgencyId",
			SUM(SF."TotalReceived") AS "TotalReceived",
			SF."LotteryChannelId",
			LC."LotteryChannelName",
			LC."ShortName",
			SF."ActionBy",
			SF."ActionByName"
		FROM "ScratchcardFullLog" SF
			JOIN "LotteryChannel" LC ON SF."LotteryChannelId" = LC."LotteryChannelId"
		WHERE SF."ActionDate"::DATE = p_date::DATE
		GROUP BY 
			SF."AgencyId",
			SF."LotteryChannelId",
			LC."LotteryChannelName",
			LC."ShortName",
			SF."ActionBy",
			SF."ActionByName"
		ORDER BY SF."AgencyId"
	)
	SELECT 
		T."AgencyId",
		T."TotalReceived",
		T."LotteryChannelId",
		T."LotteryChannelName",
		T."ShortName",
		T."ActionBy",
		T."ActionByName"
	FROM tmp T
		JOIN "LotteryChannel" LC ON T."LotteryChannelId" = LC."LotteryChannelId"
	ORDER BY T."AgencyId", LC."LotteryChannelTypeId", T."LotteryChannelId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE