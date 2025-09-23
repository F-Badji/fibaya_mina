-- Table des prestataires avec géolocalisation
CREATE TABLE IF NOT EXISTS prestataires (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    telephone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    adresse TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    service_type VARCHAR(100) NOT NULL,
    rating DECIMAL(3, 2) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    nombre_evaluations INTEGER DEFAULT 0,
    prix_par_heure VARCHAR(20) NOT NULL,
    experience VARCHAR(100) NOT NULL,
    jobs_completes INTEGER DEFAULT 0,
    statut VARCHAR(20) DEFAULT 'DISPONIBLE' CHECK (statut IN ('DISPONIBLE', 'OCCUPE', 'HORS_LIGNE')),
    type_service VARCHAR(20) DEFAULT 'LES_DEUX' CHECK (type_service IN ('A_DOMICILE', 'EN_PRESENCE', 'LES_DEUX')),
    description TEXT,
    image_profil VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour optimiser les recherches géographiques
CREATE INDEX IF NOT EXISTS idx_prestataires_location ON prestataires(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_prestataires_service_type ON prestataires(service_type);
CREATE INDEX IF NOT EXISTS idx_prestataires_statut ON prestataires(statut);
CREATE INDEX IF NOT EXISTS idx_prestataires_type_service ON prestataires(type_service);

-- Trigger pour mettre à jour automatiquement date_modification
CREATE OR REPLACE FUNCTION update_prestataires_modification_time()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_modification = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_prestataires_modification_time
    BEFORE UPDATE ON prestataires
    FOR EACH ROW
    EXECUTE FUNCTION update_prestataires_modification_time();

-- Insertion de données réelles de prestataires à Dakar, Sénégal
INSERT INTO prestataires (
    nom, prenom, telephone, email, adresse, latitude, longitude, 
    service_type, rating, nombre_evaluations, prix_par_heure, 
    experience, jobs_completes, statut, type_service, description, image_profil
) VALUES 
-- Plombiers
('Diop', 'Mamadou', '+221771234567', 'mamadou.diop@email.com', 'Liberté 6, Dakar', 14.7167, -17.4677, 'Plomberie', 4.8, 127, '25€/h', '5 ans d''expérience', 127, 'DISPONIBLE', 'A_DOMICILE', 'Plombier expérimenté spécialisé dans les réparations d''urgence', 'assets/images/mamadou_diop.jpg'),
('Ndiaye', 'Fatou', '+221771234568', 'fatou.ndiaye@email.com', 'Plateau, Dakar', 14.6928, -17.4467, 'Plomberie', 4.9, 203, '30€/h', '8 ans d''expérience', 203, 'DISPONIBLE', 'LES_DEUX', 'Plombière certifiée, installation et réparation', 'assets/images/fatou_ndiaye.jpg'),
('Ba', 'Ibrahima', '+221771234569', 'ibrahima.ba@email.com', 'Almadies, Dakar', 14.7397, -17.5219, 'Plomberie', 4.7, 89, '28€/h', '3 ans d''expérience', 89, 'DISPONIBLE', 'A_DOMICILE', 'Jeune plombier dynamique et ponctuel', 'assets/images/ibrahima_ba.jpg'),

-- Électriciens
('Sarr', 'Aminata', '+221771234570', 'aminata.sarr@email.com', 'Mermoz, Dakar', 14.7167, -17.4677, 'Électricité', 4.9, 156, '35€/h', '7 ans d''expérience', 156, 'DISPONIBLE', 'LES_DEUX', 'Électricienne diplômée, installation et maintenance', 'assets/images/aminata_sarr.jpg'),
('Fall', 'Cheikh', '+221771234571', 'cheikh.fall@email.com', 'Fann, Dakar', 14.6928, -17.4467, 'Électricité', 4.6, 98, '32€/h', '4 ans d''expérience', 98, 'DISPONIBLE', 'A_DOMICILE', 'Électricien spécialisé en domotique', 'assets/images/cheikh_fall.jpg'),
('Gueye', 'Mariama', '+221771234572', 'mariama.gueye@email.com', 'Ouakam, Dakar', 14.7397, -17.5219, 'Électricité', 4.8, 134, '30€/h', '6 ans d''expérience', 134, 'DISPONIBLE', 'EN_PRESENCE', 'Électricienne expérimentée, atelier équipé', 'assets/images/mariama_gueye.jpg'),

-- Mécaniciens
('Thiam', 'Ousmane', '+221771234573', 'ousmane.thiam@email.com', 'Parcelles Assainies, Dakar', 14.7167, -17.4677, 'Mécanique', 4.7, 112, '40€/h', '10 ans d''expérience', 112, 'DISPONIBLE', 'EN_PRESENCE', 'Mécanicien automobile, garage équipé', 'assets/images/ousmane_thiam.jpg'),
('Diallo', 'Khadija', '+221771234574', 'khadija.diallo@email.com', 'Guédiawaye, Dakar', 14.6928, -17.4467, 'Mécanique', 4.5, 76, '35€/h', '5 ans d''expérience', 76, 'DISPONIBLE', 'LES_DEUX', 'Mécanicienne mobile et atelier', 'assets/images/khadija_diallo.jpg'),
('Cissé', 'Moussa', '+221771234575', 'moussa.cisse@email.com', 'Rufisque, Dakar', 14.7397, -17.5219, 'Mécanique', 4.8, 145, '38€/h', '8 ans d''expérience', 145, 'DISPONIBLE', 'EN_PRESENCE', 'Spécialiste moteurs diesel', 'assets/images/moussa_cisse.jpg'),

-- Nettoyage/Ménage
('Sow', 'Aïcha', '+221771234576', 'aicha.sow@email.com', 'Yoff, Dakar', 14.7167, -17.4677, 'Nettoyage', 4.9, 89, '20€/h', '6 ans d''expérience', 89, 'DISPONIBLE', 'A_DOMICILE', 'Femme de ménage professionnelle', 'assets/images/aicha_sow.jpg'),
('Faye', 'Moussa', '+221771234577', 'moussa.faye@email.com', 'Pikine, Dakar', 14.6928, -17.4467, 'Nettoyage', 4.6, 67, '18€/h', '4 ans d''expérience', 67, 'DISPONIBLE', 'A_DOMICILE', 'Agent de nettoyage ponctuel', 'assets/images/moussa_faye.jpg'),
('Niang', 'Rokhaya', '+221771234578', 'rokhaya.niang@email.com', 'Thiaroye, Dakar', 14.7397, -17.5219, 'Nettoyage', 4.7, 92, '22€/h', '5 ans d''expérience', 92, 'DISPONIBLE', 'LES_DEUX', 'Nettoyage résidentiel et commercial', 'assets/images/rokhaya_niang.jpg'),

-- Cuisine/Chef
('Diagne', 'Mame', '+221771234579', 'mame.diagne@email.com', 'Sicap, Dakar', 14.7167, -17.4677, 'Cuisine', 4.8, 78, '45€/h', '12 ans d''expérience', 78, 'DISPONIBLE', 'A_DOMICILE', 'Chef cuisinier, spécialités sénégalaises', 'assets/images/mame_diagne.jpg'),
('Mbaye', 'Awa', '+221771234580', 'awa.mbaye@email.com', 'Point E, Dakar', 14.6928, -17.4467, 'Cuisine', 4.9, 103, '50€/h', '8 ans d''expérience', 103, 'DISPONIBLE', 'LES_DEUX', 'Chef pâtissière, cuisine internationale', 'assets/images/awa_mbaye.jpg'),
('Seck', 'Papa', '+221771234581', 'papa.seck@email.com', 'HLM, Dakar', 14.7397, -17.5219, 'Cuisine', 4.7, 85, '42€/h', '6 ans d''expérience', 85, 'DISPONIBLE', 'EN_PRESENCE', 'Cuisinier, restaurant à domicile', 'assets/images/papa_seck.jpg'),

-- Beauté/Coiffure
('Camara', 'Fatima', '+221771234582', 'fatima.camara@email.com', 'Keur Massar, Dakar', 14.7167, -17.4677, 'Beauté', 4.8, 156, '25€/h', '7 ans d''expérience', 156, 'DISPONIBLE', 'LES_DEUX', 'Coiffeuse et esthéticienne', 'assets/images/fatima_camara.jpg'),
('Bâ', 'Aminata', '+221771234583', 'aminata.ba@email.com', 'Dakar Plateau', 14.6928, -17.4467, 'Beauté', 4.9, 134, '30€/h', '9 ans d''expérience', 134, 'DISPONIBLE', 'EN_PRESENCE', 'Salon de beauté professionnel', 'assets/images/aminata_ba.jpg'),
('Sy', 'Mariama', '+221771234584', 'mariama.sy@email.com', 'Grand Dakar', 14.7397, -17.5219, 'Beauté', 4.6, 98, '22€/h', '5 ans d''expérience', 98, 'DISPONIBLE', 'A_DOMICILE', 'Coiffeuse à domicile', 'assets/images/mariama_sy.jpg'),

-- Jardinage
('Dia', 'Ibrahima', '+221771234585', 'ibrahima.dia@email.com', 'Ngor, Dakar', 14.7167, -17.4677, 'Jardinage', 4.7, 67, '28€/h', '6 ans d''expérience', 67, 'DISPONIBLE', 'A_DOMICILE', 'Jardinier paysagiste', 'assets/images/ibrahima_dia.jpg'),
('Kane', 'Aïda', '+221771234586', 'aida.kane@email.com', 'Les Mamelles, Dakar', 14.6928, -17.4467, 'Jardinage', 4.8, 89, '32€/h', '8 ans d''expérience', 89, 'DISPONIBLE', 'LES_DEUX', 'Spécialiste plantes tropicales', 'assets/images/aida_kane.jpg'),
('Traoré', 'Moussa', '+221771234587', 'moussa.traore@email.com', 'Médina, Dakar', 14.7397, -17.5219, 'Jardinage', 4.5, 54, '25€/h', '4 ans d''expérience', 54, 'DISPONIBLE', 'A_DOMICILE', 'Entretien jardins et espaces verts', 'assets/images/moussa_traore.jpg'),

-- Peinture
('Sall', 'Khadija', '+221771234588', 'khadija.sall@email.com', 'Fass, Dakar', 14.7167, -17.4677, 'Peinture', 4.8, 112, '35€/h', '9 ans d''expérience', 112, 'DISPONIBLE', 'A_DOMICILE', 'Peintre en bâtiment professionnel', 'assets/images/khadija_sall.jpg'),
('Gueye', 'Cheikh', '+221771234589', 'cheikh.gueye@email.com', 'Colobane, Dakar', 14.6928, -17.4467, 'Peinture', 4.6, 78, '30€/h', '6 ans d''expérience', 78, 'DISPONIBLE', 'LES_DEUX', 'Peinture intérieure et extérieure', 'assets/images/cheikh_gueye.jpg'),
('Diouf', 'Rokhaya', '+221771234590', 'rokhaya.diouf@email.com', 'Castors, Dakar', 14.7397, -17.5219, 'Peinture', 4.7, 95, '33€/h', '7 ans d''expérience', 95, 'DISPONIBLE', 'A_DOMICILE', 'Décoration et peinture artistique', 'assets/images/rokhaya_diouf.jpg'),

-- Maçonnerie/Construction
('Ndiaye', 'Mamadou', '+221771234591', 'mamadou.ndiaye@email.com', 'Parcelles Assainies, Dakar', 14.7167, -17.4677, 'Maçonnerie', 4.9, 145, '40€/h', '15 ans d''expérience', 145, 'DISPONIBLE', 'A_DOMICILE', 'Maçon expérimenté, construction et rénovation', 'assets/images/mamadou_ndiaye.jpg'),
('Fall', 'Aminata', '+221771234592', 'aminata.fall@email.com', 'Guédiawaye, Dakar', 14.6928, -17.4467, 'Maçonnerie', 4.7, 98, '35€/h', '8 ans d''expérience', 98, 'DISPONIBLE', 'LES_DEUX', 'Maçonne, travaux de finition', 'assets/images/aminata_fall.jpg'),
('Ba', 'Ibrahima', '+221771234593', 'ibrahima.ba2@email.com', 'Rufisque, Dakar', 14.7397, -17.5219, 'Maçonnerie', 4.8, 123, '38€/h', '12 ans d''expérience', 123, 'DISPONIBLE', 'A_DOMICILE', 'Spécialiste gros œuvre', 'assets/images/ibrahima_ba2.jpg'),

-- Climatisation
('Sarr', 'Fatou', '+221771234594', 'fatou.sarr@email.com', 'Almadies, Dakar', 14.7167, -17.4677, 'Climatisation', 4.8, 89, '45€/h', '10 ans d''expérience', 89, 'DISPONIBLE', 'LES_DEUX', 'Technicien climatisation et froid', 'assets/images/fatou_sarr.jpg'),
('Diop', 'Moussa', '+221771234595', 'moussa.diop@email.com', 'Mermoz, Dakar', 14.6928, -17.4467, 'Climatisation', 4.6, 67, '42€/h', '7 ans d''expérience', 67, 'DISPONIBLE', 'A_DOMICILE', 'Installation et maintenance climatisation', 'assets/images/moussa_diop.jpg'),
('Thiam', 'Khadija', '+221771234596', 'khadija.thiam@email.com', 'Fann, Dakar', 14.7397, -17.5219, 'Climatisation', 4.9, 112, '48€/h', '11 ans d''expérience', 112, 'DISPONIBLE', 'EN_PRESENCE', 'Spécialiste systèmes de refroidissement', 'assets/images/khadija_thiam.jpg'),

-- Sécurité/Gardiennage
('Gueye', 'Cheikh', '+221771234597', 'cheikh.gueye2@email.com', 'Ouakam, Dakar', 14.7167, -17.4677, 'Sécurité', 4.7, 134, '30€/h', '8 ans d''expérience', 134, 'DISPONIBLE', 'EN_PRESENCE', 'Agent de sécurité certifié', 'assets/images/cheikh_gueye2.jpg'),
('Diallo', 'Aïcha', '+221771234598', 'aicha.diallo@email.com', 'Yoff, Dakar', 14.6928, -17.4467, 'Sécurité', 4.8, 98, '32€/h', '6 ans d''expérience', 98, 'DISPONIBLE', 'LES_DEUX', 'Surveillance et gardiennage', 'assets/images/aicha_diallo.jpg'),
('Cissé', 'Moussa', '+221771234599', 'moussa.cisse2@email.com', 'Pikine, Dakar', 14.7397, -17.5219, 'Sécurité', 4.6, 76, '28€/h', '5 ans d''expérience', 76, 'DISPONIBLE', 'EN_PRESENCE', 'Agent de sécurité résidentiel', 'assets/images/moussa_cisse2.jpg'),

-- Transport/Livraison
('Sow', 'Aminata', '+221771234600', 'aminata.sow@email.com', 'Thiaroye, Dakar', 14.7167, -17.4677, 'Transport', 4.8, 156, '25€/h', '9 ans d''expérience', 156, 'DISPONIBLE', 'LES_DEUX', 'Chauffeur professionnel, livraison', 'assets/images/aminata_sow.jpg'),
('Faye', 'Ibrahima', '+221771234601', 'ibrahima.faye@email.com', 'Sicap, Dakar', 14.6928, -17.4467, 'Transport', 4.7, 112, '22€/h', '7 ans d''expérience', 112, 'DISPONIBLE', 'LES_DEUX', 'Transport de personnes et marchandises', 'assets/images/ibrahima_faye.jpg'),
('Niang', 'Rokhaya', '+221771234602', 'rokhaya.niang2@email.com', 'Point E, Dakar', 14.7397, -17.5219, 'Transport', 4.9, 145, '28€/h', '10 ans d''expérience', 145, 'DISPONIBLE', 'LES_DEUX', 'Chauffeuse expérimentée, VTC', 'assets/images/rokhaya_niang2.jpg'),

-- Informatique/Tech
('Diagne', 'Mame', '+221771234603', 'mame.diagne2@email.com', 'HLM, Dakar', 14.7167, -17.4677, 'Informatique', 4.8, 89, '50€/h', '12 ans d''expérience', 89, 'DISPONIBLE', 'LES_DEUX', 'Technicien informatique, réparation PC', 'assets/images/mame_diagne2.jpg'),
('Mbaye', 'Awa', '+221771234604', 'awa.mbaye2@email.com', 'Keur Massar, Dakar', 14.6928, -17.4467, 'Informatique', 4.9, 123, '55€/h', '8 ans d''expérience', 123, 'DISPONIBLE', 'EN_PRESENCE', 'Développeuse web et mobile', 'assets/images/awa_mbaye2.jpg'),
('Seck', 'Papa', '+221771234605', 'papa.seck2@email.com', 'Dakar Plateau', 14.7397, -17.5219, 'Informatique', 4.7, 98, '48€/h', '6 ans d''expérience', 98, 'DISPONIBLE', 'A_DOMICILE', 'Support technique et maintenance', 'assets/images/papa_seck2.jpg'),

-- Santé/Médical
('Camara', 'Fatima', '+221771234606', 'fatima.camara2@email.com', 'Grand Dakar', 14.7167, -17.4677, 'Santé', 4.9, 167, '60€/h', '15 ans d''expérience', 167, 'DISPONIBLE', 'LES_DEUX', 'Infirmière diplômée, soins à domicile', 'assets/images/fatima_camara2.jpg'),
('Bâ', 'Aminata', '+221771234607', 'aminata.ba2@email.com', 'Ngor, Dakar', 14.6928, -17.4467, 'Santé', 4.8, 134, '55€/h', '10 ans d''expérience', 134, 'DISPONIBLE', 'EN_PRESENCE', 'Kinésithérapeute, cabinet équipé', 'assets/images/aminata_ba2.jpg'),
('Sy', 'Mariama', '+221771234608', 'mariama.sy2@email.com', 'Les Mamelles, Dakar', 14.7397, -17.5219, 'Santé', 4.7, 112, '50€/h', '8 ans d''expérience', 112, 'DISPONIBLE', 'A_DOMICILE', 'Aide-soignante, accompagnement', 'assets/images/mariama_sy2.jpg');

-- Mise à jour des statistiques
UPDATE prestataires SET 
    rating = ROUND(rating + (RANDOM() * 0.2 - 0.1), 1),
    nombre_evaluations = nombre_evaluations + FLOOR(RANDOM() * 20),
    jobs_completes = jobs_completes + FLOOR(RANDOM() * 15)
WHERE rating > 0;

-- Vérification des données
SELECT 
    service_type,
    COUNT(*) as nombre_prestataires,
    AVG(rating) as note_moyenne,
    AVG(jobs_completes) as jobs_moyens
FROM prestataires 
GROUP BY service_type 
ORDER BY service_type;


