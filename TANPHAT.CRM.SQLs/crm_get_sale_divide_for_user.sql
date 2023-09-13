-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_sale_divide_for_user('[1,2,3]', '[0.5, 0.2, 0.2]', 100000000);
-- ================================
SELECT dropallfunction_byname('crm_get_sale_divide_for_user');
CREATE OR REPLACE FUNCTION crm_get_sale_divide_for_user
(
	p_list_user_id TEXT,
	p_list_percent TEXT,
	p_sale NUMERIC
)
RETURNS TEXT 
AS $BODY$
DECLARE
	v_user_list INT[] := TRANSLATE(p_list_user_id, '[]', '{}')::INT[];
	v_percent_list NUMERIC[] := TRANSLATE(p_list_percent, '[]', '{}')::NUMERIC[];
	v_user_id INT;
	v_result JSONB := '[]'::JSONB;
	v_index INT;
	v_user_name VARCHAR;
BEGIN
	
	IF ARRAY_LENGTH(v_user_list, 1) > 0 THEN
	
		FOR v_index IN 1..ARRAY_LENGTH(v_user_list, 1) LOOP
			
			v_user_id := v_user_list[v_index];
			
			SELECT
				U."FullName" INTO v_user_name
			FROM "User" U
			WHERE U."UserId" = v_user_id;
			
			IF v_user_name IS NOT NULL THEN
				
				v_result := v_result || ('{"UserId": '||v_user_id||',"FullName": "'||v_user_name||'","Percent": '||v_percent_list[v_index]||',"Sale": '||ROUND(p_sale * v_percent_list[v_index], 0)||'}')::JSONB;
				
			END IF;
			
			v_user_name := NULL;
			
		END LOOP;
	END IF;
	
	RETURN v_result::TEXT;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

