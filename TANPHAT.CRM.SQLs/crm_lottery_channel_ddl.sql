-- ================================
-- Author: Phi
-- Description: Lấy đài bán theo ngày
-- Created date: 01/03/2022
-- SELECT * FROM crm_lottery_channel_ddl(2, null);
-- ================================
SELECT dropallfunction_byname('crm_lottery_channel_ddl');
CREATE OR REPLACE FUNCTION crm_lottery_channel_ddl(
	p_region_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"Id" INT,
	"Name" VARCHAR,
	"ShortName" VARCHAR,
	"ChannelTypeShortName" VARCHAR,
	"IsScratchcard" BOOLEAN,
	"DayIds" TEXT
)
AS $BODY$
DECLARE
	v_dow INT := EXTRACT(ISODOW FROM p_date);
BEGIN
	
	RETURN QUERY 
	SELECT 
		LC."LotteryChannelId",
		LC."LotteryChannelName",
		LC."ShortName",
		LT."ShortName" AS "ChannelTypeShortName",
		LC."IsScratchcard",
		TRANSLATE(LC."DayIds" ::TEXT, '{}', '[]')
	FROM "LotteryChannel" LC
		JOIN "LotteryChannelType" LT ON LT."LotteryChannelTypeId" = LC."LotteryChannelTypeId"
	WHERE LC."IsActive" IS TRUE 
		AND LC."IsDeleted" IS FALSE
		AND LC."RegionId" IN (p_region_id, 3)
		AND (p_date IS NULL OR v_dow = ANY(LC."DayIds"))
	ORDER BY LT."LotteryChannelTypeId", LC."LotteryChannelId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE