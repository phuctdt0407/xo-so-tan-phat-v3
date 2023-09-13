-- ================================
-- Author: Hieu
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_shift_of_all_user_in_month('2023-01');	
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_shift_of_all_user_in_month');
CREATE OR REPLACE FUNCTION crm_report_get_total_shift_of_all_user_in_month
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	"ShiftTypeId" INT,
	"ShiftTypeName" VARCHAR,
	"SalePointId" INT,
	"Quantity" INT8
	
)
AS $BODY$
BEGIN
	RETURN QUERY
	WITH tmpSDD AS (
		SELECT 
			SD."UserId", 
			SD."ShiftTypeId",
			ST."ShiftTypeName",
			SD."SalePointId",
			COUNT(SD."ShiftTypeId") AS "Quantity"
		FROM "ShiftDistribute" SD JOIN "ShiftType" ST ON SD."ShiftTypeId" = ST."ShiftTypeId"
		WHERE SD."IsActive" IS TRUE 
		AND
			CASE WHEN TO_CHAR(NOW(),'YYYY-MM') = p_month
				THEN
					TO_CHAR(SD."DistributeDate",'YYYY-MM-DD') <= TO_CHAR(NOW(),'YYYY-MM-DD')
					AND TO_CHAR(SD."DistributeDate",'YYYY-MM') = TO_CHAR(NOW(),'YYYY-MM')
				ELSE
					TO_CHAR(SD."DistributeDate",'YYYY-MM') = p_month 
				END 
		GROUP BY SD."UserId", SD."ShiftTypeId", ST."ShiftTypeName",
			SD."SalePointId")
			
	SELECT 
		U."UserId",
		U."FullName",
		SDD."ShiftTypeId",
		SDD."ShiftTypeName",
		SDD."SalePointId",
		COALESCE(SDD."Quantity",0)
	FROM "User" U JOIN tmpSDD SDD ON U."UserId" = SDD."UserId"
	ORDER BY U."UserId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE