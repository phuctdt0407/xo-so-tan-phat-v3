-- ================================
-- Author: Phi
-- Description: Só lượng vé và đài của từng điểm bán  theo ngày
-- Created date: 07/03/2022
-- SELECT * FROM crm_activity_sell_get_data(5,'2022-03-11');
-- ================================
SELECT dropallfunction_byname('crm_activity_sell_get_data');
CREATE OR REPLACE FUNCTION crm_activity_sell_get_data
(
	p_user_role_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftDistributeId" INT,
	"TodayData" TEXT,
	"TomorrowData" TEXT,
	"ScratchcardData" TEXT
)
AS $BODY$
DECLARE 
	v_sale_point_id INT;
	v_sale_point_name VARCHAR;
	v_shift_dis_id INT;
	v_is_super_admin BOOL;
	v_is_manager BOOL;
	v_is_staff BOOL;
BEGIN
	
-- 	SELECT 
-- 		UR."UserId" INTO v_user_id
-- 	FROM "UserRole" UR WHERE UR."UserRoleId" = p_user_role_id;
-- 	
-- 	SELECT
-- 		SD."SalePointId",
-- 		SP."SalePointName",
-- 		SD."ShiftDistributeId"
-- 	INTO 
-- 		v_sale_point_id,
-- 		v_sale_point_name,
-- 		v_shift_dis_id
-- 	FROM "ShiftDistribute" SD 
-- 		JOIN "SalePoint" SP ON SP."SalePointId" = SD."SalePointId"
-- 	WHERE SD."UserId" = v_user_id AND SD."DistributeDate" = NOW()::DATE;
	
	SELECT 
		f."IsSuperAdmin",
		f."IsManager",
		f."IsStaff",
		f."SalePointId",
		f."ShiftDistributeId"
	INTO v_is_super_admin, v_is_manager, v_is_staff, v_sale_point_id, v_shift_dis_id
	FROM fn_get_shift_info(p_user_role_id) f;
	
	SELECT SP."SalePointName" INTO v_sale_point_name FROM "SalePoint" SP WHERE SP."SalePointId" = v_sale_point_id;

	RETURN QUERY 
	SELECT 
		v_sale_point_id,
		v_sale_point_name,
		v_shift_dis_id,
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY LCT."LotteryChannelTypeId") AS "RowNumber",
					I."LotteryDate",
					I."LotteryChannelId",
					IC."LotteryChannelName",
					I."TotalRemaining",
					I."TotalDupRemaining",
					IC."ShortName",
					LCT."ShortName" AS "ChannelTypeShortName"
				FROM "Inventory" I
					JOIN "LotteryChannel" IC ON IC."LotteryChannelId" = I."LotteryChannelId"
					LEFT JOIN "LotteryChannelType" LCT ON LCT."LotteryChannelTypeId" = IC."LotteryChannelTypeId"
				WHERE I."LotteryDate" = p_date::DATE AND I."SalePointId" = v_sale_point_id
			) r
		)::TEXT AS "TodayData",
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY LCT."LotteryChannelTypeId") AS "RowNumber",
					I."LotteryDate",
					I."LotteryChannelId",
					IC."LotteryChannelName",
					I."TotalRemaining",
					I."TotalDupRemaining",
					IC."ShortName",
					LCT."ShortName" AS "ChannelTypeShortName"
				FROM "Inventory" I
					JOIN "LotteryChannel" IC ON IC."LotteryChannelId" = I."LotteryChannelId"
					LEFT JOIN "LotteryChannelType" LCT ON LCT."LotteryChannelTypeId" = IC."LotteryChannelTypeId"
				WHERE I."LotteryDate" = (p_date + '1 day'::INTERVAL)::DATE AND I."SalePointId" = v_sale_point_id
			) r
		)::TEXT AS "TomorrowData",
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					ROW_NUMBER() OVER() AS "RowNumber",
					S."TotalRemaining"
				FROM "Scratchcard" S
				WHERE S."SalePointId" = v_sale_point_id
			) r
		)::TEXT AS "ScratchcardData";
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE