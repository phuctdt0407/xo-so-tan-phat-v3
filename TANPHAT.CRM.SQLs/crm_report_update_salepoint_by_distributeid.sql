-- ================================
-- Author: Tien
-- Description: Cập nhật trạng thái bán của nhân viên  
-- Created date: 03/06/2022
--INSERT
-- SELECT * FROM crm_report_update_salepoint_by_distributeid(-1,'Tien Le',3018, 6, '[{"Quantity":22,"LotteryDate":"09-06-2022","LotteryChannelId":18,"ShiftDistributeId":439,"LotteryPriceId":6,"LotteryTypeId":2}]' );

--DELETE
-- SELECT * FROM crm_report_update_salepoint_by_distributeid(-1,'Tien Le',3018, 6, '[{"SalePointLogId": 424, "IsDeleted": true , "Quantity": 10,"LotteryDate": "2022-05-19","LotteryChannelId": 18,"ShiftDistributeId": 617, "LotteryPriceId": 2, "LotteryTypeId": 1}]' );
-- ================================
SELECT dropallfunction_byname('crm_report_update_salepoint_by_distributeid');
CREATE OR REPLACE FUNCTION crm_report_update_salepoint_by_distributeid
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_distributeId INT,
	p_sale_point_id INT,
	p_update_data TEXT
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
	v_total_price NUMERIC :=0.0;
	v_date DATE;
	v_action_by INT;
	v_action_by_name VARCHAR;
BEGIN
	FOR ele IN SELECT * FROM json_array_elements(p_update_data::JSON) LOOP
	
	SELECT
			U."UserId",
			U."FullName"
	INTO
		v_action_by,
		v_action_by_name
	FROM "ShiftDistribute" SD
		JOIN "User"U ON U."UserId" = SD."UserId" 
	 WHERE SD."ShiftDistributeId"=COALESCE((ele ->> 'ShiftDistributeId')::INT,0);

	IF(COALESCE((ele ->> 'SalePointLogId')::INT, 0) > 0) THEN
	--Mark DELETE
		UPDATE "SalePointLog"
		SET	"IsDeleted" = COALESCE((ele ->> 'IsDeleted')::BOOLEAN,"IsDeleted")
		WHERE "SalePointLogId" =(ele ->> 'SalePointLogId')::INT; 
			v_id := 1;
			v_mess := 'Cập nhật thành công';
	ELSE
	--Start INSERT
		SELECT 
			(CASE WHEN ((ele ->> 'LotteryPriceId')::INT) = 6 THEN
				10000 * ((ele ->> 'Quantity')::INT) / 11 * 10
				ELSE LP."Price" * (ele ->> 'Quantity')::INT END) INTO v_total_price
		FROM "LotteryPrice" LP
		WHERE "LotteryPriceId" = 	(ele ->> 'LotteryPriceId')::INT;
				
		SELECT "DistributeDate" INTO v_date
		FROM "ShiftDistribute" WHERE "ShiftDistributeId" = (ele ->> 'ShiftDistributeId')::INT
		LIMIT 1;
		
		INSERT INTO "SalePointLog" (
			"SalePointId",
			"LotteryDate",
			"LotteryChannelId",
			"Quantity",
			"ActionBy",
			"ActionByName",
			"ModifyBy",
			"ModifyByName",
			"ActionDate",
			"LotteryTypeId",
			"TotalValue",
			"ShiftDistributeId",
			"LotteryPriceId"
		)VALUES(
			p_sale_point_id,
			(ele ->> 'LotteryDate')::DATE,
			(ele ->> 'LotteryChannelId')::INT,
			(ele ->> 'Quantity')::INT,
			v_action_by,
			v_action_by_name,
			p_action_by,
			p_action_by_name,
			((v_date)::VARCHAR ||' '||  CURRENT_TIME ::VARCHAR) :: TIMESTAMP,
			(ele ->> 'LotteryTypeId')::INT,
			v_total_price,
			(ele ->> 'ShiftDistributeId')::INT,
			(ele ->> 'LotteryPriceId')::INT
		);
		
		--Success INSERT
		IF(COALESCE((ele ->> 'LotteryTypeId')::INT, 0) <> 3) THEN

			UPDATE "Inventory" 
			SET 
				"TotalRemaining" = "TotalRemaining" - (CASE WHEN (ele ->> 'LotteryTypeId')::INT = 1 THEN (ele ->> 'Quantity')::INT ELSE 0 END),
				"TotalDupRemaining" = "TotalDupRemaining" - (CASE WHEN (ele ->> 'LotteryTypeId')::INT = 2 THEN (ele ->> 'Quantity')::INT ELSE 0 END)
			WHERE
				"SalePointId" = p_sale_point_id 
				AND "LotteryDate" :: DATE = (ele ->> 'LotteryDate')::DATE 
				AND "LotteryChannelId"= (ele ->> 'LotteryChannelId')::INT;
				
		ELSE
			UPDATE "Scratchcard" 
			SET 
				"TotalRemaining" = "TotalRemaining" - (ele ->> 'Quantity')::INT
			WHERE
				"SalePointId" = p_sale_point_id 
				AND "LotteryChannelId"= (ele ->> 'LotteryChannelId')::INT;
		END IF;
		--
			v_id := 1;
			v_mess := 'Thêm mới thành công';
	END IF;
END LOOP;
	
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