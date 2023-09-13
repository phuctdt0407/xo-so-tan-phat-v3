SELECT dropallfunction_byname('fn_phoneconvert_11_to_10');
CREATE OR REPLACE FUNCTION fn_phoneconvert_11_to_10(p_phone_number VARCHAR)
RETURNS TEXT AS $BODY$
DECLARE 
	v_phone_origin VARCHAR;
	v_phone_prefix VARCHAR;
	v_phone_prefix_converted VARCHAR;
BEGIN 
		IF p_phone_number IS NULL OR TRIM(p_phone_number) = '' THEN
			RETURN NULL;
		ELSE
			v_phone_origin := TRIM(regexp_replace(p_phone_number,'[^0-9+]+', '','g'));

			-- Xử lý +84
			IF(LEFT(v_phone_origin, 3) = '+84') THEN
					v_phone_origin :=  regexp_replace(v_phone_origin, '(^\+84)(\w+)', '0\2');
			END IF;

			IF (LEFT(v_phone_origin, 2) = '84') THEN
					v_phone_origin :=  regexp_replace(v_phone_origin, '(^84)(\w+)', '0\2');
			END IF;

			IF (LEFT(v_phone_origin, 2) = '00') THEN
					v_phone_origin :=  regexp_replace(v_phone_origin, '(^00)(\w+)', '0\2');
			END IF;

			IF (LEFT(v_phone_origin, 2) = '09' AND LENGTH(v_phone_origin) > 10) THEN
					v_phone_origin :=  regexp_replace(v_phone_origin, '(^09)(\w+)', '0\2');
			END IF;

			-- Chỉ xử lý số điện thoại 11 số
			IF(LENGTH(v_phone_origin) > 10) THEN
				-- Lấy 4 số đầu tiên kiểm tra
				v_phone_prefix := LEFT(v_phone_origin, 4);
				v_phone_prefix_converted := (
					CASE v_phone_prefix
						-- Viettel
						WHEN '0162' THEN '032'
						WHEN '0163' THEN '033'
						WHEN '0164' THEN '034'
						WHEN '0165' THEN '035'
						WHEN '0166' THEN '036'
						WHEN '0167' THEN '037'
						WHEN '0168' THEN '038'
						WHEN '0169' THEN '039'
						-- Mobifone
						WHEN '0120' THEN '070'
						WHEN '0121' THEN '079'
						WHEN '0122' THEN '077'
						WHEN '0126' THEN '076'
						WHEN '0128' THEN '078'
						-- Vinafone
						WHEN '0123' THEN '083'
						WHEN '0124' THEN '084'
						WHEN '0125' THEN '085'
						WHEN '0127' THEN '081'
						WHEN '0129' THEN '082'
						-- Vietnamobile
						WHEN '0186' THEN '056'
						WHEN '0188' THEN '058'
						-- Gmobile
						WHEN '0199' THEN '059'
						-- Cố định VSAT
						WHEN '0992' THEN '0672'
						ELSE v_phone_prefix END
				);
				
				IF LENGTH(v_phone_prefix_converted) > 0 THEN
					v_phone_origin := regexp_replace(v_phone_origin, '(^'||v_phone_prefix ||')(\w+)', v_phone_prefix_converted || '\2');
				END IF;
				
				RETURN v_phone_origin;
				
			ELSE
					-- Trả về như ban đầu không xử lý
					RETURN v_phone_origin;
			END IF;
		END IF;
		/* Xử lý các trường hợp lỗi ở trên*/  
		EXCEPTION WHEN OTHERS THEN 
		BEGIN 
			RETURN p_phone_number || sqlerrm;
		END;

END; 
$BODY$
LANGUAGE plpgsql VOLATILE