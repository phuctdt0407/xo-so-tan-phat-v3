-- ================================
-- Author: Hieu
-- Description:
-- Created date:
-- SELECT * FROM crm_report_sale_of_salepoint_in_month_v1('2023-01');
-- ================================
SELECT dropallfunction_byname('crm_report_sale_of_salepoint_in_month_v1');
CREATE OR REPLACE FUNCTION crm_report_sale_of_salepoint_in_month_v1
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"DataSale" TEXT,
	"DataSalePercent" TEXT
)
AS $BODY$
DECLARE 
	v_lottery INT := 1;
	v_lottery_dup INT := 2;
	v_scratch INT := 3;
	v_lottery_price_id INT := 1;
	v_lottery_scratch_price_id INT := 1;
	v_percent_loto NUMERIC; 

BEGIN
	v_percent_loto := (
		SELECT 
			C."Price"
		FROM "Constant" C 
		WHERE C."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
			AND C."ConstId" = 13
			AND C."CreatedDate" >= ALL(
				SELECT 
					CC."CreatedDate"
				FROM "Constant" CC
				WHERE CC."ConstId" = C."ConstId"
					AND CC."CreatedDate"::DATE <= ((p_month||'-01')::DATE + INTERVAL '1 month - 1 day')::DATE
			)
	)::NUMERIC;
	
	RETURN QUERY
	--Lấy danh sách điểm bán
	WITH tmp AS (
		SELECT 
			SP."SalePointId",
			SP."SalePointName",
			COALESCE(SPL."MainUserId", '{}'::INT[]) AS "MainUserId",
			COALESCE(SPL."PercentMainUserId", '{}'::NUMERIC[]) AS "PercentMainUserId"
		FROM "SalePoint" SP
			LEFT JOIN (SELECT * FROM crm_get_list_percent_salepoint_in_month(p_month)) SPL ON SP."SalePointId" = SPL."SalePointId"
		WHERE SP."IsActive" IS TRUE
			AND SP."IsDeleted" IS FALSE
	),
	--Lấy danh sách bán hàng
	tmp0 AS (
		SELECT 
			SPL."SalePointId",
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_lottery, v_lottery_dup) AND SPL."LotteryPriceId" = v_lottery_price_id), 0) AS "TotalRetail",
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_lottery, v_lottery_dup) AND SPL."LotteryPriceId" = v_lottery_price_id), 0) AS "TotalRetailMoney",
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_lottery, v_lottery_dup) AND SPL."LotteryPriceId" <> v_lottery_price_id), 0) AS "TotalWholesale",
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_lottery, v_lottery_dup) AND SPL."LotteryPriceId" <> v_lottery_price_id), 0) AS "TotalWholesaleMoney",
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryPriceId" = v_lottery_scratch_price_id), 0) AS "TotalScratchRetail",
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryPriceId" = v_lottery_scratch_price_id), 0) AS "TotalScratchRetailMoney",
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryPriceId" <> v_lottery_scratch_price_id), 0) AS "TotalScratchWholesale",
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryPriceId" <> v_lottery_scratch_price_id), 0) AS "TotalScratchWholesaleMoney"
		FROM "SalePointLog" SPL 
		WHERE SPL."IsDeleted" IS FALSE
			AND TO_CHAR(SPL."ActionDate", 'YYYY-MM') = p_month
		GROUP BY 
			SPL."SalePointId"	
	),
	--Lấy danh sách trả thưởng
	tmp1 AS (
		SELECT
			(CASE WHEN W."FromSalePointId" = 0 THEN W."SalePointId" ELSE W."FromSalePointId" END)	AS "SalePointId",
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 1) AS "WinningLotteryPrice",									--Trúng vé thường
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 2) AS "ThreeSpecialPrice",										--Ba số đặc biệt
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 3) AS "FourSpecialPrice",											--Bốn số đặc biệt
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 4) AS "TwoSpecialPrice",											--Hoàn vé
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 5) AS "VietlottPrice",												--Trả thưởng vietlott
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 6) AS "LotoPrice",														--Trả thưởng loto \\\\\
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 1) AS "WinningLottery",									--Trúng vé thường
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 2) AS "ThreeSpecial",										--Ba số đặc biệt
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 3) AS "FourSpecial",											--Bốn số đặc biệt
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 4) AS "TwoSpecial",											--Hoàn vé
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 5) AS "Vietlott",												--Trả thưởng vietlott
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 6) AS "Loto"		
		FROM "Winning" W
			JOIN "WinningType" WT ON W."WinningTypeId" = WT."WinningTypeId"
		WHERE TO_CHAR(W."ActionDate", 'YYYY-MM') = p_month
		GROUP BY 
			(CASE WHEN W."FromSalePointId" = 0 THEN W."SalePointId" ELSE W."FromSalePointId" END)
	),
	--Lấy danh sách ôm ế và vé nhận vào ban đầu
	tmp2 AS (
		SELECT 
			I."SalePointId",
			I."LotteryChannelId",
			I."LotteryDate",
			SUM(I."TotalRemaining" + I."TotalDupRemaining") AS "TotalRemaining",
			SUM(I."TotalReceived" + I."TotalDupReceived") AS "TotalReceived"
		FROM "Inventory" I
		WHERE 
			CASE WHEN TO_CHAR(NOW(),'YYYY-MM') = p_month
				THEN TO_CHAR(I."LotteryDate", 'YYYY-MM-DD') < TO_CHAR(NOW(),'YYYY-MM-DD')
				AND TO_CHAR(I."LotteryDate", 'YYYY-MM') = TO_CHAR(NOW(),'YYYY-MM')
			ELSE
				TO_CHAR(I."LotteryDate", 'YYYY-MM') = p_month
			END
			AND I."SalePointId" <> 0
		GROUP BY 
			I."SalePointId",
			I."LotteryChannelId",
			I."LotteryDate"
	),
	--Lấy danh sách nhận vé cào ban đầu
	tmp3 AS (
		SELECT 
			SL."SalePointId",
			SL."LotteryChannelId",
			TO_CHAR(SL."ActionDate", 'YYYY-MM-DD') AS "LotteryDate",
			SUM(SL."TotalReceived") AS "TotalReceived"
		FROM "ScratchcardLog" SL
		WHERE TO_CHAR(SL."ActionDate", 'YYYY-MM') = p_month
		GROUP BY
			SL."SalePointId",
			SL."LotteryChannelId",
			TO_CHAR(SL."ActionDate", 'YYYY-MM-DD')
	),
	--Lấy danh sách vé chuyển nhận
	tmp4 AS (
		SELECT
			(CASE WHEN T."FromSalePointId" = 0 THEN T."ToSalePointId" ELSE T."FromSalePointId" END) AS "SalePointId", 
			(CASE WHEN T."LotteryDate" IS NOT NULL THEN T."LotteryDate" ELSE T."TransitionDate"::DATE END) AS "LotteryDate",
			T."LotteryChannelId",
			T."IsScratchcard",
			SUM(CASE WHEN T."TransitionTypeId" = 1 THEN T."TotalTrans" + T."TotalTransDup" ELSE 0 END) AS "LotteryTrans",
			SUM(CASE WHEN T."TransitionTypeId" = 2 THEN T."TotalTrans" + T."TotalTransDup" ELSE 0 END) AS "LotteryReceive"
		FROM "Transition" T 
		WHERE T."IsDeleted" IS FALSE
			AND T."TransitionTypeId" IN (1, 2)
			AND TO_CHAR(T."TransitionDate", 'YYYY-MM') = p_month
			AND T."ConfirmStatusId" = 2
		GROUP BY
			(CASE WHEN T."FromSalePointId" = 0 THEN T."ToSalePointId" ELSE T."FromSalePointId" END),
			T."LotteryChannelId",
			(CASE WHEN T."LotteryDate" IS NOT NULL THEN T."LotteryDate" ELSE T."TransitionDate"::DATE END),
			T."IsScratchcard"
		ORDER BY (CASE WHEN T."FromSalePointId" = 0 THEN T."ToSalePointId" ELSE T."FromSalePointId" END), T."LotteryChannelId"
	),
	--Lấy giá vé trung bình theo ngày
	tmp5 AS (
		SELECT 
			T."LotteryChannelId",
			T."Date",
			T."Price"
		FROM crm_get_average_lottery_price_in_date_of_month(p_month) T
	),
	--Lấy giá tiền nhập vé
	tmp6 AS (
		SELECT
			I."SalePointId",
			I."LotteryChannelId",
			I."LotteryDate",
			COALESCE(I."TotalReceived", 0) - COALESCE(T."LotteryTrans", 0) + COALESCE(T."LotteryReceive", 0) AS "TotalReceived",
			((COALESCE(I."TotalReceived", 0) - COALESCE(T."LotteryTrans", 0) + COALESCE(T."LotteryReceive", 0)) * P."Price") AS "PriceReceived"
		FROM tmp2 I
			LEFT JOIN tmp5 P ON I."LotteryChannelId" = P."LotteryChannelId"
				AND I."LotteryDate" = P."Date"
			LEFT JOIN tmp4 T ON I."SalePointId" = T."SalePointId" 
				AND I."LotteryChannelId"  = T."LotteryChannelId"
				AND I."LotteryDate" = T."LotteryDate"
		UNION ALL
		SELECT 
			I."SalePointId",
			I."LotteryChannelId",
			NULL AS "Date",
			COALESCE(I."TotalReceived", 0) - COALESCE(T."LotteryTrans", 0) + COALESCE(T."LotteryReceive", 0) AS "TotalReceived",
			((COALESCE(I."TotalReceived", 0) - COALESCE(T."LotteryTrans", 0) + COALESCE(T."LotteryReceive", 0)) * P."Price") AS  "PriceReceived"
		FROM tmp3 I
			LEFT JOIN tmp5 P ON I."LotteryChannelId" = P."LotteryChannelId"
			LEFT JOIN tmp4 T ON I."SalePointId" = T."SalePointId" 
				AND I."LotteryChannelId"  = T."LotteryChannelId"
				AND T."IsScratchcard" IS TRUE
	),
	--Tính tổng tiền nhận vé theo tháng của điểm bán
	tmp7 AS (
		SELECT 
			T."SalePointId",
			SUM(T."TotalReceived") AS "TotalReceived",
			SUM(T."PriceReceived") AS "PriceReceived"
		FROM tmp6 T
		GROUP BY 
			T."SalePointId"			
	),
	--Lấy tổng ôm ế
	tmp8 AS (
		SELECT 
			T."SalePointId",
			SUM(T."TotalRemaining") AS "TotalRemaining"
		FROM tmp2 T
		GROUP BY 
			T."SalePointId"
	),
	--Lấy các chi phí ngoài và doanh thu vietlott, lotto
	tmp9 AS (
		SELECT
			T."SalePointId",
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 1), 0) AS "FeeOutSite",					--Chi phí ngoài
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 2), 0) AS "SaleOfVietlott",			--Doanh thu Vietlott
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 3), 0) AS "SaleOfLoto",					--Doanh thu loto
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 4), 0) AS "PunishUser",					--Phạt nhân viên
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 6), 0) AS "OvertimeUser",				--Tăng ca nhân viên
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 7), 0) AS "AwardUser",						--Thưởng nhân viên
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 8), 0) AS "DebtUser", 						--nợ nhân viên
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 9), 0) AS "PriceVietlott" 				--chi phí vietlott
		FROM "Transaction" T
		WHERE T."IsDeleted" IS FALSE
			AND TO_CHAR(T."Date", 'YYYY-MM') = p_month
		GROUP BY 
			T."SalePointId"
	),
	--Lấy lương chi cho nhân viên chưa tính các loại thưởng phạt chỉ có target
	tmp10 AS (
		SELECT 	
			((T."Data"::JSON)->>'SalePointId')::INT AS "SalePointId",
			COALESCE(((T."Data"::JSON)->>'TotalSalary')::NUMERIC, 0) AS "TotalSalary",
			COALESCE(((T."Data"::JSON)->>'TotalSalarySub')::NUMERIC, 0) AS "TotalSalarySub",
			COALESCE(((T."Data"::JSON)->>'TotalPriceForLunch')::NUMERIC, 0) AS "TotalPriceForLunch",
			COALESCE(((T."Data"::JSON)->>'TotalPriceTarget')::NUMERIC, 0) AS "TotalPriceTarget"
		FROM crm_get_salary_divide_for_salepoint_v1(p_month) T
	),
	--Lấy tổng tiền nhập/xuất kho
	tmp11 AS (
		SELECT
			IFL."SalePointId",
			SUM(IFL."BalancePrice") FILTER (WHERE IFL."ItemTypeId" = 1 AND I."TypeOfItemId" = 1) AS "PriceReceiveItem",
			SUM(IFL."BalancePrice") FILTER (WHERE IFL."ItemTypeId" = 2 AND I."TypeOfItemId" = 1) AS "PriceTransItem",
			SUM(IFL."BalancePrice") FILTER (WHERE IFL."ItemTypeId" = 1 AND I."TypeOfItemId" = 2) AS "PriceReceiveInstrument",
			SUM(IFL."BalancePrice") FILTER (WHERE IFL."ItemTypeId" = 2 AND I."TypeOfItemId" = 2) AS "PriceTransInstrument"
		FROM "ItemFullLog" IFL
			JOIN "Item" I ON IFL."ItemId" = I."ItemId"
		WHERE TO_CHAR(IFL."CreateDate", 'YYYY-MM') = p_month
			AND IFL."ItemTypeId" IN (1, 2)
		GROUP BY
			IFL."SalePointId"
	),
	tmp12 AS (
		SELECT 
			C."SalePointId",
			SUM(C."TotalCommision") AS "TotalCommission"
		FROM crm_salepoint_get_commision_of_all_user_in_month_v2(p_month) C
		WHERE C."UserId" = 0
		GROUP BY
			C."SalePointId"
	),
	tmp13 AS (
		SELECT 
			SP.*,
			COALESCE(SPL."TotalRetail", 0) AS "TotalRetail",
			COALESCE(SPL."TotalRetailMoney", 0) AS "TotalRetailMoney",
			COALESCE(SPL."TotalWholesale", 0) AS "TotalWholesale",
			COALESCE(SPL."TotalWholesaleMoney", 0) AS "TotalWholesaleMoney",
			COALESCE(SPL."TotalScratchRetail", 0) AS "TotalScratchRetail",
			COALESCE(SPL."TotalScratchRetailMoney", 0) AS "TotalScratchRetailMoney",
			COALESCE(SPL."TotalScratchWholesale", 0) AS "TotalScratchWholesale",
			COALESCE(SPL."TotalScratchWholesaleMoney", 0) AS "TotalScratchWholesaleMoney",
			COALESCE(W."WinningLotteryPrice", 0) AS "WinningLotteryPrice",
			COALESCE(W."ThreeSpecialPrice", 0) AS "ThreeSpecialPrice",
			COALESCE(W."FourSpecialPrice", 0) AS "FourSpecialPrice",
			COALESCE(W."TwoSpecialPrice", 0) AS "TwoSpecialPrice",
			COALESCE(W."VietlottPrice", 0) AS "VietlottPrice",
			COALESCE(W."LotoPrice", 0) AS "LotoPrice",
			COALESCE(W."WinningLottery", 0) AS "WinningLottery",
			COALESCE(W."ThreeSpecial", 0) AS "ThreeSpecial",
			COALESCE(W."FourSpecial", 0) AS "FourSpecial",
			COALESCE(W."TwoSpecial", 0) AS "TwoSpecial",
			COALESCE(W."Vietlott", 0) AS "Vietlott",
			COALESCE(W."Loto", 0) AS "Loto",
			COALESCE(K."TotalRemaining", 0) AS "TotalRemaining",																--Tổng ôm ế
			COALESCE(I."TotalReceived", 0) AS "TotalReceived",																	--Tổng vé nhận
			COALESCE(I."PriceReceived", 0) AS "PriceReceived",																	--Tổng chi phí nhận vé														
			COALESCE(T."FeeOutSite", 0) AS "FeeOutSite",																				--Chi phí ngoài
			COALESCE(((T."SaleOfVietlott"*0.07)*0.95) , 0) AS "SaleOfVietlott",																--Doanh thu Vietlott
			COALESCE(T."PriceVietlott", 0) AS "PriceVietlott",																  --Chi phí Vietlott
			COALESCE((T."SaleOfLoto" - (T."SaleOfLoto" *0.01) - fn_total_winning_price(p_month,6,SP."SalePointId")) , 0) AS "SaleOfLoto",																				--Doanh thu loto
			(COALESCE(T."SaleOfLoto", 0) * v_percent_loto) AS "ProfitOfLoto",										--Lợi nhuận loto
			COALESCE(T."PunishUser", 0) AS "PunishUser",																				--Phạt nhân viên
			COALESCE(T."OvertimeUser", 0) AS "OvertimeUser",																		--Tăng ca nhân viên
			COALESCE(T."AwardUser", 0) AS "AwardUser",																					--Thưởng nhân viên
			COALESCE(T."DebtUser", 0) AS "DebtUser", 																						--nợ nhân viên
			COALESCE(S."TotalSalary", 0) AS "TotalSalary",																			--Tổng tiền trả lương thường
			COALESCE(S."TotalSalarySub", 0) AS "TotalSalarySub",																--Tổng tiền trả lương tăng ca
			COALESCE(S."TotalPriceForLunch", 0) AS "TotalPriceForLunch",												--Tổng tiền cơm trưa
			COALESCE(S."TotalPriceTarget", 0) AS "TotalPriceTarget",														--Tổng tiền thưởng target
			COALESCE(IFL."PriceReceiveItem", 0) AS "PriceReceiveItem",													--Tổng tiền nhận hàng hoá
			COALESCE(IFL."PriceTransItem", 0) AS "PriceTransItem",															--Tổng tiền trả hàng hoá
			COALESCE(IFL."PriceReceiveInstrument", 0) AS "PriceReceiveInstrument",							--Tổng tiền nhận máy móc
			COALESCE(IFL."PriceTransInstrument", 0) AS "PriceTransInstrument", 									--Tổng tiền trả máy móc
			COALESCE(C."TotalCommission", 0) AS "TotalCommission"																--Hoa hồng đổi số trúng	
		FROM tmp SP
			LEFT JOIN tmp0 SPL ON SP."SalePointId" = SPL."SalePointId"
			LEFT JOIN tmp1 W ON SP."SalePointId" = W."SalePointId"
			LEFT JOIN tmp7 I ON SP."SalePointId" = I."SalePointId"
			LEFT JOIN tmp8 K ON SP."SalePointId" = K."SalePointId"
			LEFT JOIN tmp9 T ON SP."SalePointId" = T."SalePointId"
			LEFT JOIN tmp10 S ON SP."SalePointId" = S."SalePointId"
			LEFT JOIN tmp11 IFL ON SP."SalePointId" = IFL."SalePointId"
			LEFT JOIN tmp12 C ON SP."SalePointId" = C."SalePointId"
	),
	tmp14 AS (
		SELECT 
			T."SalePointId",
			T."SalePointName",
			TRANSLATE(T."MainUserId"::TEXT,'{}', '[]') AS "MainUserId",
			TRANSLATE(T."PercentMainUserId"::TEXT,'{}', '[]') AS "PercentMainUserId",
			ROUND(T."TotalRetail", 0) AS "TotalRetail",																			--Tổng vé thường lẻ
 			ROUND(T."TotalRetailMoney", 0) AS "TotalRetailMoney",
			ROUND(T."TotalWholesale", 0) AS "TotalWholesale",																--Tổng vé thường sỉ
 			ROUND(T."TotalWholesaleMoney", 0) AS "TotalWholesaleMoney",
			ROUND(T."TotalScratchRetail", 0) AS "TotalScratchRetail",												--Tổng vé cào lẻ
 			ROUND(T."TotalScratchRetailMoney", 0) AS "TotalScratchRetailMoney",
			ROUND(T."TotalScratchWholesale", 0) AS "TotalScratchWholesale",									--Tổng vé cào sỉ
 			ROUND(T."TotalScratchWholesaleMoney", 0) AS "TotalScratchWholesaleMoney",
-- 			ROUND(T."WinningLotteryPrice", 0) AS "WinningLotteryPrice",
			ROUND(T."ThreeSpecialPrice", 0) AS "ThreeSpecialPrice", -- Tổng tiền trúng 3 số 
			ROUND(T."FourSpecialPrice", 0) AS "FourSpecialPrice", -- Tổng tiền trúng 4 số 
 			ROUND(T."TwoSpecialPrice", 0) AS "TwoSpecialPrice",	-- Tổng tiền trúng 2 số 
			ROUND(T."ThreeSpecial", 0)*300000 AS "ThreeSpecial",
			ROUND(T."FourSpecial", 0)*750000 AS "FourSpecial",
			ROUND(T."TwoSpecial", 0)*10000 AS "TwoSpecial",
--  		ROUND(T."VietlottPrice", 0) AS "VietlottPrice",																	
-- 			ROUND(T."LotoPrice", 0) AS "LotoPrice",
 			ROUND(T."TotalRemaining", 0) AS "TotalRemaining",																--Tổng ôm ế 
 			ROUND(T."TotalReceived", 0) AS "TotalReceived",																	--Tổng vé nhận
			ROUND(T."PriceReceived", 0) AS "PriceReceived",																	--Tổng chi phí nhận vé														
-- 			ROUND(T."FeeOutSite", 0) AS "FeeOutSite",																				--Chi phí ngoài
 			ROUND(T."SaleOfVietlott", 0) AS "SaleOfVietlott",																--Doanh thu Vietlott			
 			ROUND(T."PriceVietlott", 0) AS "PriceVietlott",																	--Tiền nạp Vietlott
 			ROUND(T."SaleOfLoto", 0) AS "SaleOfLoto",																				--Doanh thu loto
 			ROUND(T."ProfitOfLoto", 0) AS "ProfitOfLoto",																		--lợi nhuận loto
-- 			ROUND(T."PunishUser", 0) AS "PunishUser",																				--Phạt nhân viên
-- 			ROUND(T."OvertimeUser", 0) AS "OvertimeUser",																		--Tăng ca nhân viên
-- 			ROUND(T."AwardUser", 0) AS "AwardUser",																					--Thưởng nhân viên
-- 			ROUND(T."DebtUser", 0) AS "DebtUser", 																					--nợ nhân viên
-- 			ROUND(T."TotalSalary", 0) AS "TotalSalary",																			--Tổng tiền trả lương thường
-- 			ROUND(T."TotalSalarySub", 0) AS "TotalSalarySub",																--Tổng tiền trả lương tăng ca
-- 			ROUND(T."TotalPriceForLunch", 0) AS "TotalPriceForLunch",												--Tổng tiền cơm trưa
-- 			ROUND(T."TotalPriceTarget", 0) AS "TotalPriceTarget",														--Tổng tiền thưởng target
-- 			ROUND(T."PriceReceiveItem", 0) AS "PriceReceiveItem",														--Tổng tiền nhận hàng hoá
-- 			ROUND(T."PriceTransItem", 0) AS "PriceTransItem",																--Tổng tiền trả hàng hoá
-- 			ROUND(T."PriceReceiveInstrument", 0) AS "PriceReceiveInstrument",								--Tổng tiền nhận máy móc
-- 			ROUND(T."PriceTransInstrument", 0) AS "PriceTransInstrument", 									--Tổng tiền trả máy móc
 			ROUND(T."TotalCommission", 0) AS "TotalCommission",															--Hoa hồng đổi số trúng	
			ROUND(
				T."TotalRetailMoney"
			+ T."TotalWholesaleMoney"
			+ T."TotalScratchRetailMoney"
			+ T."TotalScratchWholesaleMoney"
			+ T."ProfitOfLoto"
			+ COALESCE(T."TotalCommission",0)
			+ COALESCE(T."SaleOfVietlott",0)
			--- T."ThreeSpecialPrice"
			--- T."FourSpecialPrice"
			--- T."TwoSpecialPrice"
			--- T."PriceReceived"
			, 0) AS "Profit",
			ROUND(T."SaleOfVietlott" - T."PriceVietlott", 0) AS "ProfitOfVietlott",					--Lợi nhuận vietlott
			ROUND(T."FeeOutSite" + T."PriceReceiveItem" - T."PriceTransItem" + fn_get_total_price_transaction_type(p_month,9, T."SalePointId") , 0) AS "TotalFee",
			ROUND(T."TotalSalary"
			+ T."TotalSalarySub"
			+ T."TotalPriceForLunch"
			+ T."TotalPriceTarget"
			+ T."AwardUser"
			- T."DebtUser"
			+ T."OvertimeUser"
			- T."PunishUser", 0) AS "TotalAllSalary",																				--Tổng tiền lương																																	
			ROUND(
			T."TotalRetailMoney"
			+ T."TotalWholesaleMoney"
			+ T."TotalScratchRetailMoney"
			+ T."TotalScratchWholesaleMoney"
			+ T."ProfitOfLoto"
			+ COALESCE(T."TotalCommission",0)
			+ COALESCE(T."SaleOfVietlott",0)
			- fn_get_total_price_transaction_type(p_month,9, T."SalePointId") -- tien nap Vietlott
			- COALESCE( T."ThreeSpecialPrice",0)
			- COALESCE( T."FourSpecialPrice" ,0)
			- COALESCE(T."TwoSpecialPrice",0)
			- COALESCE(T."TotalRemaining",0)*8750
			- COALESCE(T."FeeOutSite")
			- (SELECT SUM(F."TotalReceived") FROM crm_get_inventory_inday_of_all_salepoint_v2(p_month,T."SalePointId") F) :: INT * 8750
			- (COALESCE(T."TotalSalary" , 0) + COALESCE(T."TotalSalarySub",0) + COALESCE(T."TotalPriceForLunch",0) + COALESCE(T."AwardUser",0)- COALESCE(T."PunishUser",0) + COALESCE(T."DebtUser", 0)) , 0) AS "TotalSale",
			ROUND((COALESCE(T."TotalSalary" , 0) + COALESCE(T."TotalSalarySub",0) + COALESCE(T."TotalPriceForLunch",0) + COALESCE(T."AwardUser",0)- COALESCE(T."PunishUser",0) + COALESCE(T."DebtUser", 0)),0)  AS "EmployeeSalary",
			fn_get_total_price_transaction_type(p_month,9, T."SalePointId")  AS "ToUpVietlott"
-- 			(T."Profit" / F."TotalCommision" ) AS "SuperAdmin"
		FROM tmp13 T
-- 		LEFT JOIN crm_salepoint_get_commision_of_all_user_in_month(p_month) F ON F."SalePointId" = T."SalePointId"
	),
	tmp15 AS
	(
		SELECT
		T1.*,
		(SELECT 
					array_to_json( array_agg(jsonb_build_object('FullName',F."FullName", 'Percent', F."Percent", 'TotalCommisionUser', F."TotalCommisionUser")))::TEXT
				FROM fn_total_commision_user(T1."SalePointId", p_month, T1."Profit") F
			) AS "ListTotalComitsionUser"
		FROM tmp14 T1
	)
	
	SELECT
		TO_JSONB(T.*)::TEXT AS "DataSale",
		(SELECT * FROM crm_get_sale_divide_for_user(T."MainUserId", T."PercentMainUserId", T."TotalSale"))::TEXT AS "DataSalePercent"
	FROM tmp15 T
	ORDER BY T."SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

