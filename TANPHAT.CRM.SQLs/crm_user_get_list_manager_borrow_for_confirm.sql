-- ================================
-- Author: Quang
-- Description: Get List Confirm Payment
-- Created date: 06/07/2022
-- SELECT * FROM crm_user_get_list_manager_borrow_for_confirm(10);
-- ================================
SELECT dropallfunction_byname('crm_user_get_list_manager_borrow_for_confirm');
CREATE OR REPLACE FUNCTION crm_user_get_list_manager_borrow_for_confirm
(

	p_user_id INT DEFAULT 0,
	p_date TIMESTAMP DEFAULT NOW(),
	p_page_size INT DEFAULT 100,
	p_page_number INT DEFAULT 1
)
RETURNS TABLE
(
	"ConfirmLogId" INT,
	"ActionDate" TIMESTAMP,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"ConfirmStatusId" INT,
	"ConfirmStatusName" VARCHAR,	
	"DataConfirm" TEXT,
	"Note" VARCHAR,
	"UserId" INT,
	"FullName" VARCHAR 
)
AS $BODY$ 
DECLARE
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN
	RETURN QUERY 
	SELECT 
		CL."ConfirmLogId",
		CL."ActionDate",
		CL."ActionBy",
		CL."ActionByName",
		CL."ConfirmStatusId",
		CS."ConfirmStatusName",
		(
			SELECT
				array_to_json(array_agg(T::JSONB ||('{"PaymentName": "'||(SELECT "PaymentName" FROM "FormPayment" WHERE "FormPaymentId" = (T->>'FormPaymentId')::INT)::TEXT||'"}')::JSONB))
			FROM json_array_elements(((CL."Data"::JSON)->>'DataForConfirm')::JSON) T
		)::TEXT AS "DataConfirm",
		(CL."Data"::JSON->>'Note')::VARCHAR AS "Note",
		CL."DataActionInfo"::INT AS "UserId",
		U."FullName"
	FROM "ConfirmLog" CL 
		JOIN "ConfirmStatus" CS ON CL."ConfirmStatusId" = CS."ConfirmStatusId"
		JOIN "User" U ON CL."DataActionInfo"::INT = U."UserId"
	WHERE CL."ConfirmFor" = 5
		AND (CL."DataActionInfo"::INT = p_user_id OR p_user_id = 0)
		AND CL."IsDeleted" IS FALSE
		AND CL."ActionDate"::DATE = p_date::DATE
	ORDER BY CL."ActionDate" DESC
	OFFSET v_offset_row LIMIT p_page_size;	
END;
$BODY$
LANGUAGE plpgsql VOLATILE


