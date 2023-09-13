-- ================================
-- Author: Tien
-- Description: 
-- Created date: 16-06-2022
-- SELECT * FROM crm_report_get_data_item_in_month('2022-07');
-- ================================
SELECT dropallfunction_byname('crm_report_get_data_item_in_month');
CREATE OR REPLACE FUNCTION crm_report_get_data_item_in_month
(
	p_month VARCHAR
)
RETURNS TABLE
(
	"ItemId" INT,
	"SalePointId" INT,
	"TotalReceive" INT,
	"TotalRemaining" INT,
	"Import" INT,
	"Export" INT,
	"Use" INT,
	"ImportPrice" INT,
	"ExportPrice" INT,
	"UsePrice" INT,
	"Quotation" INT,
	"Note" TEXT,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"ActionDate" TIMESTAMP,
	"BalancePrice" INT,
	"AVGPrice" NUMERIC,
	"TypeOfItemId" INT
)
AS $BODY$
DECLARE
	v_last_date DATE := ((p_month||'-01' )::date  + interval '1 month' - interval '1 day')::date;
	v_pre_last_date DATE := ((p_month||'-01' )::date - interval '1 day')::date;

BEGIN
	RETURN QUERY
	--Lấy số tồn cuối tháng 
		WITH tmp AS(
		SELECT 
			ROW_NUMBER() OVER(PARTITION BY IL."SalePointId", IL."ItemId" ORDER BY "CreateDate" DESC) AS "Id",
				IL."ItemId",
				IL."SalePointId",
				IL."TotalRemaining",
				IL."CreateDate",
				IL."Quantity",
				IL."ItemTypeId",
				IL."TotalPrice",
				IL."Month",
				COALESCE(IL."ModifyBy", IL."CreateBy") AS "ActionBy",
				COALESCE(IL."ModifyByName", IL."CreateByName") AS "ActionByName",
				COALESCE(IL."ModifyDate", IL."CreateDate") AS "ActionDate",
				IL."BalancePrice"
		FROM "ItemFullLog" IL
		WHERE IL."Month"::date <= v_last_date
	),
		--Lấy số tồn đầu tháng 
	tmp1 AS(
			SELECT 
				ROW_NUMBER() OVER(PARTITION BY IL."SalePointId", IL."ItemId" ORDER BY "CreateDate" DESC) AS "Id",
					IL."ItemId",
					IL."SalePointId",
					IL."TotalRemaining",
					IL."CreateDate",
					IL."Month"
			FROM "ItemFullLog" IL
			WHERE IL."Month"::date <= v_pre_last_date
	),
	--Tính tổng sử dụng trong tháng
	tmp2 AS(
		SELECT 
			tm."SalePointId",
			tm."ItemId",
			SUM(tm."Quantity") FILTER(WHERE tm."ItemTypeId" =1) AS "Import",
			SUM(tm."Quantity") FILTER(WHERE tm."ItemTypeId" =2) AS "Export",
			SUM(tm."Quantity") FILTER(WHERE tm."ItemTypeId" =3) AS "Use",
			SUM(tm."TotalPrice") FILTER(WHERE tm."ItemTypeId" =1) AS "ImportPrice",
			SUM(tm."TotalPrice") FILTER(WHERE tm."ItemTypeId" =2) AS "ExportPrice",
			SUM(tm."TotalPrice") FILTER(WHERE tm."ItemTypeId" =3) AS "UsePrice"
		FROM tmp tm
-- 		WHERE date_part('month',  tm."Month")  = date_part('month',  to_date(p_month, 'YYYY-MM'))
		GROUP BY tm."SalePointId", tm."ItemId"
),
	tmp3 AS(
		SELECT
			COALESCE(A."ItemId",B."ItemId") AS "ItemId",
			COALESCE(A."SalePointId",B."SalePointId") AS "SalePointId",
			COALESCE(B."TotalRemaining",0) ::INT AS "TotalReceive",
			COALESCE(A."TotalRemaining",0) ::INT AS "TotalRemaining",
			COALESCE(C."Import",0)::INT AS "Import",
 			COALESCE(C."Export",0)::INT  AS "Export",
 			COALESCE(C."Use",0)::INT  AS "Use",
			COALESCE(C."ImportPrice",0)::INT  AS "ImportPrice",
 			COALESCE(C."ExportPrice",0)::INT  AS "ExportPrice",
 			COALESCE(C."UsePrice",0)::INT  AS "UsePrice",
			I."Quotation",
			(CASE WHEN COALESCE(A."TotalRemaining",0) / I."Quotation" = 0 THEN 'Cần bổ sung gấp'
					WHEN COALESCE(A."TotalRemaining",0) ::NUMERIC /I."Quotation" > 0.5 THEN 'Đủ Dùng'
					ELSE 'Cần bổ sung gấp'
				END ) AS "Note",
			A."ActionBy",
			A."ActionByName",
			A."ActionDate",
			A."BalancePrice",
			(CASE WHEN A."TotalRemaining"= 0 THEN I."Price" ELSE A."BalancePrice" / A."TotalRemaining" END):: NUMERIC AS AVGPrice,
			TOI."TypeOfItemId"
		FROM tmp A
			FULL JOIN tmp1 B ON A."SalePointId"= B."SalePointId" AND A."ItemId"= B."ItemId" AND A."Id"= B."Id"
			LEFT JOIN tmp2 C ON COALESCE(A."SalePointId",B."SalePointId") = C."SalePointId" AND COALESCE(A."ItemId",B."ItemId")= C."ItemId"
			LEFT JOIN "Item" I ON  A."ItemId"=I."ItemId" 
			JOIN "TypeOfItem" TOI ON  TOI."TypeOfItemId"= I."TypeOfItemId" 
		WHERE 
			A."Id" =1 OR B."Id" = 1
	)
		SELECT * FROM tmp3;
END;
$BODY$
LANGUAGE plpgsql VOLATILE