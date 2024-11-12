-- DB BigBrother
-- Creé le 08/11/2024
-- Version 1.0
-- Tables initiale de la DataBase
-- tablesinitiale.sql

-- TABLE PERSONNE

CREATE TABLE IF NOT EXISTS PERSONNE (
    id SERIAL PRIMARY KEY,
    id_nom INTEGER NOT NULL,
    id_prenom INTEGER NOT NULL,-- PRIMARY KEY avec id_nom et date_naissance ? Pour simplifier ?
    date_naissance TIMESTAMP NOT NULL, -- QUESTION SUR LES PRIMARY KEY
    id_ville_naissance INTEGER NOT NULL,
    nationalite VARCHAR(10),
    id_genre INTEGER NOT NULL,
    CONSTRAINT fk_id_nom_personne FOREIGN KEY (id_nom) REFERENCES NOM(id),
    CONSTRAINT fk_id_prenom_personne FOREIGN KEY (id_prenom) REFERENCES PRENOM(id),
    CONSTRAINT fk_id_ville_naissance_personne FOREIGN KEY (id_ville_naissance) REFERENCES VILLE(id),
    CONSTRAINT fk_genre_personne FOREIGN KEY (id_genre) REFERENCES GENRE(id)
);


CREATE TABLE IF NOT EXISTS ADRESSE_POSTALE(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER NOT NULL,
    adresse INTEGER NOT NULL,
    debut TIMESTAMP NOT NULL,
    fin TIMESTAMP,
    CONSTRAINT fk_id_personne_adresse_postale FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_adresse_adresse_postale FOREIGN KEY (adresse) REFERENCES ADRESSE(id),
    CHECK (fin>=debut)
);


CREATE TABLE IF NOT EXISTS NUMERO_TEL(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER NOT NULL,
    numero INTEGER NOT NULL,
    indicatif INTEGER,
    CONSTRAINT fk_id_personne_numero_tel FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_indicatif_numero_tel FOREIGN KEY (indicatif) REFERENCES PAYS(indicatif)
);


CREATE TABLE IF NOT EXISTS ADRESSE_MAIL(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER NOT NULL,
    adresse VARCHAR(50) NOT NULL,
    CONSTRAINT fk_id_personne_adresse_mail FOREIGN KEY (id_personne) REFERENCES PERSONNE(id)
);


CREATE TABLE IF NOT EXISTS RESEAUX_PERSONNE(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER NOT NULL,
    id_reseau INTEGER NOT NULL,
    alias VARCHAR(30),
    CONSTRAINT fk_id_personne_reseaux_personne FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CONSTRAINT fk_id_reseau_reseaux_personne FOREIGN KEY (id_reseau) REFERENCES RESEAUX(id)
);

CREATE TABLE IF NOT EXISTS GEOLOC(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER NOT NULL,
    adresse INTEGER NOT NULL,
    date TIMESTAMP NOT NULL,
    CONSTRAINT fk_adresse_geoloc FOREIGN KEY (adresse) REFERENCES ADRESSE(id),
    CONSTRAINT fk_id_personne_geoloc FOREIGN KEY (id_personne) REFERENCES PERSONNE(id)
);

CREATE TABLE IF NOT EXISTS SITUATION_MATRIMONIALE(
    id SERIAL PRIMARY KEY,
    id_personne INTEGER NOT NULL,
    id_situation_matrimoniale INTEGER NOT NULL,
    debut TIMESTAMP NOT NULL,
    fin TIMESTAMP,
    CONSTRAINT fk_situation_matrimoniale_situation_matrimoniale FOREIGN KEY (id_situation_matrimoniale) REFERENCES SITUATION_MATRIMONIALE(id),
    CONSTRAINT fk_id_personne_situation_matrimoniale FOREIGN KEY (id_personne) REFERENCES PERSONNE(id),
    CHECK (fin>=debut)
);


CREATE TABLE IF NOT EXISTS RELATION(
    id_personne1 INTEGER NOT NULL,
    id_personne2 INTEGER NOT NULL,
    id_type_relation INTEGER NOT NULL,
    CONSTRAINT fk_id_personne1_relation FOREIGN KEY (id_personne1) REFERENCES PERSONNE(id),
    CONSTRAINT fk_id_personne2_relation FOREIGN KEY (id_personne2) REFERENCES PERSONNE(id),
    CONSTRAINT fk_type_relation_relation FOREIGN KEY (id_type_relation) REFERENCES TYPE_RELATION(id)
);
