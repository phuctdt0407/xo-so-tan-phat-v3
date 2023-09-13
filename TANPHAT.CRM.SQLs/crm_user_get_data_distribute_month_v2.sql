-- ================================
-- Author: Phi
-- Description: Lấy data chia ca theo tháng
-- Created date: 15/03/2022
-- SELECT * FROM crm_user_get_data_distribute_month_v2('2022-03');
-- ================================
SELECT dropallfunction_byname('crm_user_get_data_distribute_month_v2');
CREATE OR REPLACE FUNCTION crm_user_get_data_distribute_month_v2
(
	p_distribute_month VARCHAR
)
RETURNS TABLE
(
	"DistributeData" TEXT,
	"AttendanceData" TEXT
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
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
					JOIN "ShiftType" ST ON ST."ShiftTypeId" = S."ShiftTypeId"
					LEFT JOIN "ShiftMain" SM ON S."ShiftMainId" = SM."ShiftMainId" AND S."SalePointId" = SM."SalePointId"
				WHERE S."UserId" IS NOT NULL AND TO_CHAR(S."DistributeDate",'YYYY-MM') = p_distribute_month
			) r
		)::TEXT AS "DistributeData",
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					SA."ShiftAttendanceId",
					SA."UserId",
					SA."TotalShift",
					SA."TotalAbsent",
					SA."TotalOT",
					SA."TotalMakeup",
					SA."IsMainShift"
				FROM "ShiftAttendance" SA
				WHERE SA."DistributeMonth" = p_distribute_month
			) r
		)::TEXT AS "AttendanceData";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE