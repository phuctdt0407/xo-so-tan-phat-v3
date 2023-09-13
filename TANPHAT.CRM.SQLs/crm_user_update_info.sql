-- ================================
-- Author: Tien
-- Description: Update User 
-- Created date: 01/06/2022
-- Modify: Quang (28/06/2022)
-- SELECT * FROM crm_user_update_info(-1,'Ti2en Le',10, '{"FullName":"fIX L3123OI","IsActive":true, "BasicSalary": 11000000, "StartDate": "2022-06-01", "EndDate": "2022-07-01", "IsActive": "TRUE","BankAccount":"112328391230","NumberIdentity":"312124124","Address":"123 cong an","Phone":"113","IsIntern":false}');
-- ================================
SELECT dropallfunction_byname('crm_user_update_info');
CREATE OR REPLACE FUNCTION crm_user_update_info
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_user_id INT,
	p_data TEXT
)
RETURNS TABLE
(
	"Id" INT,
	"Message" TEXT
)
AS $BODY$
DECLARE 
	v_id INT;
	v_mess TEXT;
	ele JSON := p_data::JSON;
	v_check BOOL;
	v_check_2 BOOL;
	v_account VARCHAR;
	v_email VARCHAR;
BEGIN	

	SELECT "IsActive", "IsDeleted", "Account", "Email" INTO v_check, v_check_2, v_account, v_email FROM "User" WHERE "UserId" = p_user_id;
	IF v_check IS FALSE OR v_check_2 IS TRUE THEN
		IF EXISTS (
			SELECT 1 FROM "User" U
			WHERE U."UserId" <> p_user_id
				AND (U."Account" = v_account OR U."Email" = v_email)
		) THEN
			RAISE 'Không thể cập nhật do tài khoản này đã được tạo mới trong hệ thống';
		END IF;
	END IF;

	UPDATE "User"
	SET
		"IsActive" = COALESCE((ele->> 'IsActive'):: BOOLEAN, "IsActive"),
		"FullName" = COALESCE((ele->> 'FullName'):: VARCHAR,"FullName"),
		"IsDeleted" = COALESCE((ele ->> 'IsDeleted')::BOOL, "IsDeleted"),
		"StartDate" = COALESCE((ele ->> 'StartDate')::DATE, "StartDate"),
		"EndDate" = (CASE WHEN (ele->> 'IsActive'):: BOOLEAN IS FALSE THEN COALESCE((ele ->> 'EndDate')::DATE, "EndDate") ELSE NULL::DATE END),
		"SalePointId" = COALESCE((ele->>'SalePointId')::INT, "SalePointId"),
		"ModifyBy"= p_action_by,	
		"ModifyByName" = p_action_by_name,
		"Address" = COALESCE((ele ->> 'Address')::VARCHAR,"Address"),
		"BankAccount" = COALESCE((ele ->> 'BankAccount')::VARCHAR,"BankAccount"),
		"NumberIdentity" = COALESCE((ele ->> 'NumberIdentity')::VARCHAR,"NumberIdentity"),
		"Phone" = COALESCE ((ele->>'Phone')::VARCHAR,"Phone"),
		"IsIntern" = COALESCE ((ele->>'IsIntern')::BOOL,"IsIntern")
	WHERE "UserId"= p_user_id;
	
	IF((ele->>'BasicSalary')::INT IS NOT NULL) THEN
		IF NOT EXISTS(
		SELECT 1 
		FROM "BasicSalary" C 
		WHERE C."UserId" = p_user_id
			AND C."Salary" = (ele->>'BasicSalary')::INT
			AND C."Salary" = ANY(
				SELECT B."Salary"
				FROM "BasicSalary" B 
				WHERE B."UserId" = p_user_id 
				ORDER BY B."CreatedDate" DESC
				LIMIT 1
			)
		) THEN 
			INSERT INTO "BasicSalary" (
				"UserId",
				"CreatedBy",
				"CreatedByName",
				"Salary"
			)
			VALUES(
				p_user_id,
				p_action_by,
				p_action_by_name,
				(ele->>'BasicSalary')::INT
			);
		END IF;
	END IF;
	
	v_id := 1;
	v_mess := 'Cập nhật người dùng thành công';
	
	RETURN QUERY 
	SELECT 	v_id, v_mess;

	EXCEPTION WHEN OTHERS THEN
	BEGIN				
		v_id := -1;
		v_mess := sqlerrm;
		
		RETURN QUERY 
		SELECT 	v_id, v_mess;
	END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE