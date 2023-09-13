-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_update_commission(1,'Quang',1, '{"CommissionId": 33, "SalePointId": 5, "UserId": 15, "Commission": 1000000, "Date": "2022-05-14", "ListStaff": [3,5] }')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_update_commission');
CREATE OR REPLACE FUNCTION crm_salepoint_update_commission
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
	ele JSON;
	v_time TIMESTAMP := NOW();

BEGIN
	-- INSERT
	IF p_action_type = 1 THEN
		ele := p_data::JSON;
		INSERT INTO "Commission"(
			"SalePointId",
			"UserId",
			"ListStaff",
			"TotalValue",
			"Date",
			"CreatedBy",
			"CreatedByName",
			"CreatedDate",
			"IsDeleted",
			"Fee"
		)
		VALUES(
			(ele->>'SalePointId')::INT,
			p_action_by,
			translate((ele->>'ListStaff')::TEXT, '[]','{}')::INT[],
			(ele->>'Commission')::NUMERIC,
			(ele->>'Date')::DATE,
			p_action_by,
			p_action_by_name,
			v_time,
			FALSE,
			COALESCE((ele->>'Fee')::NUMERIC, 0)
		);
	
		v_id := 1;
		v_mess := 'Thêm thành công';
	-- UPDATE
	ELSEIF p_action_type = 2 THEN
	
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "Commission" 
			SET 
				"SalePointId" = COALESCE((ele->>'SalePointId')::INT, "SalePointId"),
				"UserId" = COALESCE(p_action_by, "UserId"),
				"ListStaff" = COALESCE(translate((ele->>'ListStaff')::TEXT, '[]','{}')::INT[], "ListStaff"),
				"TotalValue" = COALESCE((ele->>'TotalValue')::NUMERIC, "TotalValue"),
				"Date" = COALESCE((ele->>'Date')::DATE, "Date"),
				"ModifyBy" = p_action_by,
				"ModifyByName" = p_action_by_name,
				"ModifyDate" = v_time
			WHERE "CommissionId" = (ele ->> 'CommissionId') :: INT;
		END LOOP;
		
		v_id := 1;
		v_mess := 'Cập nhật thành công';
	-- DELETE
	ELSE 
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "Commission" 
			SET 
				"IsDeleted" = TRUE,
				"ModifyBy" = p_action_by,
				"ModifyByName" = p_action_by_name,
				"ModifyDate" = v_time
			WHERE "CommissionId" = (ele ->> 'CommissionId') :: INT;
		END LOOP;
		
		v_id := 1;
		v_mess := 'Xoá thành công';
		
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