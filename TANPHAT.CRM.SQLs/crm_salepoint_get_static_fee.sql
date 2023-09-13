-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_static_fee();
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_static_fee');
CREATE OR REPLACE FUNCTION crm_salepoint_get_static_fee
(
)
RETURNS TABLE
(
	"StaticFeeTypeId" INT,
	"StaticFeeTypeName" VARCHAR,
	"StaticFeeTypeNameVIET" VARCHAR
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	SELECT
		SFT.*
	FROM "StaticFeeType" SFT;
END;
$BODY$
LANGUAGE plpgsql VOLATILE