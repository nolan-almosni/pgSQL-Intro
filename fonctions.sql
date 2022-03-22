DROP FUNCTION IF EXISTS calculer_longueur_max;
CREATE OR REPLACE FUNCTION calculer_longueur_max(chaine1 varchar, chaine2 varchar) returns integer AS $$
DECLARE
    resultat integer ;
BEGIN
    if length(chaine1)>length(chaine2) THEN
    resultat := length(chaine1);
    elsif length(chaine2)>length(chaine1) THEN
    resultat := length(chaine2);
    else
    resultat := length(chaine1);
    end if ;
    return resultat ;
END ;
$$ LANGUAGE plpgsql ;

DROP FUNCTION IF EXISTS nb_occurences;
CREATE OR REPLACE FUNCTION nb_occurences(caractere text, chaine text, debut int, fin int) returns int AS $$
DECLARE
    nbOccurence int := 0;
    i int := debut;
BEGIN

    if debut < 1 THEN

        FOR i in debut..fin LOOP
            if debut<length(chaine) and fin<length(chaine) and debut<fin THEN 
                if caractere = substr(chaine,i,1) THEN
                    nbOccurence := nbOccurence+1 ;
                end if;
            else 
            nbOccurence = -1;
            end if;
        END LOOP ;
    end if;

    if debut = 1 THEN

        LOOP 
            if caractere = substr(chaine,i,1) THEN
                nbOccurence := nbOccurence+1 ;
            end if ;

            i := i+1 ;

            if i > fin THEN 
                EXIT ;
            end if ;
            
        end LOOP;

    end if;

    if debut > 1 THEN

        while i < fin LOOP

            if caractere = substr(chaine,i,1) THEN
                nbOccurence := nbOccurence+1 ;
            end if ;

            i := i+1 ;

            if i > fin THEN 
                EXIT ;
            end if ;

        end loop ;

    end if;

    return nbOccurence ; 
END ;
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS getNbJoursParMois;
CREATE OR REPLACE FUNCTION getNbJoursParMois(dateChoisie date) returns int AS $$

DECLARE
    annee int := EXTRACT(year FROM dateChoisie);
    mois int := EXTRACT(month FROM dateChoisie);
    jours int ;
BEGIN
    if mois in (4,6,9,11) THEN
        jours := 30;
    elsif mois = 2 and annee%4 = 0 THEN
        jours := 29;
    elsif mois = 2 and annee%4 > 0 THEN
        jours := 28;
    else
        jours := 31;
    END IF;
    return jours;
END ;
$$ LANGUAGE plpgsql ;

DROP FUNCTION IF EXISTS dateSqlToDatefr;
CREATE OR REPLACE FUNCTION dateSqlToDatefr(dateChoisie date) returns varchar AS $$

DECLARE

    annee int := EXTRACT(year FROM dateChoisie);
    mois int := EXTRACT(month FROM dateChoisie);
    jour int := EXTRACT(day FROM dateChoisie);
    dateRetour varchar;

BEGIN

    dateRetour := jour || '-' || mois || '-' || annee;
    return dateRetour;

END ;
$$ LANGUAGE plpgsql ;



DROP FUNCTION IF EXISTS getNomJour;
CREATE OR REPLACE FUNCTION getNomJour(dateChoisie date) returns varchar AS $$

DECLARE

    numJour int := EXTRACT(dow from dateChoisie);
    jour varchar;

BEGIN

    if numJour = 0 THEN
        jour := 'dimanche';
    elsif numJour = 1 THEN
        jour := 'lundi';
    elsif numJour = 2 THEN
        jour := 'mardi';
    elsif numJour = 3 THEN
        jour := 'mercredi';
    elsif numJour = 4 THEN
        jour := 'jeudi';
    elsif numJour = 5 THEN
        jour := 'vendredi';
    elsif numJour = 6 THEN
        jour := 'samedi';
    end if;
    return jour;

END ;
$$ LANGUAGE plpgsql ;



DROP FUNCTION IF EXISTS nbClientDebiteur;
CREATE OR REPLACE FUNCTION nbClientDebiteur() returns int AS $$

DECLARE

    curseur CURSOR FOR select solde from compte where solde < 0;
    nbClient int := 0;
    variable int;

BEGIN 

    OPEN curseur;
    FETCH NEXT FROM curseur INTO variable;
    while FOUND LOOP
        nbClient := nbClient+1;
        FETCH NEXT FROM curseur INTO variable;
    end LOOP;
    close curseur;
    return nbClient;

END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION IF EXISTS nbClientville;
CREATE OR REPLACE FUNCTION nbClientville( nomVille varchar) returns int AS $$

DECLARE

    curseur CURSOR FOR select num_client from client where LIKE(adresse_client,'%'|| nomVille ||'%');
    nbClient int := 0;
    variable int;

BEGIN 

    OPEN curseur;
    FETCH NEXT FROM curseur INTO variable;
    while FOUND LOOP
        nbClient := nbClient+1;
        FETCH NEXT FROM curseur INTO variable;
    end LOOP;
    close curseur;
    return nbClient;

END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION IF EXISTS ajoutClient;
CREATE OR REPLACE FUNCTION ajoutClient( nom varchar, prenom varchar, adresse varchar, identifiant varchar, mdp varchar ) returns varchar AS $$

DECLARE

    dernierClient int;
    nouveauClient int;

BEGIN 

    select into dernierClient max(num_client) from client;
    nouveauClient := dernierClient +1;

    insert into client values(nouveauClient, nom, prenom, adresse, identifiant, mdp);

    select into dernierClient max(num_client) from client;

    if dernierClient = nouveauClient THEN
        return 'tuple bien enregistrer';
    else
        return 'tuple non enregistrer';
    
    end if;

END ;
$$ LANGUAGE plpgsql ;