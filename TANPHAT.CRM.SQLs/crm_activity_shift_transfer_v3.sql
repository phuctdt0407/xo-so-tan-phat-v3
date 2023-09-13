-- ================================
-- Author: Quang
-- Description: tổng kết ca
-- Created date: 22/03/2022
-- Version: 1.0.0
-- SELECT * FROM crm_activity_shift_transfer_v3(4,1124,5,'QUANG','[{"TotalReceived":0,"TotalRemaining":440,"LotteryChannelId":12,"LotteryDate":"2023-02-07","LotteryTypeId":1,"TotalStocks":440,"TotalTrans":0,"TotalReturns":0,"TotalSold":0,"TotalSoldMoney":0,"TotalWholesale":0,"TotalWholesaleMoney":0,"TotalRetail":0,"TotalRetailMoney":0},{"TotalReceived":0,"TotalRemaining":4444,"LotteryChannelId":30,"LotteryDate":"2023-02-07","LotteryTypeId":1,"TotalStocks":4444,"TotalTrans":0,"TotalReturns":0,"TotalSold":0,"TotalSoldMoney":0,"TotalWholesale":0,"TotalWholesaleMoney":0,"TotalRetail":0,"TotalRetailMoney":0},{"TotalReceived":0,"TotalRemaining":440,"LotteryChannelId":31,"LotteryDate":"2023-02-07","LotteryTypeId":1,"TotalStocks":440,"TotalTrans":0,"TotalReturns":0,"TotalSold":0,"TotalSoldMoney":0,"TotalWholesale":0,"TotalWholesaleMoney":0,"TotalRetail":0,"TotalRetailMoney":0},{"TotalReceived":0,"TotalRemaining":370,"LotteryChannelId":1000,"LotteryDate":null,"LotteryTypeId":3,"TotalStocks":370,"TotalTrans":0,"TotalReturns":0,"TotalSold":0,"TotalSoldMoney":0,"TotalWholesale":0,"TotalWholesaleMoney":0,"TotalRetail":0,"TotalRetailMoney":0}]');
-- ================================
SELECT dropallfunction_byname('crm_activity_shift_transfer_v3');
CREATE OR REPLACE FUNCTION crm_activity_shift_transfer_v3
(
	p_user_role_id INT,
	p_shift_distribute INT,
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT,
	p_money INT
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
	v_data JSON := p_data::JSON;
	v_sale_point_id INT;
	v_user_id INT;
	ele JSON;
	v_shift_dis_id INT;
	v_shift_id INT;
BEGIN
	
	SELECT FN."UserId", FN."SalePointId", FN."ShiftDistributeId" INTO v_user_id, v_sale_point_id, v_shift_dis_id  FROM fn_get_shift_info(p_user_role_id) FN 
	WHERE FN."ShiftDistributeId" = p_shift_distribute;
	SELECT SD."ShiftId" INTO v_shift_id FROM "ShiftDistribute" SD WHERE SD."ShiftDistributeId" =  v_shift_dis_id;
	IF(EXISTS (SELECT 1 FROM "Transition" T WHERE T."ConfirmStatusId" = 1 AND T."ShiftDistributeId" = p_shift_distribute)) THEN
		v_id := 0;
		v_mess := 'Tất cả yêu cầu chuyển nhận cần được quản lý xác nhận trước khi kết ca';
	ELSEIF COALESCE(v_sale_point_id, 0) > 0 THEN
	
		FOR ele IN SELECT * FROM json_array_elements(v_data) LOOP
	
			INSERT INTO "ShiftTransfer"(
				"ShiftId",
				"UserId",
				"ShiftDistributeId",
				"LotteryChannelId",
				"LotteryTypeId",
				"ActionBy",
				"ActionByName",
				"ActionDate",
				"LotteryDate",
				"TotalStocks",
				"TotalReceived",
				"TotalTrans",
				"TotalReturns",
				"TotalRemaining",
				"TotalSold",
				"TotalSoldMoney",
				"TotalRetail",
				"TotalRetailMoney",
				"TotalWholesale",
				"TotalWholesaleMoney",
				"SalePointid"
			) VALUES (
				v_shift_id,
				v_user_id,
				v_shift_dis_id,
				(ele ->> 'LotteryChannelId')::INT,
				(ele ->> 'LotteryTypeId')::INT,
				p_action_by,
				p_action_by_name,
				NOW(),
				(ele ->> 'LotteryDate')::DATE,
				(ele ->> 'TotalStocks')::INT,
				(ele ->> 'TotalReceived')::INT,
				(ele ->> 'TotalTrans')::INT,
				(ele ->> 'TotalReturns')::INT,
				(ele ->> 'TotalRemaining')::INT,
				(ele ->> 'TotalSold')::INT,
				(ele ->> 'TotalSoldMoney')::NUMERIC,
				(ele ->> 'TotalRetail')::INT,
				(ele ->> 'TotalRetailMoney')::NUMERIC,
				(ele ->> 'TotalWholesale')::INT,
				(ele ->> 'TotalWholesaleMoney')::NUMERIC,
				v_sale_point_id
			) ;
			
		END LOOP;

			SELECT FN."Message",FN."Id" INTO  v_mess,v_id  FROM crm_activity_report_money_in_a_shift(p_shift_distribute, NOW()::DATE,p_money) FN;
	
	ELSE 
 
		v_id := 0;
		v_mess := 'Nhân viên không trong ca làm việc';
 
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

