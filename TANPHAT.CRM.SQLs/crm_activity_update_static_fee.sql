-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_activity_update_static_fee('{"SalePointId": 6, "SalePointName": "TP6", "WaterFee": 2200000, "InternetFee": 3, "EstateFee": 100, "ElectronicFee": 2, "Month": "2023-04"}') -- insert
-- SELECT * FROM crm_activity_update_static_fee(12,'Viet','{"SalePointId":2,"Month":"2023-05","StaticFeeTypeId":3,"Value":10000}')  -- update
-- ================================
SELECT dropallfunction_byname('crm_activity_update_static_fee');
CREATE OR REPLACE FUNCTION crm_activity_update_static_fee
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
    ele JSON;
    v_time TIMESTAMP := NOW();
BEGIN
		ele := p_data::JSON; 
				INSERT INTO "StaticFee" 
				VALUES(
					(ele ->> 'SalePointId') :: INT,
					(ele ->> 'Month')::VARCHAR,
					(ele ->> 'StaticFeeTypeId')::INT,
					(ele ->> 'Value')::INT8,
					NOW()::DATE,
					p_action_by,
					p_action_by_name);
			v_id := 1;
			v_mess := 'Thêm thành công';
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