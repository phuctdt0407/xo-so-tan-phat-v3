-- ================================
-- Author: Hiếu
-- Description:
-- Created date:

CREATE OR REPLACE FUNCTION update_report_lottery_inventorylog()
RETURNS TRIGGER AS $$
DECLARE 
	v_total_dup INT8;
	v_total INT8;
BEGIN
    IF EXISTS (SELECT 1 FROM "InventoryLog" WHERE "InventoryLogId" = NEW."InventoryLogId") 
									 AND NOT EXISTS (SELECT 1 FROM "ReportLottery" WHERE "LotteryDate" = NEW."LotteryDate"
												AND "LotteryChannelId" = NEW."LotteryChannelId"
												AND "SalePointId" = NEW."SalePointId")
		THEN
			FOR i IN 1..4 LOOP
					INSERT INTO "ReportLottery" 
					(
							"ShiftId", 
							"Date", 
							"LotteryChannelId", 
							"SalePointId", 
							"Stock", 
							"SoldRetail", 
							"Remaining", 
							--"LotteryTypeId", 
							"Transfer", 
							"Received", 
							"LotteryDate",
							"OrdinalNum", 
							"SoldRetailMoney",
							"SoldWholeSale",
							"SoldWholeSaleMoney",
							"ReceivedDup",
							"TransferDup",
							"RemainingDup"
					)
					VALUES(
						(CASE WHEN i % 2 = 0 THEN 2 ELSE 1 END),
						CASE WHEN i < 3 THEN (NEW."LotteryDate"::DATE - INTERVAL '1 day')  ELSE NEW."LotteryDate"::DATE END,
						NEW."LotteryChannelId",
						NEW."SalePointId",
						NEW."TotalReceived", 
						0, 
						NEW."TotalReceived", 
						--0, 
						0, 
						0 , 
						NEW."LotteryDate"::DATE,
						i,
						0,
						0,
						0,
						NEW."TotalDupReceived",
						0,
						NEW."TotalDupReceived"
					);
				END LOOP;
			ELSEIF NOT EXISTS (SELECT "AgencyId" FROM "InventoryLog" 
																							WHERE "LotteryDate" = NEW."LotteryDate"
																							AND "SalePointId" = NEW."SalePointId"
																							AND "LotteryChannelId" = NEW."LotteryChannelId"
																							AND NEW."AgencyId" = "AgencyId")
							 OR (OLD."IsMigrated" = FALSE AND NEW."IsMigrated" = TRUE) 
			THEN
					UPDATE "ReportLottery" 
					SET 
						"Stock" =  "Stock" + NEW."TotalReceived",
						"Remaining" = "Remaining" + NEW."TotalReceived",
						"StockDup" = "StockDup" + NEW."TotalDupReceived",
						"RemainingDup" = "RemainingDup" + NEW."TotalDupReceived"
					WHERE "LotteryDate" = NEW."LotteryDate"
						AND "LotteryChannelId" = NEW."LotteryChannelId"
						AND "SalePointId" = NEW."SalePointId";
					
			ELSE
					v_total_dup := COALESCE( NEW."TotalDupReceived", 0) - (SELECT COALESCE(OLD."TotalDupReceived", 0 )
														FROM "ReportLottery" 
														WHERE "LotteryDate" = NEW."LotteryDate"
															AND "LotteryChannelId" = NEW."LotteryChannelId"
															AND "SalePointId" = NEW."SalePointId"
															AND "OrdinalNum" = 1);
					v_total := COALESCE(NEW."TotalReceived", 0) - (SELECT COALESCE(OLD."TotalReceived", 0)
																	FROM "ReportLottery" 
																	WHERE "LotteryDate" = NEW."LotteryDate"
																		AND "LotteryChannelId" = NEW."LotteryChannelId"
																		AND "SalePointId" = NEW."SalePointId"
																		AND "OrdinalNum" = 1);
																		
				 UPDATE "ReportLottery" 
					SET 
						"Stock" =  "Stock" + v_total,
						"Remaining" = "Remaining" + v_total,
						"StockDup" = "StockDup" + v_total_dup,
						"RemainingDup" = "RemainingDup" + v_total_dup
					WHERE "LotteryDate" = NEW."LotteryDate"
						AND "LotteryChannelId" = NEW."LotteryChannelId"
						AND "SalePointId" = NEW."SalePointId";
			END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS crm_update_report_lottery_trigger_inventorylog ON "InventoryLog";
CREATE TRIGGER crm_update_report_lottery_trigger_inventorylog
AFTER INSERT OR UPDATE ON "InventoryLog"
FOR EACH ROW
EXECUTE FUNCTION update_report_lottery_inventorylog();
