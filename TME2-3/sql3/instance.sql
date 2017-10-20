-- compléter l'entête 
-- ==================

-- NOM    : BECIRSPAHIC
-- Prénom : Lucas

-- NOM    : FERNANDEZ
-- Prénom : Steban

-- Groupe : 4
-- binome :

-- ================================================

-- stockage des données : définition des relations
-- ====================

create table TMatiere of Matiere;
create table TPieceBase of PieceBase;
create table TPieceComposite of PieceComposite
nested table ensComposants store as t1
nested table ensComposes store as t2;

-- instanciation des objets
-- ========================

insert into TMatiere values (Matiere('bois', 10, 2));
insert into TMatiere values (Matiere('fer', 5, 3));
insert into TMatiere values (Matiere('ferrite', 6, 10));
insert into TPieceBase values (Cylindre('canne',(select ref(m) from TMatiere m where m.nom='bois'),2, 30));
insert into TPieceBase values (Parall('plateau', (select ref(m) from TMatiere m where m.nom='bois'), 1, 100, 80));
insert into TPieceBase values (Sphere('boule',(select ref(m) from TMatiere m where m.nom='fer'), 30));
insert into TPieceBase values (Sphere('pied', (select ref(m) from TMatiere m where m.nom='bois'), 30));
insert into TPieceBase values (Cylindre('clou', (select ref(m) from TMatiere m where m.nom='fer'), 1, 20));
insert into TPieceBase values (Cylindre('aimant', (select ref(m) from TMatiere m where m.nom='ferrite'), 2, 5));
insert into TPieceComposite values (PieceComposite('table', 100,
       	    		    EnsPieces(
				PieceQuantite(
					(select ref(e) from TPieceBase e where e.nom='plateau'),
			    		1 ),
				PieceQuantite(
					(select ref(e) from TPieceBase e where e.nom='pied'),
					4),
				PieceQuantite(
					(select ref(e) from TPieceBase e where e.nom='clou'),
					12)),
				null)
);
insert into TPieceComposite values (PieceComposite('billard', 10,
       	    		    EnsPieces(
				PieceQuantite(
					(select ref(e) from TPieceComposite e where e.nom='table'),
			    		1 ),
				PieceQuantite(
					(select ref(e) from TPieceBase e where e.nom='boule'),
					3),
				PieceQuantite(
					(select ref(e) from TPieceBase e where e.nom='canne'),
					2)),
				null)
);
