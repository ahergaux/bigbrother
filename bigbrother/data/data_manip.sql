-- DB BigBrother
-- Creé le 28/11/2024
-- Version 1.0
-- Autres Tables de Définition
-- tablesdefinition.sql

select * from import_fichier('data/employes.csv','employe');
select * from import_fichier('data/employes2.csv','employe');
select * from lier_personne_import('employe');

select * from import_fichier('data/etudiants.csv','etudiant');
select * from lier_personne_import('etudiant'); 


select * from import_fichier('data/securite_sociale.csv','securite_sociale');
select * from lier_personne_import('securite_sociale');

select * from import_fichier('data/bancaire.csv','bancaire');
select * from lier_personne_import('bancaire');


