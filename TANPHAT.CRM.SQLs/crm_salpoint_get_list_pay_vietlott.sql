-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salpoint_get_list_pay_vietlott('2022-01');
-- ================================
SELECT dropallfunction_byname('crm_salpoint_get_list_pay_vietlott');
CREATE OR REPLACE FUNCTION crm_salpoint_get_list_pay_vietlott
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"TotalPrice" NUMERIC,
	"ListHistory" TEXT
)
AS $BODY$
BEGIN
	RETURN QUERY
	--Lấy danh sách điểm bán
	WITH tmp AS (
		SELECT 
			SP."SalePointId",
			SP."SalePointName"
		FROM "SalePoint" SP 
		WHERE SP."IsActive" IS TRUE
			AND SP."IsDeleted" IS FALSE
	),
	tmp1 AS (
		SELECT
			T."TransactionId",
			T."Note",
			T."TotalPrice",
			T."SalePointId",
			T."ActionBy",
			T."ActionByName",
			T."Date"
		FROM "Transaction" T
		WHERE T."TransactionTypeId" = 9
			AND T."IsDeleted" IS FALSE
			AND TO_CHAR(T."Date", 'YYYY-MM') = p_month
		ORDER BY 
			T."Date" DESC
	)
	SELECT
		SP."SalePointId",
		SP."SalePointName",
		COALESCE(SUM(T."TotalPrice"), 0) AS "TotalPrice",
		(CASE WHEN COUNT(TO_JSONB(T.*)) > 0 THEN array_to_json(array_agg(TO_JSONB(T.*)))::TEXT ELSE '[]' END) AS "ListHistory"
	FROM tmp SP
		LEFT JOIN tmp1 T ON T."SalePointId" = SP."SalePointId" 
	GROUP BY
		SP."SalePointId",
		SP."SalePointName"
	ORDER BY
		SP."SalePointId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

