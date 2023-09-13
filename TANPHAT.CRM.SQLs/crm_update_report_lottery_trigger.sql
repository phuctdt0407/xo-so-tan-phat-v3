-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
CREATE OR REPLACE FUNCTION update_report_lottery_transition()
RETURNS TRIGGER AS $$
DECLARE 
	v_total_dup INT8;
	v_total INT8;
BEGIN
			-- xử lý trường hợp chuyển vé
    IF EXISTS (SELECT 1 FROM "Transition" WHERE "TransitionId" = NEW."TransitionId" 
																					AND NEW."TransitionTypeId" = 1 
																					AND NEW."ConfirmStatusId" = 2 
																					AND "IsDeleted" = FALSE)
		THEN
        UPDATE "ReportLottery" 
					SET 
						"Transfer" = "Transfer" + COALESCE(NEW."TotalTrans", 0) ,
						"TransferDup" = "TransferDup" + COALESCE(NEW."TotalTransDup", 0),
						"Remaining" = "Remaining" - COALESCE( NEW."TotalTrans", 0),
						"RemainingDup" = "RemainingDup" - COALESCE(NEW."TotalTransDup" ,0)
					WHERE "ShiftId" = (SELECT "ShiftId" 
																									FROM "ShiftDistribute" 
																									WHERE "ShiftDistributeId" = NEW."ShiftDistributeId") 
						AND "Date" = NEW."TransitionDate"::DATE
						AND "LotteryDate" = NEW."LotteryDate"
						AND "LotteryChannelId" = NEW."LotteryChannelId"
						AND "SalePointId" = NEW."FromSalePointId";
		ELSEIF (SELECT 1 FROM "Transition" WHERE "TransitionId" = NEW."TransitionId" 
																					AND NEW."TransitionTypeId" = 2 
																					AND NEW."ConfirmStatusId" = 2
																					AND "IsDeleted" = FALSE)
		THEN
		  -- xử lý trường hợp Nhận vé nếu đã tồn tại dòng thì update không thì insert
				IF EXISTS (SELECT 1 FROM "ReportLottery" 
															WHERE "ShiftId" = (SELECT "ShiftId" FROM "ShiftDistribute" 
																									WHERE "ShiftDistributeId" = NEW."ShiftDistributeId") 
															AND "Date" = NEW."TransitionDate"::DATE
															AND "LotteryDate" = NEW."LotteryDate"
															AND "LotteryChannelId" = NEW."LotteryChannelId"
															AND "SalePointId" = NEW."ToSalePointId" )
				THEN
					UPDATE "ReportLottery" 
					SET 
						"Received" = "Received"  +  COALESCE( NEW."TotalTrans", 0) ,
						"ReceivedDup" = "ReceivedDup"  + COALESCE( NEW."TotalTransDup",0) ,
						"Remaining" = "Remaining" +  COALESCE(NEW."TotalTrans",0),
						"RemainingDup" = "RemainingDup" + COALESCE( NEW."TotalTransDup",0)
					WHERE "ShiftId" = (SELECT "ShiftId" FROM "ShiftDistribute" 
																								WHERE "ShiftDistributeId" = NEW."ShiftDistributeId") 
						AND "Date" = NEW."TransitionDate"::DATE
						AND "Date" = NEW."LotteryDate"
						AND "LotteryChannelId" = NEW."LotteryChannelId"
						AND "SalePointId" = NEW."ToSalePointId";
				ELSE
					FOR i IN 1..(3 - (SELECT "ShiftId" FROM "ShiftDistribute" 
																								WHERE "ShiftDistributeId" = NEW."ShiftDistributeId")) LOOP
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
						ABS((i+(3 - (SELECT "ShiftId" FROM "ShiftDistribute" 
																								WHERE "ShiftDistributeId" = NEW."ShiftDistributeId")) % 2) % 2 - 2),
						NEW."TransitionDate"::DATE,
						NEW."LotteryChannelId",
						NEW."ToSalePointId",
						0, 
						0, 
						NEW."TotalTrans", 
						--0, 
						0, 
						(CASE WHEN i = 1 THEN NEW."TotalTrans" ELSE 0 END) , 
						NEW."LotteryDate"::DATE,
						i,
						0,
						0,
						0,
						(CASE WHEN i = 1 THEN NEW."TotalTransDup" ELSE 0 END),
						0,
						NEW."TotalTransDup"
						
					);
				END LOOP;
				END IF;
    ELSE
        -- neu co truong hop tip them o day
    END IF;
					-- cập nhật lại stock, Remaining của các ca sau. 
		IF (NEW."TransitionTypeId" = 1 OR NEW."TransitionTypeId" = 2 ) AND NEW."ConfirmStatusId" = 2 AND NEW."IsDeleted" = FALSE
		THEN
			UPDATE "ReportLottery"
			SET 
				"Remaining" = "Remaining" + (CASE WHEN NEW."TransitionTypeId" = 1  THEN - COALESCE(NEW."TotalTrans",0)
																					ELSE COALESCE(NEW."TotalTrans",0) END),
				"Stock" =  "Remaining" + (CASE WHEN NEW."TransitionTypeId" = 1  THEN - COALESCE(NEW."TotalTrans",0)
																					ELSE COALESCE(NEW."TotalTrans",0) END),
			 "RemainingDup" = "RemainingDup" + (CASE WHEN NEW."TransitionTypeId" = 1  THEN - COALESCE(NEW."TotalTransDup",0)
																					ELSE COALESCE(NEW."TotalTransDup",0) END),
				"StockDup" = "RemainingDup" + (CASE WHEN NEW."TransitionTypeId" = 1  THEN - COALESCE(NEW."TotalTransDup",0)
																					ELSE COALESCE(NEW."TotalTransDup",0) END)
			WHERE "LotteryDate" = NEW."LotteryDate"
				AND "OrdinalNum" > (SELECT "OrdinalNum" 
														FROM "ReportLottery" 
															WHERE "ShiftId" = (SELECT "ShiftId" 
																									FROM "ShiftDistribute" 
																									WHERE "ShiftDistributeId" = NEW."ShiftDistributeId")  
															AND "Date" = NEW."TransitionDate"::DATE
															AND "LotteryDate" = NEW."LotteryDate"
															AND "LotteryChannelId" = NEW."LotteryChannelId"
															AND "SalePointId"= (CASE WHEN NEW."TransitionTypeId" = 2 
																									THEN NEW."ToSalePointId" ELSE NEW."FromSalePointId" END))
				AND "SalePointId" = (CASE WHEN NEW."TransitionTypeId" = 2 
																									THEN NEW."ToSalePointId" ELSE NEW."FromSalePointId" END)
				AND "LotteryChannelId" = NEW."LotteryChannelId";
		END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS crm_update_report_lottery_trigger ON "Transition";
CREATE TRIGGER crm_update_report_lottery_trigger
AFTER INSERT OR UPDATE ON "Transition"
FOR EACH ROW
EXECUTE FUNCTION update_report_lottery_transition();
