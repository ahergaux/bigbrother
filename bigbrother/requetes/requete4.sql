--Personnes ayant un compte bancaire dans une banque donnée, vivant dans une ville spécifique, et un patrimoine supérieur à une valeur moyenne

SELECT nr.nom, pr.prenom, br.banque, p.valeur_bien
FROM bancaire AS b
JOIN patrimoine AS p ON b.id_personne = p.id_personne
JOIN nom__ref nr on nr.id=p.id_nom
JOIN prenom__ref pr on pr.id=p.id_prenom 
JOIN banque__ref br on br.id=b.id_banque
JOIN ville__ref vr on vr.id=p.id_ville

    WHERE br.banque = 'bnp_paribas'
    AND vr.ville = 'paris'
    AND p.valeur_bien > (
        SELECT AVG(inner_p.valeur_bien)
        FROM patrimoine AS inner_p
        JOIN ville__ref vr2 on vr2.id=inner_p.id_ville
        WHERE vr2.ville = 'paris'
    );