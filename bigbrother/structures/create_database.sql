-- DB BigBrother
-- Creé le 08/11/2024
-- Version 1.0
-- Création DataBase
-- create_database.sql

\c postgres

DROP DATABASE IF EXISTS bigbrother;

CREATE DATABASE bigbrother;

\c bigbrother

CREATE EXTENSION IF NOT EXISTS unaccent;


