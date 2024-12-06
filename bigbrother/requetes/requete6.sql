-- Liste des étudiants avec ou sans patrimoine enregistré | CONTEXTE : ATTRIBUTION DE BOURSE ?
SELECT nr.nom, pr.prenom, nsr.niveau_scolaire, p.valeur_bien
FROM etudiant AS et
LEFT JOIN patrimoine AS p ON et.id_personne = p.id_personne
JOIN nom__ref nr on nr.id=et.id_nom
JOIN prenom__ref pr on pr.id=et.id_prenom
JOIN niveau_scolaire__ref nsr on nsr.id=et.id_niveau_scolaire;

