-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_get_list_lottery_for_return('2022-06-01');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_list_lottery_for_return');
CREATE OR REPLACE FUNCTION crm_activity_get_list_lottery_for_return
(
	p_date TIMESTAMP DEFAULT NOW()
)
RETURNS TABLE
(
	"DataReceived" TEXT,
	"DataForReturn" TEXT
)
AS $BODY$
BEGIN
	RETURN QUERY
	--Lấy số vé chia vào ban đầu
	WITH tmp AS (
		SELECT 
			I."AgencyId",
			I."LotteryChannelId",
			I."TotalReceived",
			I."LotteryDate",
			FALSE AS "IsScratchcard"
		FROM "InventoryFull" I
		WHERE I."LotteryDate" = p_date::DATE
		UNION
		SELECT 
			SF."AgencyId",
			SF."LotteryChannelId",
			SUM(SF."TotalReceived") AS "TotalReceived",
			NULL AS "LotteryDate",
			TRUE AS "IsScratchcard"
		FROM "ScratchcardFullLog" SF
		GROUP BY 
			SF."AgencyId",
			SF."LotteryChannelId"
	),
	-- Lấy danh sách chuyển nhận
	tmp2 AS(
		SELECT 
			T."LotteryChannelId",
			T."LotteryDate",
			T."TransitionTypeId",
			T."TotalTrans",
			T."TotalTransDup",
			T."ToAgencyId",
			T."IsScratchcard"
		FROM "Transition" T
		WHERE T."ConfirmStatusId" = 2
			AND (T."IsScratchcard" IS TRUE OR T."LotteryDate" = p_date::DATE)
			AND T."IsDeleted" IS FALSE
	),
	-- Tính số vé còn lại có thể trả ế trong chuyển nhận
	tmp3 AS (
		SELECT ARRAY_TO_JSON(ARRAY_AGG(R))::TEXT AS "DataForReturn"
		FROM (
			SELECT 
				T."LotteryChannelId",
				T."IsScratchcard",
				SUM(CASE WHEN T."TransitionTypeId" = 1 THEN "TotalTrans" ELSE - "TotalTrans" END) AS "TotalTrans",
				SUM(CASE WHEN T."TransitionTypeId" = 1 THEN "TotalTransDup" ELSE - "TotalTransDup" END) AS "TotalTransDup"
			FROM tmp2 T
			GROUP BY
				T."LotteryChannelId",
				T."IsScratchcard"
			ORDER BY T."LotteryChannelId"
		)R
	),
	--Tính số vé đã trả 
	tmp4 AS (
		SELECT
			T."ToAgencyId" AS "AgencyId",
			T."LotteryChannelId",
			SUM(T."TotalTrans") AS "TotalTrans",
			SUM(T."TotalTransDup") AS "TotalTransDup"
		FROM tmp2 T
		WHERE T."ToAgencyId" IS NOT NULL AND T."TransitionTypeId" = 3
		GROUP BY 
			T."ToAgencyId",
			T."LotteryChannelId"
	), 
	-- Tính số vé còn lại có thể trả cho đại lý
	tmp5 AS (
		SELECT ARRAY_TO_JSON(ARRAY_AGG(R))::TEXT AS "DataReceived"
		FROM (
			SELECT 
				C."AgencyId",
				C."LotteryChannelId",
				C."TotalReceived",
				(COALESCE(R."TotalTrans", 0) + COALESCE(R."TotalTransDup", 0)) AS "TotalHaveReturned",
				(C."TotalReceived" - COALESCE(R."TotalTrans", 0) - COALESCE(R."TotalTransDup", 0)) AS "TotalCanReturn",
				C."LotteryDate",
				C."IsScratchcard"	
			FROM tmp C
				LEFT JOIN tmp4 R ON C."AgencyId" = R."AgencyId" AND C."LotteryChannelId" = R."LotteryChannelId"
			ORDER BY C."AgencyId", C."LotteryChannelId"
		)R
	)
	SELECT 
		tmp5."DataReceived",
		tmp3."DataForReturn"
	FROM tmp5 JOIN tmp3 ON TRUE;
		
END;
$BODY$
LANGUAGE plpgsql VOLATILE