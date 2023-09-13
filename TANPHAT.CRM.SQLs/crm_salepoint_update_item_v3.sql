-- ================================
-- Author: Viet
-- Description:
-- Created date: 05-01-2023
-- SELECT * FROM crm_salepoint_update_item_v3(1, 'Vinh', 1, '[{"ItemId":13,"Quantity":80,"SalePointId":1,"Month":"2023-08"}]')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_update_item_v3'); 
CREATE OR REPLACE FUNCTION crm_salepoint_update_item_v3
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_type_action INT,
	p_data TEXT
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
	v_time TIMESTAMP := NOW();
	v_cur_remain INT := 0; 
	v_cur_price NUMERIC := 0;
	v_check INT := 0;
	v_item_price INT;
	ele JSON;
	v_avg_price NUMERIC;
BEGIN
FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP

			-- Lấy giá một món hàng
			SELECT 
				"Price" INTO v_item_price
			FROM "Item"
			WHERE "ItemId" = (ele ->> 'ItemId') :: INT;	
			
			-- Kiểm tra món hàng đã tồn tại hay chưa
-- 			IF v_item_price IS NULL THEN
-- 					RAISE 'Món hàng chưa được thêm vào kho';
-- 			END IF;
			v_item_price:= (ele ->> 'Price') :: INT;
				
			
			-- Tính giá trung bình của món hàng khi "Cho việc xuất và sử dụng" - ĐÚNG VỚI KHO
			SELECT 
				COALESCE("TotalPrice",0)/ (CASE WHEN "TotalRemaining" =0 THEN 1 ELSE "TotalRemaining" END)
				INTO v_avg_price
			FROM "ItemFull"
			WHERE "ItemId" = (ele ->> 'ItemId') :: INT AND "SalePointId" =0;
				
			-- Nếu trong kho không còn thì lấy gía ở DDL
			IF v_avg_price IS NULL OR v_avg_price =0 THEN
				SELECT 
						"Price" INTO v_avg_price
				FROM "Item"
				WHERE "ItemId" = (ele ->> 'ItemId') :: INT;	
			END IF;
						
			-- Lấy tồn kho hiện tại
			SELECT 
				COALESCE(IFL."TotalRemaining", 0) AS "TotalRemaining",COALESCE(I."TotalPrice", 0) AS "TotalPrice" INTO v_cur_remain, v_cur_price
			FROM "ItemFullLog" IFL
				LEFT JOIN "ItemFull" I ON I."SalePointId" = IFL."SalePointId" AND I."ItemId" = IFL."ItemId"
			WHERE I."SalePointId" = (ele ->> 'SalePointId') :: INT
				AND I."ItemId" = (ele ->> 'ItemId') :: INT
				AND  ( ele ->> 'Month'||'-01')::DATE >= IFL."Month"
			ORDER BY IFL."CreateDate" DESC
			LIMIT 1;
			-- Thêm dòng vào Log
			INSERT INTO "ItemFullLog"(
				"ItemId",
				"SalePointId",
				"TotalRemaining",
				"Quantity",
				"ItemTypeId",
				"CreateBy",
				"CreateByName",
				"CreateDate",		
				"TotalPrice",
				"BalancePrice",
				"Month"
			)
			VALUES(
				(ele ->> 'ItemId') :: INT,	
				(ele ->> 'SalePointId') :: INT, 
				(CASE WHEN p_type_action = 1 THEN COALESCE(v_cur_remain, 0) + (ele ->> 'Quantity') :: numeric 
							ELSE COALESCE(v_cur_remain, 0) - (ele ->> 'Quantity') :: numeric END),
				(ele ->> 'Quantity') :: numeric,
				CASE WHEN p_type_action = 1 THEN 1 WHEN p_type_action = 3 THEN 3 ELSE 2 END,
				p_action_by,
				p_action_by_name,
				v_time,
				((ele ->> 'Quantity') :: numeric) * (CASE WHEN (ele ->> 'SalePointId') :: INT = 0 THEN v_item_price ELSE v_avg_price END),
				(CASE WHEN p_type_action = 1 THEN COALESCE(v_cur_price, 0) + (ele ->> 'Quantity') :: numeric * (CASE WHEN (ele ->> 'SalePointId') :: INT = 0 THEN  v_item_price ELSE v_avg_price END)
							ELSE COALESCE(v_cur_price, 0) - (ele ->> 'Quantity') :: numeric * v_avg_price END),
				(ele->>'Month'||'-01')::DATE
			) RETURNING "TotalRemaining" INTO v_check;
			UPDATE "ItemFullLog" 
			SET "TotalRemaining" = 	"TotalRemaining" + (ele ->> 'Quantity') :: numeric 
				WHERE "Month" >= (ele->>'Month'||'-01')::DATE + interval '1 month'
				AND "SalePointId" = (ele ->> 'SalePointId') :: INT
				AND "ItemId" = (ele ->> 'ItemId') :: INT;
			IF v_check < 0 THEN
				RAISE 'Không đủ hàng hóa trong kho';
			END IF;				
			
			IF NOT EXISTS (
				SELECT 1 FROM "ItemFull" I
				WHERE I."SalePointId" = (ele ->> 'SalePointId') :: INT
					AND I."ItemId" = (ele ->> 'ItemId') :: INT) 
				AND p_type_action = 1
			THEN 
			
				-- Thêm dòng nếu chưa có và là nhập kho
				INSERT INTO "ItemFull"(
					"ItemId",
					"SalePointId",
					"TotalRemaining",
					"CreateBy",
					"CreateByName",
					"CreateDate",
					"TotalPrice"
				)
				VALUES(
					(ele ->> 'ItemId') :: INT,	
					(ele ->> 'SalePointId') :: INT, 
					(ele ->> 'Quantity') :: numeric,
					p_action_by,
					p_action_by_name,
					v_time,
					(ele ->> 'Quantity') :: numeric * (CASE WHEN (ele ->> 'SalePointId') :: INT = 0 THEN v_item_price ELSE v_avg_price END)
				
				);
				
			ELSEIF NOT EXISTS (
				SELECT 1 FROM "ItemFull" I
				WHERE I."SalePointId" = (ele ->> 'SalePointId') :: INT
					AND I."ItemId" = (ele ->> 'ItemId') :: INT
			) THEN 				
				-- Báo lỗi vì trừ kho khi chưa có hàng
				RAISE 'Không đủ hàng hóa trong kho';
			ELSE 
				-- Cập nhật kho của điểm bán 
				UPDATE "ItemFull" 
				SET
					"ModifyDate" = v_time,
					"TotalRemaining" = (CASE WHEN p_type_action = 1 THEN "TotalRemaining"  + (ele ->> 'Quantity') ::numeric 
																										ELSE "TotalRemaining" - (ele ->> 'Quantity') :: numeric END),
					"TotalPrice" =(CASE WHEN p_type_action = 1 THEN "TotalPrice"  + (ele ->> 'Quantity') :: numeric * (CASE WHEN (ele ->> 'SalePointId') :: INT = 0 THEN v_item_price ELSE v_avg_price END)
																										ELSE "TotalPrice" - (ele ->> 'Quantity') :: numeric * v_avg_price END)
																								 
				WHERE "SalePointId" = (ele ->> 'SalePointId') :: INT
					AND "ItemId" = (ele ->> 'ItemId') :: INT
				RETURNING "TotalRemaining" INTO v_check;
				
				IF v_check < 0 THEN
					RAISE 'Không đủ hàng hóa trong kho';
				END IF;				
					
			END IF;
			
			-- Cập nhật kho số 0 nếu là xuất, nhập kho
			IF (ele ->> 'SalePointId') :: INT <> 0 AND p_type_action <> 3 THEN
				
				SELECT 
					COALESCE(I."TotalRemaining", 0),COALESCE(I."TotalPrice", 0)  INTO v_cur_remain, v_cur_price
				FROM "ItemFull" I
				WHERE I."SalePointId" = 0 :: INT
					AND I."ItemId" = (ele ->> 'ItemId') :: INT;
				
				-- Thêm dòng nếu chưa có và là nhập kho
				INSERT INTO "ItemFullLog"(
					"ItemId",
					"SalePointId",
					"TotalRemaining",
					"Quantity",
					"ItemTypeId",
					"CreateBy",
					"CreateByName",
					"CreateDate",		
					"TotalPrice",
					"BalancePrice",
					"Month"
				)
				VALUES(
					(ele ->> 'ItemId') :: INT,	
					0, 
					(CASE WHEN p_type_action = 1 THEN COALESCE(v_cur_remain, 0) - (ele ->> 'Quantity') :: numeric
								ELSE COALESCE(v_cur_remain, 0) + (ele ->> 'Quantity') :: numeric END),
					(ele ->> 'Quantity') :: numeric,
					(CASE WHEN p_type_action = 1 THEN 2 WHEN p_type_action = 2 THEN 1 ELSE 4 END),
					p_action_by,
					p_action_by_name,
					v_time,
					((ele ->> 'Quantity') :: numeric) * v_avg_price,
					(CASE WHEN p_type_action = 1 THEN COALESCE(v_cur_price, 0) - (ele ->> 'Quantity') :: numeric * v_avg_price
						ELSE COALESCE(v_cur_price, 0) + (ele ->> 'Quantity') :: numeric * v_avg_price END),
					(ele ->> 'Month'||'-01')::DATE
				) RETURNING "TotalRemaining" INTO v_check;
				
				IF v_check < 0 THEN
					RAISE 'Không đủ hàng hóa trong kho';
				END IF;
				
				UPDATE "ItemFull"
				SET
					"ModifyDate" = v_time,
					"TotalRemaining" = (CASE WHEN p_type_action = 1 THEN "TotalRemaining" - (ele ->> 'Quantity') :: numeric 
																										ELSE "TotalRemaining" + (ele ->> 'Quantity') :: numeric END),
																										
					"TotalPrice"	= (CASE WHEN p_type_action = 1 THEN COALESCE(v_cur_price, 0) - (ele ->> 'Quantity') :: numeric * v_avg_price
																										ELSE COALESCE(v_cur_price, 0) + (ele ->> 'Quantity') :: numeric * v_avg_price END)
				WHERE "SalePointId" = 0 
					AND "ItemId" = (ele ->> 'ItemId') :: INT
				RETURNING "TotalRemaining" INTO v_check;
				
				IF v_check < 0 THEN
					RAISE 'Không đủ hàng hóa trong kho';
				END IF;								
			
			END IF;
			
	END LOOP;
	
	v_id := 1;
	v_mess := 'Cập nhật thành công';
	
	RETURN QUERY
	SELECT v_id, v_mess;

	EXCEPTION WHEN OTHERS THEN
	BEGIN
	v_id := -1;
	v_mess := sqlerrm;


	RETURN QUERY
	SELECT v_id, v_mess;
	END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE

