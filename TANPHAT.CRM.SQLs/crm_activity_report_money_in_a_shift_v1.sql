-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_activity_report_money_in_a_shift_v1(1074,'2023-02-10',480000)
-- ================================
SELECT dropallfunction_byname('crm_activity_report_money_in_a_shift_v1');
CREATE OR REPLACE FUNCTION crm_activity_report_money_in_a_shift_v1
(
    p_shift_distribute INT,
		p_date TIMESTAMP,
		p_total_money INT8
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
BEGIN
			INSERT INTO "ReportMoney" ("SalePointId","TotalMoneyInDay","ShiftDistributeId","ActionDate","ShiftId" )
			SELECT ST."SalePointid",p_total_money,p_shift_distribute,p_date,ST."ShiftId"
			FROM "ShiftTransfer" ST 
			WHERE ST."LotteryDate"::DATE = p_date::DATE LIMIT 1;
			
			
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