-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_report_get_total_lottery_sell_of_some_salepoint_is_managed(5,NULL, '2022-04-07');
-- ================================
SELECT dropallfunction_byname('crm_report_get_total_lottery_sell_of_some_salepoint_is_managed');
CREATE OR REPLACE FUNCTION crm_report_get_total_lottery_sell_of_some_salepoint_is_managed
(
	p_user_role INT,
	p_month VARCHAR,
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"LotteryTypeId" INT,
	"LotteryTypeName" VARCHAR,
	"ActionDate" DATE,
	"TotalSold" INT8
)
AS $BODY$
DECLARE
	v_is_leader BOOL;
	v_user_id INT;
BEGIN

	SELECT UT."IsLeader", UR."UserId" INTO v_is_leader, v_user_id
	FROM "UserRole" UR 
		JOIN "UserTitle" UT ON UR."UserTitleId" = UT."UserTitleId"
	WHERE UR."UserRoleId" = p_user_role;
	
	IF v_is_leader IS TRUE THEN	
		IF p_month IS NOT NULL THEN
			RETURN QUERY
				WITH LIST AS (SELECT * FROM crm_get_list_salepoint_of_leader(v_user_id))
				SELECT 
					SPL."SalePointId",
					SP."SalePointName",
					SPL."LotteryTypeId",
					LT."LotteryTypeName",
					SPL."ActionDate" :: DATE,
					COALESCE(SUM(SPL."Quantity"),0) AS "TotalSold"
				FROM "SalePointLog" SPL 
					JOIN "SalePoint" SP ON SPL."SalePointId" = SP."SalePointId"
					JOIN "LotteryType" LT ON SPL."LotteryTypeId" = LT."LotteryTypeId"	
					JOIN LIST L ON SP."SalePointId" = L."SalePointId"
				WHERE TO_CHAR(SPL."ActionDate", 'YYYY-MM') = p_month AND SPL."IsDeleted" IS FALSE
				GROUP BY 
					SPL."SalePointId", 
					SP."SalePointName", 
					SPL."LotteryTypeId",
					LT."LotteryTypeName",
					SPL."ActionDate" :: DATE
				ORDER BY SPL."SalePointId",SPL."ActionDate"::DATE, SPL."LotteryTypeId";
			ELSE
				RETURN QUERY 
					WITH LIST AS (SELECT * FROM crm_get_list_salepoint_of_leader(v_user_id))
					SELECT 
						SPL."SalePointId",
						SP."SalePointName",
						SPL."LotteryTypeId",
						LT."LotteryTypeName",
						SPL."ActionDate" :: DATE,
						COALESCE(SUM(SPL."Quantity"),0) AS "TotalSold"
					FROM "SalePointLog" SPL 
						JOIN "SalePoint" SP ON SPL."SalePointId" = SP."SalePointId"
						JOIN "LotteryType" LT ON SPL."LotteryTypeId" = LT."LotteryTypeId"	
					WHERE (SPL."ActionDate" :: DATE) = (p_date :: DATE) AND SPL."IsDeleted" IS FALSE
					GROUP BY 
						SPL."SalePointId", 
						SP."SalePointName", 
						SPL."LotteryTypeId",
						LT."LotteryTypeName",
						SPL."ActionDate"::DATE
					ORDER BY SPL."SalePointId", SPL."ActionDate"::DATE, SPL."LotteryTypeId";
			END IF;
		END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

