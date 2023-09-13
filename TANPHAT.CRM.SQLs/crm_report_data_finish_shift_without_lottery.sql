-- ================================
-- Author: HAVING
-- Description: remove lottery
-- Created date: 19/04/2023
-- SELECT * FROM crm_report_data_finish_shift_without_lottery(30, 15399, '2023-04-19');
-- ================================
SELECT dropallfunction_byname('crm_report_data_finish_shift_without_lottery');
CREATE OR REPLACE FUNCTION crm_report_data_finish_shift_without_lottery
(
	p_user_role INT,
	p_shift_dis_id INT,
	p_lottery_date TIMESTAMP DEFAULT NOW()

)
RETURNS TABLE
(
	"LotteryDate" DATE,
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"LotteryTypeId"	INT,
	"LotteryTypeName" VARCHAR,
	"TotalStocks" INT,
	"TotalTrans" INT8,
	"TotalReceived" INT8,
	"TotalReturns" INT8,
	"TotalRemaining" INT8,
	"TotalSold" INT,
	"TotalSoldMoney" NUMERIC,
	"TotalRetail" INT,
	"TotalRetailMoney" NUMERIC,
	"TotalWholesale" INT,
	"TotalWholesaleMoney" NUMERIC,
	"ShiftDistributeId" INT,
	"ShortName" VARCHAR
)
AS $BODY$
DECLARE
	v_user_id INT;
	v_salepoint_id INT;
	v_shift_id INT;
	v_quantity INT;
	v_total_money NUMERIC;
	v_is_shift INT;
BEGIN
		
	SELECT 
		SD."ShiftId", SD."UserId", SD."SalePointId"
	INTO v_shift_id, v_user_id, v_salepoint_id
	FROM "ShiftDistribute" SD WHERE SD."ShiftDistributeId" =  p_shift_dis_id;
	RETURN QUERY
	WITH LoadData AS 
	(
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
		WHERE T."ShiftDistributeId" = p_shift_dis_id AND T."ConfirmStatusId" = 2 AND T."LotteryChannelId" >999
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
	
	MoneyData AS
	(
		SELECT * FROM crm_get_total_sale_of_sale_point_by_shiftdis(v_salepoint_id, p_shift_dis_id)
	)				
	SELECT 
		NULL::Date,
		A."LotteryChannelId",
		A."LotteryChannelName",
		A."LotteryTypeId",
		A."LotteryTypeName",
		(CASE WHEN A."LotteryTypeId" = 3 
		THEN
			A."FirstStore" - fn_totalreceived(v_salepoint_id, p_lottery_date,A."LotteryChannelId" , v_shift_id) 
		ELSE
			A."FirstStore"
		END) AS "FirstStore",
		A."LotteryTrans",
		(CASE WHEN A."LotteryTypeId" = 3
		THEN
			A."LotteryReceive" + fn_totalreceived(v_salepoint_id, p_lottery_date, A."LotteryChannelId",v_shift_id)
		ELSE
			A."LotteryReceive"
		END) AS "LotteryReceive",
		A."LotteryReturn" ,
		(CASE WHEN v_shift_id = 1
		THEN
			(A."FirstStore" - A."LotteryTrans" + A."LotteryReceive" - A."TotalSell" - fn_totalreceived(v_salepoint_id, p_lottery_date,A."LotteryChannelId" ,2))
		ELSE
			(A."FirstStore" - A."LotteryTrans" + A."LotteryReceive" - A."TotalSell")
		END ) AS "TotalRemaining",
		A."TotalSell",
		A."TotalSoldMoney",
		A."TotalRetail",
		A."TotalRetailMoney",
		A."TotalWholesale",
		A."TotalWholesaleMoney",
		A."ShiftDistributeId",
		COALESCE(LC."ShortName",'Vé cào')
	FROM 
	(

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
			--COALESCE(crm_get_current_store_of_sale_point_by_channel(v_salepoint_id,0,LT."LotteryTypeId",NULL), 0) 
			COALESCE(M."Quantity", 0) AS "TotalSell",
			COALESCE(M."TotalSoldMoney", 0) AS "TotalSoldMoney",
			COALESCE(M."TotalRetail", 0) AS "TotalRetail",
			COALESCE(M."TotalRetailMoney", 0) AS "TotalRetailMoney",
			COALESCE(M."TotalWholesale", 0) AS "TotalWholesale",
			COALESCE(M."TotalWholesaleMoney", 0) AS "TotalWholesaleMoney",
			p_shift_dis_id as "ShiftDistributeId"
		FROM "Scratchcard" SC
			FULL JOIN LoadData L ON L."IsScratchcard" IS TRUE
				AND SC."LotteryChannelId" = L."LotteryChannelId"
				AND L."LotteryTypeId" = 3
			LEFT JOIN "LotteryType" LT ON LT."LotteryTypeId" = 3 AND SC."SalePointId" = v_salepoint_id
			LEFT JOIN MoneyData M ON (LT."LotteryTypeId" = M."LotteryTypeId" AND M."LotteryChannelId" = SC."LotteryChannelId")
			LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = SC."LotteryChannelId"
		WHERE SC."SalePointId" = v_salepoint_id
	) A
	LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = A."LotteryChannelId"
	WHERE A."FirstStore" <> 0 OR A."LotteryTrans" <> 0 OR A."LotteryReceive" <> 0 OR A."TotalSell" <> 0 OR A."LotteryTypeId" = 1
	ORDER BY A."LotteryTypeId" DESC, LC."DayIds", LC."LotteryChannelTypeId";

END;
$BODY$
LANGUAGE plpgsql VOLATILE

