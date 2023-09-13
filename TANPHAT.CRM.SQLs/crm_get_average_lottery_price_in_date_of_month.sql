-- ================================
-- Author: Quang
-- Description:
-- Created date:
--	SELECT * FROM crm_get_average_lottery_price_in_date_of_month('2022-07');
-- ================================
SELECT dropallfunction_byname('crm_get_average_lottery_price_in_date_of_month');
CREATE OR REPLACE FUNCTION crm_get_average_lottery_price_in_date_of_month
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"LotteryChannelId" INT,
	"Date" DATE,
	"Price" NUMERIC
)
AS $BODY$
DECLARE
		v_total_date INT := (SELECT date_part('days', (date_trunc('month', (p_month||'-01')::DATE) + INTERVAL '1 month - 1 day'))) :: INT;
		v_time TIMESTAMP := NOW();
BEGIN
	RETURN QUERY
	--Lấy danh sách đài theo ngày
	WITH tmp0 AS (
		SELECT 
			(p_month||'-'||T."Date")::DATE AS "Date",
			UNNEST((SELECT ARRAY_AGG(A."Id") FROM crm_lottery_channel_ddl(2, (p_month||'-'||T."Date")::TIMESTAMP) A)::INT[]) AS "LotteryChannelId"
		FROM (
			SELECT * FROM generate_series(1, v_total_date) AS "Date"
		) T
		UNION ALL
		SELECT 
			NULL::DATE AS "Date",
			LC."LotteryChannelId"
		FROM "LotteryChannel" LC
		WHERE LC."IsScratchcard" IS TRUE 
	)
	SELECT 
		T."LotteryChannelId",
		T."Date",
		(SELECT * FROM crm_get_average_lottery_price_in_date(T."LotteryChannelId", T."Date"::TIMESTAMP))::NUMERIC
	FROM tmp0 T;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

