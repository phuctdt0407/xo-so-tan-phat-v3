-- ================================
-- Author: Tien
-- Description: Confirm salepoint update item
-- Created date: 21/06/2022
-- ================================

--UPDATE Khi có confirm log id
-- SELECT * FROM crm_salepoint_update_cornfirm_item_v2(0, 'System_27_06_2022', 1, '[{"ItemId": 2, "SalePointId": 0, "Quantity": 5}]',26,2,1)
-- SELECT * FROM crm_salepoint_update_cornfirm_item_v2(0, 'System_27_06_2022', 1, '[{"GuestId": 48, "SalePointId": 2,"TotalPrice":120000, "FormPaymentId":1}]',3,3,2)

-- SELECT * FROM crm_salepoint_update_cornfirm_item_v2(0, 'System_29_06_2022', 1, NULL,7,2,3)
-- SELECT * FROM crm_salepoint_update_cornfirm_item_v2(0, 'QUANG CONFIRM', 1, NULL,56,2,4)
--CREATE 
-- Cần trường p_confirm_log_id NULL 
-- SELECT * FROM crm_salepoint_update_cornfirm_item_v2(0, 'System_DEV', 1, '[{"ItemId": 2, "SalePointId": 0, "Quantity": 10}]',NULL,NULL,1)
-- SELECT * FROM crm_salepoint_update_cornfirm_item_v2(0, 'System_DEV', 1, '[{"GuestId": 48, "SalePointId": 2,"TotalPrice":9999, "FormPaymentId":2}]',NULL,NULL,2, NULL, 48)

-- SELECT * FROM crm_salepoint_update_cornfirm_item_v2(0, 'System_DEV', 1, '[{"LotteryDate": null, "IsScratchcard": true, "LotteryChannelId": 1000,  "Quantity": -9999,  "LotteryTypeId": 3, "LotteryPriceId": 1}]',NULL,NULL,3, '{"UserRoleId":2,"GuestId":-1,"ShiftDistributeId":430}' )

-- SELECT * FROM crm_salepoint_update_cornfirm_item_v2(0, 'System_DEV', 1, '[{"LotteryDate": null, "IsScratchcard": true, "LotteryChannelId": 1000,  "Quantity": 10,  "LotteryTypeId": 3, "LotteryPriceId": 1}]',NULL,NULL,4, '{"UserRoleId":2,"ShiftDistributeId":430, "Phone": "0938760137", "FullName": "Trần Đức Bo", "SalePointId": 1}' )
-- SELECT * FROM crm_salepoint_update_cornfirm_item_v3(11,'trumcuoi',1,'[{"ItemId":13,"SalePointId":0,"Quantity":10,"ItemName":"Giấy in bill","UnitName":"Cuộn","Price":10,"SalePointName":"Kho","TypeOfItemId":1,"Month":"2023-02"}]')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_update_cornfirm_item_v3');
CREATE OR REPLACE FUNCTION crm_salepoint_update_cornfirm_item_v3
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_type_action_id INT,							--1.ITEM:		1.1 Chuyển, 1.2 Nhận, 1.3 Sử dụng
																		--2.GUEST:	Trả ế, Trả nợ, Thanh toán,..
																		--3.LOTTERY: Trả ế,
																		--4.TẠO KHÁCH NƠ
																		--5.QUẢN LÝ MƯỢN NỢ
	p_data TEXT,
	p_confirm_log_id INT DEFAULT 0,		-- ID định danh
	p_confirm_type INT DEFAULT 1,			-- Huỷ hoặc xác nhận
	p_confirm_for INT DEFAULT 1,			-- Loại giao dịch
	p_data_info TEXT DEFAULT NULL,
	p_guest_id INT DEFAULT NULL,
	p_time TIMESTAMP DEFAULT NULL,
	p_order_id INT DEFAULT NULL
)
RETURNS TABLE
(
	"Id" INT,
	"Message" TEXT,
	"OrderId" INT
)
AS $BODY$
DECLARE
	v_id INT;
	v_mess TEXT;
	v_time TIMESTAMP := NOW();
	v_cur_remain INT := 0; 
	v_check INT := 0;
	v_item_price INT;
	v_data TEXT;
	v_data_info TEXT;
	v_json_info JSON;
	v_change INT:= 0;
	v_confirm_for INT;
	v_type_action_id INT;
	v_guest_id INT;
	ele JSON;
	v_array INT[];
