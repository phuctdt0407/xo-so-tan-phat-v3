-- ================================
-- Author: Tien
-- Description: Get Confirm Item
-- Created date: 22/03/2022
-- SELECT * FROM crm_item_get_list_confirm_v1('2023-02', NULL,1);
-- ================================
SELECT dropallfunction_byname('crm_item_get_list_confirm_v1');
CREATE OR REPLACE FUNCTION crm_item_get_list_confirm_v1
(
	p_month VARCHAR,
	p_sale_point_id INT DEFAULT 0,
	p_confirm_for_type_id INT DEFAULT 1
)
RETURNS TABLE
(
	"ItemConfirmLogId" INT,
	"ConfirmForTypeName" VARCHAR,
	"Data" TEXT,
	"TypeActionId" INT,
	"ItemTypeName" VARCHAR,
	"ConfirmStatusId" INT,
	"ConfirmStatusName" VARCHAR,
	"RequestBy" INT,
	"RequestByName" VARCHAR,
	"RequestDate" TIMESTAMP,
	"ConfirmBy" INT,
	"ConfirmByName" VARCHAR,
	"ConfirmDate" TIMESTAMP
)
AS $BODY$
DECLARE 
	
BEGIN
	RETURN QUERY 
		SELECT 
			IL."ConfirmLogId" AS "ItemConfirmLogId",
			CFT."ConfirmForTypeName",
			(
				SELECT 
					array_to_json(array_agg(
						A.*::JSONB 
						||('{"ItemName": "'||(SELECT I."ItemName" FROM "Item" I WHERE I."ItemId" = (A->>'ItemId')::INT )::TEXT||'"}')::JSONB
						||('{"UnitId": '||(SELECT I."UnitId" FROM "Item" I WHERE I."ItemId" = (A->>'ItemId')::INT)::INT||'}')::JSONB
						||('{"UnitName": "'||(SELECT U."UnitName" FROM "Item" I JOIN "Unit" U ON I."UnitId" = U."UnitId" WHERE I."ItemId" = (A->>'ItemId')::INT )::TEXT||'"}')::JSONB
					))
				FROM json_array_elements(IL."Data"::JSON) A
-- 				WHERE   (A->>'ItemId')::INT <> 13 AND  (A->>'ItemId')::INT <> 27
			)::TEXT AS "Data",
			IL."TypeActionId",
			(CASE 
				WHEN COALESCE(p_confirm_for_type_id,1) = 1 THEN  IT."ItemTypeName"
				WHEN p_confirm_for_type_id = 2 THEN  GT."TypeName"
			END) ,
			IL."ConfirmStatusId",
			CS."ConfirmStatusName",
			IL."ActionBy" AS "RequestBy",
			IL."ActionByName" AS "RequestByName",
			Il."ActionDate" AS "RequestDate",
			IL."ConfirmBy",
			IL."ConfirmByName",
			IL."ConfirmDate"
		FROM "ConfirmLog" IL 
			JOIN "ConfirmStatus" CS ON IL."ConfirmStatusId" = CS."ConfirmStatusId"
			JOIN "ItemType" IT ON IT."ItemTypeId" =IL."TypeActionId"
			JOIN "GuestActionType" GT ON GT."GuestActionTypeId" = IL."TypeActionId"
			JOIN "ConfirmForType" CFT ON CFT."ConfirmForTypeId" = IL."ConfirmFor"
		WHERE 
 			(COALESCE(p_month, NULL) IS NULL OR TO_CHAR(IL."ActionDate",'YYYY-MM') = p_month)
			AND IL."ConfirmFor" = COALESCE(p_confirm_for_type_id,1)
			AND (COALESCE(p_sale_point_id,0) = 0 OR p_sale_point_id = (((IL."Data" ::JSON)->> 0)::JSON ->> 'SalePointId')::INT)
-- 			AND (IL."Data"::JSON ->> 'ItemId')::INT8 <> 27 OR (IL."Data"::JSON ->> 'ItemId')::INT8 <> 13 
		ORDER BY IL."ActionDate" DESC;
END;
$BODY$
LANGUAGE plpgsql VOLATILE