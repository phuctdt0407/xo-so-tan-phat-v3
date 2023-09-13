-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_data_shift_transfer_by_month_v2(5, '2022-04');
-- ================================
SELECT dropallfunction_byname('crm_report_get_data_shift_transfer_by_month_v2');
CREATE OR REPLACE FUNCTION crm_report_get_data_shift_transfer_by_month_v2
(
	p_user_role INT,
	p_month VARCHAR 
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"LotteryTypeId" INT,
	"LotteryTypeName" VARCHAR,
	"DistributeDate" DATE,
	"TotalReceived" INT8,
	"TotalReturns" INT8,
	"TotalTrans" INT8,
	"TotalSold" INT8,
	"TotalRemaining" INT8
)
AS $BODY$
DECLARE
	v_is_leader BOOL;
	v_user_id INT;
BEGIN
	SELECT UT."IsLeader", UR."UserId" INTO v_is_leader, v_user_id
	FROM "UserRole" UR 
		JOIN "UserTitle" UT ON UR."UserTitleId" = UT."UserTitleId"
	WHERE UR."UserRoleId" = p_user_role;
	IF v_is_leader IS TRUE THEN	
		RETURN QUERY
			WITH LIST AS (SELECT * FROM crm_get_list_salepoint_of_leader(v_user_id))
			SELECT 
				SP."SalePointId",
				SP."SalePointName",
				SF."LotteryTypeId",
				LT."LotteryTypeName",
				SD."DistributeDate", 
				COALESCE(SUM(CASE WHEN SD."ShiftId" = 1 THEN SF."TotalReceived" END), 0) AS "TotalReceived", 
				COALESCE(SUM(SF."TotalReturns"), 0) AS "TotalReturns",
				COALESCE(SUM(SF."TotalTrans"), 0) AS "TotalTrans",
				COALESCE(SUM(SF."TotalSold"), 0) AS "TotalSold",
				COALESCE(SUM(CASE WHEN SD."ShiftId" = 2 THEN SF."TotalRemaining" END), SUM(CASE WHEN SD."ShiftId" = 1 THEN SF."TotalRemaining" END) , 0) AS "TotalRemaining"
			FROM "ShiftDistribute" SD 
				JOIN "ShiftTransfer" SF ON SD."ShiftDistributeId" = SF."ShiftDistributeId"
				JOIN "LotteryType" LT ON SF."LotteryTypeId" = LT."LotteryTypeId"
				JOIN "SalePoint" SP ON SD."SalePointId" = SP."SalePointId"
				JOIN LIST L ON L."SalePointId" = SP."SalePointId"
			WHERE TO_CHAR(SD."DistributeDate", 'YYYY-MM') = p_month
			GROUP BY SD."DistributeDate", SF."LotteryTypeId", LT."LotteryTypeName", SP."SalePointId", SP."SalePointName"
			ORDER BY SP."SalePointId", SD."DistributeDate";
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

