-- DB BigBrother
-- Creé le 27/11/2024
-- Version 1.0
-- Tables d'administration de la DataBase
-- administration.sql


CREATE TABLE attributs_identite(
    id SERIAL PRIMARY KEY,
    attributs VARCHAR(50) NOT NULL UNIQUE
);

