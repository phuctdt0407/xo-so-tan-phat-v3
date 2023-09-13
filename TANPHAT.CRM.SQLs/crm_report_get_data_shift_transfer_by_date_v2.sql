-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_data_shift_transfer_by_date_v2(5,'2022-04-08');
-- ================================
SELECT dropallfunction_byname('crm_report_get_data_shift_transfer_by_date_v2');
CREATE OR REPLACE FUNCTION crm_report_get_data_shift_transfer_by_date_v2
(
	p_user_role INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftDistributeId" INT,
	"DistributeDate" DATE,
	"ShiftId" INT,
	"ShiftName" VARCHAR,
	"LotteryTypeId" INT,
	"LotteryTypeName" VARCHAR,
	"TotalReceived" INT,
	"TotalReturns" INT,
	"TotalTrans" INT,
	"TotalSold" INT,
	"TotalRemaining" INT
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
				SF."ShiftDistributeId", 
				SD."DistributeDate", 
				SD."ShiftId",
				S."ShiftName",
				LT."LotteryTypeId",
				LT."LotteryTypeName",
				COALESCE(SF."TotalReceived", 0) AS "TotalReceived", 
				COALESCE(SF."TotalReturns", 0) AS "TotalReturns",
				COALESCE(SF."TotalTrans", 0) AS "TotalTrans",
				COALESCE(SF."TotalSold", 0) AS "TotalSold",
				COALESCE(SF."TotalRemaining", 0) AS "TotalRemaining"
			FROM "ShiftDistribute" SD 
				JOIN "ShiftTransfer" SF ON SD."ShiftDistributeId" = SF."ShiftDistributeId"
				JOIN "SalePoint" SP ON SD."SalePointId" = SP."SalePointId" 
				JOIN "LotteryType" LT ON SF."LotteryTypeId" = LT."LotteryTypeId"
				JOIN "Shift" S ON SD."ShiftId" = S."ShiftId"
				JOIN LIST L ON SP."SalePointId" = L."SalePointId"
			WHERE TO_CHAR(SD."DistributeDate", 'YYYY-MM-DD')::DATE = p_date::DATE
			ORDER BY SP."SalePointId", SD."DistributeDate", LT."LotteryTypeId" ;
		END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

