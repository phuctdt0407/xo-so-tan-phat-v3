-- ================================
-- Author: Tien
-- Description: Xoa ca lam
-- Created date: 01/07/2022
-- SELECT * FROM crm_report_delete_shift_transfer(0,'System',521)
-- ================================
SELECT dropallfunction_byname('crm_report_delete_shift_transfer');
CREATE OR REPLACE FUNCTION crm_report_delete_shift_transfer
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_shift_distribute_id INT
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
	v_check INT;
	v_user_id INT;
	v_user_name VARCHAR;
	v_salepoint_id INT;
BEGIN
	SELECT "ShiftDistributeId"
		INTO v_check
		FROM "ShiftTransfer" WHERE "ShiftDistributeId"= p_shift_distribute_id LIMIT 1;
	
	IF(COALESCE(v_check, 0)=0) THEN
		v_id := -1;
		v_mess := 'Ca làm việc chưa kết thúc HOẶC đã được huỷ kết ca';
	ELSE
		--GET DATA
		SELECT
			SD."SalePointId",
			SD."UserId",
			U."FullName"
		INTO
			v_salepoint_id,
			v_user_id,
			v_user_name
		FROM "ShiftDistribute" SD 
			JOIN "User" U ON U."UserId" = Sd."UserId"
			WHERE SD."ShiftDistributeId"  = v_check;
		--DELETE
		DELETE FROM "ShiftTransfer" 
			WHERE "ShiftDistributeId" = v_check;
		--INSERT LOG
		INSERT INTO "ShiftTransferLog" (
			"ActionBy",
			"ActionByName",
			"ActionDate",
			"ShiftDistributeId",
			"SalePointId",
			"UserId",
			"UserName"
		)VALUES(
			p_action_by,
			p_action_by_name,
			NOW(),
			v_check,
			v_salepoint_id,
			v_user_id,
			v_user_name
		);
		 
		v_id := 1;
		v_mess := 'Thao tác thành công';
	END IF;
	

	RETURN QUERY 
	SELECT 	v_id, v_mess;

	EXCEPTION WHEN OTHERS THEN
	BEGIN				
		v_id := -1;
		v_mess := sqlerrm;
		
		RETURN QUERY 
		SELECT 	v_id, v_mess;
	END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE