-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_lottery_not_sell_by_date('2022-06-05', NULL);
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_lottery_not_sell_by_date');
CREATE OR REPLACE FUNCTION crm_report_get_total_lottery_not_sell_by_date
(
	p_date TIMESTAMP,
	p_month VARCHAR
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"TotalRemaining" INT8,
	"TotalDupRemaining" INT8,
	"DataShift" TEXT
)
AS $BODY$
BEGIN
	IF p_month IS NULL THEN
		RETURN QUERY
		WITH tmp AS (
			SELECT 
				I."SalePointId", 
				SPP."SalePointName",
				I."LotteryChannelId",
				LC."LotteryChannelName", 
				COALESCE(SUM(CASE WHEN SFF."LotteryTypeId"=1 THEN SFF."TotalReturns" END), 0) AS "TotalRemaining",
				COALESCE(SUM(CASE WHEN SFF."LotteryTypeId"=2 THEN SFF."TotalReturns" END), 0) AS "TotalDupRemaining",
				(
					SELECT array_to_json(ARRAY_AGG (r))
					FROM
					(
						SELECT
							SD."ShiftId", 
							SD."ShiftDistributeId",
							I."LotteryChannelId",
							COALESCE(SUM(SF."TotalTrans"),0) AS "TotalTrans"
						FROM "ShiftDistribute" SD
							LEFT JOIN "ShiftTransfer" SF ON (SD."ShiftDistributeId" = SF."ShiftDistributeId" AND SF."LotteryChannelId" =  I."LotteryChannelId")
						WHERE SD."DistributeDate" = p_date :: DATE
							AND SD."SalePointId" = I."SalePointId"	
						GROUP BY 
							SD."ShiftId", 
							SD."ShiftDistributeId",
							SF."LotteryChannelId"
						ORDER BY SD."ShiftId"
					) r
				) :: TEXT AS "DataShift"
			FROM "SalePoint" SP
				JOIN "ShiftDistribute" SDD ON (SP."SalePointId" = SDD."SalePointId" AND SDD."DistributeDate" = p_date :: DATE)
				JOIN "ShiftTransfer" SFF ON (SDD."ShiftDistributeId" = SFF."ShiftDistributeId" AND SFF."LotteryTypeId" <> 3)
				RIGHT JOIN "Inventory" I ON (SFF."LotteryChannelId" = I."LotteryChannelId"
																		AND SFF."LotteryDate" = I."LotteryDate"
																		AND I."SalePointId" = SP."SalePointId")
				JOIN "LotteryChannel" LC ON I."LotteryChannelId" = LC."LotteryChannelId"
				JOIN "SalePoint" SPP ON I."SalePointId" = SPP."SalePointId"

			WHERE I."SalePointId" <> 0
				AND (I."LotteryDate" = p_date::DATE OR I."LotteryDate" = ((p_date ::DATE) + INTERVAL '1 DAY')) 
				AND SP."IsActive" IS TRUE
			GROUP BY 
				I."SalePointId",
				SPP."SalePointName",
				I."LotteryChannelId",
				LC."LotteryChannelName"
			ORDER BY I."SalePointId", I."LotteryChannelId"
		)
		SELECT
			A."SalePointId",
			A."SalePointName",
			A."LotteryChannelId",
			A."LotteryChannelName",
			A."TotalRemaining",
			A."TotalDupRemaining",
			A."DataShift"
		FROM tmp A
			JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = A."LotteryChannelId"
		ORDER BY A."SalePointId", LC."LotteryChannelTypeId", A."LotteryChannelId";
	ELSE
		RETURN QUERY
		WITH tmp AS (
			SELECT 
				I."SalePointId", 
				SPP."SalePointName",
				I."LotteryChannelId",
				LC."LotteryChannelName", 
				COALESCE(SUM(CASE WHEN SFF."LotteryTypeId"=1 THEN SFF."TotalReturns" END), 0) AS "TotalRemaining",
				COALESCE(SUM(CASE WHEN SFF."LotteryTypeId"=2 THEN SFF."TotalReturns" END), 0) AS "TotalDupRemaining",
				NULL AS "DataShift"
			FROM "SalePoint" SP
				JOIN "ShiftDistribute" SDD ON (SP."SalePointId" = SDD."SalePointId" AND TO_CHAR(SDD."DistributeDate",'YYYY-MM') = p_month)
				JOIN "ShiftTransfer" SFF ON (SDD."ShiftDistributeId" = SFF."ShiftDistributeId" AND SFF."LotteryTypeId" <> 3)
				RIGHT JOIN "Inventory" I ON (SFF."LotteryChannelId" = I."LotteryChannelId"
																		AND SFF."LotteryDate" = I."LotteryDate"
																		AND I."SalePointId" = SP."SalePointId")
				JOIN "LotteryChannel" LC ON I."LotteryChannelId" = LC."LotteryChannelId"
				JOIN "SalePoint" SPP ON I."SalePointId" = SPP."SalePointId"

			WHERE I."SalePointId" <> 0 AND (TO_CHAR(I."LotteryDate", 'YYYY-MM')= p_month) AND SP."IsActive" IS TRUE
			GROUP BY 
				I."SalePointId",
				SPP."SalePointName",
				I."LotteryChannelId",
				LC."LotteryChannelName"
			ORDER BY I."SalePointId", I."LotteryChannelId"
		)
		SELECT
			A."SalePointId",
			A."SalePointName",
			A."LotteryChannelId",
			A."LotteryChannelName",
			A."TotalRemaining",
			A."TotalDupRemaining",
			A."DataShift"
		FROM tmp A
			JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = A."LotteryChannelId"
		ORDER BY A."SalePointId", LC."LotteryChannelTypeId", A."LotteryChannelId";
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE


