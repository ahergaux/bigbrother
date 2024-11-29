CREATE VIEW view_personne AS (
    select nr.nom, pr.prenom, date_naissance, vr.ville, gr.genre from personne p 
left join nom__ref as nr on p.id_nom=nr.id left join prenom__ref pr on p.id_prenom=pr.id left join genre__ref gr on p.id_genre=gr.id left join ville__ref vr on p.id_ville_naissance=vr.id
)

