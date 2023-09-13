-- ================================
-- Author: Phi
-- Description: Lấy DDL loại trúng thưởng
-- Created date: 22/03/2022
-- SELECT * FROM crm_winning_type_ddl();
-- ================================
SELECT dropallfunction_byname('crm_winning_type_ddl');
CREATE OR REPLACE FUNCTION crm_winning_type_ddl()
RETURNS TABLE
(
	"Id" INT,
	"Name" VARCHAR,
	"WinningPrize" NUMERIC,
	"HasSalePoint" BOOL,
	"HasFourNumber" BOOL,
	"HasChannel" BOOL,
	"CanChangePrice" BOOL
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		W."WinningTypeId",
		W."WinningTypeName",
		W."WinningPrize",
		W."HasSalePoint",
		W."HasFourNumber",
		W."HasChannel",
		W."CanChangePrice"
	FROM "WinningType" W
	ORDER BY W."WinningTypeId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE