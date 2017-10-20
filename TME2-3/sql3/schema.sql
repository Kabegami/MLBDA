-- compléter l'entête 
-- ==================

-- NOM    : BECIRSPAHIC
-- Prénom : Lucas

-- NOM    : FERNANDEZ
-- Prénom : Steban

-- Groupe : 4
-- binome :

-- ================================================

set sqlbl on


-- nettoyer le compte
@vider

-- Définition des types de données

prompt essai

@vider
create type EnsNoms as table of varchar2(30);
/
create type Matiere as object (
 nom varchar2(30),
 prix number,
 masse number -- masse volumique
);
/
create type Piece as object (
 nom varchar2(30),
 not instantiable member function masse return number,
 not instantiable member function prix return number, 
 not instantiable member function nb_pieces_base return number,
 not instantiable member function composee_de return EnsNoms,
 not instantiable member function contenue_dans return EnsNoms
) not final not instantiable;
/
create type PieceBase under Piece (
 mat ref Matiere,
 not instantiable member function volume return number,
 overriding member function masse return number,
 overriding member function prix return number,
 overriding member function nb_pieces_base return number,
 overriding member function composee_de return EnsNoms,
 overriding member function contenue_dans return EnsNoms
) not final not instantiable;
/
create type Cylindre under PieceBase (
 rayon number,
 hauteur number,
 overriding member function volume return number
);
/
create type Sphere under PieceBase (
 rayon number,
 overriding member function volume return number
);
/
create type Parall under PieceBase (
 longueur number,
 largeur number,
 hauteur number,
 overriding member function volume return number
);
/
create type PieceQuantite as Object(
 refpiece ref Piece,
 quantite number
);
/
create type EnsPieces as table of PieceQuantite;
/
create type PieceComposite under Piece (
 coutA number,
 ensComposants EnsPieces,
 ensComposes EnsPieces,
 overriding member function masse return number,
 overriding member function prix return number,
 overriding member function nb_pieces_base return number,
 overriding member function composee_de return EnsNoms,
 overriding member function contenue_dans return EnsNoms
);
@compile


-- DEFINITION DES METHODES

drop type body PieceBase;
drop type body Cylindre;
drop type body Sphere;
drop type body Parall;
drop type body PieceComposite;

create type body PieceBase as
  overriding member function masse return number is
  m Matiere;
  begin
	select deref(self.mat) into m from dual;
	return volume() * m.masse;
  end;
  overriding member function prix return number is
  m Matiere;
  begin
	select deref(self.mat) into m from dual;
	return masse() * m.prix;
  end;
  overriding member function nb_pieces_base return number is
  begin
	return 1;
  end;
  overriding member function composee_de return EnsNoms is
  begin
	return EnsNoms(nom);
  end;
  overriding member function contenue_dans return EnsNom is
  begin
	return 
  end;
end;
/
create type body Cylindre as
  overriding member function volume return number is
  begin
	return 3.14*rayon*rayon*hauteur;
  end;
end;
/
create type body Sphere as
  overriding member function volume return number is
  begin
	return 4/3*3.14*rayon*rayon*rayon;
  end;
end;
/
create type body Parall as
  overriding member function volume return number is
  begin
	return longueur*largeur*hauteur;
  end;
end;
/
create type body PieceComposite as
  overriding member function masse return number is
  res number;
  begin
	select sum(t.refpiece.masse() * t.quantite) into res from table(self.EnsComposants) t;
	return res;
  end;
  overriding member function prix return number is
  res number;
  begin
	select sum(t.refpiece.prix() * t.quantite) into res from table(self.EnsComposants) t;
	return res;
  end;
  overriding member function nb_pieces_base return number is
  res number;
  begin
	select sum(t.refpiece.nb_pieces_base() * t.quantite) into res from table(self.EnsComposants) t;
	return res;
  end;
  overriding member function composee_de return EnsNoms is
  res EnsNoms;
  begin
	select distinct value(p) bulk collect into res
	from table(self.EnsComposants) t, table(t.refpiece.composee_de()) p;
	return res;
  end;
end;
@compile

select p.nom, p.composee_de() from TPieceComposite p;

-- REQUETES

--1
select m.nom, m.prix from TMatiere m;

--2
select m.nom from TMatiere m where m.prix <= 5;

--3
select value(p) from TPieceBase p
where p.mat = (select ref(m) from TMatiere m where m.nom = 'bois');

select value(p) from TPieceBase p where p.mat.nom = 'bois';

--4
select m.nom from TMatiere m where m.nom like('%fer%');

--5
select e.piece.nom from TPieceComposite p, table(p.ensComposants) e where p.nom='billard';

--6
select m.nom, (select count(*) from TPieceBase p where p.mat.nom = m.nom)
from TMatiere m
group by m.nom;

select m.nom, count(*)
from TMatiere m, TPieceBase p
where p.mat.nom = m.nom
group by m.nom;

--7
select value(m)
from TMatiere m
where (select count(*) from TPieceBase p where p.mat.nom = m.nom) >= 3;
