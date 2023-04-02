-- PROCEDURE: public.add_employee(character varying, character varying, integer, date, date, integer, integer)

-- DROP PROCEDURE IF EXISTS public.add_employee(character varying, character varying, integer, date, date, integer, integer);

CREATE OR REPLACE PROCEDURE public.add_employee(
	IN p_name character varying,
	IN p_address character varying,
	IN p_gender_id integer,
	IN p_birth_date date,
	IN p_active_from date,
	IN p_profession_id integer,
    OUT p_employee_id integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE v_person_id INT;
BEGIN
  INSERT INTO public.person(name, address, gender_id, birth_date)
	VALUES (p_name, p_address, p_gender_id, p_birth_date)
	RETURNING person_id INTO v_person_id;

  INSERT INTO public.employee(active_from, profession_id, person_id)
	VALUES (p_active_from, p_profession_id, v_person_id)
	RETURNING employee_id INTO p_employee_id;
END;
$BODY$;
ALTER PROCEDURE public.add_employee(character varying, character varying, integer, date, date, integer, integer)
    OWNER TO postgres;
