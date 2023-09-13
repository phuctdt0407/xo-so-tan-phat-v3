-- ================================
-- Author: Phi
-- Description: Lấy danh sách khách trả nợ
-- Created date: 17/03/2022
-- SELECT * FROM crm_activity_repayment_get_list_v2(5,1,'2022-03-31');
-- ================================
SELECT dropallfunction_byname('crm_activity_repayment_get_list_v2');
CREATE OR REPLACE FUNCTION crm_activity_repayment_get_list_v2
(
	p_user_role_id INT,
	p_sale_point_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"RepaymentId" INT,
	"CustomerName" VARCHAR,
	"Amount" NUMERIC,
	"Note" TEXT,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"ActionDate" TIMESTAMP,
	"SalePointId" INT
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
			R."RepaymentId",
			R."CustomerName",
			R."Amount",
			R."Note",
			R."ActionBy",
			R."ActionByName",
			R."ActionDate",
			R."SalePointId"
		FROM "Repayment" R
		WHERE (COALESCE(p_sale_point_id, 0) = 0 OR R."SalePointId" = p_sale_point_id)
			AND R."ActionDate"::DATE = p_date::DATE
		ORDER BY R."ActionDate" DESC;
		
	ELSE
	
		RETURN QUERY 
		SELECT 
			R."RepaymentId",
			R."CustomerName",
			R."Amount",
			R."Note",
			R."ActionBy",
			R."ActionByName",
			R."ActionDate",
			R."SalePointId"
		FROM "Repayment" R
		WHERE R."ShiftDistributeId" = v_shift_dis_id
			AND R."ActionDate"::DATE = p_date::DATE
		ORDER BY R."ActionDate" DESC;
	
	END IF;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE