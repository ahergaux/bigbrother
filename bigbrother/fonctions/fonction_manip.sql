-- DB BigBrother
-- Creé le 10/11/2024
-- Version 1.0
-- Fonctions pas utile de la DataBase
-- fonctionusless.sql 


--fonction de debogage
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

--fonction pour rajouter des personnes,  Exemple d'utilisation dans exemple.sql
CREATE OR REPLACE FUNCTION inserer_personne(
        p_nom TEXT,
        p_prenom TEXT,
        p_date_naissance DATE,
        p_ville_naissance TEXT,
        p_genre TEXT
    ) RETURNS INTEGER AS $$
    DECLARE
        v_id_nom INTEGER;
        v_id_prenom INTEGER;
        v_id_ville INTEGER;
        v_id_genre INTEGER;
        v_id_personne INTEGER;
    BEGIN
        -- Vérifier ou insérer le nom
        SELECT id INTO v_id_nom FROM NOM__REF WHERE nom = p_nom;
        IF v_id_nom IS NULL THEN
            INSERT INTO NOM__REF(nom) VALUES (p_nom) RETURNING id INTO v_id_nom;
        END IF;

        -- Vérifier ou insérer le prénom
        SELECT id INTO v_id_prenom FROM PRENOM__REF WHERE prenom = p_prenom;
        IF v_id_prenom IS NULL THEN
            INSERT INTO PRENOM__REF(prenom) VALUES (p_prenom) RETURNING id INTO v_id_prenom;
        END IF;

        -- Vérifier ou insérer la ville de naissance
        SELECT id INTO v_id_ville FROM VILLE__REF WHERE ville = p_ville_naissance;
        IF v_id_ville IS NULL THEN
            INSERT INTO VILLE__REF(ville) VALUES (p_ville_naissance) RETURNING id INTO v_id_ville;
        END IF;

        -- Vérifier ou insérer le genre
        SELECT id INTO v_id_genre FROM GENRE__REF WHERE genre = p_genre;
        IF v_id_genre IS NULL THEN
            INSERT INTO GENRE__REF(genre) VALUES (p_genre) RETURNING id INTO v_id_genre;
        END IF;

        -- Insérer la personne
        INSERT INTO PERSONNE(id_nom, id_prenom, date_naissance, id_ville_naissance, id_genre)
        VALUES (v_id_nom, v_id_prenom, p_date_naissance, v_id_ville, v_id_genre)
        RETURNING id INTO v_id_personne;

        RETURN v_id_personne;
    END;
    $$ LANGUAGE plpgsql;

--fonction pour rajouter des adresse,  Exemple d'utilisation dans exemple.sql
CREATE OR REPLACE FUNCTION ajouter_adresse_postale(
        p_id_personne INTEGER,
        p_numero INTEGER,
        p_rue TEXT,
        p_ville TEXT,
        p_debut DATE,
        p_fin DATE DEFAULT NULL
    ) RETURNS INTEGER AS $$
    DECLARE
        v_id_ville INTEGER;
        v_id_rue INTEGER;
        v_id_adresse INTEGER;
        v_id_adresse_postale INTEGER;
    BEGIN
        -- Vérifier ou insérer la ville
        SELECT id INTO v_id_ville FROM VILLE__REF WHERE ville = p_ville;
        IF v_id_ville IS NULL THEN
            INSERT INTO VILLE__REF(ville) VALUES (p_ville) RETURNING id INTO v_id_ville;
        END IF;

        -- Vérifier ou insérer la rue
        SELECT id INTO v_id_rue FROM RUE__REF WHERE rue = p_rue;
        IF v_id_rue IS NULL THEN
            INSERT INTO RUE__REF(rue) VALUES (p_rue) RETURNING id INTO v_id_rue;
        END IF;

        -- Vérifier ou insérer l'adresse
        SELECT id INTO v_id_adresse FROM ADRESSE__REF WHERE numero = p_numero AND id_rue = v_id_rue AND id_ville = v_id_ville;
        IF v_id_adresse IS NULL THEN
            INSERT INTO ADRESSE__REF(numero, id_rue, id_ville) VALUES (p_numero, v_id_rue, v_id_ville) RETURNING id INTO v_id_adresse;
        END IF;

        -- Insérer l'adresse postale
        INSERT INTO ADRESSE_POSTALE(id_personne, adresse_postale, debut, fin)
        VALUES (p_id_personne, v_id_adresse, p_debut, p_fin)
        RETURNING id INTO v_id_adresse_postale;

        RETURN v_id_adresse_postale;
    END;
    $$ LANGUAGE plpgsql;

