-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date: 24/03/2023
-- SELECT * FROM crm_activity_distribute_for_sup_agency('2023-04-19',17 ,'Hoc (Super Admin)', '[{"LotteryChannelId":14,"AgencyId":2,"TotalReceived":50,"TotalDupReceived":0,"SupAgencyId":2,"LotteryDate":"2023-04-19"}]',FALSE)

--SELECT * FROM "InventoryFull"  I WHERE I."LotteryDate" = '2023-04-05'::DATE AND I."AgencyId" =2 AND I."LotteryChannelId" = 14

--TRUNCATE "InventoryForSupAgency" RESTART IDENTITY
-- ================================
SELECT dropallfunction_byname('crm_activity_distribute_for_sup_agency');
CREATE OR REPLACE FUNCTION crm_activity_distribute_for_sup_agency 
(
		p_date TIMESTAMP,
    p_action_by INT,
		p_action_by_name VARCHAR,
		p_data TEXT,
		p_lock BOOLEAN
)
RETURNS TABLE
( 
    "Id" INT,
    "Message" TEXT
)
AS $BODY$
DECLARE
    v_id INT := 1;
		v_mess TEXT;
		v_data JSON := p_data::JSON;
		ele JSON;
		v_total_received INT8;
		v_total_dup_received INT8;
