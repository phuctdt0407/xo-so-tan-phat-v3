-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_get_list_payment_for_confirm(100 ,1, 0, NULL);
-- ================================
SELECT dropallfunction_byname('crm_get_list_payment_for_confirm');
CREATE OR REPLACE FUNCTION crm_get_list_payment_for_confirm
(
	p_page_size INT,
	p_page_number INT,
	p_salepoint_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"ArrayGuestActionId" TEXT,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"GuestId" INT,
	"FullName" VARCHAR,
	"CreatedDate" TIMESTAMP,
	"Note" VARCHAR,
	"TotalPrice" NUMERIC,
	"GuestActionTypeId" INT,
	"TypeName" VARCHAR,
	"GuestInfo" TEXT,
	"DoneTransfer" BOOL
)
AS $BODY$
DECLARE
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT
			JSON_AGG(GA."GuestActionId")::TEXT AS "ArrayGuestActionId",
			GA."SalePointId",
			SP."SalePointName",
			GA."GuestId",
			G."FullName",
			MAX(GA."CreatedDate") AS "CreatedDate",
			GA."Note",
			SUM(GA."TotalPrice") AS "TotalPrice",
			GA."GuestActionTypeId",
			GA."GuestInfo",
			GA."DoneTransfer"
		FROM "GuestAction" GA
			LEFT JOIN "Guest" G ON GA."GuestId" = G."GuestId"
			JOIN "SalePoint" SP ON GA."SalePointId" = SP."SalePointId"
		WHERE GA."FormPaymentId" = 2
			AND (GA."SalePointId" = p_salepoint_id OR COALESCE(p_salepoint_id, 0) = 0)
			AND (COALESCE(p_date, NULL) IS NULL OR GA."CreatedDate"::DATE = p_date::DATE)
			AND GA."IsDeleted" IS FALSE
		GROUP BY 
			GA."Note",
			GA."SalePointId",
			SP."SalePointName",
			GA."GuestId",
			G."FullName",
			GA."DoneTransfer",
			GA."GuestActionTypeId",
			GA."GuestInfo"
	)	
	SELECT
		T."ArrayGuestActionId",
		T."SalePointId",
		T."SalePointName",
		T."GuestId",
		T."FullName",
		T."CreatedDate",
		T."Note",
		T."TotalPrice",
		T."GuestActionTypeId",
		GA."TypeName",
		T."GuestInfo",
		T."DoneTransfer"
	FROM tmp T
		JOIN "GuestActionType" GA ON T."GuestActionTypeId" = GA."GuestActionTypeId"
	ORDER BY
		T."DoneTransfer",
		T."CreatedDate" DESC
	OFFSET v_offset_row LIMIT p_page_size;
END;
$BODY$
LANGUAGE plpgsql VOLATILE