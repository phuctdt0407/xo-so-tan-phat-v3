-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_get_tmp_winning_ticket('1111',12,'2023-03-14',4);
-- ================================
SELECT dropallfunction_byname('crm_activity_get_tmp_winning_ticket');
CREATE OR REPLACE FUNCTION crm_activity_get_tmp_winning_ticket
(
		p_number VARCHAR,
		p_lottery_channel_id INT,
		p_day TIMESTAMP,
		p_count_number INT
)
RETURNS TABLE
(
		"SalePointId" INT,
		"SalePointName" VARCHAR,
		"Count" INT
)
AS $BODY$
BEGIN

	RETURN QUERY
	SELECT 
		S."SalePointId",
		SP."SalePointName",
		Count(S."SalePointId")::INT AS "Count"
	FROM "SalePointLog" S
	LEFT JOIN "SalePoint" SP ON S."SalePointId" = SP."SalePointId"
	WHERE (S."LotteryDate" BETWEEN (p_day::DATE - INTERVAL'5 day') AND p_day::DATE )
		AND right(S."FourLastNumber", p_count_number) = right(p_number, p_count_number)
		AND right(S."FourLastNumber", p_count_number+1) != right(p_number, p_count_number+1)
		AND S."IsDeleted" = FALSE
		AND S."LotteryChannelId" = p_lottery_channel_id
	GROUP BY 
		S."SalePointId",
		SP."SalePointName"
	ORDER BY "SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE
