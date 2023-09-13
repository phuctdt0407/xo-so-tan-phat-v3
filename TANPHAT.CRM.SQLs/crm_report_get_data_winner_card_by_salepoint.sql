-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_data_winner_card_by_salepoint(3, '2022-03');
-- ================================
SELECT dropallfunction_byname('crm_report_get_data_winner_card_by_salepoint');
CREATE OR REPLACE FUNCTION crm_report_get_data_winner_card_by_salepoint
(
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
BEGIN
		RETURN QUERY
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
			WHERE (COALESCE(p_salepoint_id, 0 ) = 0 OR p_salepoint_id = WW."SalePointId")
			GROUP BY
				WW."SalePointId",
				SPS."SalePointName";
			
END;
$BODY$
LANGUAGE plpgsql VOLATILE

