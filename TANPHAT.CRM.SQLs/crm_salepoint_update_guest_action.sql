-- ================================
-- Author: Tien
-- Description: 
-- Created date: 

-- INSERT
-- SELECT * FROM crm_salepoint_update_guest_action(0, 'System','[{ "SalePointId": 1,"GuestActionTypeId":1, "TotalPrice": 100000,"FormPaymentId":2, "Note": "22222"}]')

-- UPDATE IsDeleted, FormPaymentId
-- SELECT * FROM crm_salepoint_update_guest_action(0, 'System','[{"GuestActionId": 1, "GuestId": 1, "SalePointId": 1,"GuestActionTypeId":1, "TotalPrice": 100000,"FormPaymentId":1]')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_update_guest_action');
CREATE OR REPLACE FUNCTION crm_salepoint_update_guest_action
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT,
	p_guest_action_type_id INT DEFAULT 2
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
	ele JSON;
	v_tget_price NUMERIC := 0;
	v_price NUMERIC;
BEGIN
	FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			IF 	COALESCE((ele ->> 'GuestActionId')::INT, 0) = 0 AND 
					--COALESCE((ele ->> 'GuestId')::INT, 0) <> 0 AND 
					COALESCE((ele ->> 'FormPaymentId')::INT, 0) <> 0
			THEN
				
				IF COALESCE((ele ->> 'FormPaymentId')::INT, 0) = 2 
					AND COALESCE((ele ->> 'Note')::VARCHAR, '') = '' THEN
					RAISE 'Thanh toán chuyển khoản phải có mã giao dịch';
				END IF;
				
				INSERT INTO "GuestAction" (
					"GuestId",
					"SalePointId",
					"GuestActionTypeId",
					"TotalPrice",
					"FormPaymentId",
					"CreatedBy",
					"CreatedByName",
					"CreatedDate",
					"Note",
					"GuestInfo",
					"ModifyBy",
					"ModifyByName",
					"ModifyDate",
					"DoneTransfer",
					"ShiftDistributeId"
				)
				VALUES (
					COALESCE((ele ->> 'GuestId')::INT, 0),
					COALESCE((ele ->> 'SalePointId')::INT, 0),
					COALESCE((ele ->> 'GuestActionTypeId')::INT, p_guest_action_type_id),
					COALESCE((ele ->> 'TotalPrice')::NUMERIC, 0),
					COALESCE((ele ->> 'FormPaymentId')::INT, 1),
					COALESCE((ele ->> 'ActionBy')::INT, p_action_by),
					COALESCE((ele ->> 'ActionByName')::VARCHAR, p_action_by_name),
					COALESCE((ele ->> 'ActionDate')::TIMESTAMP, NOW()),
					COALESCE((ele ->> 'Note')::VARCHAR, NULL),
					COALESCE((ele ->> 'GuestInfo')::VARCHAR, NULL),
					p_action_by,
					p_action_by_name,
					NOW(),
					(CASE WHEN COALESCE((ele ->> 'FormPaymentId')::INT, 1) = 1 THEN TRUE ELSE FALSE	END),
					COALESCE((ele ->> 'ShiftDistributeId')::INT, 0)
				);
				v_id := 1;
				v_mess := 'Tạo mới thành công';
			ELSEIF COALESCE((ele ->> 'GuestActionId')::INT, 0) = 0 THEN 
				v_id := -1;
				v_mess := 'Không đủ thông tin cập nhật';
			ELSE
				UPDATE "GuestAction" 
				SET 
					"ModifyBy" = p_action_by,
					"ModifyByName" = p_action_by_name,
					"ModifyDate" = NOW(),
					"IsDeleted" = COALESCE((ele ->> 'IsDeleted')::BOOLEAN, "IsDeleted"),
					"FormPaymentId"= COALESCE((ele ->> 'FormPaymentId')::INT, "FormPaymentId"),
					"TotalPrice" = COALESCE((ele ->> 'TotalPrice')::NUMERIC, "TotalPrice"),
					"DoneTransfer" = COALESCE((ele ->> 'DoneTransfer')::BOOLEAN, "DoneTransfer")
				WHERE "GuestActionId" = (ele ->> 'GuestActionId')::INT;
				v_id := 1;
				v_mess := 'Cập nhật thành công';
				--Xu ly delete
			END IF;
	END LOOP;
	
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

