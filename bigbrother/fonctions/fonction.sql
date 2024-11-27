-- DB BigBrother
-- Creé le 08/11/2024
-- Version 1.0
-- Fonctions de la DataBase
-- fonction.sql 


--Fonction pour avoir les tables des clés etrangères d'une table

-- Fonction pour obtenir les colonnes, tables et colonnes référencées par des clés étrangères dans une table donnée.
CREATE OR REPLACE FUNCTION get_name_table_fk(nom_table TEXT) 
    RETURNS TABLE (
        nom_attribut TEXT,     -- Nom de la colonne avec une clé étrangère
        nom_table_fk TEXT,     -- Nom de la table référencée
        nom_attribut_fk TEXT   -- Nom de la colonne référencée dans la table
    ) AS $$
    BEGIN
        -- Récupération des informations depuis les vues information_schema pour les clés étrangères.
        RETURN QUERY
        SELECT
            kcu.column_name::TEXT,            -- Nom de la colonne dans la table locale
            ccu.table_name::TEXT AS foreign_table,  -- Table étrangère référencée
            ccu.column_name::TEXT AS foreign_column -- Colonne étrangère référencée
        FROM information_schema.key_column_usage AS kcu
        JOIN information_schema.constraint_column_usage AS ccu
            ON ccu.constraint_name = kcu.constraint_name -- Lien par le nom de la contrainte
        WHERE kcu.table_name = nom_table        -- Filtrer pour la table donnée
          AND kcu.constraint_name LIKE 'fk_%'; -- Ne considérer que les contraintes commençant par 'fk_'
    END;
    $$ LANGUAGE plpgsql;

-- Fonction pour récupérer tous les attributs (colonnes) d'une table donnée dans le schéma public.
CREATE OR REPLACE FUNCTION get_attribut_of(nom_table TEXT)
RETURNS TABLE (nom_attribut TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = nom_table
      AND table_schema = 'public'; -- Filtrage limité au schéma public
END;
$$ LANGUAGE plpgsql;

-- Fonction pour créer une table de référence simple avec un identifiant et une colonne unique.
CREATE OR REPLACE FUNCTION create_table_reference(nom_table TEXT) RETURNS VOID AS $$
BEGIN
    CREATE TABLE IF NOT EXISTS nom_table ( -- Si elle n'existe pas déjà
        id SERIAL PRIMARY KEY,            -- Colonne ID auto-incrémentée
        nom VARCHAR(20) UNIQUE            -- Colonne de texte avec une contrainte unique
    );
END;
$$ LANGUAGE plpgsql;

-- Fonction pour créer une table avec des attributs spécifiques, incluant des clés étrangères pour les textes.
CREATE OR REPLACE FUNCTION create_table(nom_table TEXT, attributs TEXT[], attributs_with_type TEXT[]) RETURNS VOID as $$
DECLARE
    requete_creation TEXT; -- Variable pour construire dynamiquement la requête de création
BEGIN
    -- Début de la création de la table avec une colonne ID primaire
    requete_creation := FORMAT('CREATE TABLE IF NOT EXISTS %I ( id SERIAL PRIMARY KEY,', nom_table);

    -- Boucle sur les attributs pour ajouter des colonnes
    FOR i IN 1 .. array_length(attributs, 1)
    LOOP
        -- Si le type est "text", ajouter une clé étrangère vers une table de référence
        IF split_part(attributs_with_type[i],' ',2) IN ('text') THEN
            requete_creation := requete_creation || 'id_' || attributs[i] || ' INTEGER,'; -- Colonne id_<nom> de type entier
            requete_creation := requete_creation || FORMAT(
                'CONSTRAINT fk_id_%I_%I FOREIGN KEY (id_%I) REFERENCES %I__ref(id)', 
                attributs[i], nom_table, attributs[i], attributs[i]
            );
        -- Si le type est une valeur numérique ou temporelle, ajouter directement la colonne
        ELSEIF split_part(attributs_with_type[i],' ',2) IN ('timestamp','integer','date') THEN 
            requete_creation := requete_creation || attributs_with_type[i];
        END IF;

        -- Ajouter une virgule entre les colonnes sauf pour la dernière
        IF i < array_length(attributs, 1) THEN
            requete_creation := requete_creation || ', ';
        END IF;
    END LOOP;

    -- Fermeture de la déclaration de la table
    requete_creation := requete_creation || ')';

    -- Exécution de la requête
    EXECUTE requete_creation;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour créer une table temporaire avec des attributs donnés.
CREATE OR REPLACE FUNCTION create_table_temp(nom_table TEXT, attributs_with_type TEXT[]) RETURNS VOID as $$
DECLARE
    requete_creation TEXT; -- Variable pour construire la requête
BEGIN
    -- Début de la création de la table temporaire
    requete_creation := FORMAT('CREATE TEMP TABLE IF NOT EXISTS %I (', nom_table);

    -- Ajouter chaque attribut avec son type
    FOR i IN 1 .. array_length(attributs_with_type, 1)
    LOOP
        requete_creation := requete_creation || attributs_with_type[i];
        IF i < array_length(attributs_with_type, 1) THEN
            requete_creation := requete_creation || ', ';
        END IF;
    END LOOP;

    -- Fermeture de la déclaration de la table
    requete_creation := requete_creation || ')';

    -- Exécution de la requête
    EXECUTE requete_creation;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_table_with_att(attributs_with_type TEXT[]) RETURNS TEXT[] AS $$
DECLARE
    result TEXT[]; -- Tableau pour stocker les noms des tables de référence trouvées ou créées
    attributs TEXT[]; -- Tableau contenant les noms des attributs sans leurs types
BEGIN
    -- Vectorisation des attributs pour ne garder que les noms sans types
    attributs := vectorisation_att(attributs_with_type, FALSE);

    -- Parcours des attributs
    FOR i IN 1 .. array_length(attributs, 1)
    LOOP
        -- Vérifie si une table de référence existe pour l'attribut courant
        IF concat(attributs[i], '__ref') IN (SELECT table_name FROM information_schema.tables) THEN
            -- Ajoute le nom de la table de référence existante au résultat
            result := result || concat(attributs[i], '__ref');
        -- Si l'attribut est de type timestamp, integer ou date, aucun traitement n'est nécessaire
        ELSEIF split_part(attributs_with_type[i], ' ', 2) IN ('timestamp', 'integer', 'date') THEN
            CONTINUE;
        ELSE
            -- Crée une nouvelle table de référence pour l'attribut
            EXECUTE FORMAT(
                'CREATE TABLE IF NOT EXISTS %I ( id SERIAL PRIMARY KEY, %I VARCHAR(20) UNIQUE NOT NULL)',
                (attributs[i] || '__ref'),
                attributs[i]
            );
            -- Ajoute la table nouvellement créée au résultat
            result := result || concat(attributs[i], '__ref');
        END IF;
    END LOOP;

    -- Retourne la liste des tables de référence trouvées ou créées
    RETURN result;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_ref_table(fk_cor TEXT[], temp_table TEXT) RETURNS VOID AS $$
DECLARE
    column_names TEXT[]; -- Tableau contenant les noms des colonnes à insérer
    filtered_columns TEXT; -- Liste des colonnes filtrées sous forme de chaîne de caractères
BEGIN
    -- Parcours des tables de référence
    FOR i IN 1 .. array_length(fk_cor, 1)
    LOOP
        -- Récupère les noms des colonnes de la table de référence (excluant 'id')
        SELECT array_agg(column_name)
        INTO column_names
        FROM information_schema.columns
        WHERE table_name = fk_cor[i]
          AND column_name != 'id';

        -- Filtre les colonnes existant à la fois dans la table de référence et dans la table temporaire
        SELECT array_agg(column_name)
        INTO column_names
        FROM unnest(column_names) AS unnest_column(column_name)
        WHERE EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_name = temp_table
              AND column_name = unnest_column
        );

        -- Transforme les noms des colonnes filtrées en une chaîne de caractères
        filtered_columns := array_to_string(column_names, ', ');

        -- Si aucune colonne n'est trouvée, passe au tour suivant
        IF column_names IS NULL THEN
            CONTINUE;
        END IF;

        -- Insère les valeurs uniques de la table temporaire dans la table de référence
        EXECUTE FORMAT(
            'INSERT INTO %I (%s) SELECT DISTINCT %s FROM %I WHERE %s IS NOT NULL ON CONFLICT DO NOTHING',
            fk_cor[i],        -- Table de référence
            filtered_columns, -- Colonnes de destination
            filtered_columns, -- Colonnes source
            temp_table,       -- Table temporaire source
            filtered_columns  -- Conditions de non-nullité
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION vectorisation_att(attributs TEXT[], with_type BOOLEAN) RETURNS TEXT[] AS $$
BEGIN
    -- Parcours des attributs
    FOR i IN 1 .. array_length(attributs, 1)
    LOOP
        -- Convertit l'attribut en minuscules
        attributs[i] := lower(attributs[i]);
        
        -- Si `with_type` est faux, supprime les informations de type
        IF NOT with_type THEN
            -- Supprime les attributs contenant 'id'
            IF position('id' IN attributs[i]) > 0 THEN
                PERFORM array_remove(attributs, attributs[i]);
            END IF;

            -- Conserve uniquement la partie avant le premier espace
            attributs[i] := split_part(attributs[i], ' ', 1);
        END IF;
    END LOOP;

    -- Retourne le tableau nettoyé
    RETURN attributs;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fill_table(
    nom_table TEXT, 
    attributs TEXT[], 
    attributs_with_type TEXT[]
) RETURNS VOID AS $$
DECLARE
    requete_insertion TEXT;       -- Requête finale d'insertion
    requete_joins TEXT := '';     -- Requêtes de jointures pour les références
    colonnes_destination TEXT;    -- Colonnes de la table cible
    colonnes_source TEXT;         -- Colonnes correspondantes dans la table temporaire
    update_set TEXT;              -- Clause `UPDATE SET` pour gérer les conflits
    i INTEGER;                    -- Index pour les boucles
    colonne_unique TEXT;          -- Définition de l'unicité des colonnes
BEGIN
    -- Création de la liste des colonnes de destination (ex. : `id_nom, age`)
    colonnes_destination := array_to_string(
        ARRAY(SELECT CASE
                      WHEN split_part(attributs_with_type[gs.i], ' ', 2) = 'text' THEN 'id_' || attributs[gs.i]
                      ELSE attributs[gs.i]
                   END
        FROM generate_subscripts(attributs_with_type, 1) AS gs(i)), ', ');

    -- Création de la liste des colonnes source (ex. : `ref_nom.id, age`)
    colonnes_source := array_to_string(
        ARRAY(SELECT CASE
                      WHEN split_part(attributs_with_type[gs.i], ' ', 2) = 'text' THEN 'ref_' || attributs[gs.i] || '.id'
                      ELSE attributs[gs.i]
                   END
        FROM generate_subscripts(attributs_with_type, 1) AS gs(i)), ', ');

    -- Création des jointures nécessaires pour les attributs textuels
    FOR i IN 1 .. array_length(attributs_with_type, 1) LOOP
        IF split_part(attributs_with_type[i], ' ', 2) = 'text' THEN
            requete_joins := requete_joins || FORMAT(
                'LEFT JOIN %I__ref AS ref_%s ON src.%I = ref_%s.%s ',
                attributs[i], attributs[i], attributs[i], attributs[i], attributs[i]
            );
        END IF;
    END LOOP;

    -- Création de la clause `UPDATE SET` pour les conflits (mise à jour en cas de conflit sur les clés)
    update_set := array_to_string(
        ARRAY(SELECT FORMAT(
            '%s = COALESCE(EXCLUDED.%s, %I.%s)',
            CASE
                WHEN split_part(attributs_with_type[gs.i], ' ', 2) = 'text' THEN 'id_' || attributs[gs.i]
                ELSE attributs[gs.i]
            END,
            CASE
                WHEN split_part(attributs_with_type[gs.i], ' ', 2) = 'text' THEN 'id_' || attributs[gs.i]
                ELSE attributs[gs.i]
            END,
            nom_table,
            CASE
                WHEN split_part(attributs_with_type[gs.i], ' ', 2) = 'text' THEN 'id_' || attributs[gs.i]
                ELSE attributs[gs.i]
            END
        )
        FROM generate_subscripts(attributs_with_type, 1) AS gs(i)), ', ');

    -- Vérifie si une contrainte UNIQUE existe pour les colonnes de destination
    colonne_unique := colonnes_destination;
    PERFORM 1
    FROM pg_constraint
    WHERE conrelid = nom_table::regclass
      AND contype = 'u'
      AND pg_get_constraintdef(oid) LIKE FORMAT('UNIQUE (%s)', colonnes_destination);

    -- Si aucune contrainte UNIQUE n'existe, en ajoute une
    IF NOT FOUND THEN
        EXECUTE FORMAT(
            'ALTER TABLE %I ADD CONSTRAINT %I_unique_constraint UNIQUE (%s);',
            nom_table,
            nom_table,
            colonnes_destination
        );
    END IF;

    -- Construction de la requête d'insertion avec jointures et gestion des conflits
    requete_insertion := FORMAT(
        'INSERT INTO %I (%s)
        SELECT %s
        FROM temp_table src %s
        ON CONFLICT (%s)
        DO UPDATE SET %s;',
        nom_table,          -- Table cible
        colonnes_destination, -- Colonnes de destination
        colonnes_source,      -- Colonnes source
        requete_joins,        -- Jointures pour les références
        colonne_unique,       -- Colonnes uniques pour détecter les conflits
        update_set            -- Mise à jour en cas de conflit
    );

    -- Exécute la requête d'insertion
    EXECUTE requete_insertion;
END;
$$ LANGUAGE plpgsql;







CREATE OR REPLACE FUNCTION import_fichier(chemin_relatif TEXT, nom_table TEXT)
RETURNS VOID AS $$
DECLARE
    chemin_fichier TEXT := '/Users/alexandrehergaux/Library/Mobile Documents/com~apple~CloudDocs/ETUDES/EIDD/2A/S7/Base_de_donnees/Projet/bigbrother/' || chemin_relatif;
    entete TEXT;                   -- Ligne d'en-tête du fichier CSV
    attributs TEXT[];              -- Tableau des noms d'attributs sans types
    attributs_with_type TEXT[];    -- Tableau des attributs avec types
    requete_creation TEXT;         -- Requête de création
    fk_cor TEXT[];                 -- Liste des tables de référence à remplir
BEGIN
    -- Lecture de l'en-tête du fichier pour récupérer les attributs
    entete := pg_read_file(chemin_fichier);
    entete := split_part(entete, E'\n', 1);

    -- Transformation de l'en-tête en tableau de noms avec types
    attributs_with_type := string_to_array(entete, ',');
    attributs_with_type := vectorisation_att(attributs_with_type, TRUE); -- Avec types
    attributs := vectorisation_att(attributs_with_type, FALSE);          -- Sans types

    -- Création d'une table temporaire pour importer les données brutes
    PERFORM create_table_temp('temp_table', attributs_with_type);

    -- Importation des données CSV dans la table temporaire
    EXECUTE FORMAT('COPY temp_table FROM %L WITH (FORMAT csv, HEADER true)', chemin_fichier);

    -- Vérifie et crée les tables de référence nécessaires
    fk_cor := check_table_with_att(attributs_with_type);

    -- Remplit les tables de référence avec les données distinctes
    PERFORM fill_ref_table(fk_cor, 'temp_table');

    -- Crée la table cible avec les colonnes nécessaires
    PERFORM create_table(nom_table, attributs, attributs_with_type);

    -- Remplit la table cible avec les données transformées
    PERFORM fill_table(nom_table, attributs, attributs_with_type);

    -- Supprime la table temporaire après usage
    EXECUTE 'DROP TABLE IF EXISTS temp_table';

    -- Affiche un message de confirmation
    RAISE NOTICE 'Données importées dans la table %', nom_table;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION lier_personne_import(nom_table_import TEXT) RETURNS VOID AS $$
DECLARE
    rec RECORD;
    imported_columns TEXT[];
    personne_columns TEXT[];
    attrs_identity TEXT[];
    attrs_present TEXT[];
    threshold REAL := 1e-6; -- Ajustez ce seuil selon vos besoins
    personne_id INTEGER;
    min_score REAL;
    coeff REAL;
    total_count REAL;
    value_count REAL;
    attr_conditions TEXT;
    attr TEXT;
    val TEXT;
BEGIN
    -- Récupérer les colonnes de la table importée
    SELECT array_agg(column_name)
    INTO imported_columns
    FROM information_schema.columns
    WHERE table_name = nom_table_import
      AND table_schema = 'public';

    -- Récupérer les colonnes de la table personne
    SELECT array_agg(column_name)
    INTO personne_columns
    FROM information_schema.columns
    WHERE table_name = 'personne'
      AND table_schema = 'public';

    -- Définir les attributs d'identité possibles
    attrs_identity := ARRAY['id_nom', 'id_prenom', 'date_naissance', 'id_ville_naissance', 'id_genre'];

    -- Trouver les attributs communs
    attrs_present := ARRAY(SELECT unnest(attrs_identity) INTERSECT SELECT unnest(imported_columns) INTERSECT SELECT unnest(personne_columns));

    IF array_length(attrs_present, 1) IS NULL THEN
        RAISE WARNING 'Aucun attribut commun entre la table importée et la table personne.';
        RETURN;
    END IF;

    -- Ajouter la colonne id_personne à la table importée si elle n'existe pas
    EXECUTE FORMAT('ALTER TABLE %I ADD COLUMN IF NOT EXISTS id_personne INTEGER', nom_table_import);

    -- Boucle sur chaque enregistrement de la table importée
    FOR rec IN EXECUTE FORMAT('SELECT * FROM %I', nom_table_import) LOOP
        attr_conditions := '';
        min_score := 1.0;

        -- Construire les conditions de correspondance et calculer le score
        FOREACH attr IN ARRAY attrs_present LOOP
            -- Récupérer la valeur de l'attribut pour l'enregistrement courant
            EXECUTE FORMAT('SELECT %I FROM %I WHERE id = %s', attr, nom_table_import, rec.id) INTO val;

            IF val IS NOT NULL THEN
                -- Calcul du coefficient pour cet attribut
                EXECUTE FORMAT('SELECT COUNT(*)::REAL FROM personne WHERE %I IS NOT NULL', attr) INTO total_count;
                EXECUTE FORMAT('SELECT COUNT(*)::REAL FROM personne WHERE %I = %L', attr, val) INTO value_count;

                IF total_count > 0 THEN
                    coeff := value_count / total_count;
                ELSE
                    coeff := 1.0; -- Coefficient neutre si aucune donnée n'est disponible
                END IF;

                min_score := min_score * coeff;

                -- Ajouter la condition pour la requête de correspondance
                attr_conditions := attr_conditions || FORMAT('%I = %L AND ', attr, val);
            END IF;
        END LOOP;

        -- Supprimer le dernier 'AND ' de attr_conditions
        IF attr_conditions <> '' THEN
            attr_conditions := left(attr_conditions, length(attr_conditions) - 5);
        END IF;

        IF attr_conditions <> '' THEN
            -- Rechercher les personnes correspondantes
            EXECUTE FORMAT('SELECT id FROM personne WHERE %s LIMIT 1', attr_conditions) INTO personne_id;

            IF personne_id IS NOT NULL AND min_score <= threshold THEN
                -- Lier l'enregistrement importé à la personne existante
                EXECUTE FORMAT('UPDATE %I SET id_personne = %s WHERE id = %s', nom_table_import, personne_id, rec.id);
            ELSE
                -- Créer une nouvelle personne
                personne_id := creer_nouvelle_personne_from_import(nom_table_import, rec.id, attrs_present);
                -- Mettre à jour la table importée avec le nouvel ID de personne
                EXECUTE FORMAT('UPDATE %I SET id_personne = %s WHERE id = %s', nom_table_import, personne_id, rec.id);
            END IF;
        ELSE
            -- Si aucun attribut d'identité n'est présent, créer une nouvelle personne
            personne_id := creer_nouvelle_personne_from_import(nom_table_import, rec.id, attrs_present);
            EXECUTE FORMAT('UPDATE %I SET id_personne = %s WHERE id = %s', nom_table_import, personne_id, rec.id);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION creer_nouvelle_personne_from_import(nom_table_import TEXT, import_id INTEGER, attrs_present TEXT[]) RETURNS INTEGER AS $$
DECLARE
    insert_columns TEXT := '';
    insert_values TEXT := '';
    attr TEXT;
    val TEXT;
    new_personne_id INTEGER;
BEGIN
    FOREACH attr IN ARRAY attrs_present LOOP
        -- Récupérer la valeur de l'attribut depuis la table importée
        EXECUTE FORMAT('SELECT %I FROM %I WHERE id = %s', attr, nom_table_import, import_id) INTO val;

        IF val IS NOT NULL THEN
            insert_columns := insert_columns || FORMAT('%I, ', attr);
            insert_values := insert_values || FORMAT('%L, ', val);
        END IF;
    END LOOP;

    -- Retirer la dernière virgule et l'espace
    IF insert_columns <> '' THEN
        insert_columns := left(insert_columns, length(insert_columns) - 2);
        insert_values := left(insert_values, length(insert_values) - 2);

        -- Insérer la nouvelle personne
        EXECUTE FORMAT('INSERT INTO personne (%s) VALUES (%s) RETURNING id', insert_columns, insert_values) INTO new_personne_id;
    ELSE
        -- Insérer une nouvelle personne avec des valeurs par défaut
        EXECUTE 'INSERT INTO personne DEFAULT VALUES RETURNING id' INTO new_personne_id;
    END IF;

    RETURN new_personne_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION creer_nouvelle_personne_dynamic(
    nom_table_import TEXT,
    import_id INTEGER,
    attrs_present TEXT[]
) RETURNS INTEGER AS $$
DECLARE
    insert_columns TEXT := '';
    insert_values TEXT := '';
    attr TEXT;
    val TEXT;
    new_personne_id INTEGER;
    ref_table TEXT;
    ref_id_col TEXT;
    ref_val_col TEXT;
    ref_id INTEGER;
    attr_import TEXT;
    i INTEGER;
BEGIN
    -- Check if attrs_present is NULL or empty
    IF attrs_present IS NULL OR array_length(attrs_present, 1) IS NULL THEN
        RAISE WARNING 'attrs_present is NULL or empty. No attributes to process.';
        -- Insert a new person with default values if attrs_present is NULL or empty
        EXECUTE 'INSERT INTO personne DEFAULT VALUES RETURNING id' INTO new_personne_id;
        RETURN new_personne_id;
    END IF;

    FOR i IN 1 .. array_length(attrs_present, 1) LOOP
        attr := attrs_present[i];

        -- Determine the corresponding attribute in the imported table
        IF attr LIKE 'id_%' THEN
            attr_import := lower(substring(attr FROM 4)); -- Ex: 'id_nom' => 'nom'
        ELSE
            attr_import := attr;
        END IF;

        -- Get the value of the attribute from the imported table
        EXECUTE FORMAT('SELECT %I FROM %I WHERE id = %s', attr_import, nom_table_import, import_id) INTO val;

        IF val IS NOT NULL THEN
            IF attr LIKE 'id_%' THEN
                -- Handle the reference table
                ref_table := upper(substring(attr FROM 4)) || '__REF'; -- Ex: 'id_nom' => 'NOM__REF'
                ref_id_col := 'id';
                ref_val_col := lower(substring(attr FROM 4)); -- Ex: 'id_nom' => 'nom'

                -- Check if the value exists in the reference table
                EXECUTE FORMAT('SELECT %I FROM %I WHERE %I = %L', ref_id_col, ref_table, ref_val_col, val) INTO ref_id;
                IF ref_id IS NULL THEN
                    -- Insert the value into the reference table
                    EXECUTE FORMAT('INSERT INTO %I (%I) VALUES (%L) RETURNING %I', ref_table, ref_val_col, val, ref_id_col) INTO ref_id;
                END IF;

                insert_columns := insert_columns || FORMAT('%I, ', attr);
                insert_values := insert_values || FORMAT('%s, ', ref_id);
            ELSE
                insert_columns := insert_columns || FORMAT('%I, ', attr);
                insert_values := insert_values || FORMAT('%L, ', val);
            END IF;
        END IF;
    END LOOP;

    -- Remove the last comma and space
    IF insert_columns <> '' THEN
        insert_columns := left(insert_columns, length(insert_columns) - 2);
        insert_values := left(insert_values, length(insert_values) - 2);

        -- Insert the new person
        EXECUTE FORMAT('INSERT INTO personne (%s) VALUES (%s) RETURNING id', insert_columns, insert_values) INTO new_personne_id;
    ELSE
        -- Insert a new person with default values
        EXECUTE 'INSERT INTO personne DEFAULT VALUES RETURNING id' INTO new_personne_id;
    END IF;

    RETURN new_personne_id;
END;
$$ LANGUAGE plpgsql;
