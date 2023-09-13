-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_transaction('2022-07', 0 , 1);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_transaction');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_transaction
(
	p_month VARCHAR,
	p_user_id INT DEFAULT 0,
	p_type INT DEFAULT 0			--1: Lấy của nhân viên, 0: lấy hết
)
RETURNS TABLE
(
	"TransactionId" INT,
	"TransactionTypeId" INT,
	"TransactionTypeName" VARCHAR,
	"Note" VARCHAR,
	"IsSum" BOOL,
	"Quantity" INT,
	"Price" NUMERIC,
	"TotalPrice" NUMERIC,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftDistributeId" INT,
	"TypeName" VARCHAR,
	"UserId" INT,
	"Date" DATE,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"ActionDate" TIMESTAMP
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
		T."TransactionId",
		T."TransactionTypeId",
		TT."TransactionTypeName",
		T."Note",
		TT."IsSum",
		T."Quantity",
		T."Price",
		T."TotalPrice",
		T."SalePointId",
		SP."SalePointName",
		T."ShiftDistributeId",
		TN."Name" AS "TypeName",
		T."UserId",
		T."Date",
		T."ActionBy",
		T."ActionByName",
		T."ActionDate"
	FROM "Transaction" T
		JOIN "TransactionType" TT ON T."TransactionTypeId" = TT."TransactionTypeId"
		LEFT JOIN "SalePoint" SP ON SP."SalePointId" = T."SalePointId"
		LEFT JOIN "TypeName" TN ON T."TypeNameId" = TN."TypeNameId"
	WHERE T."IsDeleted" IS FALSE
		AND (CASE WHEN p_type = 1 THEN T."TransactionTypeId" IN (4,5,6,7) ELSE TRUE END)
		AND TO_CHAR(T."Date", 'YYYY-MM') = p_month
		AND (COALESCE(p_user_id, 0) = 0 OR T."ActionBy" = p_user_id)
	ORDER BY T."TransactionTypeId", T."Date" DESC;
END;
$BODY$
LANGUAGE plpgsql VOLATILE