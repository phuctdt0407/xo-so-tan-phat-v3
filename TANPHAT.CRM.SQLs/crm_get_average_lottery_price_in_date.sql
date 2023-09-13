-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_average_lottery_price_in_date(1000, '2022-06-06');
-- ================================
SELECT dropallfunction_byname('crm_get_average_lottery_price_in_date');
CREATE OR REPLACE FUNCTION crm_get_average_lottery_price_in_date
(
	p_lottery_channel_id INT,
	p_date TIMESTAMP DEFAULT NOW()
)
RETURNS NUMERIC 
AS $BODY$
DECLARE
	v_result NUMERIC;
BEGIN
	
	--Vé thường
	IF NOT EXISTS (SELECT 1 FROM "LotteryChannel" LC WHERE LC."LotteryChannelId" = p_lottery_channel_id AND LC."IsScratchcard" IS TRUE) THEN
		
		WITH tmp AS (
			SELECT 
				ROW_NUMBER() OVER(PARTITION BY LP."AgencyId", LP."LotteryChannelId" ORDER BY LP."CreatedDate" DESC) AS "Id",
				LP."AgencyId",
				LP."Price"
			FROM "LotteryPriceAgency" LP
			WHERE LP."IsDeleted" IS FALSE
				AND (p_date::DATE IS NULL OR LP."CreatedDate" <= p_date::DATE)
				AND LP."LotteryChannelId" = p_lottery_channel_id
		),
		tmp2 AS (
			SELECT
				A."AgencyId",
				A."Price"
			FROM tmp A
			WHERE A."Id" = 1
		),
		tmp3 AS (
			SELECT
				I."AgencyId",
				SUM(I."TotalReceived") AS "TotalReceived"
			FROM "InventoryFull" I
			WHERE I."LotteryChannelId" = p_lottery_channel_id
				AND I."LotteryDate" = p_date::DATE
			GROUP BY 
				I."AgencyId"
		)
		SELECT
			COALESCE(SUM(T."TotalReceived" * A."Price"), 0) / COALESCE(SUM(T."TotalReceived"), 1) INTO v_result
		FROM tmp3 T
			LEFT JOIN tmp2 A ON T."AgencyId" = A."AgencyId";
	--Vé cào
	ELSE
	
		v_result := (
			SELECT 
				C."Price"
			FROM "Constant" C 
			WHERE C."CreatedDate"::DATE <= p_date::DATE
				AND C."ConstId" = 12
				AND C."CreatedDate" >= ALL(
					SELECT 
						CC."CreatedDate"
					FROM "Constant" CC
					WHERE CC."ConstId" = C."ConstId"
						AND CC."CreatedDate"::DATE <= p_date::DATE
				)
		)::NUMERIC;
		
	END IF;
	
	RETURN v_result;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

