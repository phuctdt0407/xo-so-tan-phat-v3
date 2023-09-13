-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_winning_type_ddl();
-- ================================
SELECT dropallfunction_byname('crm_report_winning_type_ddl');
CREATE OR REPLACE FUNCTION crm_report_winning_type_ddl 
(

)
RETURNS TABLE
(
	"WinningTypeId" INT,
	"WinningTypeName" VARCHAR,
	"WinningPrize" NUMERIC
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT
		T."WinningTypeId",
		T."WinningTypeName",
		T."WinningPrize"
	FROM (
		SELECT 
			W."WinningTypeId" + 10000 AS "WinningTypeId",
			W."WinningTypeName",
			W."WinningPrize"
		FROM "WinningType" W
		WHERE W."WinningTypeId" IN (2,3,4)
		UNION
		SELECT
			TA."TypeAwardId",
			TA."TypeAwardName",
			TA."Price"
		FROM "TypeAward" TA
	) T
	ORDER BY T."WinningTypeId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

