




/*
Employés sans diagnostic médical récent, peut etre utile aux RH 
d'une entreprise pour savoir qu'elles sont les personne à risque 
de quitter son poste subitement ou d'etre en arret maladie
*/ 

SELECT nom, prenom
FROM employe e
JOIN nom__ref nr on nr.id=e.id_nom
JOIN prenom__ref pr on pr.id=e.id_prenom
EXCEPT
SELECT nom, prenom
FROM sante s
JOIN nom__ref nr on nr.id=s.id_nom
JOIN prenom__ref pr on pr.id=s.id_prenom;
*/