BEGIN
	 IF p_lock IS FALSE THEN 
		FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
				IF NOT EXISTS (SELECT 1 FROM "InventoryForSupAgency" I WHERE I."Date"::DATE = p_date::DATE 
						AND I."AgencyId" = (ele ->> 'AgencyId')::INT 
						AND I."LotteryChannelId" = (ele->>'LotteryChannelId')::INT
						AND I."SupAgencyId" = (ele ->> 'SupAgencyId')::INT)
				THEN 
					INSERT INTO "InventoryForSupAgency"(
						"Date",
						"AgencyId",
						"SupAgencyId",
						"TotalReceived",
						"TotalDupReceived",
						"LotteryChannelId",
						"ActionBy",
						"ActionByName"
					)
					VALUES(
						p_date,
						(ele->>'AgencyId')::INT4,
						(ele->>'SupAgencyId')::INT4,
						(ele->>'TotalReceived')::INT8,
						(ele->>'TotalDupReceived')::INT8,
						(ele->>'LotteryChannelId')::INT4,
						p_action_by,
						p_action_by_name
					);
					raise notice 'ele TotalReceived % , ele TotalDupReceived %, v_total_received %, v_total_dup_received %', (ele->>'TotalReceived')::INT8, (ele->>'TotalDupReceived')::INT8, v_total_received, v_total_dup_received;
					
					UPDATE "InventoryFull" 
						SET 
							"TotalRemaining" = "TotalRemaining" - (ele->>'TotalReceived')::INT8 - (ele->>'TotalDupReceived')::INT8
					WHERE "AgencyId" = (ele->>'AgencyId')::INT4 
						AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT4
						AND "LotteryDate" = (ele->>'LotteryDate')::DATE;
					
					v_mess := 'Thêm thành công';
				ELSE 
					raise notice '11111111111111111';
					SELECT 
						I."TotalReceived",
						I."TotalDupReceived"
						INTO v_total_received, v_total_dup_received
					FROM "InventoryForSupAgency" I 
					WHERE I."Date"::DATE = p_date::DATE 
						AND I."AgencyId" = (ele ->> 'AgencyId')::INT 
						AND I."LotteryChannelId" = (ele->>'LotteryChannelId')::INT
						AND I."SupAgencyId" = (ele ->> 'SupAgencyId')::INT;
					
					
					Update "InventoryForSupAgency" 
					SET 
						"Date" = p_date,
						"AgencyId" = 	(ele->>'AgencyId')::INT4,
						"SupAgencyId" = (ele->>'SupAgencyId')::INT4,
						"TotalReceived" = (ele->>'TotalReceived')::INT8,
						"TotalDupReceived" = (ele->>'TotalDupReceived')::INT8,
						"ActionBy" = p_action_by,
						"TotalPrice" = ( SELECT T."Price" * (ele->>'TotalReceived')::INT8 FROM "SubAgency" T WHERE T."ModifiedDate" = p_date )
					WHERE "Date"::DATE = p_date::DATE 
						AND "AgencyId" = (ele ->> 'AgencyId')::INT 
						AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT
						AND "SupAgencyId" = (ele ->> 'SupAgencyId')::INT;
					
					raise notice 'ele TotalReceived % , ele TotalDupReceived %, v_total_received %, v_total_dup_received %', (ele->>'TotalReceived')::INT8, (ele->>'TotalDupReceived')::INT8, v_total_received, v_total_dup_received;
						
					UPDATE "InventoryFull" 
						SET 
							"TotalRemaining" = "TotalRemaining" + ( v_total_received - (ele->>'TotalReceived')::INT8 ) - ((ele->>'TotalDupReceived')::INT8 - v_total_dup_received)
					WHERE "AgencyId" = (ele->>'AgencyId')::INT4 
						AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT4
						AND "LotteryDate" = (ele->>'LotteryDate')::DATE;
						
						v_mess := 'Cập nhật thành công';
				END IF;
			END LOOP;
		ELSE
		FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
				IF NOT EXISTS (SELECT 1 FROM "InventoryForSupAgency" I WHERE I."Date"::DATE = p_date::DATE 
						AND I."AgencyId" = (ele ->> 'AgencyId')::INT 
						AND I."LotteryChannelId" = (ele->>'LotteryChannelId')::INT
						AND I."SupAgencyId" = (ele ->> 'SupAgencyId')::INT)
					THEN 
						INSERT INTO "InventoryForSupAgency"(
							"Date",
							"AgencyId",
							"SupAgencyId",
							"TotalReceived",
							"TotalDupReceived",
							"LotteryChannelId",
							"ActionBy",
							"ActionByName"
						)
						VALUES(
							p_date,
							(ele->>'AgencyId')::INT4,
							(ele->>'SupAgencyId')::INT4,
							(ele->>'TotalReceived')::INT8,
							(ele->>'TotalDupReceived')::INT8,
							(ele->>'LotteryChannelId')::INT4,
							p_action_by,
							p_action_by_name
						);
					UPDATE "InventoryFull" 
						SET 
							"TotalRemaining" = "TotalRemaining" - (ele->>'TotalReceived')::INT8 - (ele->>'TotalDupReceived')::INT8
					WHERE "AgencyId" = (ele->>'AgencyId')::INT4 
						AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT4
						AND "LotteryDate" = (ele->>'LotteryDate')::DATE;
						
						v_mess := 'Thêm thành công';
				ELSE
									
					SELECT 
						I."TotalReceived",
						I."TotalDupReceived"
						INTO v_total_received, v_total_dup_received
					FROM "InventoryForSupAgency" I 
					WHERE I."Date"::DATE = p_date::DATE 
						AND I."AgencyId" = (ele ->> 'AgencyId')::INT 
						AND I."LotteryChannelId" = (ele->>'LotteryChannelId')::INT
						AND I."SupAgencyId" = (ele ->> 'SupAgencyId')::INT;
				
					UPDATE "InventoryForSupAgency" 
					SET "TotalDupReceived" = (ele->>'TotalDupReceived')::INT4
					WHERE "Date"::DATE = p_date::DATE 
						AND "AgencyId" = (ele ->> 'AgencyId')::INT 
						AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT
						AND "SupAgencyId" = (ele ->> 'SupAgencyId')::INT;
						
					UPDATE "InventoryFull" 
						SET 
							"TotalRemaining" = "TotalRemaining" + (v_total_received - (ele->>'TotalReceived')::INT8 ) - ((ele->>'TotalDupReceived')::INT8 - v_total_dup_received)
					WHERE "AgencyId" = (ele->>'AgencyId')::INT4 
						AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT4
						AND "LotteryDate" = (ele->>'LotteryDate')::DATE;
						v_mess := 'Cập nhật thành công';
				END IF;
			END LOOP;
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