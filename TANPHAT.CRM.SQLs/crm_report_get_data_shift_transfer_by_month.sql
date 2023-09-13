-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_data_shift_transfer_by_month('2022-03');
-- ================================
SELECT dropallfunction_byname('crm_report_get_data_shift_transfer_by_month');
CREATE OR REPLACE FUNCTION crm_report_get_data_shift_transfer_by_month
(
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
BEGIN
RETURN QUERY
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
	WHERE TO_CHAR(SD."DistributeDate", 'YYYY-MM') = p_month
	GROUP BY SD."DistributeDate", SF."LotteryTypeId", LT."LotteryTypeName", SP."SalePointId", SP."SalePointName"
	ORDER BY SP."SalePointId", SD."DistributeDate";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

