-- ================================
-- Author: Phi
-- Description: Quản lý ca làm việc tất cả chi nhánh theo ngày
-- Created date: 04/03/2022
-- SELECT * FROM crm_sale_point_manage_v2('2023-04-17');
--SELECT * FROM "ShiftDistribute" WHERE "ShiftDistributeId" = 13949
-- ================================
SELECT dropallfunction_byname('crm_sale_point_manage_v2');
CREATE OR REPLACE FUNCTION crm_sale_point_manage_v2
(
	p_date TIMESTAMP
)
RETURNS TABLE
(
	"RowNumber" INT8,
	"SalePointId" INT,
	"SalePointName" VARCHAR,
	"ShiftId" INT,
	"UserId" INT,
	"FullName" VARCHAR,
	"ShiftDistributeId" INT,
	"ManagerId" INT,
	"ManagerName" VARCHAR
)
AS $BODY$
DECLARE
	v_total_leader INT;
	v_off_user INT; 
BEGIN
	with tmp AS(
	SELECT COUNT(U."UserId") AS "Leaders" FROM "User" U LEFT JOIN "UserRole" UR ON UR."UserId" = U."UserId" WHERE U."IsActive" = TRUE AND UR."UserTitleId" = 4 
	) SELECT T."Leaders" * (T."Leaders" + 1) INTO v_total_leader FROM tmp T;
	
	
	
		IF (NOT EXISTS (SELECT 1  FROM "LeaderOffLog" LOL WHERE LOL."WorkingDate" = p_date::DATE) ) THEN
		
	RETURN QUERY 
	WITH tmp AS(
	SELECT 
		ROW_NUMBER() OVER(ORDER BY SP."SalePointId") AS "RowNumber",
		SP."SalePointId",
		SP."SalePointName",
		S."ShiftId",
		COALESCE(SD."UserId", 0) AS "UserId",
		(CASE WHEN U."FullName" IS NOT NULL THEN U."FullName" ELSE '-' END),
		SD."ShiftDistributeId"
	FROM "SalePoint" SP
		JOIN "Shift" S ON TRUE
		LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = SP."SalePointId" AND SD."ShiftId" = S."ShiftId" AND SD."IsActive" IS TRUE AND SD."DistributeDate" = p_date::DATE
		LEFT JOIN "User" U ON U."UserId" = SD."UserId"
	WHERE SP."IsActive" IS TRUE AND SP."IsDeleted" IS FALSE)
		, temp1 AS
				( 
					SELECT * FROM "GroupSalePoint" GSP  ORDER BY GSP."GroupSalePointId" DESC LIMIT v_total_leader
				),tmp2 AS(
					SELECT GSP."UserId", U."FullName" ,T."ShiftDistributeId" FROM "temp1" GSP
						LEFT JOIN tmp T ON T."UserId" = (
					SELECT SD."UserId"
						FROM "ShiftDistribute" SD 
					WHERE SD."DistributeDate"::DATE =p_date::DATE AND SD."UserId" = T."UserId" AND SD."ShiftDistributeId" = T."ShiftDistributeId"
						GROUP BY SD."UserId",SD."ShiftDistributeId"
			)
						LEFT JOIN "UserRole" UR ON UR."UserId" = GSP."UserId"
						LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = T."SalePointId"
						LEFT JOIN "User" U ON U."UserId" = GSP."UserId"
					WHERE T."SalePointId" = ANY(GSP."SalePointIds") AND U."IsActive" = TRUE
					AND UR."UserTitleId" = 4  AND SD."DistributeDate"::DATE =  p_date::DATE
					AND GSP."Option" = 0
					GROUP BY GSP."UserId",
					U."FullName",
					GSP."GroupSalePointId",
					GSP."Option",
					T."ShiftDistributeId"
				ORDER BY GSP."Option" ASC ,GSP."GroupSalePointId" 
				),tmp3 AS(
				SELECT T."UserId",T."FullName",T."ShiftDistributeId" FROM tmp2 T GROUP BY T."UserId",T."ShiftDistributeId",T."FullName"
				)
	SELECT 
		T.*,
		T2."UserId",
		T2."FullName"
	FROM tmp T LEFT JOIN tmp3 T2 ON T2."ShiftDistributeId" = T."ShiftDistributeId";


ELSE

RETURN QUERY 
	WITH tmp AS(
	SELECT 
		ROW_NUMBER() OVER(ORDER BY SP."SalePointId") AS "RowNumber",
		SP."SalePointId",
		SP."SalePointName",
		S."ShiftId",
		COALESCE(SD."UserId", 0) AS "UserId",
		(CASE WHEN U."FullName" IS NOT NULL THEN U."FullName" ELSE '-' END),
		SD."ShiftDistributeId"
	FROM "SalePoint" SP
		JOIN "Shift" S ON TRUE
		LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = SP."SalePointId" AND SD."ShiftId" = S."ShiftId" AND SD."IsActive" IS TRUE AND SD."DistributeDate" = p_date::DATE
		LEFT JOIN "User" U ON U."UserId" = SD."UserId"
	WHERE SP."IsActive" IS TRUE AND SP."IsDeleted" IS FALSE)
		,tmp1_0 AS(
			SELECT  LOL."UserId"  FROM "LeaderOffLog" LOL WHERE LOL."WorkingDate" = p_date
		) ,temp1 AS
				( 
					SELECT * FROM "GroupSalePoint" GSP  ORDER BY GSP."GroupSalePointId" DESC LIMIT v_total_leader
				),tmp2 AS(
					SELECT GSP."UserId", U."FullName" ,T."ShiftDistributeId" FROM "temp1" GSP
						LEFT JOIN tmp T ON T."UserId" = (
					SELECT SD."UserId"
						FROM "ShiftDistribute" SD 
					WHERE SD."DistributeDate"::DATE =p_date::DATE AND SD."UserId" = T."UserId" AND SD."ShiftDistributeId" = T."ShiftDistributeId"
						GROUP BY SD."UserId",SD."ShiftDistributeId"
			)
						LEFT JOIN "UserRole" UR ON UR."UserId" = GSP."UserId"
						LEFT JOIN "ShiftDistribute" SD ON SD."SalePointId" = T."SalePointId"
						LEFT JOIN "User" U ON U."UserId" = GSP."UserId"
					WHERE T."SalePointId" = ANY(GSP."SalePointIds") AND U."IsActive" = TRUE
					AND UR."UserTitleId" = 4  AND SD."DistributeDate"::DATE =  p_date::DATE
					AND GSP."Option" = (SELECT LA."TriggerSalePoint" FROM "LeaderAttendent" LA WHERE LA."UserId" = (SELECT  LOL."UserId"  FROM "LeaderOffLog" LOL WHERE LOL."WorkingDate" = p_date))
					GROUP BY GSP."UserId",
					U."FullName",
					GSP."GroupSalePointId",
					GSP."Option",
					T."ShiftDistributeId"
				ORDER BY GSP."Option" ASC ,GSP."GroupSalePointId" 
				),tmp3 AS(
				SELECT T."UserId",T."FullName",T."ShiftDistributeId" FROM tmp2 T GROUP BY T."UserId",T."ShiftDistributeId",T."FullName"
				)
	SELECT 
		T.*,
		T2."UserId",
		T2."FullName"
	FROM tmp T LEFT JOIN tmp3 T2 ON T2."ShiftDistributeId" = T."ShiftDistributeId";

END IF; 
END;
$BODY$
LANGUAGE plpgsql VOLATILE