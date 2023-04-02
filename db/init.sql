-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.3
-- PostgreSQL version: 13.0
-- Project Site: pgmodeler.io
-- Model Author: ---

-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: sport_club | type: DATABASE --
-- DROP DATABASE IF EXISTS sport_club;
-- CREATE DATABASE sport_club;
-- ddl-end --


-- object: public.person | type: TABLE --
-- DROP TABLE IF EXISTS public.person CASCADE;
CREATE TABLE public.person (
	person_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(200) NOT NULL,
	address varchar(500) NOT NULL,
	gender_id integer NOT NULL,
	birth_date date NOT NULL,
	CONSTRAINT person_pk PRIMARY KEY (person_id)

);
-- ddl-end --
ALTER TABLE public.person OWNER TO postgres;
-- ddl-end --

-- object: public.gender | type: TABLE --
-- DROP TABLE IF EXISTS public.gender CASCADE;
CREATE TABLE public.gender (
	gender_id integer NOT NULL,
	name varchar(20),
	CONSTRAINT gender_pk PRIMARY KEY (gender_id)

);
-- ddl-end --
ALTER TABLE public.gender OWNER TO postgres;
-- ddl-end --

INSERT INTO public.gender (gender_id, name) VALUES (E'1', E'male');
-- ddl-end --
INSERT INTO public.gender (gender_id, name) VALUES (E'2', E'female');
-- ddl-end --

-- object: public.parent | type: TABLE --
-- DROP TABLE IF EXISTS public.parent CASCADE;
CREATE TABLE public.parent (
	parent_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	occupation varchar(200),
	person_id integer NOT NULL,
	CONSTRAINT parent_pk PRIMARY KEY (parent_id)

);
-- ddl-end --
ALTER TABLE public.parent OWNER TO postgres;
-- ddl-end --

-- object: public.child | type: TABLE --
-- DROP TABLE IF EXISTS public.child CASCADE;
CREATE TABLE public.child (
	child_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	school_number integer,
	person_id integer,
	CONSTRAINT child_pk PRIMARY KEY (child_id),
	CONSTRAINT unique_child_person UNIQUE (person_id)

);
-- ddl-end --
ALTER TABLE public.child OWNER TO postgres;
-- ddl-end --

-- object: public.parent_child_link | type: TABLE --
-- DROP TABLE IF EXISTS public.parent_child_link CASCADE;
CREATE TABLE public.parent_child_link (
	parent_child_link_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	parent_id integer NOT NULL,
	child_id integer NOT NULL,
	CONSTRAINT parent_child_link_unique UNIQUE (parent_id,child_id),
	CONSTRAINT parent_child_link_pk PRIMARY KEY (parent_child_link_id)

);
-- ddl-end --
ALTER TABLE public.parent_child_link OWNER TO postgres;
-- ddl-end --

-- object: public.employee | type: TABLE --
-- DROP TABLE IF EXISTS public.employee CASCADE;
CREATE TABLE public.employee (
	employee_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	active_from date NOT NULL,
	active_to date,
	profession_id integer NOT NULL,
	person_id integer NOT NULL,
	CONSTRAINT employee_pk PRIMARY KEY (employee_id)

);
-- ddl-end --
ALTER TABLE public.employee OWNER TO postgres;
-- ddl-end --

-- object: public.profession | type: TABLE --
-- DROP TABLE IF EXISTS public.profession CASCADE;
CREATE TABLE public.profession (
	profession_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(100) NOT NULL,
	CONSTRAINT profession_unique UNIQUE (name),
	CONSTRAINT profession_pk PRIMARY KEY (profession_id)

);
-- ddl-end --
ALTER TABLE public.profession OWNER TO postgres;
-- ddl-end --

INSERT INTO public.profession (name) VALUES (E'Director');
-- ddl-end --
INSERT INTO public.profession (name) VALUES (E'Administrator');
-- ddl-end --
INSERT INTO public.profession (name) VALUES (E'Security');
-- ddl-end --
INSERT INTO public.profession (name) VALUES (E'Coach');
-- ddl-end --

-- object: public.sport | type: TABLE --
-- DROP TABLE IF EXISTS public.sport CASCADE;
CREATE TABLE public.sport (
	sport_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(100),
	CONSTRAINT sport_unique UNIQUE (name),
	CONSTRAINT sport_pk PRIMARY KEY (sport_id)

);
-- ddl-end --
ALTER TABLE public.sport OWNER TO postgres;
-- ddl-end --

INSERT INTO public.sport (name) VALUES (E'Chess');
-- ddl-end --
INSERT INTO public.sport (name) VALUES (E'Judo');
-- ddl-end --
INSERT INTO public.sport (name) VALUES (E'Wushu');
-- ddl-end --
INSERT INTO public.sport (name) VALUES (E'Aikido');
-- ddl-end --
INSERT INTO public.sport (name) VALUES (E'Hip hop dance');
-- ddl-end --
INSERT INTO public.sport (name) VALUES (E'Yoga');
-- ddl-end --

-- object: public."group" | type: TABLE --
-- DROP TABLE IF EXISTS public."group" CASCADE;
CREATE TABLE public."group" (
	group_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar(100) NOT NULL,
	active_from date NOT NULL,
	active_to date,
	sport_id integer NOT NULL,
	CONSTRAINT group_unique UNIQUE (name),
	CONSTRAINT group_pk PRIMARY KEY (group_id)

);
-- ddl-end --
ALTER TABLE public."group" OWNER TO postgres;
-- ddl-end --

-- object: public.coach | type: TABLE --
-- DROP TABLE IF EXISTS public.coach CASCADE;
CREATE TABLE public.coach (
	coach_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	active_from date NOT NULL,
	active_to date,
	employee_id integer NOT NULL,
	group_id integer NOT NULL,
	CONSTRAINT coach_pk PRIMARY KEY (coach_id)

);
-- ddl-end --
ALTER TABLE public.coach OWNER TO postgres;
-- ddl-end --

-- object: public.workout | type: TABLE --
-- DROP TABLE IF EXISTS public.workout CASCADE;
CREATE TABLE public.workout (
	workout_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	datetime timestamp NOT NULL,
	group_id integer NOT NULL,
	CONSTRAINT workout_pk PRIMARY KEY (workout_id)

);
-- ddl-end --
ALTER TABLE public.workout OWNER TO postgres;
-- ddl-end --

-- object: public.workout_child_link | type: TABLE --
-- DROP TABLE IF EXISTS public.workout_child_link CASCADE;
CREATE TABLE public.workout_child_link (
	workout_child_link_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	workout_id integer NOT NULL,
	child_id integer NOT NULL,
	CONSTRAINT workout_child_link_unique UNIQUE (workout_id,child_id),
	CONSTRAINT workout_child_link_pk PRIMARY KEY (workout_child_link_id)

);
-- ddl-end --
ALTER TABLE public.workout_child_link OWNER TO postgres;
-- ddl-end --

-- object: public.contract | type: TABLE --
-- DROP TABLE IF EXISTS public.contract CASCADE;
CREATE TABLE public.contract (
	contract_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ,
	number integer NOT NULL,
	active_from date NOT NULL,
	active_to date,
	price numeric(10,2) NOT NULL,
	parent_child_link_id integer NOT NULL,
	group_id integer NOT NULL,
	CONSTRAINT contract_pk PRIMARY KEY (contract_id)

);
-- ddl-end --
ALTER TABLE public.contract OWNER TO postgres;
-- ddl-end --

