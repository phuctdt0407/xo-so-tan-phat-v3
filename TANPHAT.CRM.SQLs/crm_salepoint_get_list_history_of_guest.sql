-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_history_of_guest(1);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_history_of_guest');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_history_of_guest
(
	p_guest_id INT,
	p_page_size INT DEFAULT 100,
	p_page_number INT DEFAULT 1
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"TotalCount" INT8,
	"HistoryOfOrderId" INT,
	"SalePointId" INT,
	"Data" TEXT,
	"CreatedDate" TIMESTAMP
)
AS $BODY$
DECLARE
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN
	RETURN QUERY
	SELECT 
		ROW_NUMBER() OVER (ORDER BY H."CreatedDate" DESC) "RowNumber",
		COUNT(1) OVER() AS "TotalCount",
		H."HistoryOfOrderId",
		H."SalePointId",
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
		AND H."GuestId" = p_guest_id
	ORDER BY H."CreatedDate" DESC
	OFFSET v_offset_row LIMIT p_page_size;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

