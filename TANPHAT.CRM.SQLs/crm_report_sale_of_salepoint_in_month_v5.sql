-- ================================
-- Author: Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_report_sale_of_salepoint_in_month_v5('2023-04');
-- ================================
SELECT dropallfunction_byname('crm_report_sale_of_salepoint_in_month_v5');
CREATE OR REPLACE FUNCTION crm_report_sale_of_salepoint_in_month_v5
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
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_lottery, v_lottery_dup) AND SPL."LotteryPriceId" = v_lottery_price_id AND SPL."LotteryChannelId" < 1000), 0) AS "TotalRetail",																						-- Vé thường bán lẻ
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_lottery, v_lottery_dup) AND SPL."LotteryPriceId" = v_lottery_price_id AND SPL."LotteryChannelId" < 1000), 0) AS "TotalRetailMoney",																				-- Vé thường bán lẻ thành tiền
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_lottery, v_lottery_dup) AND SPL."LotteryPriceId" <> v_lottery_price_id AND SPL."LotteryChannelId" < 1000), 0) AS "TotalWholesale",																					-- Vé thường bán sỉ
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_lottery, v_lottery_dup) AND SPL."LotteryPriceId" <> v_lottery_price_id AND SPL."LotteryChannelId" < 1000), 0) AS "TotalWholesaleMoney",																			-- Vé thường bán sỉ thành tiền

			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1000) , 0) AS "TotalScratchRetailOfCity",																																	-- Cào TP lẻ
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1001) , 0) AS "TotalScratchRetailOfCaMau",																																	-- Cào ĐN lẻ
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1002) , 0) AS "TotalOfBocLe",																																				-- Bóc lẻ ???
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1003) , 0) AS "TotalOfXo5K",																																					-- XO 5K lẻ ???
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1004) , 0) AS "TotalOfXo2K",																																					-- XO 2K lẻ ???

			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1000 AND SPL."LotteryPriceId" = 1) , 0) AS "TotalRetailMoneyRetailOfCity",																									-- Cào TP lẻ thành tiền
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1001 AND SPL."LotteryPriceId" = 1) , 0) AS "TotalRetailMoneyRetailOfCaMau",																								-- Cào ĐN lẻ thành tiền
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1002) , 0) AS "TotalRetailMoneyBocLe",																																		-- Bóc lẻ ??? thành tiền
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1003) , 0) AS "TotalRetailMoneyXo5K",																																		-- XO 5K lẻ ??? thành tiền
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1004) , 0) AS "TotalRetailMoneyXo2K",																																		-- XO 2K lẻ ??? thành tiền

			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1000 AND SPL."LotteryPriceId" != 1) , 0) AS "TotalScratchWholesaleOfCity",																									-- Cào TP sỉ
			COALESCE(SUM(SPL."Quantity") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1001 AND SPL."LotteryPriceId" != 1) , 0) AS "TotalScratchWholesaleOfCaMau",																									-- Cào ĐN sỉ

			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1000 AND SPL."LotteryPriceId" != 1)  , 0) AS "TotalWholesaleMoneyOfCity",																									-- Cào TP sỉ thành tiền
			COALESCE(SUM(SPL."TotalValue") FILTER (WHERE SPL."LotteryTypeId" IN (v_scratch) AND SPL."LotteryChannelId" = 1001 AND SPL."LotteryPriceId" != 1) , 0) AS "TotalWholesaleMoneyOfCaMau"																									-- Cào ĐN sỉ thành tiền

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
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 1) AS "WinningLotteryPrice",										--Trúng vé thường
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 2) AS "ThreeSpecialPrice",											--Ba số đặc biệt
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 3) AS "FourSpecialPrice",											--Bốn số đặc biệt
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 4) AS "TwoSpecialPrice",											--Hoàn vé
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 5) AS "VietlottPrice",												--Trả thưởng vietlott
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 6) AS "LotoPrice",													--Trả thưởng loto
			SUM(W."WinningPrice") FILTER (WHERE W."WinningTypeId" = 7) AS "PromotionPrice",
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 1) AS "WinningLottery",													--Trúng vé thường
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 2) AS "ThreeSpecial",													--Ba số đặc biệt
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 3) AS "FourSpecial",													--Bốn số đặc biệt
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 4) AS "TwoSpecial",														--Hoàn vé
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 5) AS "Vietlott",														--Trả thưởng vietlott
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 6) AS "Loto",
			SUM(W."Quantity") FILTER (WHERE W."WinningTypeId" = 7) AS "Promotion"		
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
			SUM(I."TotalRemaining" + I."TotalDupRemaining") AS "TotalRemaining",														-- Ôm ế
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
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 1), 0) AS "FeeOutSite",						--Chi phí ngoài
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 2), 0) AS "SaleOfVietlott",					--Doanh thu Vietlott
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 3), 0) AS "SaleOfLoto",						--Doanh thu loto
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 4), 0) AS "PunishUser",						--Phạt nhân viên
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 6), 0) AS "OvertimeUser",						--Tăng ca nhân viên
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 7), 0) AS "AwardUser",						--Thưởng nhân viên
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 8), 0) AS "DebtUser", 						--nợ nhân viên
			COALESCE(SUM(T."Price") FILTER (WHERE T."TransactionTypeId" = 9), 0) AS "PriceVietlott" 					--chi phí vietlott
		FROM "Transaction" T
		WHERE T."IsDeleted" IS FALSE
			AND TO_CHAR(T."Date", 'YYYY-MM') = p_month
		GROUP BY 
			T."SalePointId"
	),
	--Lấy lương chi cho nhân viên chưa tính các loại thưởng phạt chỉ có target
	tmp10 AS (
		SELECT 	
			((T."SalaryData"::JSON)->>'SalePointId')::INT AS "SalePointId",
			SUM(COALESCE(((T."SalaryData"::JSON)->>'TotalSalary')::NUMERIC, 0)) AS "TotalSalary"
		FROM crm_get_salary_of_user_by_month_v4(p_month,0) T
		GROUP BY ((T."SalaryData"::JSON)->>'SalePointId')::INT
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
		FROM crm_salepoint_get_commision_of_all_user_in_month_v3(p_month) C
		WHERE C."UserId" = 0
		GROUP BY
			C."SalePointId"
	),
	tmp13 AS (
		SELECT 
			SP.*,
			COALESCE(SPL."TotalRetail", 0) AS "TotalRetail",																						--Thường lẻ
			COALESCE(SPL."TotalRetailMoney", 0) AS "TotalRetailMoney",

			COALESCE(SPL."TotalWholesale", 0) AS "TotalWholesale",																					--Thường sỉ
			COALESCE(SPL."TotalWholesaleMoney", 0) AS "TotalWholesaleMoney",

			COALESCE(SPL."TotalScratchRetailOfCity", 0) AS "TotalScratchRetailOfCity",																--Cào TP lẻ
			COALESCE(SPL."TotalRetailMoneyRetailOfCity", 0) AS "TotalRetailMoneyRetailOfCity",

			COALESCE(SPL."TotalScratchWholesaleOfCity", 0) AS "TotalScratchWholesaleOfCity",														--Cào TP sỉ
			COALESCE(SPL."TotalWholesaleMoneyOfCity", 0) AS "TotalWholesaleMoneyOfCity",

			COALESCE(SPL."TotalScratchRetailOfCaMau", 0) AS "TotalScratchRetailOfCaMau",															--Cào ĐN lẻ
			COALESCE(SPL."TotalRetailMoneyRetailOfCaMau", 0) AS "TotalRetailMoneyRetailOfCaMau",

			COALESCE(SPL."TotalScratchWholesaleOfCaMau", 0) AS "TotalScratchWholesaleOfCaMau",														--Cào ĐN sỉ
			COALESCE(SPL."TotalWholesaleMoneyOfCaMau", 0) AS "TotalWholesaleMoneyOfCaMau",

			COALESCE(SPL."TotalOfBocLe", 0) AS "TotalOfBocLe",																						--Bóc lẻ
			COALESCE(SPL."TotalRetailMoneyBocLe", 0) AS "TotalRetailMoneyBocLe",

			COALESCE(SPL."TotalOfXo5K", 0) AS "TotalOfXo5K",																						--XO 5K lẻ
			COALESCE(SPL."TotalRetailMoneyXo5K", 0) AS "TotalRetailMoneyXo5K",

			COALESCE(SPL."TotalOfXo2K", 0) AS "TotalOfXo2K",																						--XO 2K lẻ
			COALESCE(SPL."TotalRetailMoneyXo2K", 0) AS "TotalRetailMoneyXo2K",

			COALESCE(K."TotalRemaining", 0) AS "TotalRemaining",																					--Ôm ế

			COALESCE(W."TwoSpecial", 0) AS "TwoSpecial",																							--Hoàn vé
			COALESCE(W."TwoSpecialPrice", 0) AS "TwoSpecialPrice",

			COALESCE(W."ThreeSpecial", 0) AS "ThreeSpecial",																						--3 số đặc biệt
			COALESCE(W."ThreeSpecialPrice", 0) AS "ThreeSpecialPrice",

			COALESCE(W."FourSpecial", 0) AS "FourSpecial",																							--4 số đặc biệt
			COALESCE(W."FourSpecialPrice", 0) AS "FourSpecialPrice",

			COALESCE(C."TotalCommission", 0) AS "TotalCommission",																					--Hoa hồng đổi số trúng

			COALESCE(T."SaleOfVietlott", 0) AS "SaleOfVietlott",																					--Hoa hồng đổi số trúng

			COALESCE(T."SaleOfVietlott" * 0.055 , 0) AS "HoaHong5_5",																				--Hoa hồng 5.5% = Doanh thu Vietlott * 5.5% 				(1)

			COALESCE(((T."SaleOfVietlott" * 0.055) * 0.015) / 0.055 , 0) AS "HoaHong1_5",															--Hoa hồng 1.5% = ((Hoa hồng 5.5%)*1.5%)/5.5%				(2)

			COALESCE(W."VietlottPrice" * 0.002, 0) AS "HoaHong0_2",																					--Hoa hồng trả thưởng 0.2% = Trả thưởng Vietlott * 0.2%		(3)

			COALESCE(((T."SaleOfVietlott" * 0.055) + (((T."SaleOfVietlott" * 0.055) * 0.015) / 0.055) + (W."VietlottPrice" * 0.002)) * 0.05, 0) AS "ThueTNCN",				--Thuế TNCN= (1 + 2 + 3) * 5%

			COALESCE(T."SaleOfLoto", 0) AS "SaleOfLoto",																							--Doanh thu Lotto

			COALESCE(W."Loto", 0) AS "Loto",																										--Trả thưởng Lotto
			COALESCE(W."LotoPrice", 0) AS "LotoPrice",

			COALESCE(S."TotalSalary", 0) AS "TotalSalary",																							--Tổng tiền trả lương thường

			COALESCE(S."TotalSalary" , 0)::NUMERIC AS "TotalSale"																							

		FROM tmp SP
			LEFT JOIN tmp0 SPL ON SP."SalePointId" = SPL."SalePointId"
			LEFT JOIN tmp1 W ON SP."SalePointId" = W."SalePointId"
			LEFT JOIN tmp7 I ON SP."SalePointId" = I."SalePointId"
			LEFT JOIN tmp8 K ON SP."SalePointId" = K."SalePointId"
			LEFT JOIN tmp9 T ON SP."SalePointId" = T."SalePointId"
			LEFT JOIN tmp10 S ON SP."SalePointId" = S."SalePointId"
			LEFT JOIN tmp11 IFL ON SP."SalePointId" = IFL."SalePointId"
			LEFT JOIN tmp12 C ON SP."SalePointId" = C."SalePointId"
	),tmp13_1 AS(
		SELECT IL."SalePointId", IL."LotteryChannelId", IL."AgencyId",IL."TotalReceived",IL."LotteryDate" FROM tmp T LEFT JOIN "InventoryLog" IL ON IL."SalePointId" = T."SalePointId" 
		WHERE TO_CHAR(IL."LotteryDate",'YYYY-MM') = p_month AND IL."LotteryDate" <= NOW()::DATE
		GROUP BY IL."SalePointId", IL."LotteryChannelId", IL."AgencyId", IL."TotalReceived", IL."LotteryDate" ORDER BY IL."LotteryDate" 
		),tmp13_5 AS(
		SELECT SUM(IL."TotalReceived") AS "TotalReceived", IL."SalePointId"
		FROM tmp13_1 IL
		GROUP BY IL."SalePointId"
		)
		,tmp13_2 AS(
		SELECT  IL."SalePointId",IL."AgencyId",IL."LotteryChannelId",IL."LotteryDate"
		FROM tmp13_1 IL
		),tmp13_3 AS(
		SELECT ROW_NUMBER () OVER (PARTITION BY T."SalePointId" ORDER BY T."LotteryDate" DESC) AS "Id",L."Price"  , T."SalePointId"
			FROM tmp13_2 T
			LEFT JOIN "LotteryPriceAgency" L ON L."AgencyId" = T."AgencyId" AND L."LotteryChannelId" = T."LotteryChannelId"
-- 		GROUP BY L."Price", T."SalePointId"
		),tmp13_4 AS ( SELECT T."Price",T."SalePointId" FROM tmp13_3 T WHERE T."Id" = 1 ),
		tmp14_1 AS(
		SELECT IL."SalePointId", IL."LotteryChannelId",IL."TotalReceived",IL."ActionDate"::DATE FROM tmp T LEFT JOIN "ScratchcardLog" IL ON IL."SalePointId" = T."SalePointId" 
		WHERE TO_CHAR(IL."ActionDate",'YYYY-MM') = '2023-04' AND IL."ActionDate"::DATE <= NOW()::DATE
-- 		GROUP BY IL."ActionDate", IL."SalePointId", IL."LotteryChannelId", IL."TotalReceived" ORDER BY IL."ActionDate" ::DATE
		),tmp14_0 AS(
			SELECT T.* FROM tmp14_1 T  GROUP BY T."ActionDate",T."SalePointId", T."LotteryChannelId", T."TotalReceived" ORDER BY T."ActionDate" 
			)
		,tmp14_5 AS(
		SELECT SUM(IL."TotalReceived") AS "TotalReceived", IL."SalePointId"
		FROM tmp14_1 IL
		GROUP BY IL."SalePointId"
		),tmp14_2 AS(
		SELECT  IL."SalePointId",IL."LotteryChannelId",IL."ActionDate"::DATE
		FROM tmp14_1 IL
		),tmp14_3 AS(
		SELECT ROW_NUMBER () OVER (PARTITION BY T."SalePointId" ORDER BY T."ActionDate" DESC) AS "Id",L."Price"  , T."SalePointId"
			FROM tmp14_2 T
			LEFT JOIN "LotteryPriceAgency" L ON  L."LotteryChannelId" = T."LotteryChannelId"
-- 		GROUP BY L."Price", T."SalePointId"
		),tmp14_4 AS ( SELECT T."Price",T."SalePointId" FROM tmp14_3 T WHERE T."Id" = 1 ),
	tmp14 AS (
		SELECT 
			T."SalePointId",
			T."SalePointName",
			TRANSLATE(T."MainUserId"::TEXT,'{}', '[]') AS "MainUserId",
			TRANSLATE(T."PercentMainUserId"::TEXT,'{}', '[]') AS "PercentMainUserId",
			ROUND(T."TotalRetail", 0) AS "TotalRetail",																									--Thường lẻ
 			ROUND(T."TotalRetailMoney", 0) AS "TotalRetailMoney",
			
			ROUND(T."TotalWholesale", 0) AS "TotalWholesale",																							--Thường sỉ
 			ROUND(T."TotalWholesaleMoney", 0) AS "TotalWholesaleMoney",

			ROUND(T."TotalScratchRetailOfCity", 0) AS "TotalScratchRetailOfCity",																		--cào TP lẻ
 			ROUND(T."TotalRetailMoneyRetailOfCity", 0) AS "TotalRetailMoneyRetailOfCity",

			ROUND(T."TotalScratchWholesaleOfCity", 0) AS "TotalScratchWholesaleOfCity",																	--cào TP sỉ
 			ROUND(T."TotalWholesaleMoneyOfCity", 0) AS "TotalWholesaleMoneyOfCity",

			ROUND(T."TotalScratchRetailOfCaMau", 0) AS "TotalScratchRetailOfCaMau",																		--cào ĐN lẻ
 			ROUND(T."TotalRetailMoneyRetailOfCaMau", 0) AS "TotalRetailMoneyRetailOfCaMau",

			ROUND(T."TotalScratchWholesaleOfCaMau", 0) AS "TotalScratchWholesaleOfCaMau",																--cào ĐN sỉ
 			ROUND(T."TotalWholesaleMoneyOfCaMau", 0) AS "TotalWholesaleMoneyOfCaMau",

			ROUND(T."TotalOfBocLe", 0) AS "TotalOfBocLe",																								--Bóc lẻ
 			ROUND(T."TotalRetailMoneyBocLe", 0) AS "TotalRetailMoneyBocLe",

			ROUND(T."TotalOfXo5K", 0) AS "TotalOfXo5K",																									--XO 5K lẻ
 			ROUND(T."TotalRetailMoneyXo5K", 0) AS "TotalRetailMoneyXo5K",

			ROUND(T."TotalOfXo2K", 0) AS "TotalOfXo2K",																									--XO 2K lẻ
 			ROUND(T."TotalRetailMoneyXo2K", 0) AS "TotalRetailMoneyXo2K",

			ROUND(T."TotalRemaining", 0) AS "TongOmE",																									--Ôm ế
			ROUND(T."TotalRemaining", 0) * 10000 AS "TongOmEThanhTien",

			ROUND(T."TwoSpecial", 0) AS "TwoSpecial",																									--Hoàn vé
			ROUND(T."TwoSpecialPrice", 0) "TwoSpecialPrice",

			ROUND(T."ThreeSpecial", 0) AS "ThreeSpecial",																								--3 số đặc biệt
			ROUND(T."ThreeSpecialPrice", 0) "ThreeSpecialPrice",

			ROUND(T."FourSpecial", 0) AS "FourSpecial",																									--4 số đặc biệt
			ROUND(T."FourSpecialPrice", 0) "FourSpecialPrice",

			ROUND(T."TotalCommission", 0) AS "TotalCommission",																							--Hoa hồng đổi số trúng

			ROUND(T."SaleOfVietlott", 0) AS "SaleOfVietlott",																									--Sale of Vietlott
			
			ROUND(T."HoaHong5_5", 0) AS "HoaHong5_5",																									--Hoa hồng 5.5%

			ROUND(T."HoaHong1_5", 0) AS "HoaHong1_5",																									--Hoa hồng 1.5%

			ROUND(T."HoaHong0_2", 0) AS "HoaHong0_2",																									--Hoa hồng trả thưởng 0.2%

			ROUND(T."ThueTNCN", 0) AS "ThueTNCN",																										--Thuế TNCN

			ROUND(T."SaleOfLoto", 0) AS "SaleOfLoto",																									--Doanh so Lotto

			ROUND(T."Loto", 0) AS "Loto",																												--Loto
			ROUND(T."LotoPrice", 0) AS "LotoPrice",																										

			ROUND(T."TotalSalary", 0) AS "TotalAllSalary",																								--Tổng tiền lương																																	
			ROUND(COALESCE(T."TotalSalary" , 0),0)  AS "EmployeeSalary",
			3000000 AS "ManagerSalary",
			1500000 AS "DistributorSalary",
			855000 AS "HRSalary",

			ROUND(T."TotalSale", 0) AS "TotalSale",	
			

			(SELECT SUM(SF."ElectronicFee") FROM "StaticFee" SF WHERE SF."SalePointId" = T."SalePointId" AND SF."StaticFeeId" =  4 AND SF."Month" = p_month) AS "ElectronicFee",				--Tiền điện
			(SELECT SUM(SF."WaterFee") FROM "StaticFee" SF WHERE SF."SalePointId" = T."SalePointId" AND SF."StaticFeeId" =  2 AND SF."Month" = p_month) AS "WaterFee",							--Tiền nước
			(SELECT SUM(SF."InternetFee") FROM "StaticFee" SF WHERE SF."SalePointId" = T."SalePointId" AND SF."StaticFeeId" =  3 AND SF."Month" = p_month) AS "InternetFee",					--Tiền internet
			(SELECT SUM(SF."EstateFee") FROM "StaticFee" SF WHERE SF."SalePointId" = T."SalePointId" AND SF."StaticFeeId" =  1 AND SF."Month" = p_month) AS "EstateFee"							--Tiền mặt bằng

		FROM tmp13 T
	),
	tmp15 AS
	(
		SELECT
		T1.*,
		json_build_object(
				'ElectronicFee',
				COALESCE(T1."ElectronicFee",0),
				'WaterFee',
				COALESCE(T1."WaterFee",0),
				'InternetFee',
				COALESCE(T1."InternetFee",0),
				'EstateFee',
				COALESCE(T1."EstateFee",0),
				'TotalFee',
				COALESCE(T1."ElectronicFee",0) + COALESCE(T1."WaterFee",0) + COALESCE(T1."InternetFee",0) +  COALESCE(T1."EstateFee",0)
		) AS "StaticFee",
		json_build_object(
				'ThreeSpecial',
				T1."ThreeSpecial",
				'FourSpecialPrice',
				T1."FourSpecialPrice",
				'TwoSpecialPrice',
				T1."TwoSpecialPrice",
				'TotalPrice',
				T1."ThreeSpecial" + T1."FourSpecialPrice" + T1."TwoSpecialPrice"
		) AS "Prize"
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