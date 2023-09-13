-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_trigger_update_salepoint();
-- ================================
SELECT dropallfunction_byname('crm_report_trigger_update_salepoint');
CREATE OR REPLACE FUNCTION crm_report_trigger_update_salepoint
(
)
RETURNS TRIGGER AS
$BODY$
BEGIN
	IF NEW."IsDeleted" IS TRUE AND OLD."IsDeleted" IS FALSE  THEN
--Inventory
			UPDATE "Inventory" 
			SET 
				"TotalRemaining" = "TotalRemaining" + (CASE WHEN NEW."LotteryTypeId" =1 THEN NEW."Quantity" ELSE 0 END),
				"TotalDupRemaining" = "TotalDupRemaining" + (CASE WHEN NEW."LotteryTypeId" =2 THEN NEW."Quantity" ELSE 0 END)
			WHERE
				"SalePointId" = NEW."SalePointId" 
				AND "LotteryDate" = NEW."LotteryDate"
				AND "LotteryChannelId"= NEW."LotteryChannelId";
--Scratchcard
			UPDATE "Scratchcard" 
			SET 
				"TotalRemaining" = "TotalRemaining" + (CASE WHEN NEW."LotteryTypeId" =3 THEN NEW."Quantity" ELSE 0 END)
			WHERE
				"SalePointId" = NEW."SalePointId" 
				AND "LotteryChannelId"= NEW."LotteryChannelId";
		
	ELSEIF NEW."IsDeleted" IS FALSE  AND OLD."IsDeleted" IS TRUE THEN
--Inventory
		UPDATE "Inventory" 
			SET 
				"TotalRemaining" = "TotalRemaining" - (CASE WHEN NEW."LotteryTypeId" =1 THEN NEW."Quantity" ELSE 0 END),
				"TotalDupRemaining" = "TotalDupRemaining" - (CASE WHEN NEW."LotteryTypeId" =2 THEN NEW."Quantity" ELSE 0 END)
			WHERE
				"SalePointId" = NEW."SalePointId" 
				AND "LotteryDate" = NEW."LotteryDate"
				AND "LotteryChannelId"= NEW."LotteryChannelId";
--"Scratchcard"
		UPDATE "Scratchcard" 
			SET 
				"TotalRemaining" = "TotalRemaining" - (CASE WHEN NEW."LotteryTypeId" =3 THEN NEW."Quantity" ELSE 0 END)
			WHERE
				"SalePointId" = NEW."SalePointId"
				AND "LotteryChannelId"= NEW."LotteryChannelId";
	END IF;
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE