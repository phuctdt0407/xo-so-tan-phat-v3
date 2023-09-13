-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_average_lottery_sell_of_user_to_current_date('2022-06',0, 0);
-- ================================
SELECT dropallfunction_byname('crm_report_average_lottery_sell_of_user_to_current_date');
CREATE OR REPLACE FUNCTION crm_report_average_lottery_sell_of_user_to_current_date
(
	p_month VARCHAR,
	p_userId INT,
	p_lottery_type INT
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	"Average" NUMERIC
)
AS $BODY$
BEGIN

	RETURN QUERY
	WITH tmp AS(
		SELECT 
			U."UserId",
			U."FullName",
			U."TypeUserId"
		FROM "User" U 
			JOIN "UserRole" UR ON U."UserId" = UR."UserId"
			JOIN "UserTitle" UT ON UR."UserTitleId" = UT."UserTitleId"
		WHERE UT."IsStaff" IS TRUE AND U."IsDeleted" IS FALSE AND U."IsActive" IS TRUE
	),
	tmp1 AS (
		SELECT 
			SPL."ActionBy",
			SPL."SalePointId",
			SPL."LotteryTypeId",
			LT."LotteryTypeName",
			TO_CHAR(COALESCE(SPL."LotteryDate", SPL."ActionDate"), 'YYYY-MM-DD') AS "DateSell",
			SUM(SPL."Quantity") AS "TotalLottery"
		FROM "SalePointLog" SPL, "LotteryType" LT
		WHERE (SPL."ActionDate" <= NOW())
			AND (TO_CHAR(SPL."ActionDate", 'YYYY-MM') =  p_month) 
			AND SPL."LotteryTypeId" = LT."LotteryTypeId"
			AND (COALESCE(p_lottery_type, 0) = 0 
				OR (p_lottery_type = 3 AND SPL."LotteryTypeId" = p_lottery_type) 
				OR (p_lottery_type <> 3 AND SPL."LotteryTypeId" IN(1,2)))
			AND SPL."IsDeleted" IS FALSE
		GROUP BY 
			SPL."ActionBy",
			SPL."SalePointId",
			SPL."LotteryTypeId",
			LT."LotteryTypeName",
			TO_CHAR(COALESCE(SPL."LotteryDate", SPL."ActionDate"), 'YYYY-MM-DD')
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
	), 
	tmp3 AS (
		SELECT 
			U."UserId",
			U."FullName",
			U."TypeUserId",
			SUM(A."TotalLottery") AS "Total"
		FROM tmp U 
			LEFT JOIN tmp2 A ON U."UserId" = A."ActionBy"
		WHERE COALESCE(p_userId, 0) = 0 OR U."UserId" = p_userId
		GROUP BY U."UserId", U."FullName", U."TypeUserId"
	),
	tmp4 AS (
		SELECT
			SD."UserId",
			COUNT(1) FILTER (WHERE TO_CHAR(SD."DistributeDate", 'YYYY-MM') = p_month ) AS "TotalShift"
		FROM "ShiftDistribute" SD	
		WHERE (COALESCE(p_userId, 0) = 0 OR SD."UserId" = p_userId)
			AND ((SD."DistributeDate" :: DATE) :: TIMESTAMP + (((CASE WHEN SD."ShiftId" = 1 THEN '6' ELSE '13' END)||' hour') :: INTERVAL))  <= NOW()
		GROUP BY SD."UserId" 
	)
	SELECT 
		tmp3."UserId",
		tmp3."FullName",
		ROUND(COALESCE(tmp3."Total", 0)/(CASE WHEN COALESCE(tmp4."TotalShift", 0) = 0 THEN 1 ELSE COALESCE(tmp4."TotalShift", 1) END), 0) AS "Average" 
	FROM tmp3 
		LEFT JOIN tmp4 ON tmp3."UserId" = tmp4."UserId"
	ORDER BY tmp3."TypeUserId", tmp3."UserId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

