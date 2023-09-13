-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_update_kpi_of_user(1, 'QUANG', '[{"UserId": 6, "KPI": 7,  "WeekId": 1, "CriteriaId": 6, "Month": "2022-06"}]')
-- ================================
SELECT dropallfunction_byname('crm_user_update_kpi_of_user');
CREATE OR REPLACE FUNCTION crm_user_update_kpi_of_user
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT,
	p_action_type INT DEFAULT 1
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
	v_check NUMERIC;
BEGIN
	--INSERT
	IF p_action_type = 1 THEN 
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			IF ((ele->>'KPILogId')::INT IS NULL) THEN
				
				IF((ele->>'WeekId')::INT IS NULL OR (ele->>'CriteriaId')::INT IS NULL) THEN
					RAISE 'Không đủ thông tin để cập nhật';
				END IF;
				
				SELECT C."MaxValue" INTO v_check FROM "Criteria" C WHERE C."CriteriaId" = (ele->>'CriteriaId')::INT;

				IF((ele->>'KPI')::NUMERIC > v_check) THEN 
					RAISE 'Số KPI nhập vào % lớn hơn số KPI giới hạn %',(ele->>'KPI')::NUMERIC, v_check;
				END IF;
				
				INSERT INTO "KPILog"(
					"UserId",
					"KPI",
					"WeekId",
					"SalePointId",
					"CriteriaId",
					"Note",
					"Month",
					"CreatedBy",
					"CreatedByName",
					"CreatedDate",
					"IsDeleted" 
				)
				VALUES(
					(ele->>'UserId')::INT,
					(ele->>'KPI')::NUMERIC,
					(ele->>'WeekId')::INT,
					COALESCE((ele->>'SalePointId')::INT, 0),
					(ele->>'CriteriaId')::INT,
					(ele->>'Note')::VARCHAR,
					(ele->>'Month')::VARCHAR,
					p_action_by,
					p_action_by_name,
					v_time,
					FALSE
				);
				
			ELSE 
			
				UPDATE "KPILog" 
				SET 
					"KPI" = COALESCE((ele->>'KPI')::NUMERIC, "KPI"),
					"Note" = COALESCE((ele->>'Note')::VARCHAR, "Note"),
					"ModifyBy" = p_action_by,
					"ModifyByName" = p_action_by_name,
					"ModifyDate" = v_time
				WHERE "KPILogId" = (ele->>'KPILogId')::INT;
				
			END IF;	
			
		END LOOP;
		
		v_id := 1;
		v_mess := 'Cập nhật thành công';
	--DELETE
	ELSEIF p_action_type = 3 THEN
	
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
			UPDATE "KPILog"
			SET 
				"IsDeleted" = TRUE
			WHERE "KPILogId" = (ele->>'KPILogId')::INT;
	
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