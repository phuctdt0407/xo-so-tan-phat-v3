-- ================================
-- Author: Quang (Việt sửa ngày 03/13/2023)->04/10/2023
-- Description: a Quang báo em Việt sau gần 1 năm -> em việt sửa j mà hàm update không có update vậy em việt p_action_type có 1 và 3 mà ko có 2 :))
-- Created date:
-- SELECT * FROM crm_activity_update_lottery_price_agency(3, 'Vinh Pham (Super Admin)',2, '[{"LotteryPriceAgencyId":1, "AgencyId":9,"LotteryChannelId":29,"Price":"11"},{"LotteryPriceAgencyId":2,"AgencyId":9,"LotteryChannelId":29,"Price":"11"}]')
-- ================================
SELECT dropallfunction_byname('crm_activity_update_lottery_price_agency');
CREATE OR REPLACE FUNCTION crm_activity_update_lottery_price_agency
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
	--INSERT UPDATE
	IF p_action_type = 1 THEN
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
					INSERT INTO "LotteryPriceAgency"(
						"AgencyId",
						"LotteryChannelId",
						"Price",
						"CreatedBy",
						"CreatedByName",
						"CreatedDate",
						"IsDeleted" 
					)
					VALUES(
						(ele->>'AgencyId')::INT,
						(ele->>'LotteryChannelId')::INT,
						(ele->>'Price')::NUMERIC,
						p_action_by,
						p_action_by_name,
						v_time,
						FALSE
					);
					
		END LOOP;
		
		v_id := 1;
		v_mess := 'INSERT thành công';
		
	--DELETE
	ELSEIF p_action_type = 3 THEN
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "LotteryPriceAgency" 
			SET "IsDeleted" = TRUE
			WHERE "LotteryPriceAgencyId" = (ele->>'LotteryPriceAgencyId')::INT;
		END LOOP;
		v_id := 1;
		v_mess := 'Xoá thành công';
	ELSE
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "LotteryPriceAgency" 
				SET "Price" = (ele->>'Price')::NUMERIC
			WHERE "LotteryPriceAgencyId" = (ele->>'LotteryPriceAgencyId')::INT;
		END LOOP;
		v_id := 1;
		v_mess := 'Cập nhật thành công';
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