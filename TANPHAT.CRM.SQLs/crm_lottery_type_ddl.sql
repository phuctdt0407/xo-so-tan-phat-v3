-- ================================
-- Author: Phi
-- Description: Lấy ĐĐL loại vé số để tính tiền
-- Created date: 11/03/2022
-- SELECT * FROM crm_lottery_type_ddl();
-- ================================
SELECT dropallfunction_byname('crm_lottery_type_ddl');
CREATE OR REPLACE FUNCTION crm_lottery_type_ddl()
RETURNS TABLE
(
	"Id" INT,
	"Name" VARCHAR
)
AS $BODY$
BEGIN
	
	RETURN QUERY 
	SELECT 
		L."LotteryTypeId",
		L."LotteryTypeName"
	FROM "LotteryType" L
	ORDER BY L."LotteryTypeId";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE