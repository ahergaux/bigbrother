CREATE VIEW view_personne AS (
    select nr.nom, pr.prenom, date_naissance, vr.ville, gr.genre from personne p 
left join nom__ref as nr on p.id_nom=nr.id left join prenom__ref pr on p.id_prenom=pr.id left join genre__ref gr on p.id_genre=gr.id left join ville__ref vr on p.id_ville_naissance=vr.id
);

CREATE VIEW view_all AS (
    select p.id, p.id_nom, p.id_prenom, p.id_genre, p.date_naissance, e.id_adresse, e.id_entreprise, e.id_job_title, e.salary, e.hire_date, e.id_regime_travail, ss.id_regime_affiliation_sante from personne  p 
    left join employe e on p.id=e.id_personne
    left join bancaire b on p.id = b.id_personne
    left join securite_sociale ss on p.id=ss.id_personne
);
