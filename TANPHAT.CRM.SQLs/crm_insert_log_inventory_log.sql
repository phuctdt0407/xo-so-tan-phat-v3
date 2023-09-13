-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_insert_log_inventory_log();
-- ================================
SELECT dropallfunction_byname('crm_insert_log_inventory_log');
CREATE OR REPLACE FUNCTION crm_insert_log_inventory_log
(
)
RETURNS TRIGGER AS
$BODY$
BEGIN
	IF COALESCE(NEW."TotalReceived", 0) <> COALESCE(OLD."TotalReceived", 0) OR COALESCE(NEW."TotalDupReceived", 0) <> COALESCE(OLD."TotalDupReceived", 0) THEN
		INSERT INTO "InventoryDetailLog"(
			"LotteryDate",
			"LotteryChannelId",
			"AgencyId",
			"TotalReceived",
			"TotalDupReceived",
			"SalePointId",
			"ActionDate",
			"ActionBy",
			"ActionByName"
		)
		VALUES(
			NEW."LotteryDate",
			NEW."LotteryChannelId",
			NEW."AgencyId",
			COALESCE(NEW."TotalReceived", 0) - COALESCE(OLD."TotalReceived", 0),
			COALESCE(NEW."TotalDupReceived", 0) - COALESCE(OLD."TotalDupReceived", 0),
			NEW."SalePointId",
			NEW."ActionDate",
			NEW."ActionBy",
			NEW."ActionByName"
		);
	END IF;
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE


