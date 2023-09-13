-- ================================
-- Author: Tien
-- Description: Create OR Update Item
-- Created date: 17/06/2022

--Create Item
-- SELECT * FROM crm_item_create_or_update(0, 'SYSTEM', '{"ItemName":"Giấy A4","Price":"50000","UnitId":1,"Quotation":1}');

--Update Item
--SELECT * FROM crm_item_create_or_update(0, 'SYSTEM', '{"ItemId":20,"ItemName":"Giấy A4","IsActive": true,"Price":"50000","UnitId":1,"Quotation":100}');
-- ================================
SELECT dropallfunction_byname('crm_item_create_or_update');
CREATE OR REPLACE FUNCTION crm_item_create_or_update
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
BEGIN
		IF(COALESCE((ele ->> 'ItemId')::INT,0)=0 ) THEN
			INSERT INTO "Item"(
				"ItemName",
				"Price",
				"UnitId",
				"CreateBy",
				"CreateByName",
				"CreatedDate",
				"Quotation",
				"TypeOfItemId"
			)
			VALUES(
				(ele ->> 'ItemName'):: VARCHAR,
				(ele ->> 'Price'):: INT,
				(ele ->> 'UnitId'):: INT,
				p_action_by,
				p_action_by_name,
				NOW(),
				(ele ->> 'Quotation'):: INT,
				COALESCE((ele ->> 'TypeOfItemId'):: INT, 1)
			) RETURNING "ItemId" INTO v_id;
			v_mess := 'Thao tác tạo thành công';
		ELSE
			v_id:=(ele ->> 'ItemId')::INT ;
			UPDATE "Item"
			SET 
				"ItemName" = COALESCE((ele ->> 'ItemName'):: VARCHAR,"ItemName") ,
				"Price" =  COALESCE((ele ->> 'Price'):: INT,"Price"),
				"UnitId" =  COALESCE((ele ->> 'UnitId'):: INT,"UnitId"),
				"ModifyBy" = p_action_by,
				"ModifyByName" = p_action_by_name,
				"ModifyDate" = NOW(),
				"IsActive" = COALESCE((ele ->> 'IsActive'):: BOOLEAN,"IsActive"),
				"Quotation" = COALESCE((ele ->> 'Quotation'):: INT,"Quotation"),
				"TypeOfItemId" = COALESCE((ele ->> 'TypeOfItemId'):: INT,"TypeOfItemId") 
			WHERE "ItemId" = v_id;
			v_mess := 'Thao tác tạo thành công';
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
