-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_current_store_of_sale_point_by_channel(1,0,3, NULL);
-- ================================
SELECT dropallfunction_byname('crm_get_current_store_of_sale_point_by_channel');
CREATE OR REPLACE FUNCTION crm_get_current_store_of_sale_point_by_channel
(
	p_sale_point_id INT,
	p_channel_id INT,
	p_lottery_type_id INT,
	p_lottery_date DATE
)
RETURNS INT
AS $BODY$
DECLARE
BEGIN
	IF p_lottery_type_id = 1 THEN
		RETURN (SELECT I."TotalRemaining"
						FROM "Inventory" I
						WHERE I."LotteryDate" = p_lottery_date
							AND I."LotteryChannelId" = p_channel_id
							AND I."SalePointId" = p_sale_point_id);
	ELSEIF p_lottery_type_id = 2 THEN
		RETURN (SELECT I."TotalDupRemaining"
						FROM "Inventory" I
						WHERE I."LotteryDate" = p_lottery_date
							AND I."LotteryChannelId" = p_channel_id
							AND I."SalePointId" = p_sale_point_id);
	ELSE 
		RETURN (SELECT S."TotalRemaining"
						FROM "Scratchcard" S
						WHERE S."SalePointId" = p_sale_point_id);
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE


