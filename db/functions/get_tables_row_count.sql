-- FUNCTION: public.get_tables_row_count()

-- DROP FUNCTION IF EXISTS public.get_tables_row_count();

CREATE OR REPLACE FUNCTION public.get_tables_row_count(
	)
    RETURNS TABLE(tbl_name character varying, row_cnt bigint)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE v_tbl_name VARCHAR;
DECLARE curs CURSOR FOR
  SELECT table_name FROM information_schema.tables
   WHERE table_schema = 'public';
BEGIN
  CREATE TEMPORARY TABLE t_result(tbl_name VARCHAR, row_cnt BIGINT) ON COMMIT DROP;
  OPEN curs;
  LOOP
    FETCH curs INTO v_tbl_name;
    IF NOT FOUND THEN EXIT;END IF;
	EXECUTE 'INSERT INTO t_result SELECT '''||v_tbl_name||''', COUNT(1) FROM public.'||v_tbl_name;
  END LOOP;
  CLOSE curs;
  RETURN QUERY SELECT * FROM t_result;
END;
$BODY$;

ALTER FUNCTION public.get_tables_row_count()
    OWNER TO postgres;