BEGIN

	--TH1. Xử lý trạng thái dùng
	IF p_type_action_id = 3 AND p_confirm_for <> 3 THEN
		--1. ITEM
		IF COALESCE(p_confirm_for,1) = 1 THEN
			SELECT f."Id", f."Id",f."Message" 
			INTO v_check,v_id, v_mess 
				FROM crm_salepoint_update_item_v3(p_action_by, p_action_by_name,p_type_action_id, p_data) f;
		--2. GUEST
		ELSEIF p_confirm_for = 2 THEN
			SELECT f."Id", f."Id",f."Message" 
			INTO v_check,v_id, v_mess 
				FROM crm_salepoint_update_guest_action_v2(p_action_by, p_action_by_name, p_data) f;
		ELSE 
			v_id := -1;
			v_mess := 'NO.1: Trạng thái mới';
		END IF;
	
	--TH2. NOT EXISTS confirmLogId -> CREATE CONFIRM 
	ELSEIF COALESCE(p_confirm_log_id, 0) = 0 THEN
		
		--Tạo giỏ hàng nếu là tương tác từ khách hàng
		IF p_confirm_for = 2 OR p_confirm_for = 3 THEN 
			IF p_order_id IS NULL THEN
				INSERT INTO "HistoryOfOrder" (
					"SalePointId",
					"CreatedBy",
					"CreatedByName",
					"CreatedDate",
					"IsDeleted",
					"ShiftDistributeId"
				)
				VALUES (
					((p_data_info::JSON)->>'SalePointId')::INT,
					p_action_by,
					p_action_by_name,
					v_time,
					FALSE,
					((p_data_info::JSON)->>'ShiftDistributeId')::INT
				) RETURNING "HistoryOfOrderId" INTO p_order_id;
			END IF;

			--Lấy danh sách id bán hàng
			SELECT "ConfirmLogIds" INTO v_array FROM "HistoryOfOrder" WHERE "HistoryOfOrderId" = p_order_id;
			IF v_array IS NULL THEN 
				v_array := '{}'::INT[];
			END IF;
		
		END IF;
	
		--0. FULL
		INSERT INTO "ConfirmLog" (
			"Data",
			"TypeActionId",
			"ActionBy",
			"ActionByName",
			"ConfirmStatusId",
			"ConfirmFor",
			"DataActionInfo",
			"ActionDate",
			"GuestId",
			"HistoryOfOrderId"
		) VALUES (
			p_data,
			p_type_action_id,
			p_action_by,
			p_action_by_name,
			COALESCE(p_confirm_type, 1),
			COALESCE(p_confirm_for, 1),
			COALESCE(p_data_info, NULL),
			COALESCE(p_time, NOW()),
			COALESCE(p_guest_id, NULL),
			p_order_id
		) 
		RETURNING "ConfirmLogId" INTO v_id;
		
		v_array := array_append(v_array, v_id);
		
		UPDATE "HistoryOfOrder" 
		SET 
			"ConfirmLogIds" = v_array
		WHERE "HistoryOfOrderId" = p_order_id;
		
		v_mess := 'Tạo mới thành công';
		
	--TH3. confirm susscess
	ELSEIF p_confirm_type = 2 THEN
		--0. GET Data
		SELECT 
			IL."Data", 
			IL."DataActionInfo",
			IL."ConfirmStatusId",
			IL."ConfirmFor",
			IL."TypeActionId",
			IL."GuestId",
			IL."HistoryOfOrderId"
		INTO 
			v_data,
			v_data_info, 
			v_change,
			v_confirm_for,
			v_type_action_id,
			v_guest_id,
			p_order_id
		FROM "ConfirmLog" IL 
		WHERE IL."ConfirmLogId" = COALESCE(p_confirm_log_id,0);
				
		--EXEC
		IF v_change = 1 THEN
			IF COALESCE(v_confirm_for, 1) = 1 THEN
		
			--1. ITEM
				SELECT f."Id",f."Message" ,f."Id"
				INTO v_check, v_mess ,v_id
				FROM crm_salepoint_update_item_v3(p_action_by, p_action_by_name,v_type_action_id, v_data) f;
					
				IF v_id <= 0 THEN
					RAISE '%', v_mess;
				END IF;
				
			ELSEIF v_confirm_for = 2 THEN
			
			--2. GUEST 
				SELECT f."Id",f."Message" ,f."Id"
				INTO v_check, v_mess ,v_id
				FROM crm_salepoint_update_guest_action_v2(p_action_by, p_action_by_name, v_data, NULL, p_order_id) f;
			
				IF v_id <= 0 THEN
					RAISE '%', v_mess;
				END IF;
				
			ELSEIF v_confirm_for = 3 THEN
			
			--3. LOTTERY 
				v_json_info := v_data_info :: JSON;
				IF COALESCE((v_json_info ->> 'ShiftDistributeId'):: INT,0) = 0
					OR COALESCE((v_json_info ->> 'UserRoleId'):: INT,0) = 0
				THEN 
				
					RAISE 'Không đủ thông tin để cập nhật';
					
				ELSE
				
					SELECT f."Id", f."Message",	f."Id"
					INTO v_check, v_mess,	v_id
					FROM crm_activity_sell_lottery_v3((v_json_info ->> 'ShiftDistributeId'):: INT, (v_json_info ->> 'UserRoleId'):: INT, p_action_by, p_action_by_name, v_data,COALESCE((v_json_info ->> 'GuestId'):: INT), p_order_id) f;
					
					IF v_id <= 0 THEN
						RAISE '%', v_mess;
					END IF;
					
				END IF;
			
			--4. TẠO KHÁCH NỢ
			ELSEIF v_confirm_for = 4 THEN
			
				-- Tạo khách
				SELECT f."Id", f."Message"
				INTO v_id, v_mess
				FROM crm_salepoint_create_or_update_guest(p_action_by, p_action_by_name, 1, v_data_info::TEXT) f;
				
				IF v_id <= 0 THEN
					RAISE '%', v_mess;
				END IF;
				

				-- Cập nhật lại data confirm
				v_data_info := (v_data_info::JSONB || ('{"GuestId": '||v_id||'}')::JSONB)::TEXT;
				
				-- Thêm dòng mới vào để confirm 
				SELECT f."Id", f."Message"
				INTO v_id, v_mess
				FROM crm_salepoint_update_cornfirm_item(p_action_by, p_action_by_name, 1,	v_data::TEXT, NULL, NULL, 3, v_data_info::TEXT) f;
				
				IF v_id <= 0 THEN
					RAISE '%', v_mess;
				END IF;
				

				-- Confirm dòng mới 
				SELECT f."Id", f."Message",	f."Id"
				INTO v_check, v_mess,	v_id
				FROM crm_salepoint_update_cornfirm_item(p_action_by, p_action_by_name, 1, NULL, v_id, 2, 3) f;
				
				IF v_id <= 0 THEN
					RAISE '%', v_mess;
				END IF;
			
			ELSE
				v_id := -1;
				v_mess := 'NO.2: Trạng thái mới';
			END IF;
			
		ELSE
		
			v_id := -1;
			v_mess := 'Yêu cầu đã được xác nhận trước đó!';
			v_check := 0;
			
		END IF;
		
		--CHECK EXEC
		IF v_check > 0 THEN
		
				--0. FULL
				UPDATE "ConfirmLog"
				SET "ConfirmStatusId" = COALESCE(p_confirm_type, "ConfirmStatusId"),
						"ConfirmByName" = p_action_by_name,
						"ConfirmBy" = p_action_by,
						"ConfirmDate" = NOW()
				WHERE "ConfirmLogId" = COALESCE(p_confirm_log_id, 0);
				
		END IF;
		
	ELSEIF p_confirm_type = 3 THEN
	
	--TH4. cancel request
		--0. FULL
		SELECT IL."ConfirmStatusId" INTO v_change
		FROM "ConfirmLog" IL 
		WHERE IL."ConfirmLogId" = p_confirm_log_id;
			
		IF v_change = 1 THEN

			UPDATE "ConfirmLog"
			SET "ConfirmStatusId"= p_confirm_type,
					"ConfirmByName"= p_action_by_name,
					"ConfirmBy" = p_action_by,
					"ConfirmDate" = NOW()
			WHERE "ConfirmLogId" = COALESCE(p_confirm_log_id, 0);		
			
			v_id := 1;
			v_mess := 'Cập nhật thành công';
			
		ELSE
		
			v_id := -1;
			v_mess := 'Yêu cầu đã được xác nhận trước đó!';
			
		END IF;
	ELSE
			v_id := -1;
			v_mess := 'Dữ liệu chưa đúng định dạng';
	END IF;
	
	RETURN QUERY
	SELECT v_id, v_mess, p_order_id;

	EXCEPTION WHEN OTHERS THEN
	BEGIN
	v_id := -1;
	v_mess := sqlerrm;


	RETURN QUERY
	SELECT v_id, v_mess, p_order_id;
	END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE

