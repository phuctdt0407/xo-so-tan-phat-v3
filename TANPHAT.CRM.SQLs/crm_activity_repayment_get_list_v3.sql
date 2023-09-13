-- ================================
-- Author: Phi
-- Description: Lấy danh sách khách trả nợ
-- Created date: 17/03/2022
-- SELECT * FROM crm_activity_repayment_get_list_v3(7,2,'2022-03-31');
-- ================================
SELECT dropallfunction_byname('crm_activity_repayment_get_list_v3');
CREATE OR REPLACE FUNCTION crm_activity_repayment_get_list_v3
(
	p_user_role_id INT,
	p_sale_point_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"GuestActionId" INT,
	"GuestId" INT,
	"FullName" VARCHAR,
	"TotalPrice" NUMERIC,
	"Note" VARCHAR,
	"CreatedBy" INT,
	"CreatedByName" VARCHAR,
	"CreatedDate" TIMESTAMP,
	"SalePointId" INT,
	"PaymentName" VARCHAR
)
AS $BODY$
DECLARE
	v_sale_point_id INT;
	v_shift_dis_id INT;
	v_is_super_admin BOOL;
	v_is_manager BOOL;
	v_is_staff BOOL;
BEGIN	
	
	SELECT 
		f."IsSuperAdmin",
		f."IsManager",
		f."IsStaff",
		f."SalePointId",
		f."ShiftDistributeId"
	INTO v_is_super_admin, v_is_manager, v_is_staff, v_sale_point_id, v_shift_dis_id
	FROM fn_get_shift_info(p_user_role_id) f;
	
	IF v_is_super_admin IS TRUE OR v_is_manager IS TRUE THEN
	
		RETURN QUERY 
		SELECT 
			GA."GuestActionId",
			GA."GuestId",
			G."FullName",
			GA."TotalPrice",
			GA."Note",
			GA."CreatedBy",
			GA."CreatedByName",
			GA."CreatedDate",
			GA."SalePointId",
			FP."PaymentName"
		FROM "GuestAction" GA
		WHERE (COALESCE(p_sale_point_id, 0) = 0 OR GA."SalePointId" = p_sale_point_id)
			AND GA."CreatedDate"::DATE = p_date::DATE
			AND GA."IsDeleted" IS FALSE
			AND GA."GuestActionTypeId" = 2
		ORDER BY R."ActionDate" DESC;
		
	ELSE
	
		RETURN QUERY 
		SELECT 
			GA."GuestActionId",
			GA."GuestId",
			G."FullName",
			GA."TotalPrice",
			GA."Note",
			GA."CreatedBy",
			GA."CreatedByName",
			GA."CreatedDate",
			GA."SalePointId",
			FP."PaymentName"
		FROM "GuestAction" GA
			JOIN "Guest" G ON G."GuestId" = GA."GuestId"
			JOIN "FormPayment" FP ON GA."FormPaymentId" = FP."FormPaymentId"
		WHERE GA."ShiftDistributeId" = v_shift_dis_id
			AND GA."IsDeleted" IS FALSE
			AND GA."GuestActionTypeId" = 2
		ORDER BY GA."CreatedDate" DESC;
	
	END IF;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE