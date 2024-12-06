--identifiez les employés ayant un patrimoine supérieur à la moyenne des employés d'une même ville :

SELECT *
FROM employe AS e
JOIN patrimoine AS p ON e.id_personne = p.id_personne
JOIN nom__ref nr on nr.id=e.id_nom
JOIN prenom__ref pr on pr.id=e.id_prenom
WHERE p.valeur_bien > (
    SELECT AVG(inner_p.valeur_bien)
    FROM patrimoine AS inner_p
    WHERE inner_p.id_ville = p.id_ville
);