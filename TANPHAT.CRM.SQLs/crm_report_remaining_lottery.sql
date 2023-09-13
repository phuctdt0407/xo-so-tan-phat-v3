-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_report_remaining_lottery('2023-03');
-- ================================
SELECT dropallfunction_byname('crm_report_remaining_lottery');
CREATE OR REPLACE FUNCTION crm_report_remaining_lottery
(
	p_month varchar
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"LotteryChannelName" VARCHAR,
	"LotteryDate" DATE,
	"TotalRemaining" INT8
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	WITH tmp AS (
        SELECT 
						S."SalePointId",
            S."SalePointName",
            I."LotteryChannelId",
            I."LotteryDate",
            LC."LotteryChannelName",
            SUM(I."TotalRemaining" + I."TotalDupRemaining") AS "TotalRemaining",
            SUM(I."TotalReceived" + I."TotalDupReceived") AS "TotalReceived"
        FROM "Inventory" I
        JOIN "SalePoint" S ON I."SalePointId" = S."SalePointId"
        JOIN "LotteryChannel" LC ON     I."LotteryChannelId" = LC."LotteryChannelId"
        WHERE 
            CASE WHEN TO_CHAR(NOW(),'YYYY-MM') = p_month
                THEN TO_CHAR(I."LotteryDate", 'YYYY-MM-DD') < TO_CHAR(NOW(),'YYYY-MM-DD')
                AND TO_CHAR(I."LotteryDate", 'YYYY-MM') = TO_CHAR(NOW(),'YYYY-MM')
            ELSE
                TO_CHAR(I."LotteryDate", 'YYYY-MM') = '2023-03'
            END
            AND I."SalePointId" <> 0
        GROUP BY 
						S."SalePointId",
            S."SalePointName",
            I."LotteryChannelId",
            I."LotteryDate",
            LC."LotteryChannelName"
    )
        SELECT 
						T."SalePointId",
            T."SalePointName",
            T."LotteryChannelName",
            T."LotteryDate",
            T."TotalRemaining" AS "TotalRemaining"
        FROM tmp T
        WHERE   T."TotalRemaining" > 0
    ORDER BY T."LotteryDate";
END;
$BODY$
LANGUAGE plpgsql VOLATILE