-- ================================
-- Author: Phi
-- Description: Lấy danh sách lịch sử bán hàng của điểm bán
-- Created date: 07/04/2022
-- SELECT * FROM crm_activity_trans_log(126);
-- ================================
SELECT dropallfunction_byname('crm_activity_trans_log');
CREATE OR REPLACE FUNCTION crm_activity_trans_log
(
	p_shift_distribute_id INT
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"TransitionDate" TIMESTAMP,
	"TransitionTypeId" INT,
	"TransitionTypeName" VARCHAR,
	"ManagerId" INT,
	"ManagerName" VARCHAR,
	"ConfirmStatusId" INT,
	"ConfirmStatusName" VARCHAR,
	"ConfirmDate" TIMESTAMP,
	"FromSalePointId" INT,
	"FromSalePointName" VARCHAR,
	"ToSalePointId" INT,
	"ToSalePointName" VARCHAR,
	"DetailData" TEXT
)
AS $BODY$
DECLARE
	
BEGIN

	RETURN QUERY
	SELECT 
		ROW_NUMBER() OVER(ORDER BY T."TransitionDate" DESC) AS "RowNumber",
		T."TransitionDate",
		T."TransitionTypeId",
		TT."TransitionTypeName",
		T."ManagerId",
		U."FullName" AS "ManagerName",
		T."ConfirmStatusId",
		CS."ConfirmStatusName",
		T."ConfirmDate",
		T."FromSalePointId",
		(CASE WHEN T."FromSalePointId" = 0 THEN 'Kho' ELSE SP."SalePointName" END) AS "FromSalePointName",
		T."ToSalePointId",
		(CASE WHEN T."ToSalePointId" = 0 THEN 'Kho' ELSE SP."SalePointName" END) AS "ToSalePointName",
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					R."LotteryChannelId",
					LC."LotteryChannelName",
					R."TotalTrans",
					R."TotalTransDup",
					R."IsScratchcard"
				FROM "Transition" R
					JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = R."LotteryChannelId"
				WHERE R."TransitionDate" = T."TransitionDate"
				ORDER BY LC."LotteryChannelTypeId"
			) r
		)::TEXT AS "DetailData"
	FROM "Transition" T
		JOIN "TransitionType" TT ON TT."TransitionTypeId" = T."TransitionTypeId"
		JOIN "ConfirmStatus" CS ON CS."ConfirmStatusId" = T."ConfirmStatusId"
		JOIN "SalePoint" SP ON (SP."SalePointId" = T."ToSalePointId" OR SP."SalePointId" = T."FromSalePointId")
		JOIN "User" U ON U."UserId" = T."ManagerId"
	WHERE T."ShiftDistributeId" = p_shift_distribute_id
	GROUP BY
		T."TransitionDate",
		T."TransitionTypeId",
		TT."TransitionTypeName",
		T."ManagerId",
		U."FullName",
		T."ConfirmStatusId",
		T."ConfirmDate",
		CS."ConfirmStatusName",
		T."FromSalePointId",
		T."ToSalePointId",
		SP."SalePointName";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE