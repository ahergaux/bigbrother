-- DB BigBrother
-- Creé le 08/11/2024
-- Version 1.0
-- Fonctions de la DataBase
-- fonction.sql 


--Fonction pour avoir les tables des clés etrangères d'une table

CREATE OR REPLACE FUNCTION get_name_table_fk(nom_table TEXT) 
RETURNS TABLE (
    nom_attribut TEXT,
    nom_table_fk TEXT,
    nom_attribut_fk TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        kcu.column_name::TEXT,
        ccu.table_name::TEXT AS foreign_table,
        ccu.column_name::TEXT AS foreign_column
    FROM information_schema.key_column_usage AS kcu
    JOIN information_schema.constraint_column_usage AS ccu
        ON ccu.constraint_name = kcu.constraint_name
    WHERE kcu.table_name = nom_table AND kcu.constraint_name LIKE 'fk_%';
END;
$$ LANGUAGE plpgsql;

--Fonction pour avoir les attributs d'une table

CREATE OR REPLACE FUNCTION get_attribut_of(nom_table TEXT) 
RETURNS TABLE (
    nom_attribut TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT column_name::TEXT FROM information_schema.columns AS c WHERE c.table_name=nom_table;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_file(nom_file TEXT) RETURNS BOOLEAN 
AS $$
BEGIN
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fill_data_for(nom_table TEXT) RETURNS BOOLEAN
AS $$
BEGIN

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert() RETURNS BOOLEAN
AS $$
BEGIN

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION is_born(
    nom TEXT,
    prenom TEXT,
    date_naissance TIMESTAMP NOT NULL,
    ville_naissance TEXT,
    nationalite VARCHAR(10),
    genre TEXT
    ) RETURNS BOOLEAN
AS $$
BEGIN 
--regarder si il n'y a pas deja une personne avec les meme nom, prenom, date de naissance dans ce cas return FALSE 
--SINON inserer la personne avec tous les attributs différent 
-- utiliser fill_data_for ?
END;
$$ LANGUAGE plpgsql;

