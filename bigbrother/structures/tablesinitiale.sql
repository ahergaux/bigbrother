-- DB BigBrother
-- Creé le 08/11/2024
-- Version 1.0
-- Tables initiale de la DataBase
-- tablesinitiale.sql

-- TABLE PERSONNE

CREATE TABLE IF NOT EXISTS PERSONNE (
    id SERIAL PRIMARY KEY,
    id_nom INTEGER,
    id_prenom INTEGER,-- PRIMARY KEY avec id_nom et date_naissance ? Pour simplifier ?
    date_naissance TIMESTAMP, -- QUESTION SUR LES PRIMARY KEY
    id_ville_naissance INTEGER,
    nationalite VARCHAR(10),
    id_genre INTEGER,
    CONSTRAINT fk_id_nom_personne FOREIGN KEY (id_nom) REFERENCES NOM__REF(id),
    CONSTRAINT fk_id_prenom_personne FOREIGN KEY (id_prenom) REFERENCES PRENOM__REF(id),
    CONSTRAINT fk_id_ville_naissance_personne FOREIGN KEY (id_ville_naissance) REFERENCES VILLE__REF(id),
    CONSTRAINT fk_genre_personne FOREIGN KEY (id_genre) REFERENCES GENRE__REF(id)
);


CREATE TABLE IF NOT EXISTS ADRESSE_POSTALE(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    adresse_postale INTEGER ,
    debut TIMESTAMP ,
    fin TIMESTAMP,
    CONSTRAINT fk_id_personne_adresse_postale FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_adresse_postale_adresse_postale FOREIGN KEY (adresse_postale) REFERENCES ADRESSE__REF(id),
    CHECK (fin>=debut)
);


CREATE TABLE IF NOT EXISTS NUMERO_TEL(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    numero_tel INTEGER ,
    indicatif_tel INTEGER,
    CONSTRAINT fk_id_personne_numero_tel FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_indicatif_numero_tel FOREIGN KEY (indicatif_tel) REFERENCES PAYS__REF(indicatif)
);


CREATE TABLE IF NOT EXISTS ADRESSE_MAIL(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    id_adresse_mail INTEGER ,
    CONSTRAINT fk_id_personne_adresse_mail FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_adresse_mail_adresse_mail FOREIGN KEY (id_adresse_mail) REFERENCES ADRESSE_MAIL__REF(id)
);


CREATE TABLE IF NOT EXISTS RESEAUX(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    id_reseaux INTEGER ,
    alias VARCHAR(30),
    CONSTRAINT fk_id_personne_reseaux_personne FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_id_reseau_reseaux_personne FOREIGN KEY (id_reseaux) REFERENCES RESEAUX__REF(id)
);

CREATE TABLE IF NOT EXISTS GEOLOC(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    geoloc INTEGER ,
    date TIMESTAMP ,
    CONSTRAINT fk_adresse_geoloc FOREIGN KEY (geoloc) REFERENCES ADRESSE__REF(id),
    CONSTRAINT fk_id_personne_geoloc FOREIGN KEY (id_personne) REFERENCES PERSONNE(id)
);

CREATE TABLE IF NOT EXISTS SITUATION_MATRIMONIALE(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    id_situation_matrimoniale INTEGER ,
    debut TIMESTAMP ,
    fin TIMESTAMP,
    CONSTRAINT fk_situation_matrimoniale_situation_matrimoniale FOREIGN KEY (id_situation_matrimoniale) REFERENCES MATRIMONIALE__REF(id),
    CONSTRAINT fk_id_personne_situation_matrimoniale FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CHECK (fin>=debut)
);


CREATE TABLE IF NOT EXISTS RELATION(
    id_personne1 INTEGER ,
    id_personne2 INTEGER ,
    id_type_relation INTEGER ,
    CONSTRAINT fk_id_personne1_relation FOREIGN KEY (id_personne1) REFERENCES PERSONNE(id),
    CONSTRAINT fk_id_personne2_relation FOREIGN KEY (id_personne2) REFERENCES PERSONNE(id),
    CONSTRAINT fk_type_relation_relation FOREIGN KEY (id_type_relation) REFERENCES TYPE_RELATION__REF(id)
);
