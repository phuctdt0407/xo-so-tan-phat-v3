-- ================================
-- Author: Quang
-- Description:
-- Created date:
-- SELECT * FROM crm_user_get_list_off_of_leader('2022-07');
-- ================================
SELECT dropallfunction_byname('crm_user_get_list_off_of_leader');
CREATE OR REPLACE FUNCTION crm_user_get_list_off_of_leader
(
	p_month VARCHAR 
)
RETURNS TABLE
(
	"UserId" INT,
	"FullName" VARCHAR,
	"Date" DATE,
	"Note" VARCHAR,
	"ActionBy" INT,
	"ActionByName" VARCHAR,
	"ActionDate" TIMESTAMP
)
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
		LO."UserId",
		U."FullName",
		LO."WorkingDate",
		LO."Note",
		LO."ActionBy",
		LO."ActionByName",
		LO."ActionDate"
	FROM "LeaderOffLog" LO
		JOIN "User" U ON LO."UserId" = U."UserId"
	WHERE TO_CHAR(LO."WorkingDate", 'YYYY-MM') = p_month
		AND LO."IsDeleted" IS FALSE
	ORDER BY 
		LO."WorkingDate";
END;
$BODY$
LANGUAGE plpgsql VOLATILE

