-- ================================
-- Author: Phi
-- Description: Lấy report tổng cho trưởng nhóm
-- Created date: 01/04/2022
-- SELECT * FROM crm_report_manager_overall_v2(5,'2022-07-13',2);
-- ================================
SELECT dropallfunction_byname('crm_report_manager_overall_v2');
CREATE OR REPLACE FUNCTION crm_report_manager_overall_v2
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

	RETURN QUERY 
	WITH tmp AS (
		SELECT 1 AS "ShiftId", f.* FROM crm_report_data_finish_shift_v2(v_role_1, v_shift_dis_1, p_lottery_date) f
		UNION
		SELECT 2 AS "ShiftId", f.* FROM crm_report_data_finish_shift_v2(v_role_2, v_shift_dis_2, p_lottery_date) f
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
				WHERE (t."TotalStocks" <> 0 OR t."TotalTrans" <> 0 OR t."TotalReceived" <> 0 OR t."TotalRemaining" <> 0 OR t."TotalSold" <> 0 OR t."LotteryTypeId" = 1)
				ORDER BY t."ShiftId", t."LotteryDate",t."LotteryTypeId" <> 2, t."LotteryTypeId", LC."DayIds", LC."LotteryChannelTypeId"
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