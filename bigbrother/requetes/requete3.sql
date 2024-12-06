--Employés qui gagnent plus que le double du salaire moyen des employés ayant un diplôme similaire
SELECT 
    nr.nom AS Nom,
    pr.prenom AS Prenom,
    jr.job_title AS Job_Title,
    e.salary AS Salaire,
    br.banque AS Banque,
    b.solde AS Solde,
    b.mouvement_montant AS Dernier_Mouvement,
    ctr.categorie_transaction AS Derniere_Transaction
FROM 
    employe AS e
JOIN bancaire AS b ON e.id_personne = b.id_personne
JOIN nom__ref nr ON e.id_nom = nr.id
JOIN prenom__ref pr ON e.id_prenom = pr.id
JOIN job_title__ref jr ON e.id_job_title = jr.id
JOIN banque__ref br on br.id=b.id_banque
JOIN categorie_transaction__ref ctr on ctr.id=b.id_categorie_transaction

WHERE 
    e.salary > (SELECT AVG(salary) FROM employe)
    AND b.solde > (SELECT AVG(solde) FROM bancaire)
ORDER BY 
    e.salary DESC, b.solde DESC
LIMIT 10;