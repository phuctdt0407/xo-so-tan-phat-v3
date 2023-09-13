-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_data_shift_transfer_by_date('2022-03-28');
-- ================================
SELECT dropallfunction_byname('crm_report_get_data_shift_transfer_by_date');
CREATE OR REPLACE FUNCTION crm_report_get_data_shift_transfer_by_date
(
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
BEGIN
	RETURN QUERY
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
		WHERE TO_CHAR(SD."DistributeDate", 'YYYY-MM-DD')::DATE = p_date::DATE
		ORDER BY SP."SalePointId", SD."DistributeDate", LT."LotteryTypeId" ;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

