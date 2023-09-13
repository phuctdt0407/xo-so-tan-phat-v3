-- ================================
-- Author: Viet
-- Description: Thưởng , phạt, tăng ca, ....
-- Created date:
-- SELECT * FROM crm_activity_update_debt(49,2000,'2023-04',2,null,false)
-- ================================
SELECT dropallfunction_byname('crm_activity_update_debt');
CREATE OR REPLACE FUNCTION crm_activity_update_debt
(
    p_user_id INT8,
		p_payed_debt decimal,
		p_month VARCHAR,
		p_salepoint_id INT8 DEFAULT 0,
		p_total_debt decimal DEFAULT 0,
		p_flag boolean DEFAULT FALSE
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
		v_check DECIMAL := (SELECT SUM(D."TotalDebt") + COALESCE(p_total_debt,0) FROM "Debt" D WHERE D."UserId" = p_user_id AND D."IsAdded" IS TRUE) ;
		-- - (SELECT SUM(D."PayedDebt") FROM "Debt" D WHERE D."UserId" = p_user_id ) - COALESCE(p_payed_debt,0);
BEGIN
			IF( v_check < 0 ) THEN 
				v_mess := 'Trả quá số nợ cần trả, vui lòng nhập lại';
				v_id := 0;
			ELSE
				RAISE NOTICE 'viet%',v_check;
				INSERT INTO "Debt" ("UserId","TotalDebt","PayedDebt","Month","SalePointId","SalePointName","IsAdded","ActionDate","DebtDone")
				VALUES (p_user_id,COALESCE(p_total_debt,(SELECT SUM(D."TotalDebt") - p_payed_debt FROM "Debt" D WHERE D."UserId" = p_user_id AND D."IsAdded" = TRUE)),p_payed_debt + p_total_debt,p_month,p_salepoint_id,(SELECT S."SalePointName" FROM "SalePoint" S WHERE S."SalePointId" = p_salepoint_id),p_flag,NOW(), p_payed_debt );
				v_mess := 'Thêm nợ thành công';
				v_id := 1;
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