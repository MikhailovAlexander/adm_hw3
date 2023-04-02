-- PROCEDURE: public.add_child_with_parent(character varying, character varying, integer, date, integer, character varying, character varying, integer, date, character varying)

-- DROP PROCEDURE IF EXISTS public.add_child_with_parent(character varying, character varying, integer, date, integer, character varying, character varying, integer, date, character varying);

CREATE OR REPLACE PROCEDURE public.add_child_with_parent(
	IN p_child_name character varying,
	IN p_child_address character varying,
	IN p_child_gender_id integer,
	IN p_child_birth_date date,
	IN p_child_school_number integer,
	IN p_parent_name character varying,
	IN p_parent_address character varying,
	IN p_parent_gender_id integer,
	IN p_parent_birth_date date,
	IN p_parent_occupation character varying,
	OUT p_parent_child_link_id integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE v_child_id INT;
DECLARE v_parent_id INT;
BEGIN
  CALL public.add_child(p_child_name, p_child_address, p_child_gender_id, p_child_birth_date, p_child_school_number, v_child_id);
  CALL public.add_parent(p_parent_name, p_parent_address, p_parent_gender_id, p_parent_birth_date, p_parent_occupation, v_parent_id);
  INSERT INTO public.parent_child_link(parent_id, child_id)
    VALUES (v_parent_id, v_child_id)
    RETURNING parent_child_link_id INTO p_parent_child_link_id;
END;
$BODY$;
ALTER PROCEDURE public.add_child_with_parent(character varying, character varying, integer, date, integer, character varying, character varying, integer, date, character varying)
    OWNER TO postgres;
