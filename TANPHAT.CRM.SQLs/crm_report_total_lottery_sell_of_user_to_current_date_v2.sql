-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_total_lottery_sell_of_user_to_current_date_v2('2022-06',2, 0);
-- ================================
SELECT dropallfunction_byname('crm_report_total_lottery_sell_of_user_to_current_date_v2');
CREATE OR REPLACE FUNCTION crm_report_total_lottery_sell_of_user_to_current_date_v2
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
			LT."LotteryTypeName",
			TO_CHAR(SPL."ActionDate", 'YYYY-MM-DD') AS "DateSell",
			SUM(SPL."Quantity") AS "TotalLottery"
		FROM "SalePointLog" SPL, "LotteryType" LT
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
			LT."LotteryTypeName",
			TO_CHAR(SPL."ActionDate", 'YYYY-MM-DD')
	),
	tmp2 AS (
		SELECT 
			TT."ActionBy", 
			SP."SalePointId",
			SP."SalePointName", 
			TT."LotteryTypeId",
			TT."LotteryTypeName",
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
		A."DateSell",
		A."TotalLottery"
	FROM "User" U JOIN tmp2 A ON U."UserId" = A."ActionBy"
	WHERE COALESCE(p_userId, 0) = 0 OR U."UserId" = p_userId
	ORDER BY U."UserId", A."DateSell";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

