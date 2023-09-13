-- ================================
-- Author: Quang
-- Description: 
-- Created date:
-- SELECT * FROM crm_salepoint_update_percent(0 ,'System', '[{"SalePointId": 5, "MainUserData": [{"UserId": 1, "Percent": 0.8}, {"UserId": 6, "Percent": 0.1}] }]')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_update_percent');
CREATE OR REPLACE FUNCTION crm_salepoint_update_percent 
(
	p_action_by INT,
	p_action_by_name VARCHAR,
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
	v_array INT[];
	v_percent NUMERIC[];
	v_total NUMERIC;
	elele JSON;
BEGIN

	
	--INSERT
	FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
		--Clear data tạm
		v_array := '{}'::INT[];
		v_percent := '{}'::NUMERIC[];
		v_total := 0;
		--Loop lấy các giá trị gửi xuống
		FOR elele IN SELECT * FROM json_array_elements((ele->>'MainUserData')::JSON) LOOP
			v_array := array_append(v_array, (elele->>'UserId')::INT);
			v_percent := array_append(v_percent, (elele->>'Percent')::NUMERIC);
			v_total := v_total +  (elele->>'Percent')::NUMERIC;
		END LOOP;
		
		IF v_total > 1 THEN
			RAISE 'Tỷ lệ phần trăm % đã nhập lớn hơn %', CONCAT(ROUND(100 * v_total, 0), '%'), CONCAT(100, '%');
		END IF;
		
		INSERT INTO "SalePointPercentLog"(
			"SalePointId",
			"MainUserId",
			"PercentMainUserId",
			"ActionBy",
			"ActionByName",
			"ActionDate"
		)
		VALUES(
			(ele->>'SalePointId')::INT,
			v_array,
			v_percent,
			p_action_by,
			p_action_by_name,
			v_time
		);
		
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