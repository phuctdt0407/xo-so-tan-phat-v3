-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_activity_report_money_in_a_shift(1074,'2023-02-10',480000)
-- ================================
SELECT dropallfunction_byname('crm_activity_report_money_in_a_shift');
CREATE OR REPLACE FUNCTION crm_activity_report_money_in_a_shift 
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
    ele JSON;
    v_time TIMESTAMP := NOW();
BEGIN
			INSERT INTO "ReportMoney"("SalePointId","TotalMoneyInDay","ShiftDistributeId","ActionDate","ShiftId" )
			VALUES( 
			 (SELECT SD."SalePointid" FROM "ShiftTransfer" SD
			WHERE SD."ActionDate" :: DATE = p_date::DATE AND SD."ShiftDistributeId" = p_shift_distribute GROUP BY SD."SalePointid"),
			 p_total_money,
			 p_shift_distribute,
			 p_date::DATE,
			 (SELECT SD."ShiftId" FROM "ShiftTransfer" SD
			WHERE SD."ActionDate" :: DATE = p_date::DATE AND SD."ShiftDistributeId" = 1074 GROUP BY SD."ShiftId") ) ;
			
			
			UPDATE "ReportMoney"
			SET 
				"SalePointId" = SD."SalePointid",
				"ShiftId" = SD."ShiftId"
			FROM "ShiftTransfer" SD 
			WHERE SD."ActionDate" :: DATE = '2023-02-10'::DATE AND SD."ShiftDistributeId" = p_shift_distribute;
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