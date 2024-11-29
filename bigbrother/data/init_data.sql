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
