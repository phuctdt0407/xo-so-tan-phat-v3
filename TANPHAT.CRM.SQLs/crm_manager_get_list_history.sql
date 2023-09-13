-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_manager_get_list_history('2022-08-16', 3, 2);
-- ================================
SELECT dropallfunction_byname('crm_manager_get_list_history');
CREATE OR REPLACE FUNCTION crm_manager_get_list_history
(
	p_date TIMESTAMP,
	p_sale_point INT,
	p_shift_id INT
)
RETURNS TABLE
(
	"HistoryOfOrderId" INT,
	"SalePointId" INT,
	"PrintTimes" INT,
	"ListPrint" TEXT,
	"Data" TEXT,
	"CreatedDate" TIMESTAMP
)
AS $BODY$
DECLARE 
	v_shift_distribute_id INT := (SELECT SD."ShiftDistributeId" FROM "ShiftDistribute" SD WHERE SD."SalePointId" = p_sale_point AND SD."ShiftId" = p_shift_id AND SD."DistributeDate" = p_date::DATE)::INT;
BEGIN
	RETURN QUERY
	SELECT * 
	FROM crm_salepoint_get_list_history_order(p_date, p_sale_point, v_shift_distribute_id);
END;
$BODY$
LANGUAGE plpgsql VOLATILE

