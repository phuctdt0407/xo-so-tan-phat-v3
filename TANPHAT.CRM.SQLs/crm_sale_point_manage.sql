-- ================================
-- Author: Phi
-- Description: Quản lý ca làm việc tất cả chi nhánh theo ngày
-- Created date: 04/03/2022
-- SELECT * FROM crm_sale_point_manage('2021-03-04');
-- ================================
SELECT dropallfunction_byname('crm_sale_point_manage');
CREATE OR REPLACE FUNCTION crm_sale_point_manage
(
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftId" INT,
	"UserId" INT,
	"FullName" VARCHAR
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		ROW_NUMBER() OVER(ORDER BY SP."SalePointId") AS "RowNumber",
		SP."SalePointId",
		SP."SalePointName",
		S."ShiftId",
		COALESCE(SD."UserId", 0),
		(CASE WHEN U."FullName" IS NOT NULL THEN U."FullName" ELSE '-' END)
	FROM "SalePoint" SP
		JOIN "Shift" S ON TRUE
		LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = SP."SalePointId" AND SD."ShiftId" = S."ShiftId" AND SD."IsActive" IS TRUE AND SD."DistributeDate" = p_date::DATE
		LEFT JOIN "User" U ON U."UserId" = SD."UserId"
	WHERE SP."IsActive" IS TRUE AND SP."IsDeleted" IS FALSE;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE