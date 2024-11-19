-- DB BigBrother
-- Creé le 10/11/2024
-- Version 1.0
-- Fonctions pas utile de la DataBase
-- fonctionusless.sql 

CREATE OR REPLACE FUNCTION afficher_tableau(arr ANYARRAY)
RETURNS VOID AS $$
DECLARE
    elem TEXT;
BEGIN
    FOREACH elem IN ARRAY arr
    LOOP
        RAISE NOTICE '%', elem;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

