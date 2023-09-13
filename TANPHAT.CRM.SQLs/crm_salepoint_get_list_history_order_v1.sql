-- ================================
-- Author: Hieu
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_history_order_v1(20,1,'2023-02-13',2,1136);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_history_order_v1');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_history_order_v1
(
	p_page_size INT,
	p_page_number INT,
	p_date TIMESTAMP,
	p_sale_point_id INT DEFAULT 0,
	p_shift_distribute_id INT DEFAULT 0
)
RETURNS TABLE
(
	"HistoryOfOrderId" INT,
	"TotalCount" INT8,
	"SalePointId" INT,
	"PrintTimes" INT,
	"ListPrint" TEXT,
	"Data" TEXT,
	"CreatedDate" TIMESTAMP
	
)
AS $BODY$
DECLARE 
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN

	RETURN QUERY
	SELECT 
		H."HistoryOfOrderId",
		COUNT(1) OVER() AS "TotalCount",
		H."SalePointId",
		H."PrintTimes",
		TRANSLATE(H."ListPrint"::TEXT, '{}', '[]') AS "ListPrint",
		json_build_object(
			'SalePointLogData',
			(
				SELECT 
					array_to_json(array_agg(R))
				FROM (
					SELECT 
						SPL."SalePointLogId",
						SPL."LotteryChannelId",
						LC."LotteryChannelName",
						SPL."LotteryDate",
						SPL."Quantity",
						SPL."LotteryTypeId",
						LT."LotteryTypeName",
						SPL."TotalValue",
						SPL."FourLastNumber",
						SPL."PromotionCode"
					FROM "SalePointLog" SPL 
						JOIN "LotteryChannel" LC ON SPL."LotteryChannelId" = LC."LotteryChannelId"
						JOIN "LotteryType" LT ON SPL."LotteryTypeId" = LT."LotteryTypeId"
					WHERE SPL."SalePointLogId" = ANY(H."SalePointLogIds")
						AND SPL."IsDeleted" IS FALSE
					ORDER BY 
						SPL."SalePointLogId"
				) R
			),
			'GuestData',
			(
				SELECT
					json_build_object(
						'GuestId',
						G."GuestId",
						'FullName',
						G."FullName"
					)
				FROM "Guest" G
				WHERE G."GuestId" = H."GuestId"
			),
			'GuestActionData',
			(
				SELECT
					array_to_json(array_agg(R))
				FROM (
					SELECT
						GA."GuestActionId",
						GA."GuestActionTypeId",
						GAT."TypeName",
						GA."FormPaymentId",
						F."PaymentName",
						GA."TotalPrice"
					FROM "GuestAction" GA 
						JOIN "GuestActionType" GAT ON GA."GuestActionTypeId" = GAT."GuestActionTypeId" 
						JOIN "FormPayment" F ON GA."FormPaymentId" = F."FormPaymentId"
					WHERE GA."IsDeleted" IS FALSE
						AND GA."GuestActionId" = ANY(H."GuestActionIds")
				)R
			),
			'LastData',
			H."Data"
		)::TEXT,
		H."CreatedDate"
	FROM "HistoryOfOrder" H
	WHERE H."IsDeleted" IS FALSE
		AND H."ShiftDistributeId" = p_shift_distribute_id 
-- 			OR(
-- 				H."CreatedDate"::DATE = p_date::DATE
-- 				AND (H."SalePointId" = p_sale_point_id OR p_sale_point_id = 0)
-- 			)
	ORDER BY H."CreatedDate" DESC
	OFFSET v_offset_row LIMIT p_page_size;

END;
$BODY$
LANGUAGE plpgsql VOLATILE