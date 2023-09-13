-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- Vé thường
-- SELECT * FROM crm_activity_return_lottery(1,'System', '[{"LotteryDate": "2022-04-01", "LotteryChannelId": 21, "FromSalePointId":  0, "ToAgencyId": 2, "TotalTrans": 10, "IsScratchcard": false  }]')
-- Vé cào
--SELECT * FROM crm_activity_return_lottery(1,'System', '[{"LotteryDate": "2022-04-01", "LotteryChannelId": 1000, "FromSalePointId":  0, "ToAgencyId": 2, "TotalTrans": 11, "IsScratchcard": true  }]')
-- Xoá
--SELECT * FROM crm_activity_return_lottery(1,'System', '[{"TransitionId": 660}]', 3)
-- ================================
SELECT dropallfunction_byname('crm_activity_return_lottery');
CREATE OR REPLACE FUNCTION crm_activity_return_lottery
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT,
	p_action_type INT DEFAULT 1,
	p_date TIMESTAMP DEFAULT NOW()
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
	v_check_dup INT := 0;
	v_check INT := 0;
	v_check_type BOOL := FALSE;
	v_check_date DATE;
	v_check_channel INT;
	v_time TIMESTAMP := NOW();
BEGIN

	--THÊM 
	IF p_action_type = 1 THEN 
	
		CREATE TEMP TABLE DataCheck ON COMMIT DROP AS (
			WITH tmp AS (
				SELECT 
					I."AgencyId",
					I."LotteryChannelId",
					I."TotalReceived",
					I."LotteryDate",
					FALSE AS "IsScratchcard"
				FROM "InventoryFull" I
				WHERE I."LotteryDate" = p_date::DATE
				UNION
				SELECT 
					SF."AgencyId",
					SF."LotteryChannelId",
					SUM(SF."TotalReceived") AS "TotalReceived",
					NULL AS "LotteryDate",
					TRUE AS "IsScratchcard"
				FROM "ScratchcardFullLog" SF
				GROUP BY 
					SF."AgencyId",
					SF."LotteryChannelId"
			),
			tmp2 AS(
				SELECT 
					T."LotteryChannelId",
					T."LotteryDate",
					T."TransitionTypeId",
					T."TotalTrans",
					T."TotalTransDup",
					T."ToAgencyId",
					T."IsScratchcard"
				FROM "Transition" T
				WHERE T."ConfirmStatusId" = 2
					AND (T."IsScratchcard" IS TRUE OR T."LotteryDate" = p_date::DATE)
					AND T."IsDeleted" IS FALSE
			),
			tmp3 AS (
				SELECT
					T."ToAgencyId" AS "AgencyId",
					T."LotteryChannelId",
					SUM(T."TotalTrans") AS "TotalTrans",
					SUM(T."TotalTransDup") AS "TotalTransDup"
				FROM tmp2 T
				WHERE T."ToAgencyId" IS NOT NULL AND T."TransitionTypeId" = 3
				GROUP BY 
					T."ToAgencyId",
					T."LotteryChannelId"
			)
			SELECT 
				C."AgencyId",
				C."LotteryChannelId",
				(C."TotalReceived" - COALESCE(R."TotalTrans", 0) - COALESCE(R."TotalTransDup", 0)) AS "TotalCanReturn",
				C."LotteryDate",
				C."IsScratchcard"	
			FROM tmp C
				LEFT JOIN tmp3 R ON C."AgencyId" = R."AgencyId" AND C."LotteryChannelId" = R."LotteryChannelId"
			ORDER BY C."AgencyId", C."LotteryChannelId"
					
		);
	
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
		
			-- Cập nhật kho vé cào
			IF (ele ->> 'IsScratchcard')::BOOL IS TRUE THEN
			
				--Kiểm tra đã tồn tại kho vé chưa
				IF NOT EXISTS(SELECT 1 FROM "Scratchcard" WHERE "SalePointId" = 0 AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT) THEN
					RAISE 'Không đủ số lượng vé trong kho';
				END IF;
				
				UPDATE "Scratchcard" 
				SET "TotalRemaining" = "TotalRemaining" - COALESCE((ele->>'TotalTrans')::INT, 0)
				WHERE "SalePointId" = 0 AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT
				RETURNING "TotalRemaining" INTO v_check;
			
			-- Cập nhật kho vé thường
			ELSE 
				
				--Kiểm tra xem kho vé đã tồn tại chưa
				IF NOT EXISTS(
					SELECT 1 FROM "Inventory"
					WHERE "SalePointId" = 0 
						AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT 
						AND "LotteryDate" = (ele->>'LotteryDate')::DATE
				) THEN
					RAISE 'Không đủ số lượng vé trong kho';
				END IF;
			
				UPDATE "Inventory" 
				SET 
					"TotalRemaining" = "TotalRemaining" - COALESCE((ele->>'TotalTrans')::INT, 0),
					"TotalDupRemaining" = "TotalDupRemaining" - COALESCE((ele->>'TotalTransDup')::INT, 0)
				WHERE "SalePointId" = 0
					AND "LotteryChannelId" = (ele->>'LotteryChannelId')::INT
					AND "LotteryDate" = (ele->>'LotteryDate')::DATE
				RETURNING "TotalRemaining", "TotalDupRemaining" INTO v_check, v_check_dup;
				
			END IF;
			
			-- Kiểm tra ra số âm
			IF v_check < 0 OR v_check_dup < 0 THEN
				RAISE 'Không đủ số lượng vé trong kho';
			END IF;
			
			-- Kiểm tra trả về đại lý
-- 			IF NOT EXISTS( 
-- 				SELECT 1 FROM DataCheck D
-- 				WHERE D."AgencyId" = (ele->>'ToAgencyId')::INT 
-- 					AND (ele->>'LotteryChannelId')::INT = D."LotteryChannelId"
-- 					AND (D."LotteryDate" = (ele->>'LotteryDate')::DATE OR (D."IsScratchcard" IS TRUE AND (ele->>'IsScratchcard')::BOOL IS TRUE))
-- 					AND D."TotalCanReturn" >= (COALESCE((ele->>'TotalTrans')::INT, 0) + COALESCE((ele->>'TotalTransDup')::INT, 0))
-- 			) THEN
-- 				RAISE 'Vé đã trả nhiều hơn số vé đã lấy từ đại lý';
-- 			END IF;
					
			-- Thêm dòng log
			INSERT INTO "Transition"(
				"LotteryDate",
				"LotteryChannelId",
				"FromSalePointId",
				"ToAgencyId",
				"TotalTrans",
				"TotalTransDup",
				"ConfirmTrans",
				"ConfirmTransDup",
				"TransitionDate",
				"TransitionTypeId",
				"ConfirmStatusId",
				"IsScratchcard",
				"ActionBy",
				"ActionByName",
				"ConfirmBy",
				"ConfirmByName",
				"ConfirmDate"
			)
			VALUES(
				(ele->>'LotteryDate')::DATE,
				(ele->>'LotteryChannelId')::INT,
				(ele->>'FromSalePointId')::INT,
				(ele->>'ToAgencyId')::INT,
				COALESCE((ele->>'TotalTrans')::INT, 0),
				COALESCE((ele->>'TotalTransDup')::INT, 0),
				COALESCE((ele->>'TotalTrans')::INT, 0),
				COALESCE((ele->>'TotalTransDup')::INT, 0),
				v_time,
				3,
				2,
				(ele->>'IsScratchcard')::BOOL,
				p_action_by,
				p_action_by_name,
				p_action_by,
				p_action_by_name,
				v_time
			);
			
			-- Cập nhật lại bảng CHECK
			UPDATE DataCheck 
			SET "TotalCanReturn" = "TotalCanReturn" - (COALESCE((ele->>'TotalTrans')::INT, 0) + COALESCE((ele->>'TotalTransDup')::INT, 0))
			WHERE "AgencyId" = (ele->>'ToAgencyId')::INT 
				AND (ele->>'LotteryChannelId')::INT = "LotteryChannelId"
				AND ("LotteryDate" = (ele->>'LotteryDate')::DATE OR ("IsScratchcard" IS TRUE AND (ele->>'IsScratchcard')::BOOL IS TRUE));
			
		END LOOP;
		
		v_id := 1;
		v_mess := 'Trả ế thành công';
		
	--SỬA
	ELSEIF p_action_type = 2 THEN 
		-- DO SOMETHING
		v_id := 1;
		v_mess := 'Cập nhật thành công';
	
	--XOÁ
	ELSEIF p_action_type = 3 THEN 
		
	
		FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
		
			--Cập nhật dòng log
			UPDATE "Transition" 
			SET "IsDeleted" = TRUE
			WHERE "TransitionId" = (ele->>'TransitionId')::INT
			RETURNING "TotalTrans", "TotalTransDup", "IsScratchcard", "LotteryDate", "LotteryChannelId"
			INTO v_check, v_check_dup, v_check_type,v_check_date, v_check_channel;
				
			
			-- Cập nhật kho vé cào
			IF v_check_type IS TRUE THEN
				
				--Kiểm tra đã tồn tại kho vé cào chưa
				IF NOT EXISTS(SELECT 1 FROM "Scratchcard" WHERE "SalePointId" = 0 AND "LotteryChannelId" = v_check_channel) THEN
					RAISE 'Không đủ số lượng vé trong kho';
				END IF;
				
				UPDATE "Scratchcard" 
				SET "TotalRemaining" = "TotalRemaining" + v_check
				WHERE "SalePointId" = 0 AND "LotteryChannelId" = v_check_channel;
			
			-- Cập nhật kho vé thường
			ELSE 
			
				--Kiểm tra xem kho vé đã tồn tại chưa
				IF NOT EXISTS(
					SELECT 1 FROM "Inventory"
					WHERE "SalePointId" = 0 
						AND "LotteryChannelId" = v_check_channel 
						AND "LotteryDate" = v_check_date
				) THEN
					RAISE 'Không đủ số lượng vé trong kho';
				END IF;
			
				UPDATE "Inventory" 
				SET 
					"TotalRemaining" = "TotalRemaining" + v_check::INT,
					"TotalDupRemaining" = "TotalDupRemaining" + v_check_dup::INT
				WHERE "SalePointId" = 0
					AND "LotteryChannelId" = v_check_channel
					AND "LotteryDate" = v_check_date;
				
			END IF;
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