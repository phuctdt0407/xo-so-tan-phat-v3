-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_base_get_type_name_ddl();
-- ================================
SELECT dropallfunction_byname('crm_base_get_type_name_ddl');
CREATE OR REPLACE FUNCTION crm_base_get_type_name_ddl
(
	p_transaction_type_id INT DEFAULT 0
)
RETURNS TABLE
(
	"TypeNameId" INT,
	"Name" VARCHAR,
	"TransactionTypeId" INT,
	"TransactionTypeName" VARCHAR,
	"Price" NUMERIC,
	"RequireSalePoint" BOOL
)
AS $BODY$
BEGIN
	RETURN QUERY
	WITH tmp AS(
		SELECT 
			C."Price",
			C."ConstId"
		FROM "Constant" C 
		WHERE C."ConstId" IN (7,8,9)
			AND C."CreatedDate" >= ALL (
				SELECT 
					A."CreatedDate"
				FROM "Constant" A
				WHERE A."ConstId" = C."ConstId"
			)
	)
	SELECT
		TN."TypeNameId",
		TN."Name",
		TN."TransactionTypeId",
		TT."TransactionTypeName",
		T."Price",
		TN."RequireSalePoint"
	FROM "TypeName" TN 
		JOIN "TransactionType" TT ON TN."TransactionTypeId" = TT."TransactionTypeId"
		LEFT JOIN tmp T ON T."ConstId" = TN."ConstId"
	WHERE TN."IsActive" IS TRUE
		AND (TN."TransactionTypeId" = p_transaction_type_id OR COALESCE(p_transaction_type_id, 0) = 0)
	ORDER BY TN."TransactionTypeId", TN."TypeNameId";
END;
$BODY$
LANGUAGE plpgsql VOLATILE