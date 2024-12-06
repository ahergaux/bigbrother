-- Vue temporaire pour les emplois avec salaires élevés
CREATE TEMP VIEW emplois_salaire_eleve AS
SELECT e.id_personne, e.salary
FROM employe AS e
WHERE e.salary > (
    SELECT AVG(inner_e.salary)
    FROM employe AS inner_e
);

-- Requête principale
SELECT st.nom, st.prenom, nsr.niveau_scolaire, er.entreprise, ee.salary
FROM etudiant AS st
JOIN emplois_salaire_eleve ee ON st.id_personne = ee.id_personne
JOIN employe AS e ON st.id_personne = e.id_personne
JOIN entreprise__ref er ON e.id_entreprise = er.id
JOIN niveau_scolaire__ref nsr ON st.id_niveau_scolaire = nsr.id;