-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_history_order('2022-07-20');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_history_order');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_history_order
(
	p_date TIMESTAMP,
	p_sale_point_id INT DEFAULT 0,
	p_shift_distribute_id INT DEFAULT 0
)
RETURNS TABLE
(
	"HistoryOfOrderId" INT,
	"SalePointId" INT,
	"PrintTimes" INT,
	"ListPrint" TEXT,
	"Data" TEXT,
	"CreatedDate" TIMESTAMP
)
AS $BODY$
BEGIN

	RETURN QUERY
	SELECT 
		H."HistoryOfOrderId",
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
						SPL."FourLastNumber"
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
	ORDER BY H."CreatedDate" DESC;

END;
$BODY$
LANGUAGE plpgsql VOLATILE