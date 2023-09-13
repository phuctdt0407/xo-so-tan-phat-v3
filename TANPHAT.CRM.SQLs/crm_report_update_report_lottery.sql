-- ================================
-- Author: Hieu
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_report_update_report_lottery(1,1,1001,3,1,0,0,20,0,10000,0,0,'2023-03-14')
-- ================================
SELECT dropallfunction_byname('crm_report_update_report_lottery');
CREATE OR REPLACE FUNCTION crm_report_update_report_lottery
(   
		p_shift_id INT,
		p_sale_point_id INT,
		p_lotteryChannel_id INT,
		p_lottery_type_id INT,
		p_report_type INT,
		p_received INT,
		p_transfer INT,
		p_sold_retail INT4,
		p_sold_wholesale INT4,
		p_sold_retail_money INT8,
		p_sold_wholesale_money INT8,
		p_split_tickets INT8,
		p_lottery_date VARCHAR
)
RETURNS TABLE
(   
    "Id" INT,    
    "Message" TEXT
)
AS $BODY$
DECLARE   
v_id INT;  
v_mess TEXT;   
v_stock INT8;
v_remaining INT8;
v_ordinal_num INT;
v_remaining_split_tickets INT8;
v_shift_distribute_id INT;
BEGIN
			-- lấy remaining khi chia vé
		v_remaining_split_tickets:= p_split_tickets -  (SELECT "Stock" FROM "ReportLottery"
																																		WHERE "ShiftId" = p_shift_id 
																																		AND "Date" = NOW()::DATE
																																		AND "LotteryChannelId" = p_lotteryChannel_id
																																		AND "SalePointId" = p_sale_point_id); 
			-- lấy shift distribute để chạy hàm crm_get_previous_remaining_v2
		v_shift_distribute_id := (CASE WHEN p_shift_id = 1 
																		THEN
																			(SELECT "ShiftDistributeId" 
																				FROM "ShiftDistribute" 
																				WHERE "DistributeDate" = (NOW() - INTERVAL '1 day')::DATE
																					AND "SalePointId" = p_sale_point_id
																					AND "ShiftId" = 2)
																		ELSE
																			(SELECT "ShiftDistributeId" 
																				FROM "ShiftDistribute"
																				WHERE "DistributeDate" = NOW()::DATE 
																					AND "SalePointId" = p_sale_point_id
																					AND "ShiftId" = 1)
																END
															);
			-- stock = remainning ca trước 
		v_stock := (SELECT * FROM crm_get_previous_remaining_v2(v_shift_distribute_id, p_lotteryChannel_id, 					p_lottery_type_id, p_lottery_date::DATE,(NOW() - INTERVAL '1 day')::DATE));							
		-- v_remaining :=?								
		-- neu chua ton tai thi tao moi
		IF NOT EXISTS (SELECT * FROM "ReportLottery" WHERE "ShiftId" = p_shift_id 
																									AND "Date" = NOW()::DATE
																									AND "LotteryChannelId" = p_lotteryChannel_id
																									AND "SalePointId" = p_sale_point_id)
			THEN
				FOR i IN 1..(5 - p_shift_id) LOOP
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
							"SoldWholeSaleMoney"
					)
					VALUES(
						ABS((i+(5 - p_shift_id) % 2) % 2 - 2),
						CASE WHEN i < 3 THEN NOW()::DATE ELSE (NOW() + INTERVAL '1 day')::DATE END,
						p_lotteryChannel_id,
						p_sale_point_id,
						v_stock, 
						(CASE WHEN i = 1 THEN p_sold_retail ELSE 0 END), 
						v_stock, 
						--p_lottery_type_id, 
						(CASE WHEN i = 1 THEN p_transfer ELSE 0 END), 
						(CASE WHEN i = 1 THEN p_received ELSE 0 END) , 
						p_lottery_date::DATE,
						i,
						(CASE WHEN i = 1 THEN p_sold_retail_money ELSE 0 END),
						(CASE WHEN i = 1 THEN p_sold_wholesale ELSE 0 END),
						(CASE WHEN i = 1 THEN p_sold_wholesale_money ELSE 0 END)
					);
				END LOOP;
		ELSE
			-- sử lý trường hợp bán vé
			IF p_report_type = 1
			THEN
				UPDATE "ReportLottery" 
				SET 
					"SoldRetail" = "SoldRetail" + p_sold_retail,
					"SoldRetailMoney" = "SoldRetailMoney" + p_sold_retail_money,
					"SoldWholeSale" = "SoldWholeSale" + p_sold_wholesale,
					"SoldWholeSaleMoney" = "SoldWholeSaleMoney" + p_sold_wholesale_money,
					"Remaining" = "Remaining" - (p_sold_retail + p_sold_wholesale)
				WHERE "ShiftId" = p_shift_id 
					AND "Date" = NOW()::DATE
					AND "LotteryChannelId" = p_lotteryChannel_id
					AND "SalePointId" = p_sale_point_id;
				
				--  sử lý trường hợp chuyển vé
			ELSEIF p_report_type = 2 
				THEN
					UPDATE "ReportLottery" 
					SET 
						"Transfer" = "Transfer" + p_transfer,
						"Remaining" = "Remaining" - p_transfer
					WHERE "ShiftId" = p_shift_id 
						AND "Date" = NOW()::DATE
						AND "LotteryChannelId" = p_lotteryChannel_id
						AND "SalePointId" = p_sale_point_id;
				
				-- trường hợp nhận vé 
			ELSEIF p_report_type = 3 
				THEN
					UPDATE "ReportLottery" 
					SET 
						"Received" = "Received"  + p_received,
						"Remaining" = "Remaining" + p_received
					WHERE "ShiftId" = p_shift_id 
						AND "Date" = NOW()::DATE
						AND "LotteryChannelId" = p_lotteryChannel_id
						AND "SalePointId" = p_sale_point_id;
				 -- trương hợp còn lại
			ELSE
					UPDATE "ReportLottery" 
					SET 
						"Stock" = p_split_tickets,
						"Remaining" = v_remaining_split_tickets + "Remaining"
					WHERE "ShiftId" = p_shift_id 
						AND "Date" = NOW()::DATE
						AND "LotteryChannelId" = p_lotteryChannel_id
						AND "SalePointId" = p_sale_point_id;
			END IF;
			-- cập nhật lại stock, Remaining của các ca sau.
			UPDATE "ReportLottery"
			SET 
				"Stock" = (SELECT "Remaining" FROM "ReportLottery" WHERE "ShiftId" = p_shift_id 
																														AND "Date" = NOW()::DATE
																														AND "LotteryChannelId" = p_lotteryChannel_id
																														AND "SalePointId" = p_sale_point_id),
				"Remaining" = (SELECT "Remaining" FROM "ReportLottery" WHERE "ShiftId" = p_shift_id 
																																AND "Date" = NOW()::DATE
																																AND "LotteryChannelId" = p_lotteryChannel_id
																																AND "SalePointId" = p_sale_point_id)
			WHERE "Date" = now()::DATE 
				AND "OrdinalNum" > (SELECT "OrdinalNum" FROM "ReportLottery" 
																								WHERE "ShiftId" = p_shift_id 
																									AND "Date" = NOW()::DATE
																									AND "LotteryChannelId" = p_lotteryChannel_id
																									AND "SalePointId" = p_sale_point_id)
				AND "SalePointId" = p_sale_point_id
				AND "LotteryChannelId" = p_lotteryChannel_id;
		END IF;
			
    v_id := 1;
    v_mess := 'Update thanh cong';
   RETURN QUERY   
SELECT
    v_id,
    v_mess;

   EXCEPTION WHEN OTHERS THEN    
			BEGIN        
				v_id := -1;        
				v_mess := sqlerrm;        
	 RETURN QUERY        
			SELECT 
				v_id, 
				v_mess;    
	 END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
