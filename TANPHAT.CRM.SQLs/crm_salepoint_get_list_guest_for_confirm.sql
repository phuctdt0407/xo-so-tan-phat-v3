-- ================================
-- Author: Quang
-- Description: Get List Confirm Payment
-- Created date: 06/07/2022
-- SELECT * FROM crm_salepoint_get_list_guest_for_confirm(1);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_guest_for_confirm');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_guest_for_confirm
(
	p_sale_point_id INT DEFAULT NULL
)
RETURNS TABLE
(
	"ActionDate" TIMESTAMP,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"ConfirmStatusId" INT,
	"ConfirmStatusName" VARCHAR,	
	"DataConfirm" TEXT,
	"SalePointId" INT,
	"SalePointName" VARCHAR 
)
AS $BODY$ 
BEGIN
	
	RETURN QUERY 
	SELECT 
		CL."ActionDate",
		CL."ActionBy",
		CL."ActionByName",
		CL."ConfirmStatusId",
		CS."ConfirmStatusName",
		CL."Data" AS "DataConfirm",
		SP."SalePointId",
		SP."SalePointName"
	FROM "ConfirmLog" CL 
		JOIN "ConfirmStatus" CS ON CL."ConfirmStatusId" = CS."ConfirmStatusId"
		JOIN "SalePoint" SP ON SP."SalePointId" = (CL."DataActionInfo"::JSON ->> 'SalePointId')::INT
	WHERE CL."ConfirmFor" = 4
		AND (SP."SalePointId" = p_sale_point_id OR COALESCE(p_sale_point_id, 0) = 0)
	ORDER BY CL."ActionDate" DESC;

	
END;
$BODY$
LANGUAGE plpgsql VOLATILE