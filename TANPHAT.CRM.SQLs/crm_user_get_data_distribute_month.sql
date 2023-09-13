-- ================================
-- Author: Phi
-- Description: Lấy data chia ca theo tháng
-- Created date: 15/03/2022
-- SELECT * FROM crm_user_get_data_distribute_month('2023-04');
-- ================================
SELECT dropallfunction_byname('crm_user_get_data_distribute_month');
CREATE OR REPLACE FUNCTION crm_user_get_data_distribute_month
(
	p_distribute_month VARCHAR
)
RETURNS TABLE
(
	"IsIntern" BOOLEAN,
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
	WITH tmp AS
	(
			(SELECT 
				FALSE,
				S."DistributeDate",
				S."SalePointId",
				S."ShiftId",
				S."UserId",
				S."ShiftTypeId",
				ST."ShiftTypeName",
				S."Note",
				SM."MainUser",
				S."IsActive"
			FROM "ShiftDistribute" S
				JOIN "SalePoint" SP ON S."SalePointId" = SP."SalePointId"
				JOIN "ShiftType" ST ON ST."ShiftTypeId" = S."ShiftTypeId"
				LEFT JOIN "ShiftMain" SM ON S."ShiftMainId" = SM."ShiftMainId" AND S."SalePointId" = SM."SalePointId"
			WHERE S."UserId" IS NOT NULL AND TO_CHAR(S."DistributeDate",'YYYY-MM') = p_distribute_month AND SP."IsActive" IS TRUE
			ORDER BY S."DistributeDate")
	)
	SELECT *
	FROM tmp T 
	ORDER BY T."DistributeDate";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE