/*
Liste des employés ayant des dossiers médicaux récents 
*/

SELECT nr.nom, pr.prenom, jr.job_title, dr.condition_medicale, d.date_diagnostic
FROM employe AS e
JOIN sante AS d ON e.id_personne = d.id_personne
JOIN nom__ref nr on nr.id=e.id_nom
JOIN prenom__ref pr on pr.id=e.id_prenom
JOIN job_title__ref jr on jr.id=e.id_job_title
JOIN condition_medicale__ref dr on dr.id=d.id_condition_medicale
