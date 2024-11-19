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

CREATE OR REPLACE FUNCTION get_attribut_of(nom_table TEXT) RETURNS TABLE ( nom_attribut TEXT) AS $$
    BEGIN
        RETURN QUERY
        SELECT column_name::TEXT FROM information_schema.columns AS c WHERE c.table_name=nom_table;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_table_reference(nom_table TEXT) RETURNS VOID AS $$
    BEGIN
        CREATE TABLE IF NOT EXISTS nom_table (
        id SERIAL PRIMARY KEY,
        nom VARCHAR(20) UNIQUE
    );
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_table(nom_table TEXT, attributs TEXT[], attributs_with_type TEXT[]) RETURNS VOID as $$
    DECLARE
        requete_creation TEXT;
    
    BEGIN
    requete_creation := FORMAT('CREATE TABLE IF NOT EXISTS %I ( id SERIAL PRIMARY KEY,', nom_table);
        FOR i IN 1 .. array_length(attributs, 1)
        LOOP
            IF split_part(attributs_with_type[i],' ',2) IN ('text') THEN
                requete_creation := requete_creation || 'id_' || attributs[i] || ' INTEGER,';
                requete_creation := requete_creation || FORMAT('CONSTRAINT fk_id_%I_%I FOREIGN KEY (id_%I) REFERENCES %I__ref(id)',attributs[i],nom_table,attributs[i],attributs[i]);
            ELSEIF split_part(attributs_with_type[i],' ',2) IN ('timestamp','integer','date') THEN 
                requete_creation := requete_creation || attributs_with_type[i];
            END IF;
            IF i < array_length(attributs, 1) THEN
                requete_creation := requete_creation || ', ';
            END IF;
        END LOOP;
        requete_creation := requete_creation || ')';
        EXECUTE requete_creation;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_table_temp(nom_table TEXT, attributs_with_type TEXT[]) RETURNS VOID as $$
    DECLARE
        requete_creation TEXT;
    BEGIN
        requete_creation:= FORMAT('CREATE TEMP TABLE IF NOT EXISTS %I (',nom_table);
        FOR i IN 1 .. array_length(attributs_with_type,1)
        LOOP
            requete_creation:= requete_creation || attributs_with_type[i];
            IF i < array_length(attributs_with_type,1) THEN
                requete_creation := requete_creation || ', ';
            END IF;
        END LOOP;
        requete_creation := requete_creation || ')';
        EXECUTE requete_creation;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_table_with_att(attributs_with_type TEXT[]) RETURNS TEXT[] as $$
    DECLARE
        result TEXT[];
        attributs TEXT[];
    BEGIN
        attributs := vectorisation_att(attributs_with_type, FALSE);
        FOR i IN 1 .. array_length(attributs,1)
        LOOP
            IF concat(attributs[i],'__ref') IN (SELECT table_name FROM information_schema.tables)  THEN -- à continuer
                result := result || concat(attributs[i],'__ref');
            ELSEIF  split_part(attributs_with_type[i],' ',2)  IN ('timestamp', 'integer', 'date') THEN
                CONTINUE;
            ELSE
                EXECUTE FORMAT('CREATE TABLE IF NOT EXISTS %I ( id SERIAL PRIMARY KEY, %I VARCHAR(20) UNIQUE NOT NULL)',(attributs[i] ||'__ref') ,attributs[i]);
                result := result || concat(attributs[i],'__ref');
            END IF;
        END LOOP;
        RETURN result;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fill_ref_table(fk_cor TEXT[], temp_table TEXT) RETURNS VOID AS $$
DECLARE
    column_names TEXT[];
    filtered_columns TEXT;
BEGIN
    FOR i IN 1 .. array_length(fk_cor, 1)
    LOOP
        SELECT array_agg(column_name)
        INTO column_names
        FROM information_schema.columns
        WHERE table_name = fk_cor[i]
          AND column_name != 'id';

        SELECT array_agg(column_name)
        INTO column_names
        FROM unnest(column_names) AS unnest_column(column_name)
        WHERE EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_name = temp_table
              AND column_name = unnest_column
        );

        filtered_columns := array_to_string(column_names, ', ');

        IF column_names IS NULL THEN
            CONTINUE;
        END IF;

        EXECUTE FORMAT(
            'INSERT INTO %I (%s) SELECT DISTINCT %s FROM %I WHERE %s IS NOT NULL ON CONFLICT DO NOTHING',
            fk_cor[i],       
            filtered_columns,
            filtered_columns, 
            temp_table,
            filtered_columns
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION vectorisation_att(attributs TEXT[], with_type BOOLEAN) RETURNS TEXT[] AS $$
    BEGIN
        FOR i IN 1 .. array_length(attributs,1)
        LOOP
            attributs[i]:= lower(attributs[i]);
            
            IF NOT with_type THEN
                IF position('id' IN attributs[i]) > 0 THEN
                    PERFORM array_remove(attributs,attributs[i]);
                END IF;
                attributs[i] := split_part(attributs[i],' ',1);
            END IF;
        
        END LOOP;

        RETURN attributs;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fill_table2(nom_table TEXT, attributs TEXT[],attributs_with_type TEXT[])
RETURNS VOID AS $$
DECLARE
    requete_insertion TEXT;
    requete_joins TEXT := '';
    colonnes_destination TEXT;
    colonnes_source TEXT;
    elm TEXT;
    update_set TEXT;
BEGIN
    colonnes_destination := array_to_string(
        ARRAY(SELECT 'id_' || att FROM unnest(attributs) AS att), ', ');

    colonnes_source := array_to_string(
        ARRAY(SELECT 'ref_' || att || '.' || 'id' FROM unnest(attributs) AS att), ', ');

    FOREACH elm IN ARRAY attributs
    LOOP
        requete_joins := requete_joins || FORMAT(
            'LEFT JOIN %I__ref AS ref_%s ON src.%I = ref_%s.%s ',
            elm, elm, elm, elm, elm
        );
    END LOOP;

    update_set := array_to_string(
        ARRAY(SELECT FORMAT(
            'id_%s = COALESCE(EXCLUDED.id_%s, %I.id_%s)',
            att, att, nom_table, att
        )
        FROM unnest(attributs) AS att), ', ');

    EXECUTE FORMAT(
        'CREATE UNIQUE INDEX IF NOT EXISTS temp_unique_%I ON %I (%s);',
        nom_table, nom_table, colonnes_destination
    );

    requete_insertion := FORMAT(
        'INSERT INTO %I (%s)
        SELECT %s
        FROM temp_table src %s
        ON CONFLICT (%s)
        DO UPDATE SET %s;',
        nom_table,          
        colonnes_destination,
        colonnes_source,      
        requete_joins,        
        colonnes_destination, 
        update_set
    );

    EXECUTE requete_insertion;

    EXECUTE FORMAT('DROP INDEX IF EXISTS temp_unique_%I;', nom_table);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fill_table(
    nom_table TEXT, 
    attributs TEXT[], 
    attributs_with_type TEXT[]
) RETURNS VOID AS $$
DECLARE
    requete_insertion TEXT;
    requete_joins TEXT := '';
    colonnes_destination TEXT;
    colonnes_source TEXT;
    update_set TEXT;
    i INTEGER;
    colonne_unique TEXT;
BEGIN
    colonnes_destination := array_to_string(
        ARRAY(SELECT CASE
                      WHEN split_part(attributs_with_type[gs.i], ' ', 2) = 'text' THEN 'id_' || attributs[gs.i]
                      ELSE attributs[gs.i]
                   END
        FROM generate_subscripts(attributs_with_type, 1) AS gs(i)), ', ');

    colonnes_source := array_to_string(
        ARRAY(SELECT CASE
                      WHEN split_part(attributs_with_type[gs.i], ' ', 2) = 'text' THEN 'ref_' || attributs[gs.i] || '.id'
                      ELSE attributs[gs.i]
                   END
        FROM generate_subscripts(attributs_with_type, 1) AS gs(i)), ', ');

    FOR i IN 1 .. array_length(attributs_with_type, 1) LOOP
        IF split_part(attributs_with_type[i], ' ', 2) = 'text' THEN
            requete_joins := requete_joins || FORMAT(
                'LEFT JOIN %I__ref AS ref_%s ON src.%I = ref_%s.%s ',
                attributs[i], attributs[i], attributs[i], attributs[i], attributs[i]
            );
        END IF;
    END LOOP;

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

    colonne_unique := colonnes_destination; 
    PERFORM 1
    FROM pg_constraint
    WHERE conrelid = nom_table::regclass
      AND contype = 'u'
      AND pg_get_constraintdef(oid) LIKE FORMAT('UNIQUE (%s)', colonnes_destination);

    IF NOT FOUND THEN
        EXECUTE FORMAT(
            'ALTER TABLE %I ADD CONSTRAINT %I_unique_constraint UNIQUE (%s);',
            nom_table,
            nom_table,
            colonnes_destination
        );
    END IF;

    requete_insertion := FORMAT(
        'INSERT INTO %I (%s)
        SELECT %s
        FROM temp_table src %s
        ON CONFLICT (%s)
        DO UPDATE SET %s;',
        nom_table,        
        colonnes_destination,
        colonnes_source,  
        requete_joins,    
        colonne_unique,     
        update_set           
    );

    EXECUTE requete_insertion;
END;
$$ LANGUAGE plpgsql;






CREATE OR REPLACE FUNCTION import_fichier( chemin_relatif TEXT,nom_table TEXT)
    RETURNS VOID AS $$
    DECLARE
        chemin_fichier TEXT := '/Users/alexandrehergaux/Library/Mobile Documents/com~apple~CloudDocs/ETUDES/EIDD/2A/S7/Base_de_donnees/Projet/bigbrother/' || chemin_relatif ;
        entete TEXT;
        attributs TEXT[];
        attributs_with_type TEXT[];
        requete_creation TEXT;
        fk_cor TEXT[];
    BEGIN
    -- Recuperation des attributs
        entete := pg_read_file(chemin_fichier);
        entete := split_part(entete, E'\n', 1);
    -- Vectorisation des attributs
        attributs_with_type := string_to_array(entete, ',');
        attributs_with_type := vectorisation_att(attributs_with_type, TRUE);
        attributs := vectorisation_att(attributs_with_type, FALSE );
        
    -- Creation table temporaire / par convention elle sera nomme 'temp_table'
        PERFORM create_table_temp('temp_table', attributs_with_type);

    -- Imporation csv dans la table temporaire
        EXECUTE FORMAT('COPY temp_table FROM %L WITH (FORMAT csv, HEADER true)', chemin_fichier);
        
    -- 
        fk_cor := check_table_with_att(attributs_with_type);

        PERFORM fill_ref_table(fk_cor,'temp_table');
        
        PERFORM create_table(nom_table, attributs, attributs_with_type);

        PERFORM fill_table(nom_table, attributs, attributs_with_type);
        
        EXECUTE 'DROP TABLE IF EXISTS temp_table';

        RAISE NOTICE 'Données importées dans la table %', nom_table;
    END;
    $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION linked() RETURNS VOID AS $$
BEGIN

END;
$$ LANGUAGE plpgsql;