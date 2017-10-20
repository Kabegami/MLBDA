-- MABD TP1 SQL avec la base MONDIAL


-- -------------------- binome -------------------------
-- NOM BECIRSPAHIC
-- Prenom LUCAS

-- NOM FERNANDEZ
-- Prenom STEBAN
-- -----------------------------------------------------

-- pour se connecter à oracle:
-- sqlplus E1234567/E1234567@oracle
-- remplacer E12345657 par la lettre E suivie de votre numéro de login

set sqlbl on
set linesize 150

prompt schema de la table Country
desc Country

prompt schema de la table City
desc City

prompt schema de la table IsMember
desc IsMember

prompt schema de la table City
desc City

-- pour afficher un nuplet entier sur une seule ligne
column name format A15
column capital format A15
column province format A20

-- Requete 0

select * from Country where name = 'France';

-- Requete 10

select o.name , COUNT(c.name), SUM(c.population)
from Country c , Organization o, isMember m
where m.country = c.code
and m.organization = o.abbreviation
group by o.name;

-- Requete 11
select o.name , COUNT(c.name), SUM(c.population)
from Country c , Organization o, isMember m
where m.country = c.code
and m.organization = o.abbreviation
group by o.name
having (COUNT(c.name) > 100);

-- Requete 12
select c.name, m.name
from Country c, Mountain m, Encompasses e, Geo_Mountain g
where e.continent = 'America' and e.country = c.code
and g.mountain = m.name and g.country = c.code and
not exists (select * from Mountain m2, Geo_Mountain g2 where g2.mountain = m2.name and
g2.country = c.code and m2.height > m.height);

select c.name, m.name
from Country c, Mountain m, Encompasses e, Geo_Mountain g
where e.continent = 'America' and e.country = c.code and g.mountain = m.name and g.country = c.code and m.height = (select MAX(height) from Mountain m2, Geo_Mountain g2 where
g2.mountain = m2.name and  g2.country = c.code);
      		  
-- Requete 13
select r.name from river r where r.river = 'Nile';

-- Requete 14
-- Profondeur 1 ou 2

select distinct r.name
from River r, River r2, River r3
where (r.river = 'Nile') or (r.river = r2.name and r2.river = 'Nile')
or (r.river = r2.name and r2.river = r3.name and r3.river='Nile');

-- Requete 15

select SUM(r.length)
from River r, River r2, River r3
where (r.river = 'Nile') or (r.river = r2.name and r2.river = 'Nile') or (r.name = 'Nile')
or (r.river = r2.name and r2.river = r3.name and r3.river='Nile');

-- Requete 16.a
select name, COUNT(*)
from Organization, IsMember
where abbreviation = organization
group by name
having COUNT(*) = (select MAX(COUNT(*))
       from Organization o, IsMember m
       where o.abbreviation = m.organization
       group by o.abbreviation, o.name
);



-- Requete 16.b
select *
from (
     select o.name, COUNT(*)
     from Organization o, IsMember m
     where o.abbreviation = m.organization
     group by o.abbreviation, o.name
     order by COUNT(*) DESC
     )
     where rownum < 4;

-- Requete 17
-- Requete 18
-- Requete 19
-- Requete 20
