
-- SELECT * FROM crm_report_total_lottery_sell_of_user_to_current_date_v3('2023-03',77, 0);
-- ================================
SELECT dropallfunction_byname('crm_report_total_lottery_sell_of_user_to_current_date_v3');
CREATE OR REPLACE FUNCTION crm_report_total_lottery_sell_of_user_to_current_date_v3
(
	p_month VARCHAR,
	p_userId INT,
	p_lottery_type INT
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"LotteryTypeId" INT,
	"LotteryTypeName" VARCHAR,
	"LotteryChannelId" INT,
	"RegionId" INT,
	"DateSell" TEXT,
	"TotalLottery" BIGINT
)
AS $BODY$
BEGIN

	RETURN QUERY
	WITH tmp1 AS (
		SELECT 
			SPL."ActionBy",
			SPL."SalePointId",
			SPL."LotteryTypeId",
			LC."LotteryChannelId",
			R."RegionId",
			LT."LotteryTypeName",
			TO_CHAR(SPL."ActionDate", 'YYYY-MM-DD') AS "DateSell",
			SUM(SPL."Quantity") AS "TotalLottery"
		FROM "SalePointLog" SPL
		JOIN "LotteryType" LT ON LT."LotteryTypeId" = SPL."LotteryTypeId"
		JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = SPL."LotteryChannelId"
		JOIN "Region" R ON R."RegionId" = LC."RegionId"
		WHERE (SPL."ActionDate" <= NOW())
			AND (TO_CHAR(SPL."ActionDate", 'YYYY-MM') =  p_month) 
			AND SPL."LotteryTypeId" = LT."LotteryTypeId"
			AND SPL."IsDeleted" IS FALSE
			AND (COALESCE(p_lottery_type, 0) = 0 
				OR (p_lottery_type = 3 AND SPL."LotteryTypeId" = p_lottery_type) 
				OR (p_lottery_type <> 3 AND SPL."LotteryTypeId" IN(1,2)))
		GROUP BY 
			SPL."ActionBy",
			SPL."SalePointId",
			SPL."LotteryTypeId",
			SPL."LotteryChannelId",
			LT."LotteryTypeName",
			LC."LotteryChannelId",
			R."RegionId",
			TO_CHAR(SPL."ActionDate", 'YYYY-MM-DD')
	),
	tmp2 AS (
		SELECT 
			TT."ActionBy", 
			SP."SalePointId",
			SP."SalePointName", 
			TT."LotteryTypeId",
			TT."LotteryTypeName",
			TT."LotteryChannelId",
			TT."RegionId",
			TT."DateSell",
			TT."TotalLottery"
		FROM "SalePoint" SP 
			JOIN tmp1 TT ON SP."SalePointId" = TT."SalePointId"
	)
	SELECT 
		U."UserId",
		U."FullName",
		A."SalePointId",
		A."SalePointName", 
		A."LotteryTypeId", 
		A."LotteryTypeName",
		A."LotteryChannelId",
		A."RegionId",
		A."DateSell",
		A."TotalLottery"
	FROM "User" U JOIN tmp2 A ON U."UserId" = A."ActionBy"
	WHERE COALESCE(p_userId, 0) = 0 OR U."UserId" = p_userId
	ORDER BY U."UserId", A."DateSell";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

