-- ================================
-- Author: Quang
-- Description: 
-- Created date:
-- SELECT * FROM crm_salepoint_update_leader_attendent(0 ,'System', '{"LeaderAttendentData": [{"UserId": 1, "TriggerSalePoint": 1}, {"UserId": 2, "TriggerSalePoint": 2}], "GroupSalePointData":[{"UserId":8,"Option":0,"SalePointIds":[7,11,17]},{"UserId":9,"Option":0,"SalePointIds":[2,3,8,12,14,19]},{"UserId":48,"Option":0,"SalePointIds":[9,16,18]},{"UserId":49,"Option":0,"SalePointIds":[10,13,15]},{"UserId":8,"Option":1,"SalePointIds":[7,11,17]},{"UserId":9,"Option":1,"SalePointIds":[2,3,8,12,14,19]},{"UserId":48,"Option":1,"SalePointIds":[9,16,18,11,1,7]},{"UserId":49,"Option":1,"SalePointIds":[10,13,15,4,5,17]},{"UserId":8,"Option":2,"SalePointIds":[1,4,5,7,11,17]},{"UserId":9,"Option":2,"SalePointIds":[2,3,8,12,14,19]},{"UserId":48,"Option":2,"SalePointIds":[16,18,3,14,8,9]},{"UserId":49,"Option":2,"SalePointIds":[10,13,15,2,12,19]},{"UserId":8,"Option":3,"SalePointIds":[1,4,5,7,11,17]},{"UserId":9,"Option":3,"SalePointIds":[9,16,18,3,14,8]},{"UserId":48,"Option":3,"SalePointIds":[9,16,18]},{"UserId":49,"Option":3,"SalePointIds":[10,13,15,2,12,19]},{"UserId":8,"Option":4,"SalePointIds":[1,4,5,7,11,17]},{"UserId":9,"Option":4,"SalePointIds":[9,16,18,3,14,8]},{"UserId":48,"Option":4,"SalePointIds":[10,13,15,2,12,19]},{"UserId":49,"Option":4,"SalePointIds":[10,13,15]}]}')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_update_leader_attendent');
CREATE OR REPLACE FUNCTION crm_salepoint_update_leader_attendent 
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
	elele INT;
	v_time TIMESTAMP := NOW();
	v_id_tmp INT;
	v_array INT[] := '{}'::INT[];
BEGIN

	--Lấy bảng tạm để check dữ liệu cuối cùng
	CREATE TEMP TABLE tmpAttendent ON COMMIT DROP AS (
		SELECT 
			LA."LeaderAttendentId",
			LA."CreatedDate",
			LA."UserId",
			LA."TriggerSalePoint"
		FROM "LeaderAttendent" LA 
		WHERE LA."CreatedDate" >= ALL(
			SELECT 
				LAA."CreatedDate"
			FROM "LeaderAttendent" LAA
			GROUP BY LAA."CreatedDate"
		)
	);
	

		
	--Lặp qua list leader
	FOR ele IN SELECT * FROM json_array_elements(((p_data::JSON)->>'LeaderAttendentData')::JSON) LOOP
		
		--INSERT
		IF NOT EXISTS (
			SELECT 1 
			FROM tmpAttendent T 
			WHERE T."UserId" = (ele->>'UserId')::INT 
				AND T."TriggerSalePoint" = (ele->>'TriggerSalePoint')::INT
		) THEN
		
			INSERT INTO "LeaderAttendent"(
				"UserId",
				"TriggerSalePoint",
				"CreatedBy",
				"CreatedByName",
				"CreatedDate"
			)
			VALUES(
				(ele->>'UserId')::INT,
				(ele->>'TriggerSalePoint')::INT,
				p_action_by,
				p_action_by_name,
				v_time
			);
		
		--UPDATE
		ELSE 
		
			--Lấy id để update
			SELECT T."LeaderAttendentId" INTO v_id_tmp 
			FROM tmpAttendent T 
			WHERE T."UserId" = (ele->>'UserId')::INT 
			AND T."TriggerSalePoint" = (ele->>'TriggerSalePoint')::INT;
			
			--Update lại thời gian
			UPDATE "LeaderAttendent" 
			SET	
				"CreatedBy" = p_action_by,
				"CreatedByName" = p_action_by_name,
				"CreatedDate" = v_time
			WHERE "LeaderAttendentId" = v_id_tmp;
		
		END IF;
		
	END LOOP;
	
	--Lặp qua list lịch làm
	FOR ele IN SELECT * FROM json_array_elements(((p_data::JSON)->>'GroupSalePointData')::JSON) LOOP
		
		v_array := '{}'::INT[];
		
		FOR elele IN SELECT UNNEST(TRANSLATE((ele->>'SalePointIds'), '[]', '{}')::INT[]) LOOP			
			v_array := array_append(v_array, elele);			
		END LOOP;
		
		--INSERT
		IF COALESCE((ele->>'GroupSalePointId')::INT, 0) = 0 THEN
		
			INSERT INTO "GroupSalePoint"(
				"UserId",
				"SalePointIds",
				"Option",
				"CreatedBy",
				"CreatedByName",
				"CreatedDate"				
			)
			VALUES(
				(ele->>'UserId')::INT,
				v_array,
				(ele->>'Option')::INT,
				p_action_by,
				p_action_by_name,
				v_time
			);
		
		--UPDATE
		ELSE 
			
			UPDATE "GroupSalePoint" 
			SET
				"SalePointIds" = v_array,
				"Option" = (ele->>'Option')::INT,
				"CreatedBy" = p_action_by,
				"CreatedByName" = p_action_by_name,
				"CreatedDate"	= v_time	
			WHERE "GroupSalePointId" = (ele->>'GroupSalePointId')::INT;
					
		END IF;
		
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