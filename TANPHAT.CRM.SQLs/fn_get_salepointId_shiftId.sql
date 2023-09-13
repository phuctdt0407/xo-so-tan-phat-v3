-- ================================
-- Author: Hiếu
-- Description:
-- Created date:
-- SELECT * FROM fn_get_salepointId_shiftId(1074,'2023-02-10');
-- ================================
SELECT dropallfunction_byname('fn_get_salepointId_shiftId');
CREATE OR REPLACE FUNCTION fn_get_salepointId_shiftId
(
		p_shift_distribute INT4,
		p_date TIMESTAMP
)
RETURNS TABLE
(
		"SalePointId" INT4,
		"ShiftId" INT4
)
AS $BODY$
DECLARE

BEGIN

	RETURN QUERY
	SELECT 
		ST."SalePointid",
		ST."ShiftId"
	FROM "ShiftTransfer" ST 
	WHERE ST."ActionDate"::DATE = p_date::DATE AND ST."ShiftDistributeId" = p_shift_distribute
	LIMIT 1;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
