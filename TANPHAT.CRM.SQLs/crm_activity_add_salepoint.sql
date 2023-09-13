-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_add_salepoint(1, 'Viet', 'TP26')
-- ================================
SELECT dropallfunction_byname('crm_activity_add_salepoint');
CREATE OR REPLACE FUNCTION crm_activity_add_salepoint
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_salePoint_name VARCHAR
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
-- 	v_is_manager BOOL;
BEGIN
-- 	SELECT 
-- 		UT."IsManager" INTO v_is_manager
-- 	FROM "User" U
-- 		JOIN "UserRole" UR ON U."UserId" = UR."UserId"
-- 		JOIN "UserTitle" UT ON UR."UserTitleId" = UT."UserTitleId"
-- 	WHERE U."UserId" = p_action_by;
-- 		
	IF(NOT EXISTS (SELECT 1 FROM "SalePoint" WHERE "SalePointName" = p_salePoint_name)) THEN
		INSERT INTO "SalePoint"(
			"SalePointName",
			"IsActive",
			"IsDeleted",	
			"ActionBy",
			"ActionByName",
			"ActionDate"
		)
		VALUES(
			p_salePoint_name,
			TRUE,
			FALSE,
			p_action_by,
			p_action_by_name,
			v_time
		);
		v_id := 1;
		v_mess := 'Tạo điểm bán thành công';
	ELSE
		v_id := -1;
		v_mess := 'Tên điểm bán đã tồn tại';
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

