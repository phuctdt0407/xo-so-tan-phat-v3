-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_commision_of_all_user_in_month('2022-06');
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_commision_of_all_user_in_month');
CREATE OR REPLACE FUNCTION crm_salepoint_get_commision_of_all_user_in_month
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"UserId" INT, 
	"FullName" VARCHAR,
	"UserTitleId" INT,
	"UserTitleName" VARCHAR,
	"SalePointId" INT,
	"TotalCommision" NUMERIC,
	"Date" DATE
)
AS $BODY$
DECLARE
	F RECORD;
	i INT;
	n INT;
	v_array INT[];
	v_commision NUMERIC;
BEGIN
	CREATE TEMP TABLE tmpTable (
		"Id" SERIAL,
		"SalePointId" INT,
		"UserId" INT,
		"Date" DATE,
		"TotalCommision" NUMERIC
	)
	ON COMMIT DROP;
	
	FOR F IN (
		SELECT *
		FROM "Commission" C 
		WHERE TO_CHAR(C."Date", 'YYYY-MM') = p_month 
			AND C."IsDeleted" IS FALSE
	) LOOP
		INSERT INTO tmpTable(
				"SalePointId",
				"UserId",
				"Date",
				"TotalCommision"
		)
		VALUES(
				F."SalePointId",
				F."UserId",
				F."Date",
				ROUND(F."TotalValue" / 3, 0)
		);
		
		INSERT INTO tmpTable(
				"SalePointId",
				"UserId",
				"Date",
				"TotalCommision"
		)
		VALUES(
				F."SalePointId",
				0,
				F."Date",
				ROUND(F."TotalValue" / 3, 0)
		);
			
			
		v_array := translate(F."ListStaff"::TEXT, '[]','{}')::INT[];
		n := array_length(v_array, 1);
		v_commision := ROUND(F."TotalValue" / 3 / n, 0);
		
		FOR i IN 1..n LOOP
			
			INSERT INTO tmpTable(
				"SalePointId",
				"UserId",
				"Date",
				"TotalCommision"
			)
			VALUES(
				F."SalePointId",
				v_array[i],
				F."Date",
				v_commision
			);
			END LOOP;
				
	END LOOP;
		
	RETURN QUERY
	WITH tmp0 AS (
		SELECT 	
			T."SalePointId",
			T."MainUserId",
			T."PercentMainUserId"
		FROM crm_get_list_percent_salepoint_in_month(p_month) T
	),
	tmp AS (
		SELECT 
			U."UserId",
			U."FullName",
			UT."UserTitleId",
			UT."UserTitleName"
		FROM "User" U
			JOIN "UserRole" UR ON U."UserId" = UR."UserId"
			JOIN "UserTitle" UT ON UR."UserTitleId" = UT."UserTitleId"
		WHERE U."IsDeleted" IS FALSE
			AND U."IsActive" IS TRUE
			AND U."EndDate" IS NULL
			AND UT."UserTitleId" <> 1
		ORDER BY U."UserId"
	),
	tmp2 AS (
-- 		SELECT 
-- 			C."SalePointId",
-- 			C."UserId",
-- 			C."Date",
-- 			SUM(C."TotalValue") AS "TotalCommision"			
-- 		FROM "Commission" C
-- 		WHERE TO_CHAR(C."Date", 'YYYY-MM') = p_month
-- 			AND C."IsDeleted" IS FALSE
-- 		GROUP BY 
-- 			C."SalePointId",
-- 			C."UserId",
-- 			C."Date"
-- 		ORDER BY C."UserId", C."Date"
		SELECT * FROM tmpTable
	),
	tmp3 AS (
		SELECT
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."UserTitleName",
			C."SalePointId",
			C."TotalCommision",
			C."Date"
		FROM tmp U
			JOIN tmp2 C ON U."UserId" = C."UserId"
	),
	tmp4 AS (
		SELECT
			T."SalePointId",
			T."UserId",
			T."Date",
			T."TotalCommision",
			SPL."MainUserId",
			SPL."PercentMainUserId"
		FROM tmp2 T
			LEFT JOIN tmp0 SPL ON T."SalePointId" = SPL."SalePointId"
		WHERE T."UserId" = 0
	),
	tmp5 AS (
		SELECT 
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."UserTitleName",
			S."SalePointId",
			ROUND(S."TotalCommision" * 
				S."PercentMainUserId"[array_position(translate(S."MainUserId"::TEXT,'[]','{}')::TEXT[], U."UserId"::TEXT)], 0) AS "TotalCommision",
			S."Date"
		FROM tmp U 
			JOIN tmp4 S ON array_position(translate(S."MainUserId"::TEXT,'[]','{}')::TEXT[], U."UserId"::TEXT) IS NOT NULL
		ORDER BY 
			U."UserId",
			S."Date",
			S."SalePointId"
	),
	tmp6 AS (
		SELECT 
			T."SalePointId",
			T."Date",
			SUM(T."TotalCommision") AS "TotalCommision"
		FROM tmp5 T
		GROUP BY
			T."SalePointId",
			T."Date"
	),
	tmp4_1 AS (
	SELECT
		T."SalePointId",
		T."Date",
		T."UserId",
		SUM(T."TotalCommision") AS "TotalCommision"
	FROM tmp4 T
	GROUP BY
		T."SalePointId",
		T."Date",
		T."UserId"
	),
	tmp7 AS (
		SELECT
			T."UserId",
			'System',
			0,
			'SystemTitle',
			T."SalePointId",
			(COALESCE(T."TotalCommision", 0) - COALESCE(C."TotalCommision", 0)) AS "TotalCommision",
			T."Date"
		FROM tmp4_1 T 
			LEFT JOIN tmp6 C ON T."SalePointId" = C."SalePointId" AND T."Date" = C."Date"
	),
	tmp8 AS (
		SELECT * FROM tmp3
		UNION ALL
		SELECT * FROM tmp5
		UNION ALL
		SELECT * FROM tmp7
	)
	SELECT *
	FROM tmp8 T
	ORDER BY 
		T."UserId",
		T."SalePointId",
		T."Date";
END;
$BODY$
LANGUAGE plpgsql VOLATILE