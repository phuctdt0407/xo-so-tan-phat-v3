-- ================================
-- Author: Hieu
-- Description: Lấy danh sách lịch sử bán hàng của điểm bán
-- Created date: 2022-12-20
-- SELECT * FROM crm_activity_sold_log_v1(202,1,10);
-- ================================
SELECT dropallfunction_byname('crm_activity_sold_log_v1');
CREATE OR REPLACE FUNCTION crm_activity_sold_log_v1
(
	p_shift_distribute_id INT,
	p_page_number INT,
	p_page_size INT
	
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"ActionDate" TIMESTAMP,
	"TotalQuantity" INT8,
	"TotalPrice" NUMERIC,
	"DetailData" TEXT,
	"TotalValues" INT
)
AS $BODY$
DECLARE
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
	v_total_count INT8;
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
		)::TEXT AS "DetailData",
		(
			SELECT COUNT(1) FROM tmp t1 GROUP BY t1."TotalQuantity"
		)::INT AS "Totalvalues"
	FROM tmp t
	OFFSET v_offset_row
	LIMIT p_page_size;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE