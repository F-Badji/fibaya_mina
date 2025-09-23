-- Script pour créer les tables spécifiques à l'application Client FIBAYA
-- Basé sur l'analyse complète de l'application Client existante
-- Exécuter ce script dans la base de données Fibaya

-- Se connecter à la base de données Fibaya
\c "Fibaya";

-- ========================================
-- 1. TABLES POUR L'AUTHENTIFICATION CLIENT
-- ========================================

-- Table pour stocker les codes de vérification SMS
CREATE TABLE IF NOT EXISTS sms_verification_codes (
    id BIGSERIAL PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL,
    country_code VARCHAR(10) NOT NULL,
    verification_code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    is_used BOOLEAN NOT NULL DEFAULT false,
    attempts INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Table pour les sessions utilisateur
CREATE TABLE IF NOT EXISTS user_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) NOT NULL UNIQUE,
    device_info JSONB,
    ip_address VARCHAR(45),
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- ========================================
-- 2. TABLES POUR LES SERVICES (50 services identifiés)
-- ========================================

-- Mettre à jour la table services avec tous les services de l'app
DELETE FROM services; -- Supprimer les données existantes

INSERT INTO services (name, description, icon, category, image_url, is_active, created_at) VALUES
-- 🛠️ BÂTIMENT & CONSTRUCTION
('Plombier', 'Installation et réparation plomberie', '🔧', '🛠️ Bâtiment & Construction', 'assets/images/plombier.jpg', true, NOW()),
('Électricien', 'Installation et réparation électrique', '⚡', '🛠️ Bâtiment & Construction', 'assets/images/electricien.jpg', true, NOW()),
('Maçon', 'Maçonnerie et construction', '🧱', '🛠️ Bâtiment & Construction', 'assets/images/macon.jpg', true, NOW()),
('Peintre en bâtiment', 'Peinture intérieure et extérieure', '🎨', '🛠️ Bâtiment & Construction', 'assets/images/peintre.jpg', true, NOW()),
('Carreleur', 'Pose de carrelage et faïence', '🔲', '🛠️ Bâtiment & Construction', 'assets/images/carreleur.jpg', true, NOW()),
('Couvreur', 'Couvreur et toiture', '🏠', '🛠️ Bâtiment & Construction', 'assets/images/couvreur.jpg', true, NOW()),
('Charpentier', 'Charpenterie et menuiserie', '🪚', '🛠️ Bâtiment & Construction', 'assets/images/charpentier.jpg', true, NOW()),
('Serrurier', 'Serrurerie et métallerie', '🔐', '🛠️ Bâtiment & Construction', 'assets/images/serrurier.jpg', true, NOW()),
('Vitrier', 'Vitrerie et miroiterie', '🪟', '🛠️ Bâtiment & Construction', 'assets/images/vitrier.jpg', true, NOW()),

-- ❄️ FROID, CLIMATISATION, CHAUFFAGE
('Chauffagiste', 'Chauffage et plomberie', '🔥', '❄️ Froid, Climatisation, Chauffage', 'assets/images/chauffagiste.jpg', true, NOW()),
('Climatiseur', 'Climatisation et ventilation', '❄️', '❄️ Froid, Climatisation, Chauffage', 'assets/images/climatiseur.jpg', true, NOW()),
('Frigoriste', 'Froid et climatisation', '🧊', '❄️ Froid, Climatisation, Chauffage', 'assets/images/frigoriste.jpg', true, NOW()),

-- ⚙️ MÉCANIQUE & MAINTENANCE
('Mécanicien auto', 'Mécanique automobile', '🚗', '⚙️ Mécanique & Maintenance', 'assets/images/mecanicien_auto.jpg', true, NOW()),
('Mécanicien moto', 'Mécanique motocycle', '🏍️', '⚙️ Mécanique & Maintenance', 'assets/images/mecanicien_moto.jpg', true, NOW()),
('Réparateur électroménager', 'Réparation électroménager', '🔧', '⚙️ Mécanique & Maintenance', 'assets/images/reparateur_electromenager.jpg', true, NOW()),
('Réparateur informatique', 'Réparation informatique', '💻', '⚙️ Mécanique & Maintenance', 'assets/images/reparateur_informatique.jpg', true, NOW()),
('Réparateur téléphone', 'Réparation téléphone', '📱', '⚙️ Mécanique & Maintenance', 'assets/images/reparateur_telephone.jpg', true, NOW()),

-- 🧹 ENTRETIEN & PROPRETÉ
('Nettoyeur', 'Nettoyage et ménage', '🧹', '🧹 Entretien & Propreté', 'assets/images/nettoyeur.jpg', true, NOW()),
('Laveur de vitres', 'Lavage de vitres', '🪟', '🧹 Entretien & Propreté', 'assets/images/laveur_vitres.jpg', true, NOW()),
('Désinsectiseur', 'Désinsectisation', '🐛', '🧹 Entretien & Propreté', 'assets/images/desinsectiseur.jpg', true, NOW()),

-- 🧑‍🍳 CUISINE & RESTAURATION
('Chef cuisinier', 'Cuisine et restauration', '👨‍🍳', '🧑‍🍳 Cuisine & restauration', 'assets/images/chef_cuisinier.jpg', true, NOW()),
('Pâtissier', 'Pâtisserie et boulangerie', '🧁', '🧑‍🍳 Cuisine & restauration', 'assets/images/patissier.jpg', true, NOW()),

-- ☕ SERVICE & HÔTELLERIE
('Serveur', 'Service en restauration', '🍽️', '☕ Service & hôtellerie', 'assets/images/serveur.jpg', true, NOW()),
('Barman', 'Bar et mixologie', '🍸', '☕ Service & hôtellerie', 'assets/images/barman.jpg', true, NOW()),

-- BEAUTÉ & BIEN-ÊTRE
('Coiffeur', 'Coiffure et esthétique', '💇‍♂️', 'Beauté & Bien-être', 'assets/images/coiffeur.jpg', true, NOW()),
('Esthéticienne', 'Esthétique et beauté', '💄', 'Beauté & Bien-être', 'assets/images/estheticienne.jpg', true, NOW()),
('Manucure', 'Manucure et pédicure', '💅', 'Beauté & Bien-être', 'assets/images/manucure.jpg', true, NOW()),
('Massage', 'Massage et bien-être', '💆‍♀️', 'Beauté & Bien-être', 'assets/images/massage.jpg', true, NOW()),

-- MAISON & JARDIN
('Jardinier', 'Jardinage et paysagisme', '🌱', 'Maison & Jardin', 'assets/images/jardinier.jpg', true, NOW()),
('Paysagiste', 'Paysagisme et aménagement', '🌳', 'Maison & Jardin', 'assets/images/paysagiste.jpg', true, NOW()),
('Ébéniste', 'Ébénisterie et menuiserie', '🪑', 'Maison & Jardin', 'assets/images/ebeniste.jpg', true, NOW()),
('Décorateur', 'Décoration intérieure', '🏠', 'Maison & Jardin', 'assets/images/decorateur.jpg', true, NOW()),

-- TECHNOLOGIE & RÉPARATION
('Technicien informatique', 'Support informatique', '💻', 'Technologie & Réparation', 'assets/images/technicien_informatique.jpg', true, NOW()),
('Développeur', 'Développement logiciel', '👨‍💻', 'Technologie & Réparation', 'assets/images/developpeur.jpg', true, NOW()),

-- CRÉATIF & FORMATION
('Graphiste', 'Design graphique', '🎨', 'Créatif & Formation', 'assets/images/graphiste.jpg', true, NOW()),
('Photographe', 'Photographie', '📸', 'Créatif & Formation', 'assets/images/photographe.jpg', true, NOW()),
('Formateur', 'Formation et enseignement', '👨‍🏫', 'Créatif & Formation', 'assets/images/formateur.jpg', true, NOW()),

-- SANTÉ & COUTURE
('Infirmier', 'Soins infirmiers', '🏥', 'Santé & Couture', 'assets/images/infirmier.jpg', true, NOW()),
('Couturier', 'Couture et retouches', '✂️', 'Santé & Couture', 'assets/images/couturier.jpg', true, NOW()),

-- SÉCURITÉ & SURVEILLANCE
('Agent de sécurité', 'Sécurité et surveillance', '🛡️', 'Sécurité & Surveillance', 'assets/images/agent_securite.jpg', true, NOW()),
('Garde du corps', 'Protection rapprochée', '👮‍♂️', 'Sécurité & Surveillance', 'assets/images/garde_corps.jpg', true, NOW()),

-- AGRICULTURE & ÉLEVAGE
('Agriculteur', 'Agriculture et élevage', '🚜', 'Agriculture & Élevage', 'assets/images/agriculteur.jpg', true, NOW()),
('Éleveur', 'Élevage et soins animaux', '🐄', 'Agriculture & Élevage', 'assets/images/eleveur.jpg', true, NOW()),

-- ÉVÉNEMENTS & ANIMATION
('Animateur', 'Animation et événements', '🎪', 'Événements & Animation', 'assets/images/animateur.jpg', true, NOW()),
('DJ', 'Animation musicale', '🎵', 'Événements & Animation', 'assets/images/dj.jpg', true, NOW()),

-- AUTRE
('Traducteur', 'Traduction et interprétation', '🌍', 'Autre', 'assets/images/traducteur.jpg', true, NOW()),
('Comptable', 'Comptabilité et gestion', '📊', 'Autre', 'assets/images/comptable.jpg', true, NOW()),
('Avocat', 'Conseil juridique', '⚖️', 'Autre', 'assets/images/avocat.jpg', true, NOW()),
('Architecte', 'Architecture et urbanisme', '🏗️', 'Autre', 'assets/images/architecte.jpg', true, NOW()),
('Géomètre', 'Topographie et géomètre', '📐', 'Autre', 'assets/images/geometre.jpg', true, NOW());

-- ========================================
-- 3. TABLES POUR LES NOTIFICATIONS CLIENT
-- ========================================

-- Table pour les notifications client (basée sur l'interface existante)
CREATE TABLE IF NOT EXISTS client_notifications (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_type VARCHAR(100) NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('En route', 'Arrivé', 'Annulé', 'En attente', 'Terminé', 'En cours', 'Confirmé')),
    estimated_arrival VARCHAR(100),
    address VARCHAR(500) NOT NULL,
    time VARCHAR(10) NOT NULL,
    date VARCHAR(20) NOT NULL,
    avatar_initial VARCHAR(2) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- ========================================
-- 4. TABLES POUR LES PRESTATAIRES
-- ========================================

-- Table pour les prestataires (basée sur l'interface existante)
CREATE TABLE IF NOT EXISTS service_providers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_id BIGINT NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    service_type VARCHAR(100) NOT NULL,
    price_per_hour DECIMAL(10,2) NOT NULL,
    experience VARCHAR(100),
    completed_jobs INTEGER NOT NULL DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0.0,
    is_available BOOLEAN NOT NULL DEFAULT true,
    is_online BOOLEAN NOT NULL DEFAULT false,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    address VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- ========================================
-- 5. TABLES POUR LES RÉSERVATIONS
-- ========================================

-- Table pour les réservations client (basée sur l'interface existante)
CREATE TABLE IF NOT EXISTS client_bookings (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_id BIGINT NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    service_type VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('En route', 'Arrivé', 'Annulé', 'En attente', 'Terminé', 'En cours', 'Confirmé')),
    estimated_arrival VARCHAR(100),
    address VARCHAR(500) NOT NULL,
    scheduled_date_time TIMESTAMP,
    completed_date_time TIMESTAMP,
    total_price DECIMAL(10,2),
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- ========================================
-- 6. INDEX POUR AMÉLIORER LES PERFORMANCES
-- ========================================

-- Index pour l'authentification
CREATE INDEX IF NOT EXISTS idx_sms_verification_phone ON sms_verification_codes(phone_number);
CREATE INDEX IF NOT EXISTS idx_sms_verification_code ON sms_verification_codes(verification_code);
CREATE INDEX IF NOT EXISTS idx_sms_verification_expires ON sms_verification_codes(expires_at);

CREATE INDEX IF NOT EXISTS idx_user_sessions_user ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_token ON user_sessions(session_token);
CREATE INDEX IF NOT EXISTS idx_user_sessions_active ON user_sessions(is_active);

-- Index pour les services
CREATE INDEX IF NOT EXISTS idx_services_category ON services(category);
CREATE INDEX IF NOT EXISTS idx_services_name ON services(name);

-- Index pour les notifications client
CREATE INDEX IF NOT EXISTS idx_client_notifications_client ON client_notifications(client_id);
CREATE INDEX IF NOT EXISTS idx_client_notifications_status ON client_notifications(status);
CREATE INDEX IF NOT EXISTS idx_client_notifications_active ON client_notifications(is_active);
CREATE INDEX IF NOT EXISTS idx_client_notifications_read ON client_notifications(is_read);

-- Index pour les prestataires
CREATE INDEX IF NOT EXISTS idx_service_providers_user ON service_providers(user_id);
CREATE INDEX IF NOT EXISTS idx_service_providers_service ON service_providers(service_id);
CREATE INDEX IF NOT EXISTS idx_service_providers_available ON service_providers(is_available);
CREATE INDEX IF NOT EXISTS idx_service_providers_online ON service_providers(is_online);
CREATE INDEX IF NOT EXISTS idx_service_providers_location ON service_providers(latitude, longitude);

-- Index pour les réservations
CREATE INDEX IF NOT EXISTS idx_client_bookings_client ON client_bookings(client_id);
CREATE INDEX IF NOT EXISTS idx_client_bookings_provider ON client_bookings(provider_id);
CREATE INDEX IF NOT EXISTS idx_client_bookings_service ON client_bookings(service_id);
CREATE INDEX IF NOT EXISTS idx_client_bookings_status ON client_bookings(status);
CREATE INDEX IF NOT EXISTS idx_client_bookings_scheduled ON client_bookings(scheduled_date_time);

-- ========================================
-- 7. DONNÉES DE TEST POUR L'APPLICATION CLIENT
-- ========================================

-- Insérer des notifications de test (basées sur l'interface existante)
INSERT INTO client_notifications (client_id, service_type, provider_name, status, estimated_arrival, address, time, date, avatar_initial, is_active, is_read, created_at) VALUES
(1, 'Plomberie', 'Jean-Marc Dubois', 'En route', 'Arrivée dans 15 min', '12 Rue de la République, Paris', '10:38', '20 sept.', 'J', true, false, NOW()),
(1, 'Menuiserie', 'Sophie Martin', 'Arrivé', '', '45 Avenue des Champs, Lyon', '10:23', '20 sept.', 'S', true, false, NOW()),
(1, 'Vétérinaire', 'Dr. Marie Lefort', 'Annulé', '', 'Clinique Animalia', '05:53', '20 sept.', 'D', false, false, NOW()),
(1, 'Électricien', 'ElecPro Services', 'En route', 'Arrivée dans 20 min', '8 Boulevard Victor Hugo', '10:43', '20 sept.', 'E', true, false, NOW()),
(1, 'Jardinage', 'GreenThumb Services', 'En attente', 'En attente de confirmation', '22 Rue des Jardins, Nice', '14:30', '20 sept.', 'G', true, false, NOW()),
(1, 'Réparation', 'FixIt Pro', 'Terminé', '', '33 Avenue de la Paix, Toulouse', '16:45', '20 sept.', 'F', true, true, NOW()),
(1, 'Plomberie', 'AquaFix Services', 'En cours', 'Travaux en cours', '55 Rue de la Fontaine, Bordeaux', '13:20', '20 sept.', 'A', true, false, NOW());

-- Insérer des prestataires de test
INSERT INTO service_providers (user_id, service_id, service_type, price_per_hour, experience, completed_jobs, rating, is_available, is_online, latitude, longitude, address, created_at) VALUES
(3, 1, 'Installation et Réparation', 25.00, '5 ans d''expérience', 127, 4.8, true, true, 48.8566, 2.3522, '123 Rue de la Paix, Paris', NOW()),
(4, 1, 'Installation et Réparation', 30.00, '8 ans d''expérience', 203, 4.9, true, true, 48.8576, 2.3532, '456 Avenue des Champs, Paris', NOW()),
(5, 2, 'Installation et Maintenance', 35.00, '5 ans d''expérience', 95, 4.7, true, false, 48.8556, 2.3512, '789 Boulevard Saint-Germain, Paris', NOW());

-- Afficher un message de confirmation
SELECT 'Tables spécifiques à l''application Client FIBAYA créées avec succès!' as message;
