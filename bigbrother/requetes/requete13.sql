-- Vue temporaire pour la moyenne des soldes par banque
CREATE VIEW moyenne_solde_par_banque AS
SELECT b.id_banque, AVG(b.solde) AS solde_moyen
FROM bancaire AS b
GROUP BY b.id_banque;

-- Requête principale
SELECT nr.nom, pr.prenom, br.banque, b.solde
FROM employe AS e
JOIN bancaire AS b ON e.id_personne = b.id_personne
JOIN nom__ref nr ON e.id_nom = nr.id
JOIN prenom__ref pr ON e.id_prenom = pr.id
JOIN banque__ref br ON b.id_banque = br.id
WHERE b.solde > (
    SELECT solde_moyen
    FROM moyenne_solde_par_banque
    WHERE moyenne_solde_par_banque.id_banque = b.id_banque