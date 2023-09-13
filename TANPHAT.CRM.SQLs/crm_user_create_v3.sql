-- ================================
-- Author: Tien
-- Description: Create user
-- Created date: 31/05/2022
-- SELECT * FROM crm_user_create_v3(0, 'system', '[{"Account":"Viet 12312 ngày 9 tháng 2 2023","FullName":"Việt thực tập Đá","Phone":"231","Email":"thuctapn@gmail.com", "NumberIdentity":"123123","BankAccount":"10202","Address":"189 đường con chó","SalePointId": 1}]',true);
-- ================================
SELECT dropallfunction_byname('crm_user_create_v3');
CREATE OR REPLACE FUNCTION crm_user_create_v3
(
	p_action_by INT,
	p_action_by_name VARCHAR,
	p_data TEXT,
	p_intern BOOL
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
	v_password VARCHAR = 'GjNJi5nlYpLw8no39S+hcg==';
	--
	ele JSON;
BEGIN
	
	FOR ele IN SELECT * FROM json_array_elements(p_data::JSON) LOOP
		IF(NOT EXISTS(SELECT 1 FROM "User" WHERE ("Account" = (ele->>'Account')::VARCHAR OR "Email" = (ele->>'Email')::VARCHAR) AND "IsActive" IS TRUE )) THEN
			INSERT INTO "User"(
				"Account",
				"Password",
				"FullName",
				"Phone",
				"Email",
				"SalePointId",
				"ActionBy",
				"ActionByName",
				"Address",
				"BankAccount",
				"NumberIdentity"
			)
			VALUES(
				(ele ->> 'Account'):: VARCHAR,
				v_password,
				(ele ->> 'FullName'):: VARCHAR,
				(ele ->> 'Phone'):: VARCHAR,
				(ele ->> 'Email'):: VARCHAR,
				(ele ->> 'SalePointId'):: INT,
				p_action_by,
				p_action_by_name,
				(ele ->> 'Address')::VARCHAR,
				(ele ->> 'BankAccount')::VARCHAR,
				(ele ->> 'NumberIdentity')::VARCHAR
			) RETURNING "UserId" INTO v_id;
			v_mess := 'User created';
		ELSE
			v_mess := 'Tài khoản hoặc email đã tồn tại';
			v_id := -1;
		END IF;
	 
		IF (v_id > 0) THEN
				INSERT INTO "UserRole"(
					"UserRoleId",
					"UserId",
					"UserTitleId"
				)
				VALUES(
					v_id,
					v_id,
					5
				);
		END IF;
		IF (p_intern = TRUE) THEN 
			UPDATE "User"
			SET "IsIntern" = TRUE 
			WHERE "UserId" = v_id;
		END IF;
	
	END LOOP;
	
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
