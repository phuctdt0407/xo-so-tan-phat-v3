-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_history_lottery_of_guest(6, '2022-07-05');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_history_lottery_of_guest');
CREATE OR REPLACE FUNCTION crm_salepoint_get_history_lottery_of_guest
(
	p_guest_id INT,
	p_date TIMESTAMP 
)
RETURNS TABLE
(
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"IsScratchcard" BOOL,
	"TotalReceived" INT8,
	"TotalValueReceived" NUMERIC,
	"TotalReturn" INT8,
	"TotalValueReturn" NUMERIC,
	"TotalCanReturn" INT8,
	"TotalValueCanReturn" NUMERIC
	)
AS $BODY$
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT 
			SPL."LotteryChannelId",
			SPL."LotteryTypeId",
			SPL."LotteryDate",
			SPL."Quantity",
			SPL."TotalValue",
			(CASE WHEN SPL."Quantity" >= 0 THEN 1 ELSE -1 END) AS "Type"
		FROM "SalePointLog" SPL
		WHERE SPL."GuestId" = p_guest_id
		AND (SPL."LotteryDate" = p_date::DATE OR SPL."LotteryTypeId" = 3)
	),
	tmp2 AS (
		SELECT 
			SPL."LotteryChannelId",
			SPL."LotteryDate",
			SUM(SPL."Quantity") AS "Quantity",
			SUM(SPL."TotalValue") AS "TotalValue"
		FROM tmp SPL
		WHERE SPL."Type" = 1
		GROUP BY 
			SPL."LotteryChannelId",
			SPL."LotteryDate"
	),
	tmp3 AS (
		SELECT 
			SPL."LotteryChannelId",
			SPL."LotteryDate",
			SUM(-SPL."Quantity") AS "Quantity",
			SUM(-SPL."TotalValue") AS "TotalValue"
		FROM tmp SPL
		WHERE SPL."Type" = -1
		GROUP BY 
			SPL."LotteryChannelId",
			SPL."LotteryDate"
	)
	SELECT 
		T."LotteryChannelId",
		LC."LotteryChannelName",
		LC."IsScratchcard",
		T."Quantity" AS "TotalReceived",
		T."TotalValue" AS "TotalValueReceived",
		S."Quantity" AS "TotalReturn",
		S."TotalValue" AS "TotalValueReturn",
		(COALESCE(T."Quantity", 0) - COALESCE(S."Quantity", 0)) AS "TotalCanReturn",
		(COALESCE(T."TotalValue", 0) - COALESCE(S."TotalValue", 0)) AS "TotalValueCanReturn"
	FROM tmp2 T
		FULL JOIN tmp3 S ON T."LotteryChannelId" = S."LotteryChannelId"
		JOIN "LotteryChannel" LC ON T."LotteryChannelId" = LC."LotteryChannelId"
	ORDER BY T."LotteryChannelId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE