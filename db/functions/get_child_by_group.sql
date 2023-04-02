-- FUNCTION: public.get_child_by_group(integer)

-- DROP FUNCTION IF EXISTS public.get_child_by_group(integer);

CREATE OR REPLACE FUNCTION public.get_child_by_group(
	p_group_id integer)
    RETURNS TABLE(child_id integer)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
  RETURN QUERY
    SELECT pcl.child_id
      FROM public.contract cn
      JOIN public.parent_child_link pcl
	    ON pcl.parent_child_link_id = cn.parent_child_link_id
     WHERE cn.group_id = p_group_id;
END;
$BODY$;

ALTER FUNCTION public.get_child_by_group(integer)
    OWNER TO postgres;
