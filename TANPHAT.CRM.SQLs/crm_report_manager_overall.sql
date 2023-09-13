-- ================================
-- Author: Phi
-- Description: Lấy report tổng cho trưởng nhóm
-- Created date: 01/04/2022
-- SELECT * FROM crm_report_manager_overall(5,'2022-04-01',1);
-- ================================
SELECT dropallfunction_byname('crm_report_manager_overall');
CREATE OR REPLACE FUNCTION crm_report_manager_overall
(
	p_user_role_id INT,
	p_lottery_date TIMESTAMP,
	p_sale_point_id INT
)
RETURNS TABLE
(
	"ScratchcardData" TEXT,
	"LotteryData" TEXT,
	"RepaymentData" TEXT,
	"WinningData" TEXT
)
AS $BODY$
BEGIN

	RETURN QUERY 
	SELECT
	(
		SELECT array_to_json(
			ARRAY_AGG (r))
		FROM
		(
			SELECT
				ST."ShiftId",
				S."ShiftName",
				ST."TotalReceived",
				ST."TotalRemaining",
				ST."TotalSold",
				ST."TotalSoldMoney"
			FROM "ShiftTransfer" ST
				JOIN "Shift" S ON S."ShiftId" = ST."ShiftId"
			WHERE "LotteryTypeId" = 3 
				AND "ActionDate"::DATE = p_lottery_date::DATE
				AND (COALESCE(p_sale_point_id, 0)= 0 OR ST."SalePointid" = p_sale_point_id)
		) r
	)::TEXT AS "ScratchcardData",
	(
		SELECT array_to_json(
			ARRAY_AGG (r))
		FROM
		(
			SELECT
				ST."ShiftId",
				S."ShiftName",
				ST."UserId",
				U."FullName",
				SUM(ST."TotalReceived") AS "TotalReceived",
				SUM(ST."TotalRemaining") AS "TotalRemaining",
				ST."LotteryChannelId",
				LC."ShortName",
				ST."LotteryDate",
				SUM(ST."TotalTrans") AS "TotalTrans",
				SUM(ST."TotalReturns") AS "TotalReturns",
				SUM(ST."TotalStocks") AS "TotalStocks",
				SUM(ST."TotalSold") AS "TotalSold",
				SUM(ST."TotalSoldMoney") AS "TotalSoldMoney",
				ST."SalePointid",
				SP."SalePointName"
			FROM "ShiftTransfer" ST
				JOIN "Shift" S ON S."ShiftId" = ST."ShiftId"
				JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = ST."LotteryChannelId"
				JOIN "User" U ON U."UserId" = ST."UserId"
				JOIN "SalePoint" SP ON SP."SalePointId" = ST."SalePointid"
			WHERE ST."LotteryTypeId" <> 3 
				AND ST."ActionDate"::DATE = p_lottery_date::DATE
				AND (COALESCE(p_sale_point_id, 0)= 0 OR ST."SalePointid" = p_sale_point_id)
			GROUP BY
				ST."ShiftId",
				S."ShiftName",
				ST."UserId",
				U."FullName",
				ST."LotteryChannelId",
				LC."ShortName",
				ST."LotteryDate",
				ST."SalePointid",
				SP."SalePointName",
				LC."DayIds",
				LC."LotteryChannelTypeId"
			ORDER BY ST."ShiftId", ST."LotteryDate", LC."DayIds", LC."LotteryChannelTypeId"
		) r
	)::TEXT AS "LotteryData",
	(
		SELECT array_to_json(
			ARRAY_AGG (r))
		FROM
		(
			SELECT
				R."SalePointId",
				SP."SalePointName",
				SD."ShiftId",
				S."ShiftName",
				SUM(R."Amount") AS "TotalRepay"
			FROM "Repayment" R
				JOIN "ShiftDistribute" SD ON SD."ShiftDistributeId" = R."ShiftDistributeId"
				JOIN "Shift" S ON S."ShiftId" = SD."ShiftId"
				JOIN "SalePoint" SP ON SP."SalePointId" = R."SalePointId"
			WHERE R."ActionDate"::DATE = p_lottery_date::DATE
				AND (COALESCE(p_sale_point_id, 0)= 0 OR R."SalePointId" = p_sale_point_id)
			GROUP BY
				R."SalePointId",
				SP."SalePointName",
				SD."ShiftId",
				S."ShiftName"
		) r
	)::TEXT AS "RepaymentData",
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
	)::TEXT AS "WinningData";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE