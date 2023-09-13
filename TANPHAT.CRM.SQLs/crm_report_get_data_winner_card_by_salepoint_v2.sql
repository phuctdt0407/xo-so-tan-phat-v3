-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_data_winner_card_by_salepoint_v2(5, 1, '2022-04');
-- ================================
SELECT dropallfunction_byname('crm_report_get_data_winner_card_by_salepoint_v2');
CREATE OR REPLACE FUNCTION crm_report_get_data_winner_card_by_salepoint_v2
(
	p_user_role INT,
	p_salepoint_id INT,
	p_month VARCHAR
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"DataWin" TEXT
)
AS $BODY$
DECLARE
	v_is_leader INT;
	v_user_id INT;
BEGIN
	SELECT UR."UserTitleId", UR."UserId" INTO v_is_leader, v_user_id
	FROM "UserRole" UR 
		JOIN "UserTitle" UT ON UR."UserTitleId" = UT."UserTitleId"
	WHERE UR."UserRoleId" = p_user_role;
	IF v_is_leader = 4 THEN	
		RETURN QUERY
		WITH LIST AS (SELECT * FROM crm_get_list_salepoint_of_leader(v_user_id))
		SELECT 
			WW."SalePointId",
			SPS."SalePointName",
			(
				SELECT array_to_json(ARRAY_AGG (r))
				FROM
				(
					SELECT 
						ROW_NUMBER() OVER(ORDER BY W."WinningId") AS "RowNumber",
						W."WinningTypeId",
						WT."WinningTypeName",
						W."LotteryNumber",
						W."LotteryChannelId",
						LC."LotteryChannelName",
						LC."LotteryChannelTypeId",
						LCT."LotteryChannelTypeName",
						W."Quantity",
						W."WinningPrice",
						W."ActionBy",
						W."ActionByName",
						W."ActionDate",
						W."FromSalePointId",
						SP."SalePointName"
					FROM "Winning" W LEFT JOIN "SalePoint" SP ON W."FromSalePointId" = SP."SalePointId", 
						"WinningType" WT, 
						"LotteryChannel" LC, 
						"LotteryChannelType" LCT
					WHERE W."WinningTypeId" = WT."WinningTypeId"
							AND W."SalePointId" = WW."SalePointId"
							AND W."LotteryChannelId" = LC."LotteryChannelId"
							AND LC."LotteryChannelTypeId" = LCT."LotteryChannelTypeId"
							AND TO_CHAR(W."ActionDate", 'YYYY-MM') = p_month
				) r
			)	:: TEXT AS "DataWin"
			FROM "Winning" WW
				JOIN "SalePoint" SPS ON SPS."SalePointId" = WW."SalePointId"
				JOIN LIST L ON L."SalePointId" = SPS."SalePointId"
			WHERE (COALESCE(p_salepoint_id, 0 ) = 0 OR p_salepoint_id = WW."SalePointId")
			GROUP BY
				WW."SalePointId",
				SPS."SalePointName";
	END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

