-- DB BigBrother
-- Creé le 10/11/2024
-- Version 1.0
-- Fonctions pas utile de la DataBase
-- fonctionusless.sql 


CREATE OR REPLACE FUNCTION adresse_valide(adresse TEXT) RETURNS BOOLEAN AS $$
DECLARE 
    P NUMERIC;
    V NUMERIC;
    R NUMERIC;
    N NUMERIC;
    est_pays_valide BOOLEAN;
    est_ville_valide BOOLEAN;
    est_rue_valide BOOLEAN;
    est_adresse_valide BOOLEAN;
BEGIN 
    P := RIGHT(adresse, 3);                
    V := RIGHT(SUBSTRING(adresse, 1, 12), 4); 
    R := RIGHT(SUBSTRING(adresse, 1, 8), 5);
    N := LEFT(adresse, 3);

    est_pays_valide := EXISTS (SELECT 1 FROM PAYS WHERE id = P);
    est_ville_valide := EXISTS (SELECT 1 FROM VILLE WHERE id = V AND id_pays = P);
    est_rue_valide := EXISTS (SELECT 1 FROM RUE WHERE id = R AND id_ville = V AND id_pays = P);
    est_adresse_valide := EXISTS (SELECT 1 FROM ADRESSE WHERE id = N AND id_ville = V AND id_pays = P AND id_rue = R);

    RETURN est_pays_valide AND est_ville_valide AND est_rue_valide AND est_adresse_valide;
END;
$$ LANGUAGE plpgsql;

