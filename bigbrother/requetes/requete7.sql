--Comptes bancaires associés à des employés enregistrés

SELECT nr.nom, pr.prenom, br.banque, b.solde, er.entreprise
FROM employe AS e
RIGHT JOIN bancaire AS b ON e.id_personne = b.id_personne
JOIN nom__ref nr on nr.id=e.id_nom
JOIN prenom__ref pr on pr.id=e.id_prenom
JOIN banque__ref br on br.id=b.id_banque
JOIN entreprise__ref er on er.id=e.id_entreprise;

