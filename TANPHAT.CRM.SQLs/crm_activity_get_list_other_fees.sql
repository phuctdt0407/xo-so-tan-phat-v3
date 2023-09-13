-- ================================
-- Author: Viet
-- Description:
-- Created date: 14/12/2022
-- SELECT * FROM crm_activity_get_list_other_fees('2023-03-20',0);
-- ================================
SELECT dropallfunction_byname('crm_activity_get_list_other_fees');
CREATE OR REPLACE FUNCTION crm_activity_get_list_other_fees
(
	p_date TIMESTAMP,
	p_sale_point_id INT8
)
RETURNS TABLE
(
	"TransactionId" INT,
	"TransactionTypeId" INT,
	"Note" VARCHAR,
	"Quantity" INT,
	"Price" NUMERIC,
	"TotalPrice" NUMERIC,
	"UserId" INT,
	"ShiftDistributeId" INT,
	"ShiftId" INT,
	"SalePointName" VARCHAR,
	"ActionDate" TIMESTAMP,
	"TypeNameId" INT,
	"Name" VARCHAR,
	"ActionBy" INT,
	"ActionName" VARCHAR
)
AS $BODY$
BEGIN
RETURN QUERY
		SELECT 
			T."TransactionId",
			T."TransactionTypeId",
			T."Note",
			T."Quantity",
			T."Price",
			T."TotalPrice",
			T."UserId",
			T."ShiftDistributeId",
			SD."ShiftId",
			S."SalePointName",
			T."ActionDate",
			TN."TypeNameId",
			TN."Name",
			T."ActionBy",
			T."ActionByName"
		FROM "Transaction" T
			LEFT JOIN "SalePoint" S ON T."SalePointId" = S."SalePointId"
			left JOIN "ShiftDistribute" SD ON T."ShiftDistributeId" = SD."ShiftDistributeId"
			left JOIN "TypeName" TN ON T."TypeNameId" = TN."TypeNameId"
		WHERE 
		(T."SalePointId" = p_sale_point_id or p_sale_point_id = 0)
			AND T."Date"::DATE = p_date
			AND T."IsDeleted" IS FALSE
		
		AND	T."TransactionTypeId" = 1
		ORDER BY 
			T."ActionDate" DESC;

END;
$BODY$
LANGUAGE plpgsql VOLATILE