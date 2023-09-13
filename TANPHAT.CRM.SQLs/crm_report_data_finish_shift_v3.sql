-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_data_finish_shift_v3(3, 412);
-- ================================
SELECT dropallfunction_byname('crm_report_data_finish_shift_v3');
CREATE OR REPLACE FUNCTION crm_report_data_finish_shift_v3
(
	p_user_role INT,
	p_shift_dis_id INT,
	p_lottery_date TIMESTAMP DEFAULT NOW()
)
RETURNS TABLE
(
	"MoneyData" TEXT,
	"LotteryData" TEXT
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
	--Lấy master từ kho
	tmp2 AS (--GetInventory
		SELECT 
			I."SalePointId",
			SP."SalePointName",
			I."LotteryDate",
			LT."LotteryTypeId",
			LT."LotteryTypeName",
			LC."LotteryChannelId",
			LC."LotteryChannelName"
		FROM "Inventory" I, "LotteryType" LT, "SalePoint" SP, "LotteryChannel" LC
		WHERE (I."LotteryDate" = p_lottery_date::DATE OR I."LotteryDate" = (p_lottery_date + INTERVAL '1 DAY') ::DATE) 
			AND LT."LotteryTypeId" <> 3
			AND I."SalePointId" = v_salepoint_id
			AND SP."SalePointId" = I."SalePointId"
			AND I."LotteryChannelId" = LC."LotteryChannelId"
		ORDER BY I."LotteryDate", I."LotteryChannelId"
	),
	--Hợp hai bảng tạm 
	tmp3 AS (--GetData
	
		SELECT 
			GI."LotteryDate",
			GI."SalePointId",
			GI."SalePointName",
			GI."LotteryChannelId",
			GI."LotteryChannelName",
			GI."LotteryTypeId",
			GI."LotteryTypeName",
			COALESCE(L."LotteryTrans", 0) AS "LotteryTrans",
			COALESCE(L."LotteryReceive", 0) AS "LotteryReceive",
			COALESCE(L."LotteryReturn", 0) AS "LotteryReturn",
			p_shift_dis_id AS "ShiftDistributeId"			
		FROM tmp2 GI 
			LEFT JOIN tmp L ON GI."LotteryDate" = L."LotteryDate" 
				AND L."IsScratchcard" IS FALSE
				AND GI."LotteryChannelId" = L."LotteryChannelId"
				AND GI."LotteryTypeId" = L."LotteryTypeId"
	),
	--Lấy tổng bán hàng
	tmp4 AS ( --MoneyData
		SELECT * FROM crm_get_total_sale_of_sale_point_by_shiftdis(v_salepoint_id, p_shift_dis_id)
	),
	--Tổng hợp lại
	tmp5 AS (
		SELECT 
			A."LotteryDate",
			A."LotteryChannelId",
			A."LotteryChannelName",
			A."LotteryTypeId",
			A."LotteryTypeName",
			A."FirstStore" AS "TotalStocks",
			A."LotteryTrans" AS "TotalTrans",
			A."LotteryReceive" AS "TotalReceived",
			A."LotteryReturn" AS "TotalReturns",
			(A."FirstStore" - A."LotteryTrans" + A."LotteryReceive" - A."TotalSell") AS "TotalRemaining",
			A."TotalSell" AS "TotalSold",
			A."TotalSoldMoney",
			A."TotalRetail",
			A."TotalRetailMoney",
			A."TotalWholesale",
			A."TotalWholesaleMoney",
			A."ShiftDistributeId",
			COALESCE(LC."ShortName",'Vé cào') AS "ShortName"
		FROM 
		(
			SELECT 
				G."LotteryDate",
				G."LotteryChannelId",
				G."LotteryChannelName",
				G."LotteryTypeId",
				G."LotteryTypeName",
				COALESCE(crm_get_previous_remaining_v2(G."ShiftDistributeId", G."LotteryChannelId", G."LotteryTypeId", G."LotteryDate", p_lottery_date::DATE), 0) AS "FirstStore",
				G."LotteryTrans",
				G."LotteryReceive",
				G."LotteryReturn" ,
				COALESCE(M."Quantity", 0) AS "TotalSell",
				COALESCE(M."TotalSoldMoney", 0) AS "TotalSoldMoney",
				COALESCE(M."TotalRetail", 0) AS "TotalRetail",
				COALESCE(M."TotalRetailMoney", 0) AS "TotalRetailMoney",
				COALESCE(M."TotalWholesale", 0) AS "TotalWholesale",
				COALESCE(M."TotalWholesaleMoney", 0) AS "TotalWholesaleMoney",
				G."ShiftDistributeId"
			FROM tmp3 G 
				FULL JOIN tmp4 M ON G."LotteryTypeId" = M."LotteryTypeId" AND G."LotteryChannelId" = M."LotteryChannelId" AND G."LotteryDate" = M."LotteryDate"
			WHERE G."SalePointId" = v_salepoint_id AND G."ShiftDistributeId" = p_shift_dis_id
			
			UNION
			
			SELECT
				NULL,
				LC."LotteryChannelId",
				LC."LotteryChannelName",
				LT."LotteryTypeId",
				LT."LotteryTypeName",
				COALESCE(crm_get_previous_remaining_v2(p_shift_dis_id, SC."LotteryChannelId", 3, p_lottery_date::DATE, p_lottery_date::DATE), 0) AS "FirstStore",
				COALESCE(L."LotteryTrans", 0) AS "LotteryTrans",
				COALESCE(L."LotteryReceive", 0) AS "LotteryReceive",
				COALESCE(L."LotteryReturn", 0) AS "LotteryReturn",
				COALESCE(M."Quantity", 0) AS "TotalSell",
				COALESCE(M."TotalSoldMoney", 0) AS "TotalSoldMoney",
				COALESCE(M."TotalRetail", 0) AS "TotalRetail",
				COALESCE(M."TotalRetailMoney", 0) AS "TotalRetailMoney",
				COALESCE(M."TotalWholesale", 0) AS "TotalWholesale",
				COALESCE(M."TotalWholesaleMoney", 0) AS "TotalWholesaleMoney",
				p_shift_dis_id
			FROM "Scratchcard" SC
				FULL JOIN tmp L ON L."IsScratchcard" IS TRUE
					AND SC."LotteryChannelId" = L."LotteryChannelId"
					AND L."LotteryTypeId" = 3
				LEFT JOIN "LotteryType" LT ON LT."LotteryTypeId" = 3 AND SC."SalePointId" = v_salepoint_id
				LEFT JOIN tmp4 M ON (LT."LotteryTypeId" = M."LotteryTypeId" AND M."LotteryChannelId" = SC."LotteryChannelId")
				LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = SC."LotteryChannelId"
			WHERE SC."SalePointId" = v_salepoint_id
		) A
		LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = A."LotteryChannelId"
		WHERE A."FirstStore" <> 0 OR A."LotteryTrans" <> 0 OR A."LotteryReceive" <> 0 OR A."TotalSell" <> 0 OR A."LotteryTypeId" = 1
		ORDER BY A."LotteryDate",A."LotteryTypeId" DESC, LC."DayIds", LC."LotteryChannelTypeId"
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
			SUM(GA."TotalPrice") FILTER (WHERE GA."GuestActionTypeId" = 1 AND GA."DoneTransfer" IS TRUE) AS "TotalTranferForGuest",
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
			SUM(T."TotalSoldMoney") AS "TotalSoldMoney"
		FROM tmp5 T
	),
	tmp11 AS (
		SELECT 
			SUM(T."TotalPrice") AS "TotalFeeOutSite"
		FROM crm_sale_point_get_list_fee_outsite(NOW()::TIMESTAMP, 0, p_shift_dis_id) T
	),
	tmp12 AS (
		SELECT
			0 AS "TotalGuestDebt",
			COALESCE(tmp7."TotalTranferForGuest", 0) AS "TotalTranferForGuest",
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
			+ T."TotalTranferForGuest"
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
	)::TEXT AS "MoneyData",
	(
		SELECT
			array_to_json(array_agg(TO_JSONB(T.*)))
		FROM tmp5 T
	)::TEXT AS "LotteryData";
	

END;
$BODY$
LANGUAGE plpgsql VOLATILE

