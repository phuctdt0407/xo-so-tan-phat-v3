-- ================================
-- Author: Phi
-- Description: Lấy danh sách transition chờ duyệt
-- Created date: 31/03/2022
-- SELECT * FROM crm_transition_get_list_to_confirm_v1(100,1,'2022-12-27',0,0,0);
-- ================================
SELECT dropallfunction_byname('crm_transition_get_list_to_confirm_v1');
CREATE OR REPLACE FUNCTION crm_transition_get_list_to_confirm_v1
(
	p_page_size INT, 
	p_page_number INT,
	p_date TIMESTAMP,
	p_sale_point_id INT,
	p_trans_type_id INT,
	p_user_role_id INT
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"TotalCount" INT8,
	"TransitionDate" TIMESTAMP,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"TransitionTypeId" INT,
	"TransitionTypeName" VARCHAR,
	"FromSalePointId" INT,
	"FromSalePointName" VARCHAR,
	"ToSalePointId" INT,
	"ToSalePointName" VARCHAR,
	"ConfirmDate" TIMESTAMP,
	"ConfirmBy" INT,
	"ConfirmByName" VARCHAR,
	"TransData" TEXT,
	"ManagerId" INT,
	"ManagerName" VARCHAR,
	"ConfirmStatusId" INT,
	"ConfirmStatusName" VARCHAR
)
AS $BODY$
DECLARE 
	v_offset_row INT8 := p_page_size * (p_page_number - 1);
	v_user_id INT;
BEGIN
SELECT "UserId" INTO v_user_id FROM fn_get_shift_info(p_user_role_id);
-- 	--Chọn ra người thế ca khi user nghỉ
-- 	IF EXISTS(SELECT 1 FROM "LeaderOffLog" LOL WHERE LOL."WorkingDate" = p_date AND LOL."UserId" = p_user_id) THEN
-- 		SELECT GSP."UserId" INTO v_user_id_temp FROM "GroupSalePoint" GSP
-- 		 WHERE (SELECT U."SalePointId" FROM "User" U WHERE U."UserId" = p_user_id) = ANY (GSP."SalePointIds")
-- 		 GROUP BY GSP."UserId", GSP."GroupSalePointId"
-- 		 ORDER BY GSP."GroupSalePointId" DESC LIMIT 1;
-- 	ELSE
-- 		SELECT p_user_id INTO v_user_id;
-- 		SELECT p_user_id INTO v_user_id_temp;
-- 	END IF;
-- 	IF EXISTS(SELECT 1 FROM "LeaderOffLog" LOL WHERE LOL."WorkingDate" = p_date AND LOL."UserId" <> p_user_i9d) THEN
-- 		SELECT GSP."UserId" INTO v_user_id_temp FROM "GroupSalePoint" GSP
-- 		 WHERE (SELECT U."SalePointId" FROM "User" U WHERE U."UserId" = p_user_id) = ANY (GSP."SalePointIds")
-- 		 GROUP BY GSP."UserId", GSP."GroupSalePointId"
-- 		 ORDER BY GSP."GroupSalePointId" DESC LIMIT 1;
-- 	ELSE
-- 		SELECT p_user_id INTO v_user_id;
-- 		SELECT p_user_id INTO v_user_id_temp;
-- 	END IF;
-- 	RAISE NOTICE 'viet: %',v_user_id;
-- 	RAISE NOTICE 'viet2: %',v_user_id_temp;
	RETURN QUERY 
	WITH tmp AS(
	SELECT 
		T."TransitionDate",
		T."ActionBy",
		T."ActionByName",
		T."TransitionTypeId",
		TT."TransitionTypeName",
		T."FromSalePointId",
		(CASE WHEN T."FromSalePointId" = 0 THEN 'Kho' ELSE SP."SalePointName" END) AS "FromSalePointName",
		T."ToSalePointId",
		(CASE WHEN T."ToSalePointId" = 0 THEN 'Kho' ELSE SP."SalePointName" END) AS "ToSalePointName",
		T."ConfirmDate",
		T."ConfirmBy",
		T."ConfirmByName",
		(
			SELECT array_to_json(
				ARRAY_AGG (r))
			FROM
			(
				SELECT
					TT."TransitionId",
					TT."LotteryDate",	
					TT."LotteryChannelId",
					TT."TotalTrans",
					TT."ConfirmTrans",
					TT."LotteryDate",
					TT."TotalTransDup",
					TT."ConfirmTransDup",
					TT."IsScratchcard"
				FROM "Transition" TT 
					JOIN "LotteryChannel" LC ON TT."LotteryChannelId" = LC."LotteryChannelId" 
				WHERE TT."TransitionDate" = T."TransitionDate" AND TT."ActionBy" = T."ActionBy"
				ORDER BY 
					TT."IsScratchcard",
					TT."LotteryDate",
					LC."LotteryChannelTypeId"
			) r
		)::TEXT AS "TransData",
		T."ManagerId",
		U."FullName" AS "ManagerName",
		T."ConfirmStatusId",
		CS."ConfirmStatusName"
	FROM "Transition" T
		JOIN "TransitionType" TT ON TT."TransitionTypeId" = T."TransitionTypeId"
		JOIN "SalePoint" SP ON (SP."SalePointId" = T."ToSalePointId" OR SP."SalePointId" = T."FromSalePointId")
		JOIN "ConfirmStatus" CS ON CS."ConfirmStatusId" = T."ConfirmStatusId"
		LEFT JOIN "User" U ON U."UserId" = T."ManagerId"
	WHERE T."TransitionDate"::DATE = p_date::DATE
		
		AND (COALESCE(p_trans_type_id, 0) = 0 OR T."TransitionTypeId" = p_trans_type_id)
		AND (COALESCE(p_sale_point_id, 0) = 0 
			OR (COALESCE(p_trans_type_id, 0) = 0 AND SP."SalePointId" = p_sale_point_id) 
			OR (COALESCE(p_trans_type_id, 0) = 1 AND T."FromSalePointId" = p_sale_point_id)
			OR (COALESCE(p_trans_type_id, 0) = 2 AND T."ToSalePointId" = p_sale_point_id))
		AND (COALESCE(v_user_id, 0) = 0  OR T."ManagerId" = v_user_id)
	GROUP BY
		T."TransitionDate",
		T."ActionBy",
		T."ActionByName",
		T."TransitionTypeId",
		TT."TransitionTypeName",
		T."FromSalePointId",
		T."ToSalePointId",
		T."ConfirmBy",
		T."ConfirmDate",
		T."ConfirmByName",
		SP."SalePointName",
		T."ManagerId",
		U."FullName",
		T."ConfirmStatusId",
		CS."ConfirmStatusName"
	)
	SELECT
		ROW_NUMBER() OVER (ORDER BY t."TransitionDate" DESC) AS "RowNumber",
		COUNT(1) OVER() AS "TotalCount",
		t.*
	FROM tmp t
	OFFSET v_offset_row LIMIT p_page_size;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE