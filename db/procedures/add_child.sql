-- PROCEDURE: public.add_child(character varying, character varying, integer, date, integer)

-- DROP PROCEDURE IF EXISTS public.add_child(character varying, character varying, integer, date, integer);

CREATE OR REPLACE PROCEDURE public.add_child(
	IN p_name character varying,
	IN p_address character varying,
	IN p_gender_id integer,
	IN p_birth_date date,
	IN p_school_number integer,
	OUT p_child_id integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE v_person_id INT;
BEGIN
  INSERT INTO public.person(name, address, gender_id, birth_date)
	VALUES (p_name, p_address, p_gender_id, p_birth_date)
	RETURNING person_id INTO v_person_id;

  INSERT INTO public.child(school_number, person_id)
	VALUES (p_school_number, v_person_id)
	RETURNING child_id INTO p_child_id;
END;
$BODY$;
ALTER PROCEDURE public.add_child(character varying, character varying, integer, date, integer)
    OWNER TO postgres;
