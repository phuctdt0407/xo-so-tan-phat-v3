--SELECT * FROM fn_totalreceived(1,'2023-02-21', 1002,1);

SELECT dropallfunction_byname('fn_totalreceived');
CREATE OR REPLACE FUNCTION fn_totalreceived
(
	p_salepoint_id INT,
	p_lottery_date TIMESTAMP,
	p_lottery_channel_id INT,
	p_shift_id INT
	
)
RETURNS INT AS $BODY$
DECLARE
	v_total_totalreceived INT;
	v_is_shift INT;
BEGIN 
		
	v_is_shift := COALESCE( (SELECT 1
									FROM "ShiftTransfer" ST 
									WHERE ST."SalePointid" = 1 AND ST."ActionDate"::DATE = p_lottery_date::DATE 
									LIMIT 1), 0);
	IF v_is_shift = 0 
	THEN
		v_total_totalreceived:= COALESCE( (SELECT SUM(SL."TotalReceived")
														FROM "ScratchcardLog" SL 
														WHERE SL."SalePointId" = p_salepoint_id
															AND SL."ActionDate"::DATE = p_lottery_date::DATE 
															AND SL."LotteryChannelId" = p_lottery_channel_id),0);
															
		
		IF p_shift_id = 2
		THEN
			v_total_totalreceived:=0;
		END IF;
	ELSE
		IF p_shift_id = 2
		THEN
			v_total_totalreceived:= COALESCE( (SELECT SUM(SL."TotalReceived")
														FROM "ScratchcardLog" SL 
														WHERE SL."SalePointId" = p_salepoint_id
															AND SL."LotteryChannelId" = p_lottery_channel_id
															AND SL."ActionDate"::TIMESTAMP >= (SELECT 
																															ST."ActionDate"
																														FROM "ShiftTransfer" ST
																														WHERE ST."SalePointid" = p_salepoint_id 
																														AND ST."ActionDate"::DATE = p_lottery_date::DATE
																														LIMIT 1)::TIMESTAMP
															AND SL."ActionDate"::DATE = p_lottery_date::DATE), 0);
			
		ELSE
			v_total_totalreceived:= COALESCE( (SELECT SUM(SL."TotalReceived")
												FROM "ScratchcardLog" SL 
												WHERE SL."SalePointId" = p_salepoint_id
													AND SL."LotteryChannelId" = p_lottery_channel_id
													AND SL."ActionDate"::TIMESTAMP <= (SELECT 
																													ST."ActionDate"
																												FROM "ShiftTransfer" ST
																												WHERE ST."SalePointid" = p_salepoint_id
																												AND ST."ActionDate"::DATE = p_lottery_date::DATE
																												LIMIT 1)::TIMESTAMP
													AND SL."ActionDate"::DATE = p_lottery_date::DATE), 0);
												
		END IF;
		
 END IF;
 
			RETURN v_total_totalreceived;
END; 
$BODY$
LANGUAGE plpgsql VOLATILE