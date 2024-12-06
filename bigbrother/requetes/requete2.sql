--Liste des étudiants dont les parents travaillent dans une entreprise spécifique
SELECT nr.nom, pr.prenom, nsr.niveau_scolaire,er.entreprise
FROM etudiant AS et
JOIN employe AS e ON et.id_personne = e.id_personne
JOIN entreprise__ref er on er.id=e.id_entreprise
JOIN nom__ref nr ON e.id_nom = nr.id
JOIN prenom__ref pr ON e.id_prenom = pr.id
JOIN job_title__ref jr ON e.id_job_title = jr.id
JOIN niveau_scolaire__ref nsr on nsr.id=et.id_niveau_scolaire
WHERE er.entreprise='renault';
