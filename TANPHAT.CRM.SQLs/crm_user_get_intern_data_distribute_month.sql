-- ================================
-- Author: Phi
-- Description: Lấy data chia ca theo tháng
-- Created date: 15/03/2022
-- SELECT * FROM crm_user_get_intern_data_distribute_month('2023-02');
-- ================================
SELECT dropallfunction_byname('crm_user_get_intern_data_distribute_month');
CREATE OR REPLACE FUNCTION crm_user_get_intern_data_distribute_month
(
	p_distribute_month text
)	
RETURNS TABLE
(
	"ShiftDistributeId" INT,
	"DistributeDate" DATE,
	"SalePointId" INT,
	"ShiftId" INT,
	"UserId" INT,
	"ShiftTypeId" INT,
	"ShiftTypeName" VARCHAR,
	"Note" TEXT,
	"ShiftMain" VARCHAR,
	"IsActive" BOOL
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		S."ShiftDistributeId",
		S."DistributeDate",
		S."SalePointId",
		S."ShiftId",
		S."UserId",
		S."ShiftTypeId",
		ST."ShiftTypeName",
		S."Note",
		SM."MainUser",
		S."IsActive"
	FROM "ShiftDistributeForIntern" S
		JOIN "SalePoint" SP ON S."SalePointId" = SP."SalePointId"
		JOIN "ShiftType" ST ON ST."ShiftTypeId" = S."ShiftTypeId"
		LEFT JOIN "ShiftMain" SM ON S."ShiftMainId" = SM."ShiftMainId" AND S."SalePointId" = SM."SalePointId"
		LEFT JOIN "User" U ON U."UserId" = S."UserId" 
	WHERE S."UserId" IS NOT NULL AND TO_CHAR(S."DistributeDate",'YYYY-MM') = p_distribute_month AND SP."IsActive" IS TRUE AND U."IsIntern" = TRUE 
	ORDER BY S."DistributeDate";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE