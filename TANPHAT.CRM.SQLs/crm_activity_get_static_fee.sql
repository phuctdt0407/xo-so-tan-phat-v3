-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_activity_get_static_fee('2023-05-01');
-- ================================
SELECT dropallfunction_byname('crm_activity_get_static_fee');
CREATE OR REPLACE FUNCTION crm_activity_get_static_fee
(
	p_month TIMESTAMP
)
RETURNS TABLE
(
	"Month" varchar,
	"SalePointId" INT,
	"StaticFeeTypeId" INT8,
	"Value" INT8,
	"CreatedDate" TIMESTAMP,
	"CreatedBy" INT8,
	"CreatedByName" VARCHAR,
	"StaticFeeId" INT8
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	with tmp AS(
	SELECT
		ROW_NUMBER() OVER ( PARTITION BY ST."StaticFeeTypeId" ORDER BY ST."StaticFeeId" DESC) AS "Id",
		ST."Month" ,
		ST."SalePointId" ,
		ST."StaticFeeTypeId" ,
		ST."Value" ,
		ST."CreatedDate" ,
		ST."CreatedBy" ,
		ST."CreatedByName",
		ST."StaticFeeId" 
	FROM "StaticFee" ST
	WHERE ST."Month" = TO_CHAR(p_month ::DATE,'YYYY-MM'))
	SELECT 
		ST."Month" ,
		ST."SalePointId" ,
		ST."StaticFeeTypeId" ,
		ST."Value" ,
		ST."CreatedDate" ,
		ST."CreatedBy" ,
		ST."CreatedByName",
		ST."StaticFeeId" 
	FROM tmp ST WHERE ST."Id" = 1;
END;
$BODY$
LANGUAGE plpgsql VOLATILE