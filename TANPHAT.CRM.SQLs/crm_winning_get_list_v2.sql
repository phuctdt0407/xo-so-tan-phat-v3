-- ================================
-- Author: Quang
-- Description: Lấy danh sách trúng thưởng
-- Created date: 03/06/2022
-- SELECT * FROM crm_winning_get_list_v2(433,1,'2022-06-03');
-- ================================
SELECT dropallfunction_byname('crm_winning_get_list_v2');
CREATE OR REPLACE FUNCTION crm_winning_get_list_v2
(
	p_shift_dis_id INT,
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
			LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = W."LotteryChannelId"
			LEFT JOIN "SalePoint" SP ON SP."SalePointId" = W."SalePointId"
			LEFT JOIN "SalePoint" SP2 ON SP2."SalePointId" = W."FromSalePointId"
		WHERE W."ShiftDistributeId" = p_shift_dis_id
			AND (p_date IS NULL OR W."ActionDate"::DATE = p_date::DATE)
		ORDER BY "ActionDate" DESC;	
END;
$BODY$
LANGUAGE plpgsql VOLATILE