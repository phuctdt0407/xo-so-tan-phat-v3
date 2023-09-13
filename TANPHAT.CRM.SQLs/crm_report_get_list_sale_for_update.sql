-- ================================
-- Author: Tien
-- Description: Lấy thông tin bán hàng để chỉnh sửa
-- Created date: 03-06-2022
-- SELECT * FROM crm_report_get_list_sale_for_update(6,1,'2022-06-09');
-- ================================
SELECT dropallfunction_byname('crm_report_get_list_sale_for_update');
CREATE OR REPLACE FUNCTION crm_report_get_list_sale_for_update
(
	p_sale_point_id INT,
	p_shift_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"LotteryInfo" TEXT,
	"SalePointInfo" TEXT,
	"HistoryInfo" TEXT
)
AS $BODY$
DECLARE
	v_shift_dis_id INT := (
					SELECT 
						SD."ShiftDistributeId"
					FROM "ShiftDistribute" SD
					WHERE
						SD."ShiftId"=p_shift_id AND SD."SalePointId"= p_sale_point_id AND SD."DistributeDate"=p_date :: DATE) ::INT;
BEGIN
RETURN QUERY
	WITH tmp0 AS
	(
		SELECT array_to_json(ARRAY_AGG(R)) :: TEXT
		FROM
			(SELECT *FROM
				(
					(
						SELECT 
							LC."LotteryChannelTypeId",
							I."SalePointId",
							I."LotteryDate",
							LC."LotteryChannelId",
							LC."ShortName",
							I."TotalRemaining",
							I."TotalDupRemaining",
							FALSE AS "IsScratchcard"
						FROM "Inventory" I,  "LotteryChannel" LC
						WHERE 
							(I."LotteryDate" = p_date ::DATE OR I."LotteryDate" = (p_date ::DATE + INTERVAL '1 DAY') ::DATE)
							AND I."SalePointId" = p_sale_point_id
							AND I."LotteryChannelId" = LC."LotteryChannelId"
							AND (I."TotalRemaining" > 0 OR I."TotalDupRemaining" > 0)
					) 
					UNION
					(
						SELECT 
							LC."LotteryChannelTypeId",
							SC."SalePointId",
							'9999-01-01' AS "LotteryDate",
							LC."LotteryChannelId",
							LC."ShortName",
							SC."TotalRemaining" ,
							0 AS "TotalDupRemaining",
							TRUE AS "IsScratchcard"
						FROM "Scratchcard" SC
							JOIN "LotteryChannel" LC ON LC."LotteryChannelId"= SC."LotteryChannelId"
						WHERE SC."SalePointId"= p_sale_point_id
					
					)
				) A
				ORDER BY  A."LotteryDate", A."LotteryChannelTypeId"
			)R
	),
	tmp1 AS
	(
			SELECT ROW_TO_JSON(R) :: TEXT
			FROM
				(
					SELECT 
						SD."ShiftDistributeId",
						SD."UserId",
						SD."SalePointId",
						SD."ShiftId",
						COALESCE((SELECT TRUE FROM "ShiftTransfer" WHERE "ShiftDistributeId" = SD."ShiftDistributeId" LIMIT 1),FALSE) AS "IsEndOfShift"
					FROM "ShiftDistribute" SD
					WHERE
						SD."ShiftId"=p_shift_id 
						AND SD."SalePointId"= p_sale_point_id 
						AND SD."DistributeDate"=p_date :: DATE
				) R
	),
	tmp2 AS
	(
		SELECT array_to_json(ARRAY_AGG(R)) :: TEXT
		FROM
			(
				SELECT 
					SPL."ShiftDistributeId",
					SPL."SalePointLogId",
					SPL."LotteryDate",
					SPL."LotteryChannelId",
					SPL."LotteryTypeId",
					LT."LotteryTypeName",
					LC."ShortName",
					SPL."Quantity",
					SPL."TotalValue",
					SPL."ActionDate"
				FROM	"SalePointLog" SPL
					JOIN "LotteryChannel" LC ON SPL."LotteryChannelId" = LC."LotteryChannelId"
					JOIN "LotteryType" LT ON LT."LotteryTypeId"= SPL."LotteryTypeId"
				WHERE SPL."ShiftDistributeId" = v_shift_dis_id 
				  AND SPL."IsDeleted" IS FALSE 
				ORDER BY SPL."LotteryDate"
			)R
	)
	SELECT 
		*
	FROM tmp0, tmp1, tmp2;
		

END;
$BODY$
LANGUAGE plpgsql VOLATILE