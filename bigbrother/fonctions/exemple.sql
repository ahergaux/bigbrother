SELECT ajouter_adresse_postale(
    p_id_personne := 1,
    p_numero := 123,
    p_rue := 'Rue de la République',
    p_ville := 'Lyon',
    p_debut := '2021-01-01'
);

SELECT inserer_personne(
    p_nom := 'Durand',
    p_prenom := 'Alice',
    p_date_naissance := '1990-06-15',
    p_ville_naissance := 'Lyon',
    p_genre := 'Femme'
);

