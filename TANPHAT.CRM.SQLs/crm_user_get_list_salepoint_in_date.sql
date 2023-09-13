-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_list_salepoint_in_date(2);
-- ================================
SELECT dropallfunction_byname('crm_user_get_list_salepoint_in_date');
CREATE OR REPLACE FUNCTION crm_user_get_list_salepoint_in_date
(
	p_user_id INT,
	p_date TIMESTAMP DEFAULT NOW()
)
RETURNS TABLE
(
	"ShiftDistributeId" INT ,
	"ShiftId" INT,
	"SalePointId" INT,
	"SalePointName" VARCHAR
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT
		SD."ShiftDistributeId",
		SD."ShiftId",
		SD."SalePointId",
		SP."SalePointName"
	FROM "ShiftDistribute" SD 
		JOIN "SalePoint" SP ON SD."SalePointId" = SP."SalePointId"
	WHERE SD."UserId" = p_user_id
		AND SD."DistributeDate" = p_date::DATE
	ORDER BY SD."ShiftId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE