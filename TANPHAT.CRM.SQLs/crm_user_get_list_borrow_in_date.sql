-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_list_borrow_in_date('2022-07');
-- ================================
SELECT dropallfunction_byname('crm_user_get_list_borrow_in_date');
CREATE OR REPLACE FUNCTION crm_user_get_list_borrow_in_date
(
	p_month VARCHAR DEFAULT NOW(),
	p_user_id INT DEFAULT 0
)
RETURNS TABLE
(
	"Date" DATE,
	"TotalData" TEXT
)
AS $BODY$
DECLARE
		v_total_date INT := (SELECT date_part('days', (date_trunc('month', (p_month||'-01')::DATE) + INTERVAL '1 month - 1 day'))) :: INT;
		v_time TIMESTAMP := NOW();
BEGIN
	RETURN QUERY
	WITH tmp AS (
		SELECT 
			U."UserId",
			U."FullName"
		FROM crm_get_user_ddl(2, v_time::DATE) U
		WHERE (U."UserId" = p_user_id OR p_user_id = 0)
	),
	--Lấy tất cả mượn trả từ trước đến giờ
	tmp1 AS (
		SELECT
			MB."UserId",
			MB."Price",
			MB."FormPaymentId",
			F."PaymentName",
			MB."Note",
			MB."CreatedDate",
			MB."IsPay"
		FROM "ManagerBorrow" MB
			JOIN "FormPayment" F ON MB."FormPaymentId" = F."FormPaymentId"
		WHERE MB."IsDeleted" IS FALSE
		ORDER BY 
			MB."CreatedDate"
	),
	--Tạo chuỗi ngày
	tmp3 AS (
		SELECT
			(p_month||'-'||"D")::DATE AS "Date"
		FROM generate_series(1, v_total_date) AS "D"
		WHERE (p_month||'-'||"D")::DATE <= v_time::DATE
	),
	tmp4 AS (
		SELECT
			U."CreatedDate"::DATE AS "Date",
			U."UserId",
			COALESCE(SUM(U."Price") FILTER (WHERE U."IsPay" IS FALSE), 0) AS "TotalBorrow",
			COALESCE(SUM(U."Price") FILTER (WHERE U."IsPay" IS TRUE), 0) AS "TotalPay",
			array_to_json(array_agg(jsonb_build_object(
				'CreatedDate',
				U."CreatedDate",
				'Price',
				U."Price",
				'Note',
				U."Note"
			))) AS "DataInDate"
		FROM tmp1 U
		GROUP BY 
			U."CreatedDate"::DATE,
			U."UserId"
	),
	tmp5 AS (
		SELECT 
			D."Date",
			U."UserId",
			U."FullName",		
			M."DataInDate",
			(
				SELECT
						COALESCE(SUM(T."Price") FILTER (WHERE T."IsPay" IS FALSE), 0) - COALESCE(SUM(T."Price") FILTER (WHERE T."IsPay" IS TRUE), 0) AS "FisrtDate"
				FROM tmp1 T 
				WHERE T."CreatedDate"::DATE < D."Date"
					AND T."UserId" = U."UserId"
			)::NUMERIC AS "FisrtDate",
			COALESCE(M."TotalBorrow", 0) AS "TotalBorrow",
			COALESCE(M."TotalPay", 0) AS "TotalPay"
		FROM tmp3 D 
			JOIN tmp U ON TRUE
			LEFT JOIN tmp4 M ON D."Date" = M."Date" AND U."UserId" = M."UserId"
	),
	tmp6 AS (
		SELECT
			U."Date",
			U."UserId",
			U."FullName",		
			U."DataInDate",
			U."FisrtDate",
			U."TotalBorrow",
			U."TotalPay",
			U."FisrtDate" + U."TotalBorrow" -	U."TotalPay" AS "TotalRemaining"
		FROM tmp5 U
		ORDER BY
			U."Date",
			U."UserId"
	)
	SELECT
		U."Date",
		array_to_json(array_agg(TO_JSONB(U.*)))::TEXT AS "TotalData"
	FROM tmp6 U
	GROUP BY 
		U."Date"
	ORDER BY 
		U."Date" DESC;
END;
$BODY$
LANGUAGE plpgsql VOLATILE

