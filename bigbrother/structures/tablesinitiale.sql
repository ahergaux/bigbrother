-- DB BigBrother
-- Creé le 08/11/2024
-- Version 1.0
-- Tables initiale de la DataBase
-- tablesinitiale.sql

-- TABLE PERSONNE

CREATE TABLE IF NOT EXISTS PERSONNE (
    id SERIAL PRIMARY KEY,
    id_nom INTEGER,
    id_prenom INTEGER,
    date_naissance TIMESTAMP,
    id_ville_naissance INTEGER,
    id_genre INTEGER,
    CONSTRAINT fk_id_nom_personne FOREIGN KEY (id_nom) REFERENCES NOM__REF(id),
    CONSTRAINT fk_id_prenom_personne FOREIGN KEY (id_prenom) REFERENCES PRENOM__REF(id),
    CONSTRAINT fk_id_ville_naissance_personne FOREIGN KEY (id_ville_naissance) REFERENCES VILLE__REF(id),
    CONSTRAINT fk_genre_personne FOREIGN KEY (id_genre) REFERENCES GENRE__REF(id)
);

CREATE TABLE IF NOT EXISTS ADRESSE_POSTALE(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    id_adresse_postale INTEGER ,
    CONSTRAINT fk_id_personne_adresse_postale FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_adresse_postale_adresse_postale FOREIGN KEY (id_adresse_postale) REFERENCES ADRESSE__REF(id)
);


CREATE TABLE IF NOT EXISTS NUMERO_TEL(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    numero_tel INTEGER ,
    CONSTRAINT fk_id_personne_numero_tel FOREIGN KEY (id_personne) REFERENCES PERSONNE(id)
);


CREATE TABLE IF NOT EXISTS ADRESSE_MAIL(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    id_adresse_mail INTEGER ,
    CONSTRAINT fk_id_personne_adresse_mail FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_id_adresse_mail_adresse_mail FOREIGN KEY (id_personne) REFERENCES ADRESSE_MAIL__REF(id)

);


CREATE TABLE IF NOT EXISTS RESEAUX(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER ,
    id_reseaux INTEGER,
    CONSTRAINT fk_id_personne_reseaux_personne FOREIGN KEY (id_personne) REFERENCES PERSONNE(id)
);

