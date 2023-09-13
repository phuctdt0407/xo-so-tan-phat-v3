-- ================================
-- Author: Phi
-- Description: Danh sách tất cả các ca làm việc trong ngày
-- Created date:  01/04/2022
-- SELECT * FROM crm_shift_distribute_get_by_date('2022-04-06', 5)
-- ================================
SELECT dropallfunction_byname('crm_shift_distribute_get_by_date');
CREATE OR REPLACE FUNCTION crm_shift_distribute_get_by_date
(
	p_date TIMESTAMP,
	p_user_id INT
)
RETURNS TABLE
(
	"ShiftDistributeId" INT,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftId" INT,
	"ShiftName" VARCHAR,
	"WorkingTime" TEXT,
	"UserId" INT,
	"FullName" VARCHAR,
	"ShiftTypeId" INT,
	"ShiftTypeName" VARCHAR,
	"CanClick" BOOL,
	"Message" TEXT
)
AS $BODY$
DECLARE
	v_user_role_id INT;
	v_current_shift_dis INT;
BEGIN

	SELECT UR."UserRoleId" INTO v_user_role_id FROM "UserRole" UR WHERE UR."UserId" = p_user_id;

	SELECT f."ShiftDistributeId" INTO v_current_shift_dis FROM fn_get_shift_info(v_user_role_id) f;

	RETURN QUERY 
	SELECT 
		SD."ShiftDistributeId",
		SD."SalePointId",
		SP."SalePointName",
		SD."ShiftId",
		S."ShiftName",
		TO_CHAR(S."StartTime",'HH24:MI') || ' - ' || TO_CHAR(S."EndTime",'HH24:MI') AS "WorkingTime",
		SD."UserId",
		U."FullName",
		SD."ShiftTypeId",
		ST."ShiftTypeName",
		(CASE WHEN 
				(v_current_shift_dis <> SD."ShiftDistributeId" AND SD."ShiftId" = 1 AND EXISTS (SELECT 1 FROM "ShiftTransfer" ST WHERE ST."ActionDate"::DATE = SD."DistributeDate" AND ST."ShiftId" = 1 AND ST."ShiftDistributeId" = SD."ShiftDistributeId")) OR
				(v_current_shift_dis = SD."ShiftDistributeId" AND SD."ShiftId" = 1) OR 
				(v_current_shift_dis = SD."ShiftDistributeId" AND SD."ShiftId" = 2 AND EXISTS (SELECT 1 FROM "ShiftTransfer" ST WHERE ST."ActionDate"::DATE = SD."DistributeDate" AND ST."ShiftId" IN(1,2) AND ST."SalePointid" = SD."SalePointId"))
			THEN TRUE ELSE FALSE END) AS "CanClick",
		(CASE WHEN 
				(v_current_shift_dis <> SD."ShiftDistributeId" AND SD."ShiftId" = 1 AND EXISTS (SELECT 1 FROM "ShiftTransfer" ST WHERE ST."ActionDate"::DATE = SD."DistributeDate" AND ST."ShiftId" = 1 AND ST."ShiftDistributeId" = SD."ShiftDistributeId")) OR
				(v_current_shift_dis = SD."ShiftDistributeId" AND SD."ShiftId" = 1) OR 
				(v_current_shift_dis = SD."ShiftDistributeId" AND SD."ShiftId" = 2 AND EXISTS (SELECT 1 FROM "ShiftTransfer" ST WHERE ST."ActionDate"::DATE = SD."DistributeDate" AND ST."ShiftId" IN(1,2) AND ST."SalePointid" = SD."SalePointId"))
			THEN 'Ok' ELSE 'Ca trước chưa kết ca' END) AS "Message"
	FROM "ShiftDistribute" SD
		JOIN "SalePoint" SP ON SP."SalePointId" = SD."SalePointId"
		JOIN "Shift" S ON S."ShiftId" = SD."ShiftId"
		JOIN "ShiftType" ST ON ST."ShiftTypeId" = SD."ShiftTypeId"
		JOIN "User" U ON U."UserId" = SD."UserId"
	WHERE SD."DistributeDate" = p_date::DATE
		AND (COALESCE(p_user_id, 0) = 0 OR SD."UserId" = p_user_id)
	ORDER BY SD."ShiftId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE