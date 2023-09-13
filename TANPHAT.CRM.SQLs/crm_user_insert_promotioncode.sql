-- ================================
-- Author: Hieu
-- Description: 
-- Created date:
-- SELECT * FROM crm_user_insert_promotioncode('2023-03-30', 999999)
-- ================================
SELECT dropallfunction_byname('crm_user_insert_promotioncode');
CREATE OR REPLACE FUNCTION crm_user_insert_promotioncode
(   
		p_date TIMESTAMP,
		p_total_number INT8
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
BEGIN   
	WITH tmp AS
	(
		SELECT 
			A::INT AS "Number",
			p_date::DATE AS "Date"
		FROM generate_series(1, p_total_number) A
	)
	INSERT INTO "PromotionCode" ("PromotionCode", "Date")
	SELECT 
		CONCAT( SUBSTRING('000000',1,(6 - LENGTH(T."Number"::VARCHAR(255)))), T."Number"::VARCHAR(255)), 
		T."Date"
	FROM tmp T
	ORDER BY RANDOM();

    v_id := 1;
    v_mess := 'Update successful';
   RETURN QUERY   
SELECT
    v_id,
    v_mess;

   EXCEPTION WHEN OTHERS THEN    
			BEGIN        
				v_id := -1;        
				v_mess := sqlerrm;        
	 RETURN QUERY        
			SELECT 
				v_id, 
				v_mess;    
	 END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
