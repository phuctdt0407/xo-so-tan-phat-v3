-- ================================
-- SELECT * FROM crm_winning_get_list_by_month('2023-03');
-- ================================
SELECT dropallfunction_byname('crm_winning_get_list_by_month');
CREATE OR REPLACE FUNCTION crm_winning_get_by_month
(
	p_month VARCHAR
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
	v_last_date DATE := ((p_month||'-01' )::date  + interval '1 month' - interval '1 day')::date;
	v_pre_last_date DATE := ((p_month||'-01' )::date - interval '1 day')::date;
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
		WHERE TO_CHAR(W."ActionDate",'YYYY-MM')= p_month
		GROUP BY SP."SalePointName", SP2."SalePointName", LC."LotteryChannelName", W."WinningId", WT."WinningTypeName", W."SalePointId", W."WinningTypeId", W."ActionDate":: DATE
        ORDER BY SP."SalePointName", SP2."SalePointName", LC."LotteryChannelName", W."WinningId", WT."WinningTypeName", W."SalePointId", W."WinningTypeId", W."ActionDate":: DATE;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;