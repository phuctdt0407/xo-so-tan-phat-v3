-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_data_finish_shift(5);
-- ================================
SELECT dropallfunction_byname('crm_report_data_finish_shift');
CREATE OR REPLACE FUNCTION crm_report_data_finish_shift
(
	p_user_role INT
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
	"TotalRemaining" INT,
	"TotalSold" INT,
	"TotalSoldMoney" NUMERIC,
	"ShiftDistributeId" INT
	
)
AS $BODY$
DECLARE
	v_user_id INT;
	v_shift_dis_id INT;
	v_salepoint_id INT;
	v_shift_id INT;
	v_quantity INT;
	v_total_money NUMERIC;
BEGIN
		
	SELECT FN."UserId", FN."SalePointId", FN."ShiftDistributeId" INTO v_user_id, v_salepoint_id, v_shift_dis_id  FROM fn_get_shift_info(p_user_role) FN;
	SELECT SD."ShiftId" INTO v_shift_id FROM "ShiftDistribute" SD WHERE SD."ShiftDistributeId" =  v_shift_dis_id;

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
					SUM(CASE WHEN T."TransitionTypeId" = 1 AND LT."LotteryTypeId" = 1 THEN T."TotalTrans" 
									 WHEN T."TransitionTypeId" = 1 AND LT."LotteryTypeId" = 2 THEN T."TotalTransDup" ELSE 0 END) AS "LotteryTrans",
					SUM(CASE WHEN T."TransitionTypeId" = 2 AND LT."LotteryTypeId" = 1 THEN T."TotalTrans" 
									 WHEN T."TransitionTypeId" = 2 AND LT."LotteryTypeId" = 2 THEN T."TotalTransDup" ELSE 0 END) AS "LotteryReceive",
					SUM(CASE WHEN T."TransitionTypeId" = 3 AND LT."LotteryTypeId" = 1 THEN T."TotalTrans" 
									 WHEN T."TransitionTypeId" = 3 AND LT."LotteryTypeId" = 2 THEN T."TotalTransDup" ELSE 0 END) AS "LotteryReturn",
					T."ShiftDistributeId"
				FROM "Transition" T 
							JOIN "SalePoint" SP ON (T."ToSalePointId" = SP."SalePointId" OR T."FromSalePointId" = SP."SalePointId")
							JOIN "LotteryChannel" LC ON T."LotteryChannelId" = LC."LotteryChannelId",
							"LotteryType" LT	
				WHERE LT."LotteryTypeId" <> 3	AND T."ShiftDistributeId" = v_shift_dis_id
				GROUP BY 
					(CASE WHEN T."FromSalePointId" = 0 THEN T."ToSalePointId" ELSE T."FromSalePointId" END), 
					SP."SalePointName",
					T."LotteryChannelId",
					LC."LotteryChannelName",
					T."LotteryDate",
					LT."LotteryTypeId",
					LT."LotteryTypeName",
					T."ShiftDistributeId"
				ORDER BY (CASE WHEN T."FromSalePointId" = 0 THEN T."ToSalePointId" ELSE T."FromSalePointId" END), T."LotteryChannelId"
			),
			GetInventory AS 
			(
				SELECT 
					I."SalePointId",
					SP."SalePointName",
					I."LotteryDate",
					LT."LotteryTypeId",
					LT."LotteryTypeName",
					LC."LotteryChannelId",
					LC."LotteryChannelName"
				FROM "Inventory" I, "LotteryType" LT, "SalePoint" SP, "LotteryChannel" LC
				WHERE (I."LotteryDate" = NOW() ::DATE OR I."LotteryDate" = (NOW() + INTERVAL '1 DAY') ::DATE) 
					AND LT."LotteryTypeId" <> 3
					AND I."SalePointId" = v_salepoint_id
					AND SP."SalePointId" = I."SalePointId"
					AND I."LotteryChannelId" = LC."LotteryChannelId"
				ORDER BY I."LotteryDate", I."LotteryChannelId"
			)	,
			GetData AS 
			(
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
					v_shift_dis_id AS "ShiftDistributeId"			
				FROM GetInventory GI LEFT JOIN LoadData L ON GI."LotteryDate" = L."LotteryDate"
																										AND GI."LotteryChannelId" = L."LotteryChannelId"
																										AND GI."LotteryTypeId" = L."LotteryTypeId"
			),
			MoneyData AS
			(
				SELECT * FROM crm_get_total_sale_of_sale_point_by_shiftdis(v_salepoint_id, v_shift_dis_id)
			)				
				SELECT * FROM 
						((SELECT 
						G."LotteryDate",
						G."LotteryChannelId",
						G."LotteryChannelName",
						G."LotteryTypeId",
						G."LotteryTypeName",
						COALESCE(crm_get_previous_remaining(G."ShiftDistributeId", G."LotteryChannelId", G."LotteryTypeId", G."LotteryDate"), 0) AS "FirstStore",
						G."LotteryTrans",
						G."LotteryReceive",
						G."LotteryReturn" ,
						COALESCE(crm_get_current_store_of_sale_point_by_channel(G."SalePointId",G."LotteryChannelId",G."LotteryTypeId",G."LotteryDate"), 0) 
						AS "Last",
						COALESCE(M."Quantity", 0) AS "TotalSell",
						COALESCE(M."TotalSoldMoney", 0) AS "TotalSoldMoney",
						G."ShiftDistributeId"					
					FROM GetData G 
					  FULL JOIN MoneyData M ON (G."LotteryTypeId" = M."LotteryTypeId"
																AND G."LotteryChannelId" = M."LotteryChannelId"
																AND G."LotteryDate" = M."LotteryDate")
					WHERE G."SalePointId" = v_salepoint_id AND G."ShiftDistributeId" = v_shift_dis_id
					ORDER BY G."LotteryDate")
					UNION
					(SELECT
						NULL,
						NULL,
						NULL,
						LT."LotteryTypeId",
						LT."LotteryTypeName",
						COALESCE(crm_get_previous_remaining(v_shift_dis_id, 0, LT."LotteryTypeId", NULL), 0) AS "FirstStore",
						0,
						0,
						0,
						COALESCE(crm_get_current_store_of_sale_point_by_channel(v_salepoint_id,0,LT."LotteryTypeId",NULL), 0) 
						AS "Last",
						COALESCE(M."Quantity", 0) AS "TotalSell",
						COALESCE(M."TotalSoldMoney", 0) AS "TotalSoldMoney",
						v_shift_dis_id
					FROM "LotteryType" LT LEFT JOIN MoneyData M ON (LT."LotteryTypeId" = M."LotteryTypeId" AND M."LotteryChannelId" = 0)
					WHERE LT."LotteryTypeId" = 3)) A
				ORDER BY A."LotteryDate", A."LotteryChannelId", A."LotteryTypeId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

