-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_fee_of_commission('2022-06');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_fee_of_commission');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_fee_of_commission
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"SalePointId" INT,
	"Date" DATE,
	"TotalValue" INT8,
	"Fee" NUMERIC,
	"ActionBy" INT,
	"ActionByName" VARCHAR
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
		C."SalePointId",
		C."Date",
		C."TotalValue",
		C."Fee",
		C."UserId",
		U."FullName"
	FROM "Commission" C
		JOIN "User" U ON C."UserId" = U."UserId"
	WHERE C."IsDeleted" IS FALSE
		AND TO_CHAR(C."Date", 'YYYY-MM') = p_month
		AND COALESCE(C."Fee", 0) > 0
	ORDER BY 
		C."SalePointId",
		C."Date",
		C."CreatedDate";
END;
$BODY$
LANGUAGE plpgsql VOLATILE