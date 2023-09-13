-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_get_every_payed_debt_and_new_debt_all_time(3);
-- ================================
SELECT dropallfunction_byname('crm_get_every_payed_debt_and_new_debt_all_time');
CREATE OR REPLACE FUNCTION crm_get_every_payed_debt_and_new_debt_all_time
(
	p_user_id INT
)
RETURNS TABLE
(
	"UserId" INT,
	"PayedDebtData" TEXT,
	"DebtData" TEXT
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	with tmp AS(
		SELECT
			D."UserId",
			D."TotalDebt",
			D."ActionDate"
		FROM "Debt" D
			LEFT JOIN "UserRole" UR ON UR."UserId" = D."UserId"
		WHERE D."IsAdded" IS TRUE AND D."UserId" = p_user_id
	), tmp1 AS(
		SELECT
			D."UserId",
			D."DebtDone"
		FROM "Debt" D
			LEFT JOIN "UserRole" UR ON UR."UserId" = D."UserId"
		WHERE D."UserId" = p_user_id
	),tmp2 AS(
		SELECT 
			T1."UserId",
			json_agg(json_build_object('PayedData',T1."DebtDone"))::TEXT AS "PayedData" 
		FROM tmp1 T1 
		GROUP BY T1."UserId"
	),tmp3 AS(
		SELECT 
			T."UserId",
			array_to_json(array_agg(json_build_object(
				'TotalDebt',
				T."TotalDebt",
				'Date',
				T."ActionDate")))::TEXT AS "DebtData" 
		FROM tmp T
		GROUP BY T."UserId"
	)
	SELECT T."UserId",T."PayedData",T1."DebtData" FROM tmp2 T LEFT JOIN tmp3 T1 ON T."UserId" = T1."UserId"
	;
END;
$BODY$
LANGUAGE plpgsql VOLATILE