-- Villes avec un patrimoine total dépassant un seuil élevé

CREATE VIEW patrimoine_par_ville AS
SELECT vr.ville, SUM(valeur_bien) AS patrimoine_total
FROM patrimoine p
JOIN ville__ref vr on p.id_ville=vr.id
GROUP BY ville;


SELECT ville, patrimoine_total
FROM patrimoine_par_ville
WHERE patrimoine_total > 5000000;

