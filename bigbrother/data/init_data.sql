INSERT INTO PRENOM__REF (prenom) VALUES ('Alice'), ('Bob'), ('Clara'), ('David'), ('Emma'), ('François'), ('Gabriel'), ('Hugo'), ('Isabelle'), ('Jules'), ('Karine'), ('Léo'), ('Marie'), ('Nicolas'), ('Olivia'), ('Pierre'), ('Quentin'), ('Rita'), ('Sophie'), ('Thomas');

SELECT normalize_table_content('prenom__ref');

INSERT INTO GENRE__REF (genre) VALUES ('hoMme'),('femme');

SELECT normalize_table_content('genre__ref');

INSERT INTO NOM__REF (nom) VALUES 
('Martin'),
('Bernard'),
('Thomas'),
('Petit'),
('Leroy'),
('Morel'),
('Garcia'),
('Roux'),
('Fournier'),
('Dumas'),
('Dubois'),
('Blanc'),
('Henry'),
('Lopez'),
('Laurent'),
('Dupont'),
('Simon'),
('Michel'),
('Noel'),
('Lucas');

SELECT normalize_table_content('nom__ref');

INSERT INTO VILLE__REF (ville) VALUES 
('Paris'),
('Marseille'),
('Lyon'),
('Toulouse'),
('Nice'),
('Nantes'),
('Strasbourg'),
('Montpellier'),
('Bordeaux'),
('Lille'),
('Rennes'),
('Reims'),
('Le Havre'),
('Saint-Étienne'),
('Toulon'),
('Grenoble'),
('Dijon'),
('Angers'),
('Nîmes'),
('Villeurbanne');

SELECT normalize_table_content('ville__ref');

INSERT INTO RUE__REF (rue, id_ville) VALUES 
    
    ('Champs-Élysées', 1),
    ('Rue de Rivoli', 1),
    ('Avenue Montaigne', 1),
    ('Boulevard Saint-Germain', 1),
    ('Rue du Faubourg Saint-Honoré', 1),
    

    ('La Canebière', 2),
    ('Rue Paradis', 2),
    ('Avenue du Prado', 2),
    ('Rue de la République', 2),
    ('Boulevard Baille', 2),
    
    	
    ('Rue de la République', 3),
    ('Rue Mercière', 3),
    ('Avenue des Frères Lumière', 3),
    ('Quai Saint-Antoine', 3),
    ('Cours Lafayette', 3),
    
    
    ('Rue du Taur', 4),
    ('Allées Jean-Jaurès', 4),
    ('Rue Alsace-Lorraine', 4),
    ('Rue Saint-Rome', 4),
    ('Avenue de la Garonnette', 4),
    
    
    ('Promenade des Anglais', 5),
    ('Avenue Jean Médecin', 5),
    ('Rue Masséna', 5),
    ('Boulevard Victor Hugo', 5),
    ('Rue de France', 5),
    
    
    ('Rue Crébillon', 6),
    ('Cours des 50 Otages', 6),
    ('Rue du Calvaire', 6),
    ('Quai de la Fosse', 6),
    ('Rue de Strasbourg', 6),
    
   
    ('Rue du Vieux-Marché-aux-Poissons', 7),
    ('Grand Rue', 7),
    ('Quai des Bateliers', 7),
    ('Rue des Juifs', 7),
    ('Avenue des Vosges', 7),
    
    
    ('Place de la Comédie', 8),
    ('Rue de l''Aiguillerie', 8),
    ('Rue Foch', 8),
    ('Boulevard du Jeu de Paume', 8),
    ('Avenue de Lodève', 8),
    
    
    ('Rue Sainte-Catherine', 9),
    ('Cours de l''Intendance', 9),
    ('Quai des Chartrons', 9),
    ('Rue du Pas-Saint-Georges', 9),
    ('Avenue Thiers', 9),
    
    
    ('Rue Faidherbe', 10),
    ('Boulevard de la Liberté', 10),
    ('Rue de Béthune', 10),
    ('Rue Nationale', 10),
    ('Avenue du Peuple Belge', 10),
    ('Avenue de Laon', 11), 
    ('Boulevard du Ceres', 11), 
    ('Rue de Vesle', 11), 
    ('Place Drouet d''Erlon', 11), 
    ('Rue de Talleyrand', 11), 
    ('Rue de Paris', 12), ('Avenue Foch', 12), ('Boulevard de Strasbourg', 12), ('Place de l''Hotel de Ville', 12), ('Quai de la Réunion', 12), ('Avenue Georges Pompidou', 13), ('Rue de la République', 13), ('Place Jean Jaurès', 13), ('Rue Gambetta', 13), ('Boulevard Thiers', 13),('Place de la Liberté', 14), ('Avenue de la République', 14), ('Rue Jean Jaurès', 14), ('Boulevard de Strasbourg', 14), ('Quai du Commerce', 14),('Avenue Jean Perrot', 15), ('Boulevard Agutte Sembat', 15), ('Rue de la République', 15), ('Quai de la Dyle', 15), ('Place Victor Hugo', 15),('Rue de la Liberté', 16), ('Avenue Foch', 16), ('Boulevard de la République', 16), ('Rue du Faubourg Raines', 16), ('Rue des Godrans', 16),('Avenue Patton', 17), ('Boulevard de la Gare', 17), ('Place du Ralliement', 17), ('Rue des Lices', 17), ('Rue du Mail', 17),('Avenue Feuchères', 18), ('Boulevard de la Libération', 18), ('Rue de la Madeleine', 18), ('Rue des Marchands', 18), ('Place d''Assas', 18),('Cours Emile Zola', 19), ('Avenue Henri Barbusse', 19), ('Place Charles Hernu', 19), ('Rue du 8 Mai 1945', 19), ('Boulevard de la République', 19);

SELECT normalize_table_content('rue__ref');

INSERT INTO ADRESSE__REF (numero, id_rue, id_ville) VALUES (10, 1, 1), (5, 2, 1), (12, 6, 2), (3, 7, 2), (25, 9, 3), (30, 10, 3), (15, 13, 4), (7, 14, 4), (20, 16, 5), (14, 17, 5), (8, 19, 6), (16, 20, 6), (10, 22, 7), (12, 23, 7), (28, 25, 8), (35, 26, 8), (50, 28, 9), (40, 29, 9), (5, 31, 10), (25, 32, 10), (11, 34, 11), (8, 35, 11), (22, 37, 12), (9, 38, 12), (5, 40, 13), (15, 41, 13), (30, 43, 14), (20, 44, 14), (18, 46, 15), (14, 47, 15), (12, 49, 16), (21, 50, 16), (2, 52, 17), (8, 53, 17), (9, 55, 18), (27, 56, 18), (10, 58, 19), (12, 59, 19);

SELECT normalize_table_content('adresse__ref');

INSERT INTO PERSONNE (id_nom, id_prenom, date_naissance, id_ville_naissance, id_genre) VALUES 
    (1, 2, '1990-05-15 00:00:00', 1, 1),
    (2, 3, '1985-03-22 00:00:00', 2, 2),
    (3, 4, '1992-07-11 00:00:00', 3, 1),
    (4, 5, '1980-11-09 00:00:00', 4, 2),
    (5, 6, '2000-02-14 00:00:00', 5, 1),
    (6, 7, '1998-08-25 00:00:00', 6, 2),
    (7, 8, '1995-01-18 00:00:00', 7, 1),
    (8, 9, '1987-12-30 00:00:00', 8, 2),
    (9, 10, '1993-04-02 00:00:00', 9, 1),
    (10, 11, '1986-06-20 00:00:00', 10, 2),
    (11, 12, '1994-09-10 00:00:00', 2, 1),
    (12, 13, '1988-12-05 00:00:00', 3, 2),
    (13, 14, '1983-01-22 00:00:00', 4, 1),
    (14, 15, '1996-11-14 00:00:00', 5, 2),
    (15, 16, '1997-07-07 00:00:00', 6, 1),
    (16, 17, '1989-04-18 00:00:00', 7, 2),
    (17, 18, '1991-02-03 00:00:00', 8, 1),
    (18, 19, '1982-05-27 00:00:00', 9, 2),
    (19, 20, '1984-08-30 00:00:00', 10, 1),
  (2, 19, '1999-11-10 00:00:00', 1, 2);

  INSERT INTO ADRESSE_POSTALE (id_personne, adresse_postale, debut, fin) VALUES
    (1, 1, '2020-01-01 00:00:00', '2025-01-01 00:00:00'),
    (2, 2, '2021-02-01 00:00:00', '2026-02-01 00:00:00'),
    (3, 3, '2019-03-01 00:00:00', '2024-03-01 00:00:00'),
    (4, 4, '2022-04-01 00:00:00', '2027-04-01 00:00:00'),
    (5, 5, '2020-05-01 00:00:00', '2025-05-01 00:00:00'),
    (6, 6, '2018-06-01 00:00:00', '2023-06-01 00:00:00'),
    (7, 7, '2020-07-01 00:00:00', '2025-07-01 00:00:00'),
    (8, 8, '2021-08-01 00:00:00', '2026-08-01 00:00:00'),
    (9, 9, '2022-09-01 00:00:00', '2027-09-01 00:00:00'),
    (10, 10, '2019-10-01 00:00:00', '2024-10-01 00:00:00'),
    (11, 11, '2020-11-01 00:00:00', '2025-11-01 00:00:00'),
    (12, 12, '2021-12-01 00:00:00', '2026-12-01 00:00:00'),
    (13, 13, '2018-01-01 00:00:00', '2023-01-01 00:00:00'),
    (14, 14, '2022-02-01 00:00:00', '2027-02-01 00:00:00'),
    (15, 15, '2021-03-01 00:00:00', '2026-03-01 00:00:00'),
    (16, 16, '2020-04-01 00:00:00', '2025-04-01 00:00:00'),
    (17, 17, '2019-05-01 00:00:00', '2024-05-01 00:00:00'),
    (18, 18, '2021-06-01 00:00:00', '2026-06-01 00:00:00'),
    (19, 19, '2022-07-01 00:00:00', '2027-07-01 00:00:00'),
    (20, 20, '2018-08-01 00:00:00', '2023-08-01 00:00:00');


