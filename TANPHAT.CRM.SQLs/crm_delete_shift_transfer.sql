-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_delete_shift_transfer('2022-12-20',1,3)
-- ================================
SELECT dropallfunction_byname('crm_delete_shift_transfer');
CREATE OR REPLACE FUNCTION crm_delete_shift_transfer
(
	p_date DATE,
	p_shift_id INT,
	p_sale_point INT
)
RETURNS TABLE
(
	"Id" INT,
	"Message" TEXT
)
AS $BODY$
DECLARE
	v_id INT;
	v_mess TEXT;
	v_shift_dis INT;
	v_shift_dis_after INT;
BEGIN
	IF p_shift_id = 1 THEN 
		SELECT 
			"ShiftDistributeId" INTO v_shift_dis
		FROM "ShiftDistribute"
		WHERE "SalePointId" = p_sale_point
			AND "ShiftId" = p_shift_id
			AND "DistributeDate" :: DATE = p_date::DATE;
		
		SELECT 
			"ShiftDistributeId" INTO v_shift_dis_after
		FROM "ShiftDistribute"
		WHERE "SalePointId" = p_sale_point
			AND "ShiftId" = 2
			AND "DistributeDate" :: DATE = (p_date::DATE);
			
		IF NOT EXISTS(SELECT 1 FROM "ShiftTransfer" WHERE "ShiftDistributeId" = v_shift_dis_after) 
			AND NOT EXISTS(SELECT 1 FROM "ShiftTransfer" WHERE "ActionDate"::DATE >= ((p_date::DATE) + INTERVAL '1 day')::DATE)
		THEN 
			IF EXISTS(SELECT 1 FROM "ShiftTransfer" WHERE "ShiftDistributeId" = v_shift_dis) THEN
				DELETE FROM "ShiftTransfer" WHERE "SalePointid" = p_sale_point AND "ShiftDistributeId" = v_shift_dis;
				v_id := 0;
				v_mess := 'Xoá thành công';
			ELSE
				v_id := 0;
				v_mess := 'Không có ca làm này trong kết ca';
			END IF;
		ELSE
			v_id := 0;
			v_mess := 'Ca làm sau đã kết thúc nên không thể xoá lịch sử kết ca';
		END IF;
	ELSE 
		SELECT 
			"ShiftDistributeId" INTO v_shift_dis
		FROM "ShiftDistribute"
		WHERE "SalePointId" = p_sale_point
			AND "ShiftId" = p_shift_id
			AND "DistributeDate" :: DATE = p_date::DATE;
		
		IF NOT EXISTS(SELECT 1 FROM "ShiftTransfer" WHERE "ActionDate"::DATE >= ((p_date::DATE) + INTERVAL '1 day')::DATE) THEN
			IF EXISTS(SELECT 1 FROM "ShiftTransfer" WHERE "ShiftDistributeId" = v_shift_dis) THEN
				DELETE FROM "ShiftTransfer" WHERE "SalePointid" = p_sale_point AND "ShiftDistributeId" = v_shift_dis;
				v_id := 0;
				v_mess := 'Xoá thành công';
			ELSE
				v_id := 0;
				v_mess := 'Không có ca làm này trong kết ca';
			END IF;
		ELSE
			v_id := 0;
			v_mess := 'Ca làm sau đã kết thúc nên không thể xoá lịch sử kết ca';
		END IF;
		
	END IF;
	
	RETURN QUERY
	SELECT v_id, v_mess;
	
	EXCEPTION WHEN OTHERS THEN
	BEGIN
		v_id := -1;
		v_mess := sqlerrm;

	RETURN QUERY
	SELECT v_id, v_mess;
	END;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE

