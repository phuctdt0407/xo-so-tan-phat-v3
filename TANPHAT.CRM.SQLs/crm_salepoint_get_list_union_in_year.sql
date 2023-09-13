-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_list_union_in_year(2022);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_list_union_in_year');
CREATE OR REPLACE FUNCTION crm_salepoint_get_list_union_in_year
(
	p_year INT
)
RETURNS TABLE
(
	"PriceUnionFirst" NUMERIC,
	"TotalUnionSend" NUMERIC,
	"TotalUse" NUMERIC,
	"TotalRemain" NUMERIC,
	"UserData" TEXT,
	"DataUse" TEXT
)
AS $BODY$
BEGIN
	RETURN QUERY
	--Lấy danh sách user
	WITH tmp0 AS (
		SELECT 
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."ListSalePoint",
			SP."SalePointName"
		FROM crm_get_user_ddl(0, (p_year||'-01-01')::TIMESTAMP) U
			LEFT JOIN "SalePoint" SP ON SP."SalePointId" = U."SalePointId" 
		WHERE U."UserTitleId" IN (6, 4, 5)
	),
	--Lấy danh sách tháng trong năm
	tmp AS (
		SELECT
			TO_CHAR((p_year||'-'||T."Data"||'-01')::DATE, 'YYYY-MM') AS "Month"
		FROM (
			SELECT
				*
			FROM generate_series(1, 12) "Data"
		) T
	),
	--Lấy danh sách tiền nộp trước năm 
	tmp1 AS (
		SELECT
			SUM(((SC."Data"::JSON)->>'PriceUnion')::NUMERIC) AS "PriceUnion"
		FROM "SalaryConfirm" SC
		WHERE SC."IsDeleted" IS FALSE
			AND SUBSTRING(SC."Month", 1, 4)::INT < p_year
	),
	--Lấy danh sách trích quỹ trước năm
	tmp2 AS (
		SELECT
			SUM(T."TotalPrice") AS "TotalPrice"
		FROM "Transaction" T
		WHERE T."IsDeleted" IS FALSE
			AND T."TransactionTypeId" = 12
			AND TO_CHAR(T."Date", 'YYYY')::INT < p_year
	),
	--Lấy danh sách nộp trong năm theo user
	tmp3 AS (
		SELECT
			SC."UserId",
			SC."Month",
			SUM(((SC."Data"::JSON)->>'PriceUnion')::NUMERIC) AS "PriceUnion"
		FROM "SalaryConfirm" SC
		WHERE SC."IsDeleted" IS FALSE
			AND SUBSTRING(SC."Month", 1, 4)::INT = p_year
		GROUP BY 
			SC."UserId",
			SC."Month"
	),
	--Lấy danh sách nộp trong năm theo 12 tháng
	tmp4 AS (
		SELECT
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."ListSalePoint",
			U."SalePointName",
			SUM(COALESCE(P."PriceUnion", 0)) AS "TotalUnionSend",
			array_to_json(array_agg(json_build_object(
				'Month',
				M."Month",
				'PriceUnion',
				COALESCE(P."PriceUnion", 0)
			))) AS "DataSend"
		FROM tmp0 U
			JOIN tmp M ON TRUE
			LEFT JOIN tmp3 P ON U."UserId" = P."UserId" AND M."Month" = P."Month"
		GROUP BY
			U."UserId",
			U."FullName",
			U."UserTitleId",
			U."SalePointId",
			U."ListSalePoint",
			U."SalePointName"
		ORDER BY
			U."UserTitleId" IN (4, 6),
			U."SalePointId",
			U."UserId"
	),
	--Lấy danh sách trích quỹ trong năm
	tmp5 AS (
		SELECT
			SUM(T."TotalPrice") AS "TotalUse",
			array_to_json(array_agg(json_build_object(
				'TransactionId',
				T."TransactionId",
				'Date',
				T."Date",
				'Price',
				T."Price",
				'Note',
				T."Note"
			))) AS "DataUse"
		FROM "Transaction" T
		WHERE T."IsDeleted" IS FALSE
			AND T."TransactionTypeId" = 12
			AND TO_CHAR(T."Date", 'YYYY')::INT = p_year
	),
	--Tổng hợp tiền nộp user trong năm
	tmp6 AS (
		SELECT
			SUM(U."TotalUnionSend") AS "TotalUnionSend",
			array_to_json(array_agg(TO_JSONB(U.*))) "UserData"
		FROM tmp4 U
	),
	tmp7 AS (
		SELECT 
			COALESCE(P."PriceUnion", 0) - COALESCE(T."TotalPrice", 0) AS "PriceUnionFirst",
			COALESCE(U."TotalUnionSend", 0) AS "TotalUnionSend",
			COALESCE(A."TotalUse", 0) AS "TotalUse",	
			COALESCE(P."PriceUnion", 0) - COALESCE(T."TotalPrice", 0) + COALESCE(U."TotalUnionSend", 0) - COALESCE(A."TotalUse", 0) AS "TotalRemain",
			U."UserData",
			A."DataUse"
		FROM tmp1 P
			FULL JOIN tmp2 T ON TRUE
			FULL JOIN tmp6 U ON TRUE
			FULL JOIN tmp5 A ON TRUE
	)
	SELECT
		T."PriceUnionFirst",
		T."TotalUnionSend",
		T."TotalUse",
		T."TotalRemain",
		T."UserData"::TEXT,
		T."DataUse"::TEXT		
	FROM tmp7 T;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

