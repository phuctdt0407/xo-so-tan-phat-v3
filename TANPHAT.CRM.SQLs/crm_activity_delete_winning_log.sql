-- ================================
-- Author: Quang
-- Description: Xoá lịch sử trả thưởng
-- Created date:
-- SELECT * FROM crm_activity_delete_winning_log(0 ,'System', 43)
-- ================================
SELECT dropallfunction_byname('crm_activity_delete_winning_log');
CREATE OR REPLACE FUNCTION crm_activity_delete_winning_log 
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_winning_id INT
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
	v_time TIMESTAMP := NOW();
	v_data TEXT;
BEGIN
	
	IF EXISTS (SELECT 1 FROM "Winning" W WHERE W."WinningId" = p_winning_id) THEN
		SELECT
			TO_JSONB(W.*)::TEXT INTO v_data
		FROM "Winning" W
		WHERE W."WinningId" = p_winning_id;
		
		DELETE FROM "Winning"
		WHERE "WinningId" = p_winning_id;
		
		INSERT INTO "LogDelete"(
			"LogTypeId",
			"LogData",
			"ActionBy",
			"ActionByName",
			"ActionDate"
		)
		VALUES(
			1,
			v_data,
			p_action_by,
			p_action_by_name,
			v_time
		) RETURNING "LogDeleteId" INTO v_id;
		
		v_mess := 'Xoá thành công';
		
	ELSE
		RAISE 'Dòng này đã bị xoá hoặc không tồn tại';
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