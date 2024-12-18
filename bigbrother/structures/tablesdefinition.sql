-- DB BigBrother
-- Creé le 08/11/2024
-- Version 1.0
-- Autres Tables de Définition
-- tablesdefinition.sql


-- DEFINITION AUTRES TABLES PERSONNE 

CREATE TABLE IF NOT EXISTS NOM__REF(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS PRENOM__REF(
    id SERIAL PRIMARY KEY,
    prenom VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS VILLE__REF(
    id SERIAL PRIMARY KEY,
    ville VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS RUE__REF(
    id SERIAL PRIMARY KEY,
    rue VARCHAR(50) NOT NULL,
    id_ville INTEGER NOT NULL,
    CONSTRAINT fk_id_ville_rue FOREIGN KEY (id_ville) REFERENCES VILLE__REF(id),
    CONSTRAINT rue_nom_ville_unique UNIQUE (rue, id_ville)
);

CREATE TABLE IF NOT EXISTS ADRESSE__REF(
    id SERIAL PRIMARY KEY,
    numero INTEGER NOT NULL,
    id_rue INTEGER NOT NULL,
    id_ville INTEGER NOT NULL,
    CONSTRAINT fk_id_rue_adresse FOREIGN KEY (id_rue) REFERENCES RUE__REF(id),
    CONSTRAINT fk_id_ville_adresse FOREIGN KEY (id_ville) REFERENCES VILLE__REF(id),
    CONSTRAINT adresse_unique UNIQUE (numero, id_rue, id_ville)
);


CREATE TABLE IF NOT EXISTS GENRE__REF(
    id SERIAL PRIMARY KEY,
    genre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS ADRESSE_MAIL__REF(
    id SERIAL PRIMARY KEY,
    adresse_mail VARCHAR(50) UNIQUE NOT NULL
);