-- object: fk_person_gender | type: CONSTRAINT --
-- ALTER TABLE public.person DROP CONSTRAINT IF EXISTS fk_person_gender CASCADE;
ALTER TABLE public.person ADD CONSTRAINT fk_person_gender FOREIGN KEY (gender_id)
REFERENCES public.gender (gender_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fr_parent_person | type: CONSTRAINT --
-- ALTER TABLE public.parent DROP CONSTRAINT IF EXISTS fr_parent_person CASCADE;
ALTER TABLE public.parent ADD CONSTRAINT fr_parent_person FOREIGN KEY (person_id)
REFERENCES public.person (person_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_child_person | type: CONSTRAINT --
-- ALTER TABLE public.child DROP CONSTRAINT IF EXISTS fk_child_person CASCADE;
ALTER TABLE public.child ADD CONSTRAINT fk_child_person FOREIGN KEY (person_id)
REFERENCES public.person (person_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_parent_child_link_parent | type: CONSTRAINT --
-- ALTER TABLE public.parent_child_link DROP CONSTRAINT IF EXISTS fk_parent_child_link_parent CASCADE;
ALTER TABLE public.parent_child_link ADD CONSTRAINT fk_parent_child_link_parent FOREIGN KEY (parent_id)
REFERENCES public.parent (parent_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_parent_child_link_child | type: CONSTRAINT --
-- ALTER TABLE public.parent_child_link DROP CONSTRAINT IF EXISTS fk_parent_child_link_child CASCADE;
ALTER TABLE public.parent_child_link ADD CONSTRAINT fk_parent_child_link_child FOREIGN KEY (child_id)
REFERENCES public.child (child_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_employee_profession | type: CONSTRAINT --
-- ALTER TABLE public.employee DROP CONSTRAINT IF EXISTS fk_employee_profession CASCADE;
ALTER TABLE public.employee ADD CONSTRAINT fk_employee_profession FOREIGN KEY (profession_id)
REFERENCES public.profession (profession_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_employee_person | type: CONSTRAINT --
-- ALTER TABLE public.employee DROP CONSTRAINT IF EXISTS fk_employee_person CASCADE;
ALTER TABLE public.employee ADD CONSTRAINT fk_employee_person FOREIGN KEY (person_id)
REFERENCES public.person (person_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_group_sport | type: CONSTRAINT --
-- ALTER TABLE public."group" DROP CONSTRAINT IF EXISTS fk_group_sport CASCADE;
ALTER TABLE public."group" ADD CONSTRAINT fk_group_sport FOREIGN KEY (sport_id)
REFERENCES public.sport (sport_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_coach_employee | type: CONSTRAINT --
-- ALTER TABLE public.coach DROP CONSTRAINT IF EXISTS fk_coach_employee CASCADE;
ALTER TABLE public.coach ADD CONSTRAINT fk_coach_employee FOREIGN KEY (employee_id)
REFERENCES public.employee (employee_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_coach_group | type: CONSTRAINT --
-- ALTER TABLE public.coach DROP CONSTRAINT IF EXISTS fk_coach_group CASCADE;
ALTER TABLE public.coach ADD CONSTRAINT fk_coach_group FOREIGN KEY (group_id)
REFERENCES public."group" (group_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_workout_group | type: CONSTRAINT --
-- ALTER TABLE public.workout DROP CONSTRAINT IF EXISTS fk_workout_group CASCADE;
ALTER TABLE public.workout ADD CONSTRAINT fk_workout_group FOREIGN KEY (group_id)
REFERENCES public."group" (group_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_workout_child_link_workout | type: CONSTRAINT --
-- ALTER TABLE public.workout_child_link DROP CONSTRAINT IF EXISTS fk_workout_child_link_workout CASCADE;
ALTER TABLE public.workout_child_link ADD CONSTRAINT fk_workout_child_link_workout FOREIGN KEY (workout_id)
REFERENCES public.workout (workout_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_workout_child_link_child | type: CONSTRAINT --
-- ALTER TABLE public.workout_child_link DROP CONSTRAINT IF EXISTS fk_workout_child_link_child CASCADE;
ALTER TABLE public.workout_child_link ADD CONSTRAINT fk_workout_child_link_child FOREIGN KEY (child_id)
REFERENCES public.child (child_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_contract_parent_child_link | type: CONSTRAINT --
-- ALTER TABLE public.contract DROP CONSTRAINT IF EXISTS fk_contract_parent_child_link CASCADE;
ALTER TABLE public.contract ADD CONSTRAINT fk_contract_parent_child_link FOREIGN KEY (parent_child_link_id)
REFERENCES public.parent_child_link (parent_child_link_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_contract_group | type: CONSTRAINT --
-- ALTER TABLE public.contract DROP CONSTRAINT IF EXISTS fk_contract_group CASCADE;
ALTER TABLE public.contract ADD CONSTRAINT fk_contract_group FOREIGN KEY (group_id)
REFERENCES public."group" (group_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


