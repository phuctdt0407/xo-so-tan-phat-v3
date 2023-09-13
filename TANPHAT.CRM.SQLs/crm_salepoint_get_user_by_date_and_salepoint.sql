-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_user_by_date_and_salepoint(1, '2023-04-04');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_user_by_date_and_salepoint');
CREATE OR REPLACE FUNCTION crm_salepoint_get_user_by_date_and_salepoint
(
	p_sale_point_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"ShiftDistributeId" INT,
	"UserId" INT,
	"FullName" VARCHAR,
	"ShiftId" INT
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
		SD."ShiftDistributeId",
		SD."UserId",
		U."FullName",
		SD."ShiftId"
	FROM "ShiftDistribute" SD
		JOIN "User" U ON SD."UserId" = U."UserId"
	WHERE SD."SalePointId" = p_sale_point_id 
		AND SD."DistributeDate" = p_date :: DATE
		AND SD."IsActive" IS TRUE
	ORDER BY SD."ShiftId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE