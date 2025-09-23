-- Script pour créer la base de données FIBAYA propre
-- Architecture: Client, Prestataire, Admin

-- Créer la nouvelle base
CREATE DATABASE "Fibaya";

-- Se connecter à la nouvelle base
\c "Fibaya";

-- Activer l'extension UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table des utilisateurs (simplifiée pour l'application Client)
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    phone VARCHAR(20) NOT NULL UNIQUE,
    country_code VARCHAR(10) NOT NULL DEFAULT '+221',
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('CLIENT', 'PRESTATAIRE', 'ADMIN')),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des services
CREATE TABLE services (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    category VARCHAR(50),
    image_url VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des prestataires (liée aux utilisateurs)
CREATE TABLE prestataires (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_id BIGINT NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    price_per_hour DECIMAL(10,2),
    experience_years INTEGER DEFAULT 0,
    completed_jobs INTEGER DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0.0,
    is_available BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des réservations (commandes clients)
CREATE TABLE reservations (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    prestataire_id BIGINT NOT NULL REFERENCES prestataires(id) ON DELETE CASCADE,
    service_id BIGINT NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'EN_ATTENTE' CHECK (status IN ('EN_ATTENTE', 'CONFIRME', 'EN_COURS', 'TERMINE', 'ANNULE')),
    address TEXT NOT NULL,
    estimated_arrival TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des notifications
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    data JSONB,
    status VARCHAR(20) NOT NULL DEFAULT 'UNREAD' CHECK (status IN ('READ', 'UNREAD')),
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des codes de vérification SMS
CREATE TABLE sms_verification_codes (
    id BIGSERIAL PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    code VARCHAR(10) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table des sessions utilisateur
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table des codes pays
CREATE TABLE country_codes (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(10) NOT NULL UNIQUE,
    flag VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les performances
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_type ON users(user_type);
CREATE INDEX idx_prestataires_user_id ON prestataires(user_id);
CREATE INDEX idx_prestataires_service_id ON prestataires(service_id);
CREATE INDEX idx_reservations_client_id ON reservations(client_id);
CREATE INDEX idx_reservations_prestataire_id ON reservations(prestataire_id);
CREATE INDEX idx_reservations_status ON reservations(status);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_sms_verification_phone ON sms_verification_codes(phone);
CREATE INDEX idx_sms_verification_expires ON sms_verification_codes(expires_at);
CREATE INDEX idx_user_sessions_token ON user_sessions(session_token);

-- Insérer les services (basés sur l'application client)
INSERT INTO services (name, description, icon, category, image_url) VALUES
('Nettoyage', 'Service de nettoyage à domicile', 'cleaning_services', 'Ménage', 'assets/images/cleaning.jpg'),
('Plomberie', 'Réparation et installation plomberie', 'plumbing', 'Réparation', 'assets/images/plumbing.jpg'),
('Électricité', 'Installation et réparation électrique', 'electrical_services', 'Réparation', 'assets/images/electrical.jpg'),
('Jardinage', 'Entretien et aménagement jardin', 'yard', 'Extérieur', 'assets/images/gardening.jpg'),
('Peinture', 'Peinture intérieure et extérieure', 'format_paint', 'Rénovation', 'assets/images/painting.jpg'),
('Réparation', 'Réparation d''appareils électroménagers', 'build', 'Réparation', 'assets/images/repair.jpg'),
('Livraison', 'Service de livraison rapide', 'local_shipping', 'Transport', 'assets/images/delivery.jpg'),
('Cuisine', 'Service de cuisine à domicile', 'restaurant', 'Alimentation', 'assets/images/cooking.jpg'),
('Bricolage', 'Petits travaux de bricolage', 'handyman', 'Rénovation', 'assets/images/diy.jpg'),
('Sécurité', 'Installation systèmes de sécurité', 'security', 'Sécurité', 'assets/images/security.jpg');

-- Insérer les codes pays
INSERT INTO country_codes (name, code, flag) VALUES
('Sénégal', '+221', '🇸🇳'),
('France', '+33', '🇫🇷'),
('Côte d''Ivoire', '+225', '🇨🇮'),
('Mali', '+223', '🇲🇱'),
('Burkina Faso', '+226', '🇧🇫'),
('Niger', '+227', '🇳🇪'),
('Guinée', '+224', '🇬🇳'),
('Gambie', '+220', '🇬🇲'),
('Guinée-Bissau', '+245', '🇬🇼'),
('Cap-Vert', '+238', '🇨🇻'),
('Maroc', '+212', '🇲🇦'),
('Algérie', '+213', '🇩🇿'),
('Tunisie', '+216', '🇹🇳'),
('Égypte', '+20', '🇪🇬'),
('Nigeria', '+234', '🇳🇬'),
('Ghana', '+233', '🇬🇭'),
('Cameroun', '+237', '🇨🇲'),
('République Démocratique du Congo', '+243', '🇨🇩'),
('Congo', '+242', '🇨🇬'),
('Gabon', '+241', '🇬🇦'),
('Tchad', '+235', '🇹🇩'),
('République Centrafricaine', '+236', '🇨🇫'),
('Togo', '+228', '🇹🇬'),
('Bénin', '+229', '🇧🇯'),
('Madagascar', '+261', '🇲🇬'),
('Maurice', '+230', '🇲🇺'),
('Seychelles', '+248', '🇸🇨'),
('Comores', '+269', '🇰🇲'),
('Djibouti', '+253', '🇩🇯'),
('Éthiopie', '+251', '🇪🇹'),
('Kenya', '+254', '🇰🇪'),
('Tanzanie', '+255', '🇹🇿'),
('Ouganda', '+256', '🇺🇬'),
('Rwanda', '+250', '🇷🇼'),
('Burundi', '+257', '🇧🇮'),
('Afrique du Sud', '+27', '🇿🇦'),
('Zimbabwe', '+263', '🇿🇼'),
('Zambie', '+260', '🇿🇲'),
('Botswana', '+267', '🇧🇼'),
('Namibie', '+264', '🇳🇦'),
('Angola', '+244', '🇦🇴'),
('Mozambique', '+258', '🇲🇿'),
('Malawi', '+265', '🇲🇼'),
('Lesotho', '+266', '🇱🇸'),
('Eswatini', '+268', '🇸🇿'),
('États-Unis', '+1', '🇺🇸'),
('Canada', '+1', '🇨🇦'),
('Royaume-Uni', '+44', '🇬🇧'),
('Allemagne', '+49', '🇩🇪'),
('Italie', '+39', '🇮🇹'),
('Espagne', '+34', '🇪🇸'),
('Portugal', '+351', '🇵🇹'),
('Belgique', '+32', '🇧🇪'),
('Suisse', '+41', '🇨🇭'),
('Pays-Bas', '+31', '🇳🇱'),
('Suède', '+46', '🇸🇪'),
('Norvège', '+47', '🇳🇴'),
('Danemark', '+45', '🇩🇰'),
('Finlande', '+358', '🇫🇮'),
('Pologne', '+48', '🇵🇱'),
('République Tchèque', '+420', '🇨🇿'),
('Hongrie', '+36', '🇭🇺'),
('Roumanie', '+40', '🇷🇴'),
('Bulgarie', '+359', '🇧🇬'),
('Grèce', '+30', '🇬🇷'),
('Turquie', '+90', '🇹🇷'),
('Russie', '+7', '🇷🇺'),
('Chine', '+86', '🇨🇳'),
('Japon', '+81', '🇯🇵'),
('Corée du Sud', '+82', '🇰🇷'),
('Inde', '+91', '🇮🇳'),
('Brésil', '+55', '🇧🇷'),
('Argentine', '+54', '🇦🇷'),
('Chili', '+56', '🇨🇱'),
('Colombie', '+57', '🇨🇴'),
('Pérou', '+51', '🇵🇪'),
('Venezuela', '+58', '🇻🇪'),
('Mexique', '+52', '🇲🇽'),
('Australie', '+61', '🇦🇺'),
('Nouvelle-Zélande', '+64', '🇳🇿');

-- Insérer quelques utilisateurs de test
INSERT INTO users (phone, country_code, first_name, last_name, user_type) VALUES
-- Clients
('771234567', '+221', 'Fily', 'Badji', 'CLIENT'),
('771234568', '+221', 'Aminata', 'Diallo', 'CLIENT'),
('771234569', '+221', 'Moussa', 'Sarr', 'CLIENT'),

-- Prestataires (ceux qui apparaissent dans l'accueil client)
('771234570', '+221', 'Jean-Marc', 'Dubois', 'PRESTATAIRE'),
('771234571', '+221', 'Marie', 'Martin', 'PRESTATAIRE'),
('771234572', '+221', 'Pierre', 'Durand', 'PRESTATAIRE'),
('771234573', '+221', 'Sophie', 'Moreau', 'PRESTATAIRE'),
('771234574', '+221', 'Antoine', 'Leroy', 'PRESTATAIRE'),

-- Admin
('771234575', '+221', 'Admin', 'FIBAYA', 'ADMIN');

-- Insérer les prestataires avec leurs services
INSERT INTO prestataires (user_id, service_id, price_per_hour, experience_years, completed_jobs, rating, is_available) VALUES
-- Jean-Marc Dubois - Plomberie
((SELECT id FROM users WHERE phone = '771234570'), (SELECT id FROM services WHERE name = 'Plomberie'), 25.00, 5, 120, 4.8, true),

-- Marie Martin - Nettoyage
((SELECT id FROM users WHERE phone = '771234571'), (SELECT id FROM services WHERE name = 'Nettoyage'), 15.00, 3, 85, 4.6, true),

-- Pierre Durand - Électricité
((SELECT id FROM users WHERE phone = '771234572'), (SELECT id FROM services WHERE name = 'Électricité'), 30.00, 7, 200, 4.9, true),

-- Sophie Moreau - Jardinage
((SELECT id FROM users WHERE phone = '771234573'), (SELECT id FROM services WHERE name = 'Jardinage'), 20.00, 4, 95, 4.7, true),

-- Antoine Leroy - Réparation
((SELECT id FROM users WHERE phone = '771234574'), (SELECT id FROM services WHERE name = 'Réparation'), 22.00, 6, 150, 4.8, true);

-- Insérer quelques notifications de test
INSERT INTO notifications (user_id, type, title, message, status, is_read) VALUES
-- Notifications pour les clients
((SELECT id FROM users WHERE phone = '771234567'), 'BOOKING', 'Réservation confirmée', 'Votre service de plomberie a été confirmé par Jean-Marc Dubois', 'UNREAD', false),
((SELECT id FROM users WHERE phone = '771234567'), 'ARRIVAL', 'Prestataire en route', 'Jean-Marc Dubois est en route vers votre domicile', 'UNREAD', false),
((SELECT id FROM users WHERE phone = '771234567'), 'COMPLETED', 'Service terminé', 'Votre service de plomberie a été terminé avec succès', 'READ', true),

-- Notifications pour les prestataires
((SELECT id FROM users WHERE phone = '771234570'), 'NEW_BOOKING', 'Nouvelle réservation', 'Nouvelle demande de service de plomberie', 'UNREAD', false),
((SELECT id FROM users WHERE phone = '771234570'), 'PAYMENT', 'Paiement reçu', 'Paiement de 25.00€ reçu pour votre service', 'READ', true);

SELECT 'Base de données FIBAYA créée avec succès!' AS message;
