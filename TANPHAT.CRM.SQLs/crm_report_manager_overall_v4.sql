-- ================================
-- Author: Phi
-- Description: Lấy report tổng cho trưởng nhóm
-- Created date: 01/04/2022
-- SELECT * FROM crm_report_manager_overall_v4(12,'2023-03-03',1);
-- ================================
SELECT dropallfunction_byname('crm_report_manager_overall_v4');
CREATE OR REPLACE FUNCTION crm_report_manager_overall_v4
(
	p_user_role_id INT,
	p_lottery_date TIMESTAMP,
	p_sale_point_id INT
)
RETURNS TABLE
(
	"ScratchcardData" TEXT,
	"LotteryData" TEXT,
	"WinningData" TEXT,
	"MoneyData" TEXT
)
AS $BODY$
DECLARE
	v_role_1 INT;
	v_shift_dis_1 INT;
	v_role_2 INT;
	v_shift_dis_2 INT;
BEGIN
	--Lấy ca 1
	SELECT UR."UserRoleId", SD."ShiftDistributeId"
	INTO v_role_1, v_shift_dis_1
	FROM "ShiftDistribute" SD 
		JOIN "UserRole" UR ON UR."UserId" = SD."UserId"
	WHERE "SalePointId" = p_sale_point_id AND "DistributeDate"::DATE = p_lottery_date::DATE AND "ShiftId" = 1;
	--Lấy ca 2
	SELECT UR."UserRoleId", SD."ShiftDistributeId"
	INTO v_role_2, v_shift_dis_2
	FROM "ShiftDistribute" SD 
		JOIN "UserRole" UR ON UR."UserId" = SD."UserId"
	WHERE "SalePointId" = p_sale_point_id AND "DistributeDate"::DATE = p_lottery_date::DATE AND "ShiftId" = 2;
	
	raise notice 'v_role_1: %, v_shift_dis_1: %, v_role_2: %, v_shift_dis_2: %', v_role_1, v_shift_dis_1, v_role_2, v_shift_dis_2;
	RETURN QUERY 
	WITH tmp AS (
		SELECT 1 AS "ShiftId", f.* FROM crm_report_data_finish_shift_v4(v_role_1, v_shift_dis_1, p_lottery_date) f
		UNION
		SELECT 2 AS "ShiftId", f.* FROM crm_report_data_finish_shift_v4(v_role_2, v_shift_dis_2, p_lottery_date) f
	)
	SELECT
	(
		SELECT array_to_json(
			ARRAY_AGG (r))
		FROM
		(
			SELECT t.* FROM tmp t WHERE t."LotteryTypeId" = 3
		) r
	)::TEXT AS "ScratchcardData",
	(
		SELECT array_to_json(
			ARRAY_AGG (r))
		FROM
		(
				SELECT 
					t.*,
					LC."ShortName"
				FROM tmp t 
					JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = t."LotteryChannelId"
				WHERE (t."TotalStocks" <> 0 OR t."TotalTrans" <> 0 OR t."TotalReceived" <> 0 OR t."TotalRemaining" <> 0 OR t."TotalSold" <> 0 OR t."LotteryTypeId" = 1 )
				ORDER BY t."ShiftId", t."LotteryDate",t."LotteryTypeId" <> 2, t."LotteryTypeId", LC."DayIds", LC."LotteryChannelTypeId"
		) r
	)::TEXT AS "LotteryData",
	(
		SELECT array_to_json(
			ARRAY_AGG (r))
		FROM
		(
			SELECT
				W."WinningTypeId",
				WT."WinningTypeName",
				S."ShiftId",
				S."ShiftName",
				SUM(W."Quantity") AS "TotalQuantity",
				SUM(W."WinningPrice") AS "TotalPrice"
			FROM "Winning" W
				JOIN "ShiftDistribute" SD ON SD."ShiftDistributeId" = W."ShiftDistributeId"
				JOIN "Shift" S ON S."ShiftId" = SD."ShiftId"
				JOIN "SalePoint" SP ON SP."SalePointId" = W."SalePointId"
				JOIN "WinningType" WT ON WT."WinningTypeId" = W."WinningTypeId"
			WHERE W."ActionDate"::DATE = p_lottery_date::DATE
				AND (COALESCE(p_sale_point_id, 0)= 0 OR W."SalePointId" = p_sale_point_id)
			GROUP BY
				W."WinningTypeId",
				WT."WinningTypeName",
				S."ShiftId",
				S."ShiftName"
		) r
	)::TEXT AS "WinningData",
	(
			SELECT array_to_json(
			ARRAY_AGG (md))
			FROM(
						WITH Moneydata AS
						(
						-- 2 bảng transaction va report money  "TransactionTypeId" IN (2,3)) se chi co duy nhat 1 dong nen sum dc.
								(SELECT 
									1::INT AS "ShiftId",
									COALESCE( SUM(T."TotalPrice") FILTER (WHERE  T."TransactionTypeId" = 2 ),0) AS "Vietllot",
									COALESCE( SUM(T."TotalPrice") FILTER (WHERE  T."TransactionTypeId" = 3 ),0) AS "Loto",
									COALESCE( SUM(T."TotalPrice") FILTER (WHERE  T."TransactionTypeId" = 1 ),0) AS "Cost",
									COALESCE((SELECT SUM( G."TotalPrice") FROM "GuestAction" G WHERE G."ShiftDistributeId" = v_shift_dis_1 AND G."SalePointId" = p_sale_point_id AND G."CreatedDate"::DATE = p_lottery_date::DATE AND G."IsDeleted" = FALSE AND G."GuestActionTypeId" = 2 AND G."DoneTransfer" = TRUE),0) AS "TransferConfirmed",
									COALESCE((SELECT SUM( G."TotalPrice") FROM "GuestAction" G WHERE G."ShiftDistributeId" = v_shift_dis_1 AND G."SalePointId" = p_sale_point_id AND G."CreatedDate"::DATE = p_lottery_date::DATE AND G."IsDeleted" = FALSE AND G."GuestActionTypeId" = 1 AND G."DoneTransfer" = TRUE),0)  AS "TransferToGuest",
									 SUM(R."TotalMoneyInDay")  AS "TotalMoneyInDay"
								FROM "Transaction" T 
								LEFT JOIN "ReportMoney" R ON R."ShiftDistributeId" = v_shift_dis_1
									AND R."ActionDate" = p_lottery_date::DATE
									AND R."ShiftId" = 1
								WHERE T."Date" = p_lottery_date::DATE 
									AND T."SalePointId" = p_sale_point_id
									AND T."ShiftDistributeId" = v_shift_dis_1
								GROUP BY T."SalePointId",T."TransactionTypeId",T."Date",R."TotalMoneyInDay"
								ORDER BY T."TransactionTypeId"
								)
								UNION 
								(SELECT 
									2::INT AS "ShiftId",
									COALESCE( SUM(T."TotalPrice") FILTER (WHERE  T."TransactionTypeId" = 2 ),0) AS "Vietllot",
									COALESCE( SUM(T."TotalPrice") FILTER (WHERE  T."TransactionTypeId" = 3 ),0) AS "Loto",
									COALESCE( SUM(T."TotalPrice") FILTER (WHERE  T."TransactionTypeId" = 1 ),0) AS "Cost",
									COALESCE((SELECT SUM( G."TotalPrice") FROM "GuestAction" G WHERE G."ShiftDistributeId" = v_shift_dis_2 AND G."SalePointId" = p_sale_point_id AND G."CreatedDate"::DATE = p_lottery_date::DATE AND G."IsDeleted" = FALSE AND G."GuestActionTypeId" = 2 AND G."DoneTransfer" = TRUE),0) AS "TransferConfirmed",
									COALESCE((SELECT SUM( G."TotalPrice") FROM "GuestAction" G WHERE G."ShiftDistributeId" = v_shift_dis_2 AND G."SalePointId" = p_sale_point_id AND G."CreatedDate"::DATE = p_lottery_date::DATE AND G."IsDeleted" = FALSE AND G."GuestActionTypeId" = 1 AND G."DoneTransfer" = TRUE),0)  AS "TransferToGuest",
									SUM(R."TotalMoneyInDay")  AS "TotalMoneyInDay"
								FROM "Transaction" T 
								LEFT JOIN "ReportMoney" R ON R."ShiftDistributeId" = v_shift_dis_2 
									AND R."ActionDate" = p_lottery_date::DATE
									AND R."ShiftId" = 2
								WHERE T."Date" = p_lottery_date::DATE AND T."SalePointId" = p_sale_point_id 
									AND T."ShiftDistributeId" = v_shift_dis_2
								GROUP BY T."SalePointId",T."TransactionTypeId",T."Date",R."TotalMoneyInDay"
								ORDER BY T."TransactionTypeId"
								)
						)
							SELECT 
								M."ShiftId",
								SUM(M."Vietllot") AS "Vietllot",
								SUM(M."Loto") AS "Loto",
								SUM(M."Cost") AS "Cost",
								M."TransferConfirmed" AS "TransferConfirmed",
								M."TransferToGuest" AS "TransferToGuest",
								M."TotalMoneyInDay"
							FROM Moneydata M 
							GROUP BY M."ShiftId", M."TotalMoneyInDay",M."TransferToGuest",M."TransferConfirmed"
			)md
	)::TEXT  AS "MoneyData";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE