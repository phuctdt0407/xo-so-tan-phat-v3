-- ================================
-- Author:Viet
-- Description:
-- Created date:
-- SELECT * FROM crm_salepoint_get_total_commision('2023-01',1);
-- ================================
SELECT dropallfunction_byname('crm_salepoint_get_total_commision');
CREATE OR REPLACE FUNCTION crm_salepoint_get_total_commision
(
	p_date TEXT, 
	p_salepoint_id INT8 DEFAULT 0
 )
RETURNS TABLE
(
	"CommissionId" INT,
	"User" TEXT,
	"SalePointId" INT,
	"SalePointName" TEXT,
	"Date" DATE,
	"TotalCommision" INT8,
	"Fee" numeric,
	"CreatedDate" TIMESTAMP
)
AS $BODY$
DECLARE
BEGIN
	RETURN QUERY
	--Lấy ra danh sách nhân viên được chia hoa hồng
	WITH tmp AS(
	SELECT 
		U."UserId",
		U."FullName"
	FROM "User" U 
		LEFT JOIN "UserRole" UR ON UR."UserId" = U."UserId"
	WHERE UR."UserTitleId" = 5  
	),tmp2 AS(
		SELECT 
			C."CommissionId",
			array_to_json(array_agg(json_build_object(
				'UserId',
				T."UserId",
				'UserName',
				T."FullName"
			)))::TEXT AS "Users"
		FROM tmp T 
		LEFT JOIN "Commission" C ON T."UserId" = ANY(C."ListStaff")
		LEFT JOIN "SalePoint" S ON S."SalePointId" = C."SalePointId"
		WHERE  (C."SalePointId" = p_salepoint_id OR p_salepoint_id = 0) AND date_part('month',C."Date") = date_part('month',CONCAT(p_date,'-01')::DATE)  
		GROUP BY C."CommissionId"
	)
	SELECT 
		C."CommissionId",
		T2."Users",
		C."SalePointId",
		S."SalePointName"::TEXT,
		C."Date",
		C."TotalValue",
		C."Fee",
		C."CreatedDate"
	FROM tmp T 
	LEFT JOIN "Commission" C ON T."UserId" = ANY(C."ListStaff")
	LEFT JOIN "SalePoint" S ON S."SalePointId" = C."SalePointId"
	LEFT JOIN tmp2 T2 ON T2."CommissionId" = C."CommissionId"
	WHERE  (C."SalePointId" = p_salepoint_id OR p_salepoint_id = 0) AND date_part('month',C."Date") = date_part('month',CONCAT(p_date,'-01')::DATE) AND C."IsDeleted" = FALSE
	GROUP BY
		C."CommissionId",
		C."SalePointId",
		S."SalePointName",
		C."Date",
		T2."Users"
	ORDER BY C."Date" DESC, C."CommissionId" DESC;
END;
$BODY$
LANGUAGE plpgsql VOLATILE