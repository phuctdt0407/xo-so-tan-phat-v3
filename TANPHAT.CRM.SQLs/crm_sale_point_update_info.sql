-- ================================
-- Author: Tien
-- Description: Update SalePoint 
-- Created date: 14/06/2022

--INSERT
-- SELECT * FROM crm_sale_point_update_info(-1,'System', '{"FullAddress":"THU_DUC_2022_06_14","IsActive":false}');

--UPDATE
-- SELECT * FROM crm_sale_point_update_info(-1,'System', '{"FullAddress":"THU_DUC_2022_06_14","IsActive":false,"SalePointName":"TP_TEST1", "Note":"TEST_@@22"}',22);
-- ================================
SELECT dropallfunction_byname('crm_sale_point_update_info');
CREATE OR REPLACE FUNCTION crm_sale_point_update_info
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT,
	p_sale_point_id INT DEFAULT 0
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
	v_max INT := (SELECT MAX("SalePointId") 
		FROM "SalePoint");
BEGIN
	
	
	IF p_sale_point_id = 0 THEN
		INSERT INTO "SalePoint" (
			"SalePointName",
			"FullAddress",
			"ActionBy",
			"ActionByName",
			"ActionDate",
			"Note"
		)
		VALUES (
			COALESCE((ele->> 'SalePointName'),'TP'|| (v_max+1)),
			(ele->> 'FullAddress'),
			p_action_by,
			p_action_by_name,
			NOW(),
			(ele->> 'Note')
		);
	ELSE
		UPDATE "SalePoint"
		SET
			"IsActive" = COALESCE((ele->> 'IsActive'):: BOOLEAN, "IsActive"),
			"FullAddress" = COALESCE((ele->> 'FullAddress'):: VARCHAR,"FullAddress"),
			"SalePointName" = COALESCE((ele->> 'SalePointName'):: VARCHAR,"SalePointName"),
			"Note" = COALESCE((ele->> 'Note'):: VARCHAR,"Note"),
			"ModifyBy"= p_action_by,	
			"ModifyByName" = p_action_by_name,
			"ModifyDate" = NOW()
		WHERE "SalePointId"= p_sale_point_id;
	END IF;
	
	v_id := 1;
	v_mess := 'Cập nhật điểm bán thành công';
	
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