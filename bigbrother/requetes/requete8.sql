
--Détail des employés et étudiants vivant à la même adresse
SELECT nr.nom AS employe_nom, pr.prenom AS employe_prenom, nr2.nom AS etudiant_nom, pr2.prenom AS etudiant_prenom
FROM employe AS e
FULL OUTER JOIN etudiant AS et ON e.id_adresse = et.id_adresse
JOIN nom__ref nr on nr.id=e.id_nom
JOIN prenom__ref pr on pr.id=e.id_prenom
JOIN nom__ref nr2 on nr2.id=et.id_nom
JOIN prenom__ref pr2 on pr2.id=et.id_prenom

