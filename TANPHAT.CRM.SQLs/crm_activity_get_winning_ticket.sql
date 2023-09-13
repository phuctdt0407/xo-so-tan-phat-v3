-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_get_winning_ticket('5','2023-02-23');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_winning_ticket');
CREATE OR REPLACE FUNCTION crm_activity_get_winning_ticket
(
		p_number VARCHAR,
		p_day TIMESTAMP
)
RETURNS TABLE
(
		"SalePointId" INT,
		"SalePointName" VARCHAR,
		"LotteryDate" DATE,
		"FourLastNumber" VARCHAR,
		"Count" INT
)
AS $BODY$
DECLARE
	v_lenght_number INT := LENGTH(p_number);
BEGIN

	RETURN QUERY
	SELECT 
		S."SalePointId",
		SP."SalePointName",
		S."LotteryDate",
		S."FourLastNumber",
		Count(S."SalePointId")::INT AS "Count"
	FROM "SalePointLog" S
	LEFT JOIN "SalePoint" SP ON S."SalePointId" = SP."SalePointId"
	WHERE (S."LotteryDate" BETWEEN (p_day::DATE - INTERVAL'5 day') AND p_day::DATE )
		AND right(S."FourLastNumber", v_lenght_number) = p_number
		AND S."IsDeleted" = FALSE
	GROUP BY 
		S."SalePointId",
		S."LotteryDate",
		S."FourLastNumber",
		SP."SalePointName"
	ORDER BY "SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE
