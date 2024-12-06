--Toutes les combinaisons entre entreprises et types de biens dans le patrimoine

SELECT e.entreprise, tr.type_bien
FROM entreprise__ref AS e
CROSS JOIN patrimoine AS p
join type_bien__ref tr on p.id_type_bien=tr.id;

