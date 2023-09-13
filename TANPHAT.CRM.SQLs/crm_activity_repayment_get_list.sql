-- ================================
-- Author: Phi
-- Description: Lấy danh sách khách trả nợ
-- Created date: 17/03/2022
-- SELECT * FROM crm_activity_repayment_get_list(1,1,'2022-03-01');
-- ================================
SELECT dropallfunction_byname('crm_activity_repayment_get_list');
CREATE OR REPLACE FUNCTION crm_activity_repayment_get_list
(
	p_shift_distribute_id INT,
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
BEGIN	
	
	IF COALESCE(p_sale_point_id, 0) = 0 THEN
	
		SELECT SD."SalePointId" INTO v_sale_point_id FROM "ShiftDistribute" SD WHERE SD."ShiftDistributeId" = p_shift_distribute_id;
	
	ELSE
	
		v_sale_point_id := p_sale_point_id;
		
	END IF;
	
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
	WHERE ((COALESCE(p_shift_distribute_id, 0) = 0 AND COALESCE(p_sale_point_id, 0) = 0) OR R."SalePointId" = v_sale_point_id)
		AND R."ActionDate"::DATE = p_date::DATE
	ORDER BY R."ActionDate" DESC;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE