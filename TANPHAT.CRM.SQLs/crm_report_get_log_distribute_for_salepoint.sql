-- ================================
-- Author: Tien
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_log_distribute_for_salepoint('2022-06-06',3);
-- ================================
SELECT dropallfunction_byname('crm_report_get_log_distribute_for_salepoint');
CREATE OR REPLACE FUNCTION crm_report_get_log_distribute_for_salepoint
(
	p_date TIMESTAMP,
	p_sale_point_id INT DEFAULT 0
)
RETURNS TABLE
(
"LotteryDate" DATE,
"LotteryChannelId" INT,
"TotalReceived" INT8,
"TotalDupReceived" INT8,
"SalePointId" INT,
"ActionDate" TIMESTAMP,
"ShortName" VARCHAR
)
AS $BODY$
DECLARE
BEGIN
RETURN QUERY

SELECT
	IL."LotteryDate",
	IL."LotteryChannelId",
	SUM(IL."TotalReceived"),
	SUM(IL."TotalDupReceived"),
	IL."SalePointId",
	IL."ActionDate",
	LC."ShortName"
FROM "InventoryDetailLog" IL 
	JOIN "LotteryChannel" LC ON LC."LotteryChannelId"= IL."LotteryChannelId"
WHERE IL."LotteryDate" = p_date::DATE 
	AND ((COALESCE(p_sale_point_id, 0) = 0) OR IL."SalePointId" = p_sale_point_id)
GROUP BY
	IL."LotteryDate",
	IL."LotteryChannelId",
	IL."ActionDate",
	IL."SalePointId",
	LC."ShortName",
	LC."LotteryChannelTypeId"
ORDER BY
	IL."ActionDate" DESC,
	LC."LotteryChannelTypeId";
	
		
END;
$BODY$
LANGUAGE plpgsql VOLATILE