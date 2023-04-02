-- PROCEDURE: public.add_parent(character varying, character varying, integer, date, character varying)

-- DROP PROCEDURE IF EXISTS public.add_parent(character varying, character varying, integer, date, character varying);

CREATE OR REPLACE PROCEDURE public.add_parent(
	IN p_name character varying,
	IN p_address character varying,
	IN p_gender_id integer,
	IN p_birth_date date,
	IN p_occupation character varying,
	OUT p_parent_id integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE v_person_id INT;
BEGIN
  INSERT INTO public.person(name, address, gender_id, birth_date)
	VALUES (p_name, p_address, p_gender_id, p_birth_date)
	RETURNING person_id INTO v_person_id;

  INSERT INTO public.parent(occupation, person_id)
	VALUES (p_occupation, v_person_id)
	RETURNING parent_id INTO p_parent_id;
END;
$BODY$;
ALTER PROCEDURE public.add_parent(character varying, character varying, integer, date, character varying)
    OWNER TO postgres;
