-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_sale_point_get_list_fee_outsite('2022-07-22', 1);
-- ================================
SELECT dropallfunction_byname('crm_sale_point_get_list_fee_outsite');
CREATE OR REPLACE FUNCTION crm_sale_point_get_list_fee_outsite
(
	p_date TIMESTAMP DEFAULT NOW(),
	p_salepoint_id INT DEFAULT 0, 
	p_shift_dis_id INT DEFAULT 0
)
RETURNS TABLE
(
	"TransactionId" INT,
	"Note" VARCHAR,
	"Quantity" INT,
	"Price" NUMERIC,
	"TotalPrice" NUMERIC,
	"UserId" INT,
	"ShiftDistributeId" INT,
	"ShiftId" INT,
	"SalePointId" INT,
	"ActionDate" TIMESTAMP,
	"TypeNameId" INT,
	"Name" VARCHAR
)
AS $BODY$
BEGIN
	IF p_shift_dis_id > 0 THEN
		RETURN QUERY
		SELECT 
			T."TransactionId",
			T."Note",
			T."Quantity",
			T."Price",
			T."TotalPrice",
			T."UserId",
			T."ShiftDistributeId",
			SD."ShiftId",
			T."SalePointId",
			T."ActionDate",
			TN."TypeNameId",
			TN."Name"
		FROM "Transaction" T
			JOIN "ShiftDistribute" SD ON T."ShiftDistributeId" = SD."ShiftDistributeId"
			JOIN "TypeName" TN ON T."TypeNameId" = TN."TypeNameId"
		WHERE T."TransactionTypeId" = 1
			AND (COALESCE(p_shift_dis_id, 0) = 0 OR T."ShiftDistributeId" = p_shift_dis_id)
			AND T."IsDeleted" IS FALSE
		ORDER BY 
			T."SalePointId", 
			T."ActionDate" DESC;
	ELSE
		RETURN QUERY
		SELECT
			T."TransactionId", 
			T."Note",
			T."Quantity",
			T."Price",
			T."TotalPrice",
			T."UserId",
			T."ShiftDistributeId",
			SD."ShiftId",
			T."SalePointId",
			T."ActionDate",
			TN."TypeNameId",
			TN."Name"
		FROM "Transaction" T
			JOIN "ShiftDistribute" SD ON T."ShiftDistributeId" = SD."ShiftDistributeId"
			JOIN "TypeName" TN ON T."TypeNameId" = TN."TypeNameId"
		WHERE T."TransactionTypeId" = 1
			AND (COALESCE(p_salepoint_id, 0) = 0 OR T."SalePointId" = p_salepoint_id)
			AND (T."Date"::DATE = p_date::DATE)
			AND T."IsDeleted" IS FALSE
		ORDER BY 
			T."SalePointId", 
			T."ActionDate";
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE