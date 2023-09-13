-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_get_list_lottery_price_agency(NULL);
-- ================================
SELECT dropallfunction_byname('crm_activity_get_list_lottery_price_agency');
CREATE OR REPLACE FUNCTION crm_activity_get_list_lottery_price_agency
(
	p_date TIMESTAMP DEFAULT NOW()
)
RETURNS TABLE
(
	"AgencyId" INT,
	"AgencyName" VARCHAR,
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"IsScratchcard" BOOL,
	"Price" NUMERIC,
	"CreatedDate" TIMESTAMP
)
AS $BODY$
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT 
			A."AgencyId",
			A."AgencyName"
		FROM "Agency" A
		WHERE A."IsDeleted" IS FALSE
	),
	tmp2 AS (
		SELECT 
			LC."LotteryChannelId",
			LC."LotteryChannelName",
			LC."IsScratchcard"
		FROM "LotteryChannel" LC
		WHERE LC."IsDeleted" = FALSE
		ORDER BY LC."LotteryChannelTypeId",
			LC."LotteryChannelId"
	),
	tmp3 AS (
		SELECT
			A."AgencyId",
			A."AgencyName",
			LC."LotteryChannelId",
			LC."LotteryChannelName",
			LC."IsScratchcard"
		FROM tmp A 
			JOIN tmp2 LC ON TRUE
	),
	tmp4 AS (
		SELECT 
			ROW_NUMBER() OVER(PARTITION BY LP."AgencyId", LP."LotteryChannelId" ORDER BY LP."CreatedDate" DESC) AS "Id",
			LP."AgencyId",
			LP."LotteryChannelId",
			LP."CreatedDate",
			LP."Price"
		FROM "LotteryPriceAgency" LP
		WHERE LP."IsDeleted" IS FALSE
			AND (p_date IS NULL OR LP."CreatedDate" <= p_date)
	)
	SELECT 
			A."AgencyId",
			A."AgencyName",
			A."LotteryChannelId",
			A."LotteryChannelName",
			A."IsScratchcard",
			P."Price",
			P."CreatedDate"
	FROM tmp3 A
		JOIN tmp4 P ON A."AgencyId" = P."AgencyId" AND A."LotteryChannelId" = P."LotteryChannelId"
	WHERE P."Id" = 1;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

