-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_data_finish_shift_v5_reuse_money_data(87, 14032);
-- ================================
SELECT dropallfunction_byname('crm_report_data_finish_shift_v5_reuse_money_data');
CREATE OR REPLACE FUNCTION crm_report_data_finish_shift_v5_reuse_money_data
(
	p_user_role INT,
	p_shift_dis_id INT,
	p_lottery_date TIMESTAMP DEFAULT NOW()
)
RETURNS TABLE
(
	"MoneyData" TEXT
)
AS $BODY$
DECLARE
	v_user_id INT;
	v_salepoint_id INT;
	v_shift_id INT;
	v_quantity INT;
	v_total_money NUMERIC;
BEGIN
		
	SELECT 
		SD."ShiftId", SD."UserId", SD."SalePointId"
	INTO v_shift_id, v_user_id, v_salepoint_id
	FROM "ShiftDistribute" SD WHERE SD."ShiftDistributeId" =  p_shift_dis_id;

	RETURN QUERY
	--Lấy tổng chuyển nhận
	WITH tmp AS (
		SELECT
			(CASE WHEN T."FromSalePointId" = 0 THEN T."ToSalePointId" ELSE T."FromSalePointId" END) AS "SalePointId", 
			SP."SalePointName",
			T."LotteryDate",
			T."LotteryChannelId",
			LC."LotteryChannelName",
			LT."LotteryTypeId",
			LT."LotteryTypeName",
			T."IsScratchcard",
			SUM(CASE WHEN T."TransitionTypeId" = 1 AND LT."LotteryTypeId" IN (1, 3) THEN T."TotalTrans" 
							WHEN T."TransitionTypeId" = 1 AND LT."LotteryTypeId" = 2 THEN T."TotalTransDup" ELSE 0 END) AS "LotteryTrans",
			SUM(CASE WHEN T."TransitionTypeId" = 2 AND LT."LotteryTypeId" IN (1, 3) THEN T."TotalTrans" 
							WHEN T."TransitionTypeId" = 2 AND LT."LotteryTypeId" = 2 THEN T."TotalTransDup" ELSE 0 END) AS "LotteryReceive",
			SUM(CASE WHEN T."TransitionTypeId" = 3 AND LT."LotteryTypeId" IN (1, 3) THEN T."TotalTrans" 
							WHEN T."TransitionTypeId" = 3 AND LT."LotteryTypeId" = 2 THEN T."TotalTransDup" ELSE 0 END) AS "LotteryReturn",
			T."ShiftDistributeId"
		FROM "Transition" T 
			JOIN "SalePoint" SP ON (T."ToSalePointId" = SP."SalePointId" OR T."FromSalePointId" = SP."SalePointId")
			JOIN "LotteryChannel" LC ON T."LotteryChannelId" = LC."LotteryChannelId"
			JOIN "LotteryType" LT	ON (CASE WHEN T."IsScratchcard" IS TRUE THEN LT."LotteryTypeId" = 3 ELSE LT."LotteryTypeId" <> 3 END)
		WHERE T."ShiftDistributeId" = p_shift_dis_id AND T."ConfirmStatusId" = 2 
		GROUP BY
			(CASE WHEN T."FromSalePointId" = 0 THEN T."ToSalePointId" ELSE T."FromSalePointId" END),
			SP."SalePointName",
			T."LotteryChannelId",
			LC."LotteryChannelName",
			T."LotteryDate",
			LT."LotteryTypeId",
			LT."LotteryTypeName",
			T."ShiftDistributeId",
			T."IsScratchcard"
		ORDER BY (CASE WHEN T."FromSalePointId" = 0 THEN T."ToSalePointId" ELSE T."FromSalePointId" END), T."LotteryChannelId"
	),
	--Khách nợ
	tmp6 AS (
		SELECT 
			SUM(SPL."TotalValue") AS "TotalGuestDebt"
		FROM "SalePointLog" SPL 
		WHERE SPL."GuestId" IS NOT NULL	
			AND SPL."IsDeleted" IS FALSE
			AND SPL."ShiftDistributeId" = p_shift_dis_id
	),
	--Khách trả
	tmp7 AS (
		SELECT
			SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 1 AND GA."DoneTransfer" IS FALSE) AS "TotalTransferForGuestNotConfirm",
			SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 1 AND GA."DoneTransfer" IS TRUE) AS "TotalTransferForGuestConfirm",
			SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 2 AND GA."FormPaymentId" = 1 AND GA."DoneTransfer" IS TRUE) AS "TotalGuestPay",
			SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 2 AND GA."FormPaymentId" = 2 AND GA."DoneTransfer" IS TRUE) AS "TotalGuestTransferConfirm",
				SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 2 AND GA."FormPaymentId" = 2 AND GA."DoneTransfer" IS FALSE) AS "TotalGuestTransferNotConfirm",
			SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 3 AND GA."DoneTransfer" IS TRUE) AS "TotalPayForGuest"
		FROM "GuestAction" GA
		WHERE GA."IsDeleted" IS FALSE
			AND GA."ShiftDistributeId" = p_shift_dis_id
	),
	tmp8 AS (
		SELECT
			W."WinningTypeId",
			WT."WinningTypeName",
			SUM(W."WinningPrice") AS "WinningPrice"
		FROM "Winning" W
			JOIN "WinningType" WT ON WT."WinningTypeId" = W."WinningTypeId"
		WHERE W."ShiftDistributeId" = p_shift_dis_id
		GROUP BY
			W."WinningTypeId",
			WT."WinningTypeName"
	),
	tmp9 AS (
		SELECT
			SUM(W."WinningPrice") AS "WinningPrice",
			array_to_json(array_agg(W.*)) AS "WinningData"
		FROM tmp8 W
	),
	tmp10 AS (
		SELECT 
			SUM(SL."TotalValue") AS "TotalSoldMoney"
		FROM "SalePointLog" SL WHERE SL."ShiftDistributeId" = p_shift_dis_id
	),
	tmp11 AS (
		SELECT 
			SUM(T."TotalPrice") AS "TotalFeeOutSite"
		FROM crm_sale_point_get_list_fee_outsite(NOW()::TIMESTAMP, 0, p_shift_dis_id) T
	),
	tmp12 AS (
		SELECT
			0 AS "TotalGuestDebt",
			COALESCE(tmp7."TotalTransferForGuestConfirm", 0) AS "TotalTransferForGuestConfirm",
			COALESCE(tmp7."TotalTransferForGuestNotConfirm", 0) AS "TotalTransferForGuestNotConfirm",
			COALESCE(tmp7."TotalGuestPay", 0) AS "TotalGuestPay",
			COALESCE(tmp7."TotalGuestTransferConfirm", 0) AS "TotalGuestTransferConfirm",
			COALESCE(tmp7."TotalGuestTransferNotConfirm", 0) AS "TotalGuestTransferNotConfirm",
			COALESCE(tmp7."TotalPayForGuest", 0) AS "TotalPayForGuest",
			COALESCE(tmp9."WinningPrice", 0) AS "WinningPrice",
			COALESCE(tmp11."TotalFeeOutSite", 0) AS "TotalFeeOutSite",
			tmp9."WinningData",
			COALESCE(tmp10."TotalSoldMoney", 0) AS "TotalSoldMoney"
		FROM tmp6, tmp7, tmp9, tmp10, tmp11
	),
	tmp13 AS (
		SELECT 
			T.*,
			(T."TotalSoldMoney"
			- T."TotalGuestDebt"
			+ T."TotalTransferForGuestConfirm"
			+ T."TotalGuestPay"
			- T."TotalPayForGuest"
		
			- T."TotalFeeOutSite"
			- T."WinningPrice"
			) AS "TotalMoneyReturn"
		FROM tmp12 T
	)
	SELECT 
	(
		SELECT 
			TO_JSONB(T.*)
		FROM tmp13 T
	)::TEXT AS "MoneyData";

END;
$BODY$
LANGUAGE plpgsql VOLATILE

