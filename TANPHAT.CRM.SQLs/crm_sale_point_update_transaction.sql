-- ================================
-- Author: Hieu
-- Description: 
-- Created date: 18/01/2023
-- SELECT * FROM crm_sale_point_update_transaction(381,17,'Hoc',1,4000,4000,'2023-03-15')
-- ================================
SELECT dropallfunction_byname('crm_sale_point_update_transaction');
CREATE OR REPLACE FUNCTION crm_sale_point_update_transaction
(   
		p_transaction_id INT,
		p_action_by INT,
		p_action_by_name VARCHAR,
		p_quantity INT,
		p_price INT,
		p_total_price INT,
		p_date TIMESTAMP
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
		UPDATE "Transaction" 
		SET 
			"Quantity" = p_quantity,
			"Price" = p_price,
			"TotalPrice" = p_total_price,
			"ModifyBy" = p_action_by,
			"ModifyByName" = p_action_by_name,
			"ModifyDate" = NOW(),
			"Date" = p_date::DATE
		WHERE "TransactionId" = p_transaction_id;
		v_id := 1;
    v_mess := 'Update thanh cong';
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
