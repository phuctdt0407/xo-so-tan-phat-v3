-- ================================
-- Author: Phi
-- Description: Só lượng vé và đài của từng điểm bán  theo ngày
-- Created date: 07/03/2022
-- SELECT * FROM crm_activity_sell_get_data_v3(855,3,'2023-02-03');
-- ================================
SELECT dropallfunction_byname('crm_activity_sell_get_data_v3');
CREATE OR REPLACE FUNCTION crm_activity_sell_get_data_v3
(
	p_shift_distribute_id INT,
	p_user_role_id INT,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"ManagerId" INT,
	"ManagerName" VARCHAR,
	"UserId" INT,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftDistributeId" INT,
	"Flag" BOOL, 
	"TodayData" TEXT,
	"TomorrowData" TEXT,
	"ScratchcardData" TEXT,
	"SoldData" TEXT,
	"SalePointAddress" VARCHAR
)
AS $BODY$
DECLARE 
	v_sale_point_id INT;
	v_sale_point_name VARCHAR;
	v_shift_dis_id INT;
	v_is_super_admin BOOL;
	v_is_manager BOOL;
	v_is_staff BOOL;
	v_user_id INT;
	v_user_check INT;
	v_shift_id INT;
	v_shift_bef_dis_id INT;
	v_flag BOOL;
	v_sale_point_address VARCHAR;
	v_temp INT;
BEGIN

	SELECT UR."UserId" INTO v_user_check
	FROM "UserRole" UR 
	WHERE UR."UserRoleId" = p_user_role_id;

	SELECT SD."ShiftDistributeId", SD."ShiftId" , SD."SalePointId" INTO v_shift_dis_id, v_shift_id ,v_sale_point_id
	FROM "ShiftDistribute" SD
	WHERE SD."ShiftDistributeId" = p_shift_distribute_id
		AND SD."DistributeDate" = p_date;
	
	IF v_shift_id IS NULL THEN
		SELECT 
			SD."SalePointId", 
			SD."UserId", 
			FALSE
			INTO v_sale_point_id, v_user_id, v_flag
		FROM "ShiftDistribute" SD
		WHERE SD."ShiftDistributeId" = p_shift_distribute_id;
	
	ELSEIF v_shift_id = 1 THEN 
	
		SELECT 
			SD."SalePointId", 
			SD."UserId", 
			(CASE WHEN EXISTS (SELECT 1 FROM "ShiftTransfer" SF WHERE SF."ShiftDistributeId" = v_shift_dis_id) THEN FALSE ELSE TRUE END)
			INTO v_sale_point_id, v_user_id, v_flag
		FROM "ShiftDistribute" SD
		WHERE SD."ShiftDistributeId" = v_shift_dis_id;
		
	ELSE
	
		SELECT SD."ShiftDistributeId" INTO v_shift_bef_dis_id 
		FROM "ShiftDistribute" SD 
		WHERE SD."DistributeDate" = p_date
			AND SD."ShiftId" =  1
			AND SD."SalePointId" =  v_sale_point_id;
			
		IF(EXISTS (SELECT 1 FROM "ShiftTransfer" SF WHERE SF."ShiftDistributeId" = v_shift_bef_dis_id) OR v_shift_bef_dis_id IS NULL) THEN
		
			SELECT 
				SD."SalePointId", 
				SD."UserId" , 
				(CASE WHEN EXISTS (SELECT 1 FROM "ShiftTransfer" SF WHERE SF."ShiftDistributeId" = v_shift_dis_id) THEN FALSE ELSE TRUE END)
				INTO v_sale_point_id, v_user_id, v_flag
			FROM "ShiftDistribute" SD
			WHERE SD."ShiftDistributeId" = p_shift_distribute_id;
			
		END IF;

	END IF;
	
	SELECT SP."SalePointName", SP."FullAddress" INTO v_sale_point_name, v_sale_point_address FROM "SalePoint" SP WHERE SP."SalePointId" = v_sale_point_id;
	IF(v_user_id IS NOT NULL AND v_user_id = v_user_check) THEN
		
			IF (EXISTS (SELECT 1  FROM "LeaderOffLog" LOL WHERE LOL."WorkingDate" = p_date::DATE) ) THEN
			RETURN QUERY 
		SELECT 
		(
				with tmp AS(
				SELECT U."SalePointId",  U."UserId"
					FROM "User" U 
				LEFT JOIN "UserRole" UR ON UR."UserId" = U."UserId"
				WHERE U."UserId" = v_user_id
			)
			SELECT GSP."UserId" FROM "GroupSalePoint" GSP
				LEFT JOIN tmp T ON T."SalePointId" = ANY (GSP."SalePointIds")
				LEFT JOIN "UserRole" UR ON UR."UserId" = GSP."UserId"
				LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = T."SalePointId"
			WHERE UR."UserTitleId" = 4  AND SD."DistributeDate"::DATE = p_date::DATE
				AND GSP."UserId" <> ( SELECT LOL."UserId" FROM "LeaderOffLog" LOL WHERE LOL."WorkingDate" = p_date::DATE)
					GROUP BY GSP."UserId"
				ORDER BY GSP."UserId" DESC 
			LIMIT 1
		)
		 As "ManagerId",
			(
		with tmp AS(
			SELECT U."SalePointId",  U."UserId"
				FROM "User" U 
			LEFT JOIN "UserRole" UR ON UR."UserId" = U."UserId"
			WHERE U."UserId" = v_user_id
		)
		SELECT U."FullName" FROM "GroupSalePoint" GSP
			LEFT JOIN tmp T ON T."SalePointId" = ANY (GSP."SalePointIds")
			LEFT JOIN "UserRole" UR ON UR."UserId" = GSP."UserId"
			LEFT JOIN "User" U ON U."UserId" = UR."UserId"
			LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = T."SalePointId"
		WHERE UR."UserTitleId" = 4  AND SD."DistributeDate"::DATE = p_date ::DATE
			AND GSP."UserId" <> ( SELECT LOL."UserId" FROM "LeaderOffLog" LOL WHERE LOL."WorkingDate" =p_date::DATE)
				GROUP BY GSP."UserId", U."FullName"
				ORDER BY GSP."UserId" DESC 
			LIMIT 1
			) As "ManagerName",
			v_user_id,
			v_sale_point_id,
			v_sale_point_name,
			p_shift_distribute_id,
			v_flag,
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
					ORDER BY I."LotteryDate", IC."LotteryChannelTypeId"
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
					ORDER BY I."LotteryDate", IC."LotteryChannelTypeId"
				) r
			)::TEXT AS "TomorrowData",
			(
				SELECT array_to_json(
					ARRAY_AGG (r))
				FROM
				(
					SELECT
						ROW_NUMBER() OVER() AS "RowNumber",
						S."TotalRemaining",
						S."LotteryChannelId",
						LC."ShortName"
					FROM "Scratchcard" S
						JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = S."LotteryChannelId"
					WHERE S."SalePointId" = v_sale_point_id
					ORDER BY LC."LotteryChannelTypeId"
				) r
			)::TEXT AS "ScratchcardData",
			(
				SELECT array_to_json(
					ARRAY_AGG (r))
				FROM
				(
					SELECT
						SUM(SL."Quantity") FILTER(WHERE SL."LotteryPriceId" NOT IN(1,6)) AS "TotalWholesaleQuantity",
						SUM(SL."TotalValue") FILTER(WHERE SL."LotteryPriceId" NOT IN(1,6)) AS "TotalWholesalePrice",
						SUM(SL."Quantity") FILTER(WHERE SL."LotteryPriceId" IN(1,6)) AS "TotalRetailQuantity",
						SUM(SL."TotalValue") FILTER(WHERE SL."LotteryPriceId" IN(1,6)) AS "TotalRetailPrice"
					FROM "SalePointLog" SL
					WHERE SL."ShiftDistributeId" = v_shift_dis_id AND SL."IsDeleted" IS FALSE
				) r
			)::TEXT AS "SoldData",
			v_sale_point_address;
		ELSE
		RETURN QUERY 
			SELECT 
		(
			with tmp AS(
				SELECT U."SalePointId",  U."UserId"
					FROM "User" U 
				LEFT JOIN "UserRole" UR ON UR."UserId" = U."UserId"
				WHERE U."UserId" = v_user_id
			)
		SELECT GSP."UserId" FROM "GroupSalePoint" GSP
			LEFT JOIN tmp T ON T."SalePointId" = ANY (GSP."SalePointIds")
			LEFT JOIN "UserRole" UR ON UR."UserId" = GSP."UserId"
			LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = T."SalePointId"
		WHERE UR."UserTitleId" = 4  AND SD."DistributeDate"::DATE = p_date::DATE
				GROUP BY GSP."UserId",
				GSP."Option"
			ORDER BY GSP."Option" ASC
		LIMIT 1
		)
		 As "ManagerId",
			(
			with tmp AS(
					SELECT U."SalePointId",  U."UserId"
						FROM "User" U 
					LEFT JOIN "UserRole" UR ON UR."UserId" = U."UserId"
					WHERE U."UserId" = v_user_id
				)
			SELECT U."FullName" FROM "GroupSalePoint" GSP
				LEFT JOIN tmp T ON T."SalePointId" = ANY (GSP."SalePointIds")
				LEFT JOIN "UserRole" UR ON UR."UserId" = GSP."UserId"
				LEFT JOIN "User" U ON U."UserId" = UR."UserId"
				LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = T."SalePointId"
			WHERE UR."UserTitleId" = 4  AND SD."DistributeDate"::DATE = p_date ::DATE
				GROUP BY 
					GSP."UserId",
					GSP."Option",
					U."FullName"
			ORDER BY GSP."Option" ASC
		LIMIT 1
			) As "ManagerName",
			v_user_id,
			v_sale_point_id,
			v_sale_point_name,
			p_shift_distribute_id,
			v_flag,
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
					ORDER BY I."LotteryDate", IC."LotteryChannelTypeId"
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
					ORDER BY I."LotteryDate", IC."LotteryChannelTypeId"
				) r
			)::TEXT AS "TomorrowData",
			(
				SELECT array_to_json(
					ARRAY_AGG (r))
				FROM
				(
					SELECT
						ROW_NUMBER() OVER() AS "RowNumber",
						S."TotalRemaining",
						S."LotteryChannelId",
						LC."ShortName"
					FROM "Scratchcard" S
						JOIN "LotteryChannel" LC ON LC."LotteryChannelId" = S."LotteryChannelId"
					WHERE S."SalePointId" = v_sale_point_id
					ORDER BY LC."LotteryChannelTypeId"
				) r
			)::TEXT AS "ScratchcardData",
			(
				SELECT array_to_json(
					ARRAY_AGG (r))
				FROM
				(
					SELECT
						SUM(SL."Quantity") FILTER(WHERE SL."LotteryPriceId" NOT IN(1,6)) AS "TotalWholesaleQuantity",
						SUM(SL."TotalValue") FILTER(WHERE SL."LotteryPriceId" NOT IN(1,6)) AS "TotalWholesalePrice",
						SUM(SL."Quantity") FILTER(WHERE SL."LotteryPriceId" IN(1,6)) AS "TotalRetailQuantity",
						SUM(SL."TotalValue") FILTER(WHERE SL."LotteryPriceId" IN(1,6)) AS "TotalRetailPrice"
					FROM "SalePointLog" SL
					WHERE SL."ShiftDistributeId" = v_shift_dis_id AND SL."IsDeleted" IS FALSE
				) r
			)::TEXT AS "SoldData",
			v_sale_point_address;
				
			END IF;
			RAISE NOTICE 'value of a : %', v_temp; 
		END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE