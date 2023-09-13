-- ================================
-- Author: Việt
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_create_or_update_guest_v2(0, 'Vit', 2, '{"GuestId": 7, "FullName": "Trần Minh Tiến Lê Béo", "Phone": "84938226183","SalePointId": 2, "IsWholesale": "TRUE", "WholesalePrice": 1, "ScratchPrice": 1 }')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_create_or_update_guest_v2');
CREATE OR REPLACE FUNCTION crm_salepoint_create_or_update_guest_v2
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_action_type INT,
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
	v_phone TEXT;
	ele JSON;
BEGIN
	
	-- THÊM
	IF p_action_type = 1 THEN 
		ele := p_data::JSON;
		-- Kiểm tra SĐT
		v_phone := fn_phoneconvert_11_to_10(ele ->> 'Phone');
		IF LENGTH(v_phone) <> 10 THEN
			RAISE 'Số điện thoại không đúng cú pháp';
		END IF;
		-- Kiểm tra xem đã có số điện thoại và loại khách này chưa
		IF NOT EXISTS(SELECT 1 FROM "Guest" G WHERE fn_phoneconvert_11_to_10(G."Phone") = v_phone AND G."SalePointId" = (ele ->> 'SalePointId')::INT) THEN 
			INSERT INTO "Guest"(
				"FullName",
				"Phone",
				"SalePointId",
				"WholesalePrice",
				"ScratchPrice",
				"CreatedBy",
				"CreatedByName"
			)
			VALUES(
				(ele->>'FullName')::VARCHAR,
				v_phone,
				(ele->>'SalePointId')::INT,
				(ele->>'WholesalePrice')::INT,
				(ele->>'ScratchPrice'     )::INT,
				p_action_by,
				p_action_by_name
			) RETURNING "GuestId" INTO v_id;
								
		ELSE
			RAISE 'Đã tồn tại khách với số điện thoại này trong hệ thống';
		END IF;
		
		v_mess := 'Thêm thành công';
	-- Sửa
	ELSEIF p_action_type = 2 THEN
		ele := p_data::JSON;
		v_phone := fn_phoneconvert_11_to_10(ele ->> 'Phone');
		IF LENGTH(v_phone) <> 10 THEN
			RAISE 'Số điện thoại không đúng cú pháp';
		END IF;
		
		UPDATE "Guest"
		SET
			"FullName" = COALESCE((ele ->> 'FullName')::VARCHAR, "FullName"),
			"Phone" = COALESCE(fn_phoneconvert_11_to_10((ele ->> 'Phone')::VARCHAR) , "Phone"),
			"WholesalePrice" = COALESCE((ele ->> 'WholesalePrice')::INT, "WholesalePrice"),
			"ScratchPrice" = COALESCE((ele ->> 'ScratchPrice')::INT, "ScratchPriceId"),
			"ModifyBy" = p_action_by,
			"ModifyByName" = p_action_by_name,
			"ModifyDate" = NOW()
		WHERE 
			"GuestId" = (ele ->> 'GuestId')::INT;
		v_id := 1;
		v_mess := 'Cập nhật thành công';
	-- Xóa
	ELSEIF p_action_type = 3 THEN
		ele := p_data::JSON;
		UPDATE "Guest"
		SET
			"IsActive" = FALSE,
			"ModifyBy" = p_action_by,
			"ModifyByName" = p_action_by_name,
			"ModifyDate" = NOW()
		WHERE 
			"GuestId" = (ele ->> 'GuestId')::INT;
		v_id := 1;
		v_mess := 'Xóa thành công';
	END IF;

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