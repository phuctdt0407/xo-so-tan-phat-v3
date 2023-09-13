-- ================================
-- Author: Phi
-- Description: Lấy danh sách lịch sử bán hàng của điểm bán
-- Created date: 07/04/2022
-- SELECT * FROM crm_activity_sold_log(645);
-- ================================
SELECT dropallfunction_byname('crm_activity_sold_log');
CREATE OR REPLACE FUNCTION crm_activity_sold_log
(
	p_shift_distribute_id INT
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"ActionDate" TIMESTAMP,
	"TotalQuantity" INT8,
	"TotalPrice" NUMERIC,
	"DetailData" TEXT
)
AS $BODY$
DECLARE
	
BEGIN

	RETURN QUERY
	WITH tmp AS(
		SELECT
			SL."ActionDate",
			SUM(SL."Quantity") AS "TotalQuantity",
			SUM(SL."TotalValue") AS "TotalPrice"
		FROM "SalePointLog" SL 
		WHERE SL."ShiftDistributeId" = p_shift_distribute_id
			AND SL."IsDeleted" IS FALSE
		GROUP BY
			SL."ActionDate"
	)
	SELECT 
		ROW_NUMBER() OVER(ORDER BY t."ActionDate" DESC) AS "RowNumber",
		t."ActionDate",
		t."TotalQuantity",
		t."TotalPrice",
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					SL."SalePointLogId",
					SL."LotteryDate",
					SL."LotteryChannelId",
					LC."LotteryChannelName",
					SL."Quantity",
					SL."TotalValue",
					SL."LotteryTypeId",
					LT."LotteryTypeName"
				FROM "SalePointLog" SL
					JOIN "LotteryType" LT ON LT."LotteryTypeId" = SL."LotteryTypeId"
					LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = SL."LotteryChannelId"
				WHERE SL."ActionDate" = t."ActionDate"
					AND SL."IsDeleted" IS FALSE
				ORDER BY SL."SalePointLogId"
			) r
		)::TEXT AS "DetailData"
	FROM tmp t;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE