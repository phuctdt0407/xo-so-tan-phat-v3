-- Author: hoc
-- SELECT * FROM crm_report_update_return_money(1, 2000000)
SELECT * FROM dropallfunction_byname('crm_report_update_return_money');
CREATE OR REPLACE FUNCTION crm_report_update_return_money(
	p_return_money_id INT,
	p_return_money INT8
)
RETURNS TABLE(
	"Id" INT,
	"Message" VARCHAR
) AS $BODY$
DECLARE
	v_id INT;
	v_mess VARCHAR;
BEGIN

	UPDATE "ReportMoney"
	SET
		"TotalMoneyInDay" = p_return_money 
	WHERE "ReturnMoneyId" = p_return_money_id
	RETURNING "ReturnMoneyId" INTO v_id;
		
	v_mess := 'Update successful';
	
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
LANGUAGE plpgsql;