-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_shift_of_all_user_in_month_of_salepoint('2022-03',1);
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_shift_of_all_user_in_month_of_salepoint');
CREATE OR REPLACE FUNCTION crm_report_get_total_shift_of_all_user_in_month_of_salepoint
(
	p_month VARCHAR,
	p_salePointId INT
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftTypeId" INT,
	"ShiftTypeName" VARCHAR,
	"Quantity" INT8
)
AS $BODY$
BEGIN
	IF p_salePointId <> 0 THEN
		RETURN QUERY
		WITH tmpSDD AS (
			SELECT 
				SD."UserId", 
				SD."ShiftTypeId",
				ST."ShiftTypeName",
				SP."SalePointId",
				SP."SalePointName",
				COUNT(SD."ShiftTypeId") AS "Quantity"
			FROM "ShiftDistribute" SD JOIN "ShiftType" ST ON SD."ShiftTypeId" = ST."ShiftTypeId", "SalePoint" SP
			WHERE SD."IsActive" = 't' 
				AND TO_CHAR(SD."DistributeDate",'YYYY-MM') = p_month 
				AND SP."SalePointId" = SD."SalePointId" 
				AND SD."SalePointId" = p_salePointId
			GROUP BY SD."UserId", SD."ShiftTypeId", ST."ShiftTypeName", SP."SalePointId", SP."SalePointName")
		SELECT 
			U."UserId",
			U."FullName",
			SDD."SalePointId",
			SDD."SalePointName",
			SDD."ShiftTypeId",
			SDD."ShiftTypeName",
			COALESCE(SDD."Quantity",0)	
		FROM "User" U JOIN tmpSDD SDD ON U."UserId" = SDD."UserId"
		ORDER BY U."UserId";
	ELSE
		RETURN QUERY
			WITH tmpSDD AS (
				SELECT 
					SD."UserId", 
					SD."ShiftTypeId",
					ST."ShiftTypeName",
					SP."SalePointId",
					SP."SalePointName",
					COUNT(SD."ShiftTypeId") AS "Quantity"
				FROM "ShiftDistribute" SD JOIN "ShiftType" ST ON SD."ShiftTypeId" = ST."ShiftTypeId", "SalePoint" SP
				WHERE SD."IsActive" = 't' 
					AND TO_CHAR(SD."DistributeDate",'YYYY-MM') = p_month 
					AND SP."SalePointId" = SD."SalePointId"
				GROUP BY SD."UserId", SD."ShiftTypeId", ST."ShiftTypeName", SP."SalePointId", SP."SalePointName")
			SELECT 
				U."UserId",
				U."FullName",
				SDD."SalePointId",
				SDD."SalePointName",
				SDD."ShiftTypeId",
				SDD."ShiftTypeName",
				COALESCE(SDD."Quantity",0)	
			FROM "User" U JOIN tmpSDD SDD ON U."UserId" = SDD."UserId"
			ORDER BY U."UserId";
	END IF;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE