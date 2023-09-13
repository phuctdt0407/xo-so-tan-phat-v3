-- ================================
-- Author: Phi
-- Description: Cho trưởng nhóm xem tất cả só lượng còn lại của các chi nhánh
-- Created date: 17/03/2022
-- SELECT * FROM crm_report_get_remaining();
-- ================================
SELECT dropallfunction_byname('crm_report_get_remaining');
CREATE OR REPLACE FUNCTION crm_report_get_remaining
(
	p_page_size INT, 
	p_page_number INT,
	-- something
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"TotalCount" INT8,
	-- something
)
AS $BODY$
DECLARE 
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
BEGIN
	
	RETURN QUERY 
	SELECT 
		ROW_NUMBER() OVER (ORDER BY something) "RowNumber",
		COUNT(1) OVER() AS "TotalCount",
		-- something
	FROM 	
	WHERE 
	OFFSET v_offset_row LIMIT p_page_size;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE