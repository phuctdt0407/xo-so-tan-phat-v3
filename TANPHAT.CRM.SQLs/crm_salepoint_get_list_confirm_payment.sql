-- ================================
-- Author: Tien
-- Description: Get List Confirm Payment
-- Created date: 29/06/2022
-- SELECT * FROM crm_salepoint_get_list_confirm_payment(3,0, 10, 1);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_confirm_payment');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_confirm_payment
(
	p_sale_point_id INT DEFAULT NULL,
	p_guest_id INT DEFAULT NULL,
	p_page_size INT DEFAULT 100,
	p_page_number INT DEFAULT 1
)
RETURNS TABLE
(
	"ActionDate" TIMESTAMP,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"GuestId" INT,
	"GuestName" VARCHAR,
	"CanBuyWholeSale" BOOL,
	"DataConfirm" TEXT,
	"SalePointId" INT,
	"SalePointName" VARCHAR 
)
AS $BODY$ 
DECLARE
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN
	RETURN QUERY 
	SELECT 
		CL."ActionDate",
		CL."ActionBy",
		CL."ActionByName",
		CL."GuestId",
		G."FullName" AS "GuestName",
		(CASE WHEN G."WholesalePriceId" IS NOT NULL AND G."ScratchPriceId" IS NOT NULL THEN TRUE ELSE FALSE END) AS "CanBuyWholeSale",
		(SELECT json_agg(t) FROM (
				SELECT 
					CL1."ConfirmLogId",
					CL1."ConfirmFor",
					CT."ConfirmForTypeName",
					CS."ConfirmStatusId",
					CS."ConfirmStatusName",
					CL1."Data",
					CL1."DataActionInfo"
				FROM "ConfirmLog" CL1
				JOIN "ConfirmForType" CT ON CT."ConfirmForTypeId" = CL1."ConfirmFor"
				JOIN "ConfirmStatus" CS ON CS."ConfirmStatusId" = CL1."ConfirmStatusId"
				WHERE (CL1."ConfirmFor" = 2 OR CL1."ConfirmFor" = 3)
					AND CL1."ActionDate" = CL."ActionDate"
		) t ) ::TEXT AS "DataConfirm",
		SP."SalePointId",
		SP."SalePointName"
	FROM "ConfirmLog" CL 
		JOIN "Guest" G ON (G."GuestId"= CL."GuestId" AND (COALESCE(p_sale_point_id,0) = 0 OR G."SalePointId" = p_sale_point_id) AND (COALESCE(p_guest_id, 0)=0 OR G."GuestId" = p_guest_id))
		JOIN "SalePoint" SP ON SP."SalePointId"= G."SalePointId"
	WHERE CL."ConfirmFor" = 2 OR CL."ConfirmFor" = 3		
	GROUP BY 
		CL."ActionDate", 
		CL."ActionBy", 
		CL."ActionByName", 
		CL."GuestId",
		G."FullName", 
		SP."SalePointId",
		SP."SalePointName", 
		G."WholesalePriceId", 
		G."ScratchPriceId"
	ORDER BY  CL."ActionDate" DESC
	OFFSET v_offset_row LIMIT p_page_size;	
END;
$BODY$
LANGUAGE plpgsql VOLATILE