-- Table pour stocker les audits
CREATE TABLE IF NOT EXISTS personne_audit (
    id SERIAL PRIMARY KEY,
    personne_id INTEGER,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_personne_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO personne_audit (
        personne_id,
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        COALESCE(OLD.id, NEW.id),
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_personne_changes
AFTER INSERT OR UPDATE OR DELETE ON personne
FOR EACH ROW
EXECUTE FUNCTION audit_personne_changes();

-- Ajouter une colonne updated_at à la table personne si elle n'existe pas déjà
ALTER TABLE personne ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

-- Fonction du trigger pour mettre à jour le champ updated_at
CREATE OR REPLACE FUNCTION update_personne_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Création du trigger
CREATE TRIGGER trg_update_personne_updated_at
BEFORE UPDATE OR INSERT ON personne
FOR EACH ROW
EXECUTE FUNCTION update_personne_updated_at();



--tout ajouter
CREATE TABLE IF NOT EXISTS adresse_postale_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_adresse_postale_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO adresse_postale_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_adresse_postale_changes
AFTER INSERT OR UPDATE OR DELETE ON adresse_postale
FOR EACH ROW
EXECUTE FUNCTION audit_adresse_postale_changes();


--tout ajouter
CREATE TABLE IF NOT EXISTS numero_tel_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_numero_tel_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO numero_tel_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_numero_tel_changes
AFTER INSERT OR UPDATE OR DELETE ON numero_tel
FOR EACH ROW
EXECUTE FUNCTION audit_numero_tel_changes();



--tout ajouter
CREATE TABLE IF NOT EXISTS adresse_mail_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_adresse_mail_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO adresse_mail_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_adresse_mail_changes
AFTER INSERT OR UPDATE OR DELETE ON adresse_mail
FOR EACH ROW
EXECUTE FUNCTION audit_adresse_mail_changes();



--tout ajouter
CREATE TABLE IF NOT EXISTS reseaux_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_reseaux_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO reseaux_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_audit_reseaux_changes
AFTER INSERT OR UPDATE OR DELETE ON reseaux
FOR EACH ROW
EXECUTE FUNCTION audit_reseaux_changes();

--tout ajouter
CREATE TABLE IF NOT EXISTS nom__ref_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_nom__ref_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO nom__ref_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_nom__ref_changes
AFTER INSERT OR UPDATE OR DELETE ON nom__ref
FOR EACH ROW
EXECUTE FUNCTION audit_nom__ref_changes();


CREATE TABLE IF NOT EXISTS prenom__ref_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_prenom__ref_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO prenom__ref_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_prenom__ref_changes
AFTER INSERT OR UPDATE OR DELETE ON prenom__ref
FOR EACH ROW
EXECUTE FUNCTION audit_prenom__ref_changes();




CREATE TABLE IF NOT EXISTS ville__ref_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_ville__ref_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO ville__ref_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_ville__ref_changes
AFTER INSERT OR UPDATE OR DELETE ON ville__ref
FOR EACH ROW
EXECUTE FUNCTION audit_ville__ref_changes();




CREATE TABLE IF NOT EXISTS rue__ref_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_rue__ref_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO rue__ref_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_rue__ref_changes
AFTER INSERT OR UPDATE OR DELETE ON rue__ref
FOR EACH ROW
EXECUTE FUNCTION audit_rue__ref_changes();



CREATE TABLE IF NOT EXISTS adresse__ref_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_adresse__ref_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO adresse__ref_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_adresse__ref_changes
AFTER INSERT OR UPDATE OR DELETE ON adresse__ref
FOR EACH ROW
EXECUTE FUNCTION audit_adresse__ref_changes();


CREATE TABLE IF NOT EXISTS genre__ref_audit (
    id SERIAL PRIMARY KEY,
    operation VARCHAR(10),
    modifie_par TEXT,
    modifie_le TIMESTAMP,
    anciennes_valeurs JSONB,
    nouvelles_valeurs JSONB
);


-- Fonction du trigger pour auditer les modifications
CREATE OR REPLACE FUNCTION audit_genre__ref_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO genre__ref_audit (
        operation,
        modifie_par,
        modifie_le,
        anciennes_valeurs,
        nouvelles_valeurs
    ) VALUES (
        TG_OP,
        CURRENT_USER,
        NOW(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_genre__ref_changes
AFTER INSERT OR UPDATE OR DELETE ON genre__ref
FOR EACH ROW
EXECUTE FUNCTION audit_genre__ref_changes();