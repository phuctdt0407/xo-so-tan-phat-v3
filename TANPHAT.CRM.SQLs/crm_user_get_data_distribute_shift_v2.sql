-- ================================
-- Author: Phi
-- Description: Chia ca làm việc
-- Created date: 01/03/2022
-- SELECT * FROM crm_user_get_data_distribute_shift_v2('2023-03', 1, true);
-- ================================
SELECT dropallfunction_byname('crm_user_get_data_distribute_shift_v2');
CREATE OR REPLACE FUNCTION crm_user_get_data_distribute_shift_v2
(
	p_distribute_month VARCHAR,
	p_sale_point_id INT,
	p_is_active BOOL
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
	"Note" TEXT
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	with tmp AS(
	(SELECT 
		FALSE,
		S."DistributeDate",
		S."SalePointId",
		S."ShiftId",
		S."UserId",
		S."ShiftTypeId",
		ST."ShiftTypeName",
		S."Note"
	FROM "ShiftDistribute" S
		JOIN "ShiftType" ST ON ST."ShiftTypeId" = S."ShiftTypeId"
	WHERE TO_CHAR(S."DistributeDate",'YYYY-MM') = p_distribute_month
		AND S."SalePointId" = p_sale_point_id
		AND ((p_is_active IS TRUE AND S."IsActive" IS TRUE) OR (p_is_active IS FALSE AND S."ShiftTypeId" = 1))
	ORDER BY S."DistributeDate")
	UNION
		(SELECT 
		TRUE,
		S."DistributeDate",
		S."SalePointId",
		S."ShiftId",
		S."UserId",
		S."ShiftTypeId",
		ST."ShiftTypeName",
		S."Note"
	FROM "ShiftDistributeForIntern" S
		JOIN "ShiftType" ST ON ST."ShiftTypeId" = S."ShiftTypeId"
	WHERE TO_CHAR(S."DistributeDate",'YYYY-MM') = p_distribute_month
		AND S."SalePointId" = p_sale_point_id
		AND ((p_is_active IS TRUE AND S."IsActive" IS TRUE) OR (p_is_active IS FALSE AND S."ShiftTypeId" = 1))
	ORDER BY S."DistributeDate")
	)
	SELECT T1.* FROM tmp T1 ;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE