-- ================================
-- Author: Phi
-- Description: Lấy danh sách trúng thưởng
-- Created date: 30/03/2022
-- SELECT * FROM crm_winning_get_list(5,5,'2022-03-29');
-- ================================
SELECT dropallfunction_byname('crm_winning_get_list');
CREATE OR REPLACE FUNCTION crm_winning_get_list
(
	p_user_role_id INT,
	p_sale_point_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"WinningId" INT,
	"WinningTypeId" INT,
	"WinningTypeName" VARCHAR,
	"LotteryNumber" VARCHAR,
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"Quantity" INT,
	"WinningPrice" NUMERIC,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"ActionDate" TIMESTAMP,
	"FromSalePointId" INT,
	"FromSalePointName" VARCHAR,
	"SalePointId" INT,
	"SalePointName" VARCHAR
)
AS $BODY$
DECLARE
	v_sale_point_id INT;
	v_shift_dis_id INT;
	v_is_super_admin BOOL;
	v_is_manager BOOL;
	v_is_staff BOOL;
BEGIN
	
	SELECT 
		f."IsSuperAdmin",
		f."IsManager",
		f."IsStaff",
		f."SalePointId",
		f."ShiftDistributeId"
	INTO v_is_super_admin, v_is_manager, v_is_staff, v_sale_point_id, v_shift_dis_id
	FROM fn_get_shift_info(p_user_role_id) f;
	
	v_is_super_admin := TRUE;
	
	
	IF v_is_super_admin IS TRUE OR v_is_manager IS TRUE THEN
		
		RETURN QUERY 
		SELECT 
			W."WinningId",
			W."WinningTypeId",
			WT."WinningTypeName",
			W."LotteryNumber",
			W."LotteryChannelId",
			LC."LotteryChannelName",
			W."Quantity",
			W."WinningPrice",
			W."ActionBy",
			W."ActionByName",
			W."ActionDate",
			W."FromSalePointId",
			SP2."SalePointName",
			W."SalePointId",
			SP."SalePointName"
		FROM "Winning" W
			JOIN "WinningType" WT ON WT."WinningTypeId" = W."WinningTypeId"
			JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = W."LotteryChannelId"
			JOIN "SalePoint" SP ON SP."SalePointId" = W."SalePointId"
			LEFT JOIN "SalePoint" SP2 ON SP2."SalePointId" = W."FromSalePointId"
		WHERE (COALESCE(p_sale_point_id, 0) = 0 OR W."SalePointId" = p_sale_point_id)
			AND (p_date IS NULL OR W."ActionDate"::DATE = p_date::DATE)
		ORDER BY "ActionDate" DESC;
		
	ELSE
	
		RETURN QUERY 
		SELECT 
			W."WinningId",
			W."WinningTypeId",
			WT."WinningTypeName",
			W."LotteryNumber",
			W."LotteryChannelId",
			LC."LotteryChannelName",
			W."Quantity",
			W."WinningPrice",
			W."ActionBy",
			W."ActionByName",
			W."ActionDate",
			W."FromSalePointId",
			SP2."SalePointName",
			W."SalePointId",
			SP."SalePointName"
		FROM "Winning" W
			JOIN "WinningType" WT ON WT."WinningTypeId" = W."WinningTypeId"
			JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = W."LotteryChannelId"
			JOIN "SalePoint" SP ON SP."SalePointId" = W."SalePointId"
			LEFT JOIN "SalePoint" SP2 ON SP2."SalePointId" = W."FromSalePointId"
		WHERE W."ShiftDistributeId" = v_shift_dis_id
			AND (p_date IS NULL OR W."ActionDate"::DATE = p_date::DATE)
		ORDER BY "ActionDate" DESC;
	
	END IF;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE