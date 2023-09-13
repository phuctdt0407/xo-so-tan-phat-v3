-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_lottery_award_expected('2023-04-30');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_lottery_award_expected');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_lottery_award_expected
(
	p_date TIMESTAMP DEFAULT NOW(),
	p_salepoint_id INT DEFAULT 0
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"DataGroupType" TEXT,
	"PriceLottery" NUMERIC,
	"PriceLotteryDB" NUMERIC,
	"DataWinning" TEXT
)
AS $BODY$
DECLARE 
	v_date DATE := p_date::DATE;
	v_day_id INT := (CASE WHEN EXTRACT(DOW FROM p_date) =0 THEN 7 ELSE EXTRACT(DOW FROM p_date) END);
	v_two INT := 4;
	v_three INT := 2;
	v_four INT := 3;
BEGIN
	RETURN QUERY
	--Lấy danh sách xổ số
	WITH tmp AS (
		SELECT
			RL."LotteryChannelId",
			RL."LotteryDate",
			RL."TypeAwardId",
			TA."TypeAwardName",
			RL."ListNumber",
			TA."Price"
		FROM "ResultLottery" RL
			JOIN "TypeAward" TA ON TA."TypeAwardId" = RL."TypeAwardId"
		WHERE RL."IsDeleted" IS FALSE
			AND RL."LotteryDate" = v_date
	),
	--Lấy danh sách bán hàng theo ngày 
	tmp1 AS (
		SELECT 
			SPl."SalePointLogId",
			SPL."SalePointId",
			SPL."Quantity",
			SPL."LotteryPriceId",
			SPL."LotteryChannelId",
			SPL."FourLastNumber"
		FROM "SalePointLog" SPL
			LEFT JOIN "Guest" G ON SPL."GuestId" = G."GuestId"
		WHERE SPL."IsDeleted" IS FALSE
			AND SPL."LotteryTypeId" <> 3
			AND (G."GuestId" IS NULL OR (G."GuestId" IS NOT NULL AND G."ScratchPriceId" IS NULL AND G."WholesalePriceId" IS NULL))
			AND SPL."FourLastNumber" IS NOT NULL
			AND SPL."LotteryDate" = p_date::DATE
	),
	--Lấy danh sách masterdata thưởng 
	tmp2 AS (
		SELECT
			WT."WinningTypeId",
			WT."WinningTypeName",
			WT."WinningPrize",
			LC."LotteryChannelId",
			T."ListNumber"
		FROM "WinningType" WT
			JOIN "LotteryChannel" LC ON LC."RegionId" = 2 AND LC."IsActive" IS TRUE AND LC."IsDeleted" IS FALSE AND array_position(LC."DayIds", v_day_id) > 0
			JOIN tmp T ON T."LotteryChannelId" = LC."LotteryChannelId" aND T."TypeAwardId" = 9
		WHERE WT."WinningPrize" IS NOT NULL
			AND WT."WinningTypeId" IN (2,3,4)
	),
	--Quy đổi thưởng
	tmp3 AS (
		SELECT 
			ROW_NUMBER() OVER(PARTITION BY T."SalePointLogId" ORDER BY COALESCE(RS."Price", RSS."WinningPrize", 0) DESC) AS "Id",
			T."SalePointId",
			T."LotteryChannelId",
			T."Quantity",
			T."LotteryPriceId",
			LC."LotteryChannelName",
			T."FourLastNumber",
			RS."TypeAwardId",
			RS."TypeAwardName",
			RS."ListNumber",
			RS."Price",
			RSS."ListNumber" AS "ListNumberDB",
			RSS."WinningTypeId",
			RSS."WinningTypeName",
			RSS."WinningPrize"
		FROM tmp1 T
			JOIN "LotteryChannel" LC ON T."LotteryChannelId" = LC."LotteryChannelId"
			LEFT JOIN tmp RS ON RS."LotteryChannelId" = T."LotteryChannelId" AND T."FourLastNumber" LIKE ANY(SELECT '%'||LS FROM UNNEST(RS."ListNumber") LS)
			LEFT JOIN tmp2 RSS ON RSS."LotteryChannelId" = T."LotteryChannelId" AND  
				T."FourLastNumber" LIKE ANY(
					SELECT '%'||RIGHT(LSS, CASE WHEN RSS."WinningTypeId" = v_two THEN 2 
																			WHEN RSS."WinningTypeId" = v_three THEN 3
																			WHEN RSS."WinningTypeId" = v_four THEN 4 
																			ELSE 0 END) 
					FROM UNNEST(RSS."ListNumber") LSS
				)
		WHERE COALESCE(RS."TypeAwardId", RSS."WinningTypeId", -1) <> -1
	),
	-- lấy danh sách điểm bán
	tmp4 AS (
		SELECT
			SP."SalePointId",
			SP."SalePointName"
		FROM "SalePoint" SP 
		WHERE SP."IsActive" IS TRUE
			AND SP."IsDeleted" IS FALSE
			AND (SP."SalePointId" = p_salepoint_id OR p_salepoint_id = 0)
	),
	tmp5 AS (
		SELECT 
			SP."SalePointId",
			T."LotteryChannelId",
			COALESCE(T."TypeAwardId", T."WinningTypeId" + 10000) AS "WinningTypeId",
			COALESCE(T."TypeAwardName", T."WinningTypeName") AS "WinningTypeName",
			COALESCE(SUM(COALESCE(T."Price", T."WinningPrize", 0) * T."Quantity"), 0)  AS "PriceLottery"
		FROM tmp4 SP
			LEFT JOIN tmp3 T ON T."SalePointId" = SP."SalePointId" AND T."Id" = 1
		GROUP BY
			SP."SalePointId",
			COALESCE(T."TypeAwardId", T."WinningTypeId" + 10000),
			COALESCE(T."TypeAwardName", T."WinningTypeName"),
			T."LotteryChannelId"
	),
	tmp6 AS (
		SELECT
			T."SalePointId",
			(CASE WHEN COUNT(T."WinningTypeId") > 0 THEN array_to_json(array_agg(TO_JSONB(T.*))) ELSE '[]' END) AS "DataGroupType"
		FROM tmp5 T
		GROUP BY
			T."SalePointId"
	)
	SELECT 
		SP."SalePointId",
		SP."SalePointName",
		S."DataGroupType"::TEXT,
		COALESCE(SUM(COALESCE(T."Price", 0) * T."Quantity") FILTER (WHERE T."TypeAwardId" IS NOT NULL), 0) AS "PriceLottery",
		COALESCE(SUM(COALESCE(T."WinningPrize", 0) * T."Quantity") FILTER (WHERE T."TypeAwardId" IS NULL AND T."WinningTypeId" IS NOT NULL), 0)  AS "PriceLotteryDB",
		(CASE WHEN (COUNT(T."TypeAwardId") + COUNT(T."WinningTypeId")) > 0 
				THEN array_to_json(array_agg(json_build_object(
					'Quantity',
					T."Quantity",
					'Number',
					T."FourLastNumber",
					'LotteryChannelId',
					T."LotteryChannelId",					
					'LotteryChannelName',
					T."LotteryChannelName",
					'WinningTypeId',
					COALESCE(T."TypeAwardId", T."WinningTypeId" + 10000),
					'TypeAwardName',
					COALESCE(T."TypeAwardName", T."WinningTypeName"),
					'WinningPrice',
					COALESCE(T."Price", T."WinningPrize"),
					'Number', 	COALESCE(T."FourLastNumber", '')		
				)))
				ELSE '[]' END)::TEXT
		 AS "DataWinning"
	FROM tmp4 SP
		LEFT JOIN tmp3 T ON T."SalePointId" = SP."SalePointId" AND T."Id" = 1
		LEFT JOIN tmp6 S ON S."SalePointId" = SP."SalePointId"
	GROUP BY
		SP."SalePointId",
		SP."SalePointName",
		S."DataGroupType"::TEXT
	ORDER BY
		SP."SalePointId";
END
$BODY$
LANGUAGE plpgsql VOLATILE

