-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_update_event_date(0,'System', '[{"Date": "2022-06-27", "Note": "Ngày Nhà Giáo VNam", "IsDeleted": "TRUE" }]')
-- ================================
SELECT dropallfunction_byname('crm_user_update_event_date');
CREATE OR REPLACE FUNCTION crm_user_update_event_date
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
	v_cur_time DATE := NOW()::DATE;
ele JSON;
BEGIN

	FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
		IF((ele->>'Date')::DATE <= v_cur_time) THEN 
			RAISE 'Không thể cập nhật ngày của quá khứ';
		END IF;
	END LOOP;

	FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
		--Xóa 
		IF((ele ->> 'IsDeleted')::BOOL IS TRUE) THEN 
			UPDATE "EventDay"
			SET "IsDeleted" = TRUE,
				"ModifyBy" = p_action_by,
				"ModifyByName" = p_action_by_name,
				"ModifyDate" = v_cur_time
			WHERE "Date" = (ele ->> 'Date')::DATE AND "IsDeleted" IS FAlSE;
			
			v_id := 1;
			v_mess := 'Xóa thành công';
		-- Nếu không xóa
		ELSEIF((ele ->> 'IsDeleted')::BOOL IS FALSE OR ((ele ->> 'IsDeleted')::BOOL IS NULL)) THEN
			-- Thêm nếu chưa có
			IF(NOT EXISTS(SELECT 1 FROM "EventDay" E WHERE E."Date" = (ele->>'Date')::DATE AND E."IsDeleted" IS FALSE)) THEN 
				INSERT INTO "EventDay"(
					"Year",
					"Date",
					"CreateBy",
					"CreateByName",
					"CreateDate",
					"Month",
					"IsDeleted",
					"Note"					
				)
				VALUES(
					EXTRACT(YEAR FROM (ele ->> 'Date')::DATE),
					(ele ->> 'Date')::DATE,
					p_action_by,
					p_action_by_name,
					v_cur_time,
					EXTRACT(MONTH FROM (ele ->> 'Date')::DATE),
					FALSE,
					(ele ->> 'Note')::VARCHAR
				);
				
				v_id := 1;
				v_mess := 'Thêm thành công';
			-- Cập nhật lại khi đã có và chưa bị xóa
			ELSE 
				UPDATE "EventDay"
				SET
					"Note" = (ele ->> 'Note')::VARCHAR, 
					"ModifyBy" = p_action_by,
					"ModifyByName" = p_action_by_name,
					"ModifyDate" = v_cur_time
				WHERE "Date" = (ele ->> 'Date')::DATE AND "IsDeleted" IS FALSE;
				
				v_id := 1;
				v_mess := 'Cập nhật thành công';
			END IF;
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