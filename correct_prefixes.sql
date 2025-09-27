-- Script SQL pour corriger les préfixes de téléphone avec des valeurs plus réalistes
-- ATTENTION: Ces préfixes sont génériques et doivent être vérifiés avec de vraies sources

-- Pays africains avec préfixes plus réalistes
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Mali';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Burkina Faso';
UPDATE phone_formats SET mobile_prefixes = ARRAY['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Côte d''Ivoire';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Guinée';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Gambie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5', '6', '7', '8', '9'] WHERE country_name = 'Guinée-Bissau';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Cap-Vert';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Mauritanie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['8', '9'] WHERE country_name = 'Niger';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Tchad';

-- Pays d'Afrique centrale et de l'Ouest
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Cameroun';
UPDATE phone_formats SET mobile_prefixes = ARRAY['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Gabon';
UPDATE phone_formats SET mobile_prefixes = ARRAY['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Congo';
UPDATE phone_formats SET mobile_prefixes = ARRAY['8', '9'] WHERE country_name = 'République démocratique du Congo';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Centrafrique';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Togo';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Bénin';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Nigeria';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '5'] WHERE country_name = 'Ghana';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Liberia';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Sierra Leone';

-- Pays d'Afrique du Nord
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Maroc';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5', '6', '7', '9'] WHERE country_name = 'Algérie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Tunisie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1'] WHERE country_name = 'Égypte';

-- Pays d'Afrique de l'Est
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Afrique du Sud';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Kenya';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Éthiopie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Ouganda';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Tanzanie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Rwanda';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Burundi';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Madagascar';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5', '6', '7', '8', '9'] WHERE country_name = 'Maurice';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Seychelles';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Comores';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Djibouti';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Somalie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Soudan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Soudan du Sud';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1', '2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Érythrée';

-- Pays d'Afrique australe
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Zimbabwe';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Zambie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Botswana';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Namibie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Angola';
UPDATE phone_formats SET mobile_prefixes = ARRAY['8', '9'] WHERE country_name = 'Mozambique';
UPDATE phone_formats SET mobile_prefixes = ARRAY['8', '9'] WHERE country_name = 'Malawi';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5', '6', '7', '8', '9'] WHERE country_name = 'Lesotho';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Eswatini';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'São Tomé-et-Príncipe';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Guinée équatoriale';

-- Pays européens
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7'] WHERE country_name = 'France';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1'] WHERE country_name = 'Allemagne';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Royaume-Uni';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3'] WHERE country_name = 'Italie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7'] WHERE country_name = 'Espagne';
UPDATE phone_formats SET mobile_prefixes = ARRAY['4'] WHERE country_name = 'Belgique';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Suisse';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6'] WHERE country_name = 'Pays-Bas';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Suède';
UPDATE phone_formats SET mobile_prefixes = ARRAY['4', '9'] WHERE country_name = 'Norvège';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Danemark';
UPDATE phone_formats SET mobile_prefixes = ARRAY['4', '5'] WHERE country_name = 'Finlande';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5', '6', '7', '8', '9'] WHERE country_name = 'Pologne';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7'] WHERE country_name = 'République tchèque';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Hongrie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Roumanie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['8', '9'] WHERE country_name = 'Bulgarie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6'] WHERE country_name = 'Grèce';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Portugal';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5'] WHERE country_name = 'Turquie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Russie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5', '6', '7', '8', '9'] WHERE country_name = 'Ukraine';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5'] WHERE country_name = 'Israël';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6'] WHERE country_name = 'Albanie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3', '4', '6'] WHERE country_name = 'Andorre';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6'] WHERE country_name = 'Autriche';

-- Pays asiatiques
UPDATE phone_formats SET mobile_prefixes = ARRAY['1'] WHERE country_name = 'Chine';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '8', '9'] WHERE country_name = 'Japon';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Inde';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1'] WHERE country_name = 'Corée du Sud';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '8', '9'] WHERE country_name = 'Thaïlande';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3', '5', '7', '8', '9'] WHERE country_name = 'Vietnam';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1'] WHERE country_name = 'Malaisie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['8', '9'] WHERE country_name = 'Singapour';
UPDATE phone_formats SET mobile_prefixes = ARRAY['8'] WHERE country_name = 'Indonésie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Philippines';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1', '6', '7', '8', '9'] WHERE country_name = 'Cambodge';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Laos';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Myanmar';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Sri Lanka';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Népal';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1', '2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Bhoutan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '9'] WHERE country_name = 'Maldives';
UPDATE phone_formats SET mobile_prefixes = ARRAY['8', '9'] WHERE country_name = 'Mongolie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Kazakhstan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Ouzbékistan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5', '7', '9'] WHERE country_name = 'Kirghizistan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Tadjikistan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['6', '7', '8', '9'] WHERE country_name = 'Turkménistan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Afghanistan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3'] WHERE country_name = 'Pakistan';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1'] WHERE country_name = 'Bangladesh';

-- Pays du Moyen-Orient
UPDATE phone_formats SET mobile_prefixes = ARRAY['5'] WHERE country_name = 'Arabie saoudite';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5'] WHERE country_name = 'Émirats arabes unis';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3', '5', '6', '7'] WHERE country_name = 'Qatar';
UPDATE phone_formats SET mobile_prefixes = ARRAY['5', '6', '9'] WHERE country_name = 'Koweït';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3', '6', '7'] WHERE country_name = 'Bahreïn';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7', '9'] WHERE country_name = 'Oman';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Jordanie';
UPDATE phone_formats SET mobile_prefixes = ARRAY['3', '7', '8', '9'] WHERE country_name = 'Liban';
UPDATE phone_formats SET mobile_prefixes = ARRAY['7'] WHERE country_name = 'Irak';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Iran';

-- Pays américains
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'États-Unis';
UPDATE phone_formats SET mobile_prefixes = ARRAY['2', '3', '4', '5', '6', '7', '8', '9'] WHERE country_name = 'Canada';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Brésil';
UPDATE phone_formats SET mobile_prefixes = ARRAY['9'] WHERE country_name = 'Argentine';
UPDATE phone_formats SET mobile_prefixes = ARRAY['1', '4'] WHERE country_name = 'Australie';

-- Vérifier les mises à jour
SELECT country_name, mobile_prefixes, total_digits, example_number 
FROM phone_formats 
WHERE country_name IN ('Sénégal', 'Mali', 'Burkina Faso', 'Côte d''Ivoire', 'France', 'Algérie')
ORDER BY country_name;
