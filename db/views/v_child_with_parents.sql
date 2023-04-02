-- View: public.v_child_with_parents

-- DROP VIEW public.v_child_with_parents;

CREATE OR REPLACE VIEW public.v_child_with_parents
 AS
 SELECT ch.child_id,
    ch.person_id,
    ch_pr.name AS child_name,
    ch_pr.address AS child_address,
    ch_pr.birth_date AS child_birth_date,
    EXTRACT(year FROM age(ch_pr.birth_date::timestamp with time zone)) AS child_age,
    ch_pr.gender_id AS child_gender_id,
    ch_g.name AS child_gender_name,
    mother.mother_parent_id,
    mother.mother_person_id,
    mother.mother_name,
    mother.mother_address,
    mother.mother_birth_date,
    mother.mother_occupation,
    father.father_parent_id,
    father.father_person_id,
    father.father_name,
    father.father_address,
    father.father_birth_date,
    father.father_occupation
   FROM child ch
     JOIN person ch_pr ON ch_pr.person_id = ch.person_id
     JOIN gender ch_g ON ch_g.gender_id = ch_pr.gender_id
     LEFT JOIN LATERAL ( SELECT pr.parent_id AS mother_parent_id,
            pr.person_id AS mother_person_id,
            ps.name AS mother_name,
            ps.address AS mother_address,
            ps.birth_date AS mother_birth_date,
            pr.occupation AS mother_occupation
           FROM parent_child_link pcl
             JOIN parent pr ON pr.parent_id = pcl.parent_id
             JOIN person ps ON ps.person_id = pr.person_id AND ps.gender_id = 2
          WHERE pcl.child_id = ch.child_id) mother ON true
     LEFT JOIN LATERAL ( SELECT pr.parent_id AS father_parent_id,
            pr.person_id AS father_person_id,
            ps.name AS father_name,
            ps.address AS father_address,
            ps.birth_date AS father_birth_date,
            pr.occupation AS father_occupation
           FROM parent_child_link pcl
             JOIN parent pr ON pr.parent_id = pcl.parent_id
             JOIN person ps ON ps.person_id = pr.person_id AND ps.gender_id = 1
          WHERE pcl.child_id = ch.child_id) father ON true;

ALTER TABLE public.v_child_with_parents
    OWNER TO postgres;
