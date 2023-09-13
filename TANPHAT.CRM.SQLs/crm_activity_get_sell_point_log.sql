-- ================================
-- Author: Phi
-- Description: Lấy danh sách lịch sử bán hàng của điểm bán
-- Created date: 11/03/2022
-- SELECT * FROM crm_activity_get_sell_point_log(15543,4,'2023-04-01');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_sell_point_log');
CREATE OR REPLACE FUNCTION crm_activity_get_sell_point_log
(
	p_shift_distribute_id INT,
	p_sale_point_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"SalePointId" INT,
	"LotteryDate" DATE,
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"TotalTrans" INT,
	"TotalTransDup" INT,
	"TotalTransScratch" INT,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"ActionDate" TIMESTAMP,
	"LotteryTypeId" INT,
	"LotteryTypeName" VARCHAR,
	"TotalValue" NUMERIC,
	"TransitionId" INT8,
	"SalePointLogId" INT8,
	"TransitionTypeId" INT,
	"FromSalePointId" INT,
	"ToSalePointId" INT,
	"ManagerId" INT,
	"ManagerName" VARCHAR,
	"PromotionCode" TEXT
)
AS $BODY$
DECLARE 
	v_sale_point_id INT;
BEGIN

	IF COALESCE(p_sale_point_id, 0) = 0 THEN
	
		SELECT SD."SalePointId" INTO v_sale_point_id FROM "ShiftDistribute" SD WHERE SD."ShiftDistributeId" = p_shift_distribute_id;
	
	ELSE
	
		v_sale_point_id := p_sale_point_id;
		
	END IF;

	RETURN QUERY
	WITH tmp AS(
		SELECT 
			SL."SalePointId",
			SL."LotteryDate",
			SL."LotteryChannelId",
			NULL AS "LotteryChannelName",
			0 AS "TotalTrans",
			0 AS "TotalTransDup",
			SL."Quantity" AS "TotalTransScratch",
			SL."ActionBy",
			SL."ActionByName",
			SL."ActionDate",
			SL."LotteryTypeId",
			LT."LotteryTypeName",
			SL."TotalValue",
			0 AS "TransitionId",
			SL."SalePointLogId",
			0 AS "TransitionTypeId",
			0 AS "FromSalePointId",
			0 AS "ToSalePointId",
			NULL::INT AS "ManagerId",
			NULL::VARCHAR AS "ManagerName",
			SL."PromotionCode"::TEXT
		FROM "SalePointLog" SL
			JOIN "LotteryType" LT ON LT."LotteryTypeId" = SL."LotteryTypeId"
		WHERE SL."SalePointId" = v_sale_point_id AND SL."ActionDate"::DATE = p_date::DATE AND SL."LotteryTypeId" = 3 AND SL."IsDeleted" IS FALSE
		
		UNION 
		
		SELECT 
			SL."SalePointId",
			SL."LotteryDate",
			SL."LotteryChannelId",
			LC."LotteryChannelName",
			(CASE WHEN SL."LotteryTypeId" = 1 THEN SL."Quantity" ELSE 0 END) AS "TotalTrans",
			(CASE WHEN SL."LotteryTypeId" = 2 THEN SL."Quantity" ELSE 0 END) AS "TotalTransDup",
			0 AS "TotalTransScratch",
			SL."ActionBy",
			SL."ActionByName",
			SL."ActionDate",
			SL."LotteryTypeId",
			LT."LotteryTypeName",
			SL."TotalValue",
			0 AS "TransitionId",
			SL."SalePointLogId",
			0 AS "TransitionTypeId",
			0 AS "FromSalePointId",
			0 AS "ToSalePointId",
			NULL::INT AS "ManagerId",
			NULL::VARCHAR AS "ManagerName",
			SL."PromotionCode"::TEXT
		FROM "SalePointLog" SL
			JOIN "LotteryType" LT ON LT."LotteryTypeId" = SL."LotteryTypeId"
			JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = SL."LotteryChannelId"
		WHERE SL."SalePointId" = v_sale_point_id AND SL."ActionDate"::DATE = p_date::DATE AND SL."LotteryTypeId" IN(1,2)  AND SL."IsDeleted" IS FALSE
			
		UNION
		
		SELECT
			v_sale_point_id AS "SalePointId",
			T."LotteryDate",
			T."LotteryChannelId",
			LC."LotteryChannelName",
			T."TotalTrans",
			T."TotalTransDup",
			0 AS "TotalTransScratch",
			T."ActionBy",
			T."ActionByName",
			T."TransitionDate" AS "ActionDate",
			0 AS "LotteryTypeId",
			''::VARCHAR AS "LotteryTypeName",
			0 AS "TotalValue",
			T."TransitionId",
			0 AS "SalePointLogId",
			T."TransitionTypeId",
			T."FromSalePointId",
			T."ToSalePointId",
			T."ManagerId",
			U."FullName" AS "ManagerName",
			NULL::TEXT AS "PromotionCode"
	
		FROM "Transition" T
			JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = T."LotteryChannelId"
			LEFT JOIN "User" U ON U."UserId" = T."ManagerId"
		WHERE (T."FromSalePointId" = v_sale_point_id OR T."ToSalePointId" = v_sale_point_id) AND T."TransitionDate"::DATE = p_date::DATE
	)
	SELECT t.* FROM tmp t ORDER BY t."ActionDate" DESC;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE