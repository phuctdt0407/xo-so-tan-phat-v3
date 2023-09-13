CREATE OR REPLACE FUNCTION dropallfunction_byname(functionname text)
RETURNS TEXT AS $BODY$
DECLARE
	funcrow RECORD;
	numfunctions smallint := 0;
	numparameters int;
	i int;
	paramtext text;
BEGIN
FOR funcrow IN SELECT proargtypes,proname FROM pg_proc WHERE LOWER(proname) = LOWER(functionname) LOOP
    numparameters = array_upper(funcrow.proargtypes, 1) + 1;

    i = 0;
    paramtext = '';

    LOOP
        IF i < numparameters THEN
            IF i > 0 THEN
                paramtext = paramtext || ', ';
            END IF;
            paramtext = paramtext || (SELECT typname FROM pg_type WHERE oid = funcrow.proargtypes[i]);
            i = i + 1;
        ELSE
            EXIT;
        END IF;
    END LOOP;

    EXECUTE 'DROP FUNCTION ' || funcrow.proname || '(' || paramtext || ');';
    numfunctions = numfunctions + 1;

END LOOP;

RETURN 'Dropped ' || numfunctions || ' functions';
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100