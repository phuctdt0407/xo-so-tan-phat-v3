-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_all_shift_of_one_employee(17, '2023-03');
-- ================================
SELECT dropallfunction_byname('crm_get_all_shift_of_one_employee');
CREATE OR REPLACE FUNCTION crm_get_all_shift_of_one_employee
(
	p_user_role INT,
	p_month VARCHAR
)
RETURNS TABLE
(
	"UserId" INT,
	"DistributeDate" DATE,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftId" INT,
	"ShiftName" VARCHAR,
	"ShiftTypeId" INT,
	"ShiftTypeName" VARCHAR
)
AS $BODY$
DECLARE 
	v_user_id INT;
BEGIN
	SELECT UR."UserId" INTO v_user_id FROM "UserRole" UR WHERE UR."UserRoleId" = p_user_role;
	RETURN QUERY
		SELECT 
			SD."UserId",
			SD."DistributeDate",
			SD."SalePointId",
			SP."SalePointName",
			SD."ShiftId",
			S."ShiftName",
			SD."ShiftTypeId",
			ST."ShiftTypeName"
		FROM "ShiftDistribute" SD
			JOIN "SalePoint" SP ON SD."SalePointId" = SP."SalePointId"
			JOIN "Shift" S ON SD."ShiftId" = S."ShiftId"
			JOIN "ShiftType" ST ON SD."ShiftTypeId" = ST."ShiftTypeId"
		WHERE SD."UserId" = v_user_id AND TO_CHAR(SD."DistributeDate", 'YYYY-MM')=p_month
		ORDER BY SD."DistributeDate", SP."SalePointId", S."ShiftId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE


