-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_update_history_order(1, 'QUANG', '{"HistoryOfOrderId": 65, "SalePointId": 3 ,"ActionType":3, "ShiftDistributeId": 100 , "Data": "Helo WOLRD"}')
-- ================================
SELECT dropallfunction_byname('crm_salepoint_update_history_order');
CREATE OR REPLACE FUNCTION crm_salepoint_update_history_order
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
	ele JSON := p_data::JSON;
	v_time TIMESTAMP := NOW();
	v_tmp INT;
	v_arr TEXT;
BEGIN
	--INSERT
	IF (ele->>'ActionType')::INT = 1 THEN 
		INSERT INTO "HistoryOfOrder"(
			"SalePointId",
			"PrintTimes",
			"ListPrint",
			"Data",
			"CreatedBy",
			"CreatedByName",
			"CreatedDate",
			"IsDeleted",
			"ShiftDistributeId",
			"GuestId"
		)
		VALUES(
			(ele->>'SalePointId')::INT,
			(CASE WHEN (ele->>'IsPrint')::BOOL IS TRUE THEN 1 ELSE 0 END),
			(CASE WHEN (ele->>'IsPrint')::BOOL IS TRUE THEN '{'||p_action_by||'}' ELSE '{}' END)::INT[],
			(ele->>'Data')::TEXT,
			p_action_by,
			p_action_by_name,
			v_time,
			FALSE,
			(ele->>'ShiftDistributeId')::INT,
			(ele->>'GuestId')::INT
		) RETURNING "HistoryOfOrderId" INTO v_id;
		
		v_mess := 'Thêm thành công';
	-- PRINT
	ELSEIF (ele->>'ActionType')::INT = 2 THEN
		
		UPDATE "HistoryOfOrder"
		SET 
			"PrintTimes" = "PrintTimes" + 1,
			"ListPrint" = array_append("ListPrint", p_action_by)
		WHERE "HistoryOfOrderId" = (ele->>'HistoryOfOrderId')::INT;
	
		v_id := 1;
		v_mess := 'In thành công';
	-- DELETE
	ELSEIF (ele->>'ActionType')::INT = 3 THEN
	
		UPDATE "HistoryOfOrder"
		SET 
			"IsDeleted" = TRUE
		WHERE "HistoryOfOrderId" = (ele->>'HistoryOfOrderId')::INT;
		
		--Xoá lịch sử bán hàng
		FOR v_tmp IN (SELECT UNNEST("SalePointLogIds") FROM "HistoryOfOrder" WHERE "HistoryOfOrderId" = (ele->>'HistoryOfOrderId')::INT) LOOP
			UPDATE "SalePointLog"
			SET "IsDeleted" = TRUE
			WHERE "SalePointLogId" = v_tmp;			
		END LOOP;
		--XOá lịch sử trả tiền
		FOR v_tmp IN (SELECT UNNEST("GuestActionIds") FROM "HistoryOfOrder" WHERE "HistoryOfOrderId" = (ele->>'HistoryOfOrderId')::INT) LOOP
			UPDATE "GuestAction"
			SET "IsDeleted" = TRUE
			WHERE "GuestActionId" = v_tmp;		
		END LOOP;
		--Xoá lịch sử confirm
		FOR v_tmp IN (SELECT UNNEST("ConfirmLogIds") FROM "HistoryOfOrder" WHERE "HistoryOfOrderId" = (ele->>'HistoryOfOrderId')::INT) LOOP
			UPDATE "ConfirmLog"
			SET "IsDeleted" = TRUE
			WHERE "ConfirmLogId" = v_tmp;			
		END LOOP;
		
		v_id := 1;
		v_mess := 'Xoá thành công';
	--Tự conftrm bill
	ELSEIF (ele->>'ActionType')::INT = 4 THEN
		SELECT 
			array_to_json(array_agg(jsonb_build_object('ConfirmLogId', A."ConfirmLogId")))::TEXT 
		INTO
			v_arr
		FROM (
			SELECT
				UNNEST(HOD."ConfirmLogIds") AS "ConfirmLogId"
			FROM "HistoryOfOrder" HOD
			WHERE HOD."HistoryOfOrderId" = (ele->>'HistoryOfOrderId')::INT
		) A;
		SELECT 
			T."Id",
			T."Message"
		INTO
			v_id,
			v_mess
		FROM crm_salepoint_confirm_list_payment_v2(0, 'System_CRM', 2, v_arr ) T;
	ELSE
		v_id := -1;
		v_mess := 'Không có gì để thực hiện';
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