-- Fonction pour joindre les attributs des vues avec leurs clée étrangères
CREATE OR REPLACE FUNCTION dynamic_join_view(view_name TEXT) RETURNS TEXT AS $$
    DECLARE
        ref_query TEXT := 'SELECT ';
        col_name TEXT;
        t_n TEXT;
        join_clause TEXT := '';
    BEGIN
        -- Obtenir les colonnes de la vue
        FOR col_name IN
            SELECT column_name
            FROM information_schema.columns
            WHERE table_name = view_name AND column_name LIKE 'id_%'
        LOOP
            -- Déduire le nom de la table de référence
            t_n := replace(col_name, 'id_', '') || '__ref';

            -- Ajouter les colonnes de la table de référence dans la requête
            ref_query := ref_query || format('%s.* AS %s_ref_columns, ', t_n, t_n);

            -- Ajouter la jointure avec la table de référence
            join_clause := join_clause || format(' LEFT JOIN %I ON %I.id = %I.%s', 
                                                t_n, 
                                                t_n, 
                                                view_name, 
                                                col_name);
        END LOOP;

        -- Retirer la dernière virgule de ref_query
        ref_query := left(ref_query, length(ref_query) - 2);

        -- Construire la requête complète
        ref_query := ref_query || format(' FROM %I %s', view_name, join_clause);

        -- Retourner la requête finale
        RETURN ref_query;
    END;
    $$ LANGUAGE plpgsql;

-- Fonction pour joindre les attributs des tables avec leurs clée étrangères
CREATE OR REPLACE FUNCTION dynamic_join_table(nom_table TEXT) RETURNS TEXT AS $$
    DECLARE
        join_query TEXT := '';  -- Requête de jointure complète
        select_columns TEXT := 'SELECT t.*';  -- Sélection des colonnes de la table principale
        fk_record RECORD;  -- Enregistrement pour itérer sur les résultats de get_name_table_fk
    BEGIN
        -- Parcours des colonnes avec clés étrangères
        FOR fk_record IN SELECT * FROM get_name_table_fk(nom_table)
        LOOP
            -- Ajouter les colonnes des tables de référence au SELECT
            select_columns := select_columns || format(', %I.* AS %I_columns', fk_record.nom_table_fk, fk_record.nom_table_fk);

            -- Ajouter les jointures
            join_query := join_query || format(
                ' LEFT JOIN %I ON t.%I = %I.%I',
                fk_record.nom_table_fk,       -- Table de référence
                fk_record.nom_attribut,       -- Colonne locale (clé étrangère)
                fk_record.nom_table_fk,       -- Table de référence
                fk_record.nom_attribut_fk     -- Colonne référencée
            );
        END LOOP;

        -- Construire la requête complète
        join_query := select_columns || format(' FROM %I AS t', nom_table) || join_query;

        -- Retourner la requête complète
        RETURN join_query;
    END;
    $$ LANGUAGE plpgsql;

-- Fonction pour créer une table d'audit et un trigger pour une table donnée
CREATE OR REPLACE FUNCTION create_audit_changes(nom_table TEXT) RETURNS VOID AS $$
    BEGIN
        -- Création de la table d'audit si elle n'existe pas
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS %I_audit (
                id SERIAL PRIMARY KEY,
                operation VARCHAR(10),
                modifie_par TEXT,
                modifie_le TIMESTAMP,
                anciennes_valeurs JSONB,
                nouvelles_valeurs JSONB
            );
        ', nom_table);

        -- Création de la fonction du trigger d'audit
        EXECUTE format('
            CREATE OR REPLACE FUNCTION %I_audit_changes()
            RETURNS TRIGGER AS $func$
            BEGIN
                INSERT INTO %I_audit (
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
                IF TG_OP = ''DELETE'' THEN
                    RETURN OLD;
                ELSE
                    RETURN NEW;
                END IF;
            END;
            $func$ LANGUAGE plpgsql;
        ', nom_table, nom_table);

        -- Création du trigger d'audit
        EXECUTE format('
            DROP TRIGGER IF EXISTS trg_%I_audit_changes ON %I;
            CREATE TRIGGER trg_%I_audit_changes
            AFTER INSERT OR UPDATE OR DELETE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION %I_audit_changes();
        ', nom_table, nom_table, nom_table, nom_table, nom_table);

        RAISE NOTICE 'trigger add : %_audit_changes',nom_table; 
    END;
    $$ LANGUAGE plpgsql;
