-- ================================
-- Author: Phi
-- Description: Só lượng vé và đài của từng điểm bán  theo ngày
-- Created date: 07/03/2022
-- SELECT * FROM crm_activity_sell_get_inventory_data('2022-06-07');
-- ================================
SELECT dropallfunction_byname('crm_activity_sell_get_inventory_data');
CREATE OR REPLACE FUNCTION crm_activity_sell_get_inventory_data
(
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftDistributeId" INT,
	"TodayData" TEXT,
	"TomorrowData" TEXT,
	"ScratchcardData" TEXT
)
AS $BODY$
DECLARE 
	v_sale_point_id INT;
	v_sale_point_name VARCHAR;
	v_shift_dis_id INT;
	v_user_id INT;
BEGIN

	RETURN QUERY 
	SELECT 
		0,
		'Inventory'::VARCHAR,
		0,
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY IC."LotteryChannelTypeId") AS "RowNumber",
					T."LotteryDate",
					T."LotteryChannelId",
					IC."LotteryChannelName",
					IC."ShortName",
				  IC."LotteryChannelTypeId",
					(COALESCE(SUM(T."TotalTrans") FILTER(WHERE T."TransitionTypeId" = 1),0) - COALESCE(SUM(T."TotalTrans") FILTER(WHERE T."TransitionTypeId" = 2),0)) AS "TotalRemaining",
					(COALESCE(SUM(T."TotalTransDup") FILTER(WHERE T."TransitionTypeId" = 1),0) - COALESCE(SUM(T."TotalTransDup") FILTER(WHERE T."TransitionTypeId" = 2),0)) AS "TotalDupRemaining"
				FROM "Transition" T
					JOIN "LotteryChannel" IC ON IC."LotteryChannelId" = T."LotteryChannelId"
				WHERE T."LotteryDate" = p_date::DATE AND T."ConfirmStatusId" = 2  AND T."IsScratchcard" IS FALSE
				GROUP BY
					T."LotteryDate",
					T."LotteryChannelId",
					IC."LotteryChannelName",
					IC."ShortName",
				  IC."LotteryChannelTypeId"
			) r
		)::TEXT AS "TodayData",
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY IC."LotteryChannelTypeId") AS "RowNumber",
					T."LotteryDate",
					T."LotteryChannelId",
					IC."LotteryChannelName",
					IC."ShortName",
					IC."LotteryChannelTypeId",
					(COALESCE(SUM(T."TotalTrans") FILTER(WHERE T."TransitionTypeId" = 1), 0) - COALESCE(SUM(T."TotalTrans") FILTER(WHERE T."TransitionTypeId" = 2),0))  AS "TotalRemaining",
					(COALESCE(SUM(T."TotalTransDup") FILTER(WHERE T."TransitionTypeId" = 1),0) - COALESCE(SUM(T."TotalTransDup") FILTER(WHERE T."TransitionTypeId" = 2),0))  AS "TotalDupRemaining"
				FROM "Transition" T
					JOIN "LotteryChannel" IC ON IC."LotteryChannelId" = T."LotteryChannelId"
				WHERE T."LotteryDate" = (p_date + '1 day'::INTERVAL)::DATE AND T."ConfirmStatusId" = 2 AND T."IsScratchcard" IS FALSE
				GROUP BY
					T."LotteryDate",
					T."LotteryChannelId",
					IC."LotteryChannelName",
					IC."ShortName",
					IC."LotteryChannelTypeId"
			) r
		)::TEXT AS "TomorrowData",
			(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY IC."LotteryChannelTypeId") AS "RowNumber",
					T."LotteryChannelId",
					IC."LotteryChannelName",
					IC."ShortName",
					IC."LotteryChannelTypeId",
					(COALESCE(SUM(T."TotalTrans") FILTER(WHERE T."TransitionTypeId" = 1), 0) - COALESCE(SUM(T."TotalTrans") FILTER(WHERE T."TransitionTypeId" = 2),0))  AS "TotalRemaining",
					(COALESCE(SUM(T."TotalTransDup") FILTER(WHERE T."TransitionTypeId" = 1),0) - COALESCE(SUM(T."TotalTransDup") FILTER(WHERE T."TransitionTypeId" = 2),0))  AS "TotalDupRemaining"
				FROM "Transition" T
					JOIN "LotteryChannel" IC ON IC."LotteryChannelId" = T."LotteryChannelId"
				WHERE T."IsScratchcard" IS TRUE AND T."ConfirmStatusId" = 2
				GROUP BY
					T."LotteryChannelId",
					IC."LotteryChannelName",
					IC."ShortName",
					IC."LotteryChannelTypeId"
			) r
		)::TEXT AS "ScratchcardData";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE