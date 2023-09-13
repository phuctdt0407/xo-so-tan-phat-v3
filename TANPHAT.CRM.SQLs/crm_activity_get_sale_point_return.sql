-- ================================
-- Author: Phi
-- Description: Lấy lịch sử nhận xuất vé
-- Created date: 18/03/2022
-- SELECT * FROM crm_activity_get_sale_point_return('2022-04-19');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_sale_point_return');
CREATE OR REPLACE FUNCTION crm_activity_get_sale_point_return
(
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"LotteryDate" DATE,
	"LotteryChannelId" INT,
	"LotteryChannelName" VARCHAR,
	"TotalReceived" INT,
	"TotalRemaining" INT,
	"TotalDupReceived" INT,
	"TotalDupRemaining" INT,
	"TransitionLog" TEXT
)
AS $BODY$
DECLARE 
	v_sale_point_id INT;
BEGIN

	RETURN QUERY 
	SELECT
		SP."SalePointId",
		SP."SalePointName",
		I."LotteryDate",
		I."LotteryChannelId",
		LC."LotteryChannelName",
		I."TotalReceived",
		I."TotalRemaining",
		I."TotalDupReceived",
		I."TotalDupRemaining",
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					T."LotteryDate",
					T."LotteryChannelId",
					LCC."LotteryChannelName",
					T."FromSalePointId",
					(CASE WHEN T."FromSalePointId" = 0 THEN 'Kho' ELSE SP."SalePointName" END) AS "FromSalePointName",
					T."ToSalePointId",
					(CASE WHEN T."ToSalePointId" = 0 THEN 'Kho' ELSE SP."SalePointName" END) AS "ToSalePointName",
					T."TotalTrans",
					T."TotalTransDup",
					T."ActionBy",
					T."ActionByName",
					T."TransitionTypeId",
					T."TransitionDate",
					T."ManagerId",
					U."FullName" AS "ManagerName"
				FROM "Transition" T
					JOIN "LotteryChannel" LCC ON LCC."LotteryChannelId" = T."LotteryChannelId"
					LEFT JOIN "User" U ON U."UserId" = T."ManagerId"
				WHERE T."LotteryDate" = p_date::DATE AND (T."FromSalePointId" = SP."SalePointId" OR T."ToSalePointId" = SP."SalePointId")
					AND T."TransitionTypeId" = 3
				ORDER BY T."TransitionDate"
			) r
		)::TEXT AS "TransitionLog"
	FROM "SalePoint" SP
		LEFT JOIN "Inventory" I ON I."SalePointId" = SP."SalePointId" AND I."LotteryDate" = p_date::DATE
		LEFT JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = I."LotteryChannelId"
	WHERE (I."SalePointId" IS NULL OR I."SalePointId" <> 0)  AND SP."IsActive" IS TRUE
	ORDER BY SP."SalePointId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE