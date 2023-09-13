-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_update_const_price(1, 'SYSTEM', '[{"ConstId": 1, "Price": 2000000, "ConstantName": "Tiền cơm trưa" }]')
-- ================================
SELECT dropallfunction_byname('crm_activity_update_const_price');
CREATE OR REPLACE FUNCTION crm_activity_update_const_price
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
BEGIN

	FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
		
		IF NOT EXISTS(
			SELECT 1 FROM "Constant" C
			WHERE C."ConstId" = (ele->>'ConstId')::INT
				AND C."Price" = (ele->>'Price')::NUMERIC
			ORDER BY C."CreatedDate" DESC
			LIMIT 1
		) THEN
			
			INSERT INTO "Constant"(
				"ConstantName",
				"Price",
				"ConstId",
				"CreatedBy",
				"CreatedByName",
				"CreatedDate"
			)
			VALUES(
				(ele->>'ConstantName')::VARCHAR,
				(ele->>'Price')::NUMERIC,
				(ele->>'ConstId')::INT,
				p_action_by,
				p_action_by_name,
				v_time
			);
		END IF;
	
		v_id := 1;
		v_mess := 'Cập nhật thành công';
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