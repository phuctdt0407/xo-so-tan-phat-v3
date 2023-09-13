-- ================================
-- Author: Hiếu
-- Description:
-- Created date:

CREATE OR REPLACE FUNCTION update_report_lottery_salepointlog()
RETURNS TRIGGER AS $$
DECLARE
	v_total_dup INT8;
	v_total INT8;
BEGIN
		IF NEW."IsDeleted" = TRUE AND OLD."IsDeleted" = FALSE AND NEW."LotteryTypeId" != 3
			THEN
				UPDATE "ReportLottery"
				SET 
					"SoldRetail" = "SoldRetail" - (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NOT NULL
													THEN 0 ELSE NEW."Quantity"  END),
					"SoldRetailMoney" = "SoldRetailMoney" - (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NOT NULL
													THEN 0 ELSE NEW."TotalValue"  END),
					"SoldWholeSale" = "SoldWholeSale" - (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NULL
													THEN 0 ELSE NEW."Quantity" END),
					"SoldWholeSaleMoney" = "SoldWholeSaleMoney" - (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NULL
													THEN 0 ELSE NEW."TotalValue" END),
					"SoldRetailDup" = "SoldRetailDup" - (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NULL
													THEN NEW."Quantity" ELSE 0 END),
					"SoldRetailMoneyDup" = "SoldRetailMoneyDup" - (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NULL
													THEN NEW."TotalValue"  ELSE 0 END),
					"SoldWholeSaleDup" = "SoldWholeSaleDup" - (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NOT NULL
													THEN NEW."Quantity"  ELSE 0 END),
					"SoldWholeSaleMoneyDup" = "SoldWholeSaleMoneyDup" - (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NOT NULL
													THEN NEW."TotalValue"  ELSE 0 END),
					"Remaining" = "Remaining" + (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
					"RemainingDup" = "RemainingDup" + (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END)
				WHERE "ShiftId" = (SELECT "ShiftId" 
													  FROM "ShiftDistribute" 
														WHERE "ShiftDistributeId" = NEW."ShiftDistributeId") 
					AND "Date" = NEW."ActionDate"::DATE
					AND "LotteryChannelId" = NEW."LotteryChannelId"
					AND "SalePointId" = NEW."SalePointId";
					
			UPDATE "ReportLottery"
			SET 
				"Remaining" = "Remaining" + (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
				"Stock" = "Remaining" + "SoldRetail" + "SoldWholeSale" + "Transfer" - "Received" + (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
			 "RemainingDup" = "RemainingDup" + (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END),
				"StockDup" = "RemainingDup" + "SoldRetailDup" + "SoldWholeSaleDup" + "TransferDup" + "ReceivedDup" + (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END)
			WHERE "LotteryDate" = NEW."LotteryDate"
				AND "OrdinalNum" > (SELECT "OrdinalNum" 
														FROM "ReportLottery" 
															WHERE "ShiftId" = (SELECT "ShiftId" 
																									FROM "ShiftDistribute" 
																									WHERE "ShiftDistributeId" = NEW."ShiftDistributeId")  
															AND "Date" = NEW."ActionDate"::DATE
															AND "LotteryChannelId" = NEW."LotteryChannelId"
															AND "SalePointId" = NEW."SalePointId"
															ORDER BY "OrdinalNum"
															LIMIT 1)
				AND "SalePointId" = NEW."SalePointId"
				AND "LotteryChannelId" = NEW."LotteryChannelId";
		ELSEIF  NEW."IsMigrated" = TRUE AND OLD."IsMigrated" IS FALSE AND NEW."IsDeleted" IS FALSE
			THEN
				UPDATE "ReportLottery"
				SET 
					"SoldRetail" = "SoldRetail" + (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NOT NULL
													THEN 0 ELSE NEW."Quantity"  END),
					"SoldRetailMoney" = "SoldRetailMoney" + (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NOT NULL
													THEN 0 ELSE NEW."TotalValue"  END),
					"SoldWholeSale" = "SoldWholeSale" + (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NULL
													THEN 0 ELSE NEW."Quantity" END),
					"SoldWholeSaleMoney" = "SoldWholeSaleMoney" + (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NULL
													THEN 0 ELSE NEW."TotalValue" END),
					"SoldRetailDup" = "SoldRetailDup" + (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NULL
													THEN NEW."Quantity" ELSE 0 END),
					"SoldRetailMoneyDup" = "SoldRetailMoneyDup" + (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NULL
													THEN NEW."TotalValue"  ELSE 0 END),
					"SoldWholeSaleDup" = "SoldWholeSaleDup" + (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NOT NULL
													THEN NEW."Quantity"  ELSE 0 END),
					"SoldWholeSaleMoneyDup" = "SoldWholeSaleMoneyDup" + (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NOT NULL
													THEN NEW."TotalValue"  ELSE 0 END),
					"Remaining" = "Remaining" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
					"RemainingDup" = "RemainingDup" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END)
				WHERE "ShiftId" = (SELECT "ShiftId" 
													  FROM "ShiftDistribute" 
														WHERE "ShiftDistributeId" = NEW."ShiftDistributeId") 
					AND "Date" = NEW."ActionDate"::DATE
					AND "LotteryChannelId" = NEW."LotteryChannelId"
					AND "SalePointId" = NEW."SalePointId"
					AND NEW."IsDeleted" IS FALSE;
					
			UPDATE "ReportLottery"
			SET 
				"Remaining" = "Remaining" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
				"Stock" = "Remaining" + "SoldRetail" + "SoldWholeSale" + "Transfer" - "Received" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
			 "RemainingDup" = "RemainingDup" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END),
				"StockDup" = "RemainingDup" + "SoldRetailDup" + "SoldWholeSaleDup" + "TransferDup" + "ReceivedDup" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END)
			WHERE "LotteryDate" = NEW."LotteryDate"
				AND "OrdinalNum" > (SELECT "OrdinalNum" 
														FROM "ReportLottery" 
															WHERE "ShiftId" = (SELECT "ShiftId" 
																									FROM "ShiftDistribute" 
																									WHERE "ShiftDistributeId" = NEW."ShiftDistributeId")  
															AND "Date" = NEW."ActionDate"::DATE
															AND "LotteryChannelId" = NEW."LotteryChannelId"
															AND "SalePointId" = NEW."SalePointId"
															ORDER BY "OrdinalNum"
															LIMIT 1)
				AND "SalePointId" = NEW."SalePointId"
				AND "LotteryChannelId" = NEW."LotteryChannelId";
					
					ELSEIF NEW."IsDeleted" IS FALSE AND NOT EXISTS (SELECT 1 FROM "SalePointLog" WHERE "SalePointLogId" = NEW."SalePointLogId")
			THEN
				UPDATE "ReportLottery"
				SET 
					"SoldRetail" = "SoldRetail" + (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NOT NULL
													THEN 0 ELSE NEW."Quantity"  END),
					"SoldRetailMoney" = "SoldRetailMoney" + (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NOT NULL
													THEN 0 ELSE NEW."TotalValue"  END),
					"SoldWholeSale" = "SoldWholeSale" + (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NULL
													THEN 0 ELSE NEW."Quantity" END),
					"SoldWholeSaleMoney" = "SoldWholeSaleMoney" + (CASE WHEN NEW."LotteryTypeId" = 2 OR NEW."GuestId" IS NULL
													THEN 0 ELSE NEW."TotalValue" END),
					"SoldRetailDup" = "SoldRetailDup" + (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NULL
													THEN NEW."Quantity" ELSE 0 END),
					"SoldRetailMoneyDup" = "SoldRetailMoneyDup" + (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NULL
													THEN NEW."TotalValue"  ELSE 0 END),
					"SoldWholeSaleDup" = "SoldWholeSaleDup" + (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NOT NULL
													THEN NEW."Quantity"  ELSE 0 END),
					"SoldWholeSaleMoneyDup" = "SoldWholeSaleMoneyDup" + (CASE WHEN NEW."LotteryTypeId" = 2 AND NEW."GuestId" IS NOT NULL
													THEN NEW."TotalValue"  ELSE 0 END),
					"Remaining" = "Remaining" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
					"RemainingDup" = "RemainingDup" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END)
				WHERE "ShiftId" = (SELECT "ShiftId" 
													  FROM "ShiftDistribute" 
														WHERE "ShiftDistributeId" = NEW."ShiftDistributeId") 
					AND "Date" = NEW."ActionDate"::DATE
					AND "LotteryChannelId" = NEW."LotteryChannelId"
					AND "SalePointId" = NEW."SalePointId"
					AND NEW."IsDeleted" IS FALSE;
					
			UPDATE "ReportLottery"
			SET 
				"Remaining" = "Remaining" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
				"Stock" = "Remaining" + "SoldRetail" + "SoldWholeSale" + "Transfer" - "Received" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN 0 ELSE NEW."Quantity" END),
			 "RemainingDup" = "RemainingDup" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END),
				"StockDup" = "RemainingDup" + "SoldRetailDup" + "SoldWholeSaleDup" + "TransferDup" + "ReceivedDup" - (CASE WHEN NEW."LotteryTypeId" = 2  
													THEN NEW."Quantity" ELSE 0 END)
			WHERE "LotteryDate" = NEW."LotteryDate"
				AND "OrdinalNum" > (SELECT "OrdinalNum" 
														FROM "ReportLottery" 
															WHERE "ShiftId" = (SELECT "ShiftId" 
																									FROM "ShiftDistribute" 
																									WHERE "ShiftDistributeId" = NEW."ShiftDistributeId")  
															AND "Date" = NEW."ActionDate"::DATE
															AND "LotteryChannelId" = NEW."LotteryChannelId"
															AND "SalePointId" = NEW."SalePointId"
															ORDER BY "OrdinalNum"
															LIMIT 1)
				AND "SalePointId" = NEW."SalePointId"
				AND "LotteryChannelId" = NEW."LotteryChannelId";
		END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS crm_update_report_lottery_trigger_salepointlog ON "SalePointLog";
CREATE TRIGGER crm_update_report_lottery_trigger_salepointlog
BEFORE INSERT OR UPDATE ON "SalePointLog"
FOR EACH ROW
EXECUTE FUNCTION update_report_lottery_salepointlog();
