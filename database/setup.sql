-- Script de création de la base de données Fibaya
-- Exécuter ce script dans PostgreSQL pour créer la base de données

-- Créer la base de données
CREATE DATABASE "Fibaya"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Se connecter à la base de données Fibaya
\c "Fibaya";

-- Créer les extensions nécessaires
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Créer la table users
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('CLIENT', 'PROVIDER', 'ADMIN')),
    profile_image VARCHAR(500),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    address VARCHAR(500),
    city VARCHAR(100),
    country VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Créer la table services
CREATE TABLE IF NOT EXISTS services (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    icon VARCHAR(10) NOT NULL,
    category VARCHAR(50) NOT NULL,
    image_url VARCHAR(500),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Créer la table provider_services
CREATE TABLE IF NOT EXISTS provider_services (
    id BIGSERIAL PRIMARY KEY,
    provider_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_id BIGINT NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    price_per_hour DECIMAL(10,2) NOT NULL,
    service_type VARCHAR(100) NOT NULL,
    experience VARCHAR(100),
    completed_jobs INTEGER NOT NULL DEFAULT 0,
    is_available BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    UNIQUE(provider_id, service_id)
);

-- Créer la table bookings
CREATE TABLE IF NOT EXISTS bookings (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_id BIGINT NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    provider_service_id BIGINT NOT NULL REFERENCES provider_services(id) ON DELETE CASCADE,
    booking_type VARCHAR(20) NOT NULL CHECK (booking_type IN ('AT_DOMICILE', 'EN_PRESENCE')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    scheduled_date_time TIMESTAMP NOT NULL,
    completed_date_time TIMESTAMP,
    total_price DECIMAL(10,2),
    description TEXT,
    client_address VARCHAR(500),
    client_latitude DOUBLE PRECISION,
    client_longitude DOUBLE PRECISION,
    estimated_duration VARCHAR(50),
    estimated_distance VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Créer la table provider_reviews
CREATE TABLE IF NOT EXISTS provider_reviews (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    booking_id BIGINT NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Créer les index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_users_user_type ON users(user_type);
CREATE INDEX IF NOT EXISTS idx_users_location ON users(latitude, longitude);

CREATE INDEX IF NOT EXISTS idx_services_category ON services(category);
CREATE INDEX IF NOT EXISTS idx_services_active ON services(is_active);

CREATE INDEX IF NOT EXISTS idx_provider_services_provider ON provider_services(provider_id);
CREATE INDEX IF NOT EXISTS idx_provider_services_service ON provider_services(service_id);
CREATE INDEX IF NOT EXISTS idx_provider_services_available ON provider_services(is_available);

CREATE INDEX IF NOT EXISTS idx_bookings_client ON bookings(client_id);
CREATE INDEX IF NOT EXISTS idx_bookings_provider ON bookings(provider_id);
CREATE INDEX IF NOT EXISTS idx_bookings_service ON bookings(service_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_scheduled ON bookings(scheduled_date_time);

CREATE INDEX IF NOT EXISTS idx_reviews_provider ON provider_reviews(provider_id);
CREATE INDEX IF NOT EXISTS idx_reviews_client ON provider_reviews(client_id);

-- Insérer les données initiales
INSERT INTO services (name, description, icon, category, image_url, is_active, created_at) VALUES
('Plombier', 'Installation et réparation de plomberie', '🔧', 'Réparation', 'assets/images/plombier.jpg', true, NOW()),
('Électricien', 'Installation et maintenance électrique', '⚡', 'Électricité', 'assets/images/electricien.jpg', true, NOW()),
('Mécanicien', 'Réparation et maintenance automobile', '🔧', 'Automobile', 'assets/images/mecanicien.jpg', true, NOW()),
('Nettoyage', 'Services de nettoyage et ménage', '🧹', 'Ménage', 'assets/images/nettoyage.jpg', true, NOW()),
('Cuisine', 'Services culinaires et restauration', '👨‍🍳', 'Culinaire', 'assets/images/cuisine.jpg', true, NOW()),
('Beauté', 'Services de beauté et coiffure', '💄', 'Beauté', 'assets/images/beaute.jpg', true, NOW()),
('Jardinage', 'Entretien et aménagement de jardins', '🌱', 'Jardin', 'assets/images/jardinage.jpg', true, NOW()),
('Peinture', 'Peinture et décoration intérieure', '🎨', 'Décoration', 'assets/images/peinture.jpg', true, NOW()),
('Maçonnerie', 'Travaux de maçonnerie et construction', '🧱', 'Construction', 'assets/images/maconnerie.jpg', true, NOW()),
('Climatisation', 'Installation et maintenance de climatisation', '❄️', 'Climatisation', 'assets/images/climatisation.jpg', true, NOW());

-- Insérer les utilisateurs de test
INSERT INTO users (email, password, first_name, last_name, phone, user_type, profile_image, latitude, longitude, address, city, country, is_active, created_at) VALUES
-- Clients
('client1@fibaya.com', 'password123', 'Marie', 'Dubois', '+33 6 12 34 56 78', 'CLIENT', 'assets/images/marie_dubois.jpg', 48.8566, 2.3522, '123 Rue de la Paix', 'Paris', 'France', true, NOW()),
('client2@fibaya.com', 'password123', 'Pierre', 'Martin', '+33 6 23 45 67 89', 'CLIENT', 'assets/images/pierre_martin.jpg', 48.8576, 2.3532, '456 Avenue des Champs', 'Paris', 'France', true, NOW()),

-- Prestataires
('jean.dupont@fibaya.com', 'password123', 'Jean', 'Dupont', '+33 6 12 34 56 78', 'PROVIDER', 'assets/images/jean_dupont.jpg', 48.8576, 2.3532, 'Liberté 6, Dakar', 'Dakar', 'Sénégal', true, NOW()),
('marie.laurent@fibaya.com', 'password123', 'Marie', 'Laurent', '+33 6 23 45 67 89', 'PROVIDER', 'assets/images/marie_laurent.jpg', 48.8556, 2.3512, 'Liberté 6, Dakar', 'Dakar', 'Sénégal', true, NOW()),
('ahmed.benali@fibaya.com', 'password123', 'Ahmed', 'Benali', '+33 6 34 56 78 90', 'PROVIDER', 'assets/images/ahmed_benali.jpg', 48.8586, 2.3542, 'Liberté 6, Dakar', 'Dakar', 'Sénégal', true, NOW());

-- Insérer les services de prestataires
INSERT INTO provider_services (provider_id, service_id, price_per_hour, service_type, experience, completed_jobs, is_available, created_at) VALUES
-- Jean Dupont - Plombier
(3, 1, 25.00, 'Installation et Réparation', '5 ans d''expérience', 127, true, NOW()),
-- Marie Laurent - Plombier
(4, 1, 30.00, 'Installation et Réparation', '8 ans d''expérience', 203, true, NOW()),
-- Ahmed Benali - Plombier
(5, 1, 28.00, 'Installation et Réparation', '3 ans d''expérience', 89, true, NOW()),

-- Jean Dupont - Électricien
(3, 2, 35.00, 'Installation et Maintenance', '5 ans d''expérience', 95, true, NOW()),
-- Marie Laurent - Électricien
(4, 2, 40.00, 'Installation et Maintenance', '8 ans d''expérience', 156, true, NOW()),

-- Ahmed Benali - Mécanicien
(5, 3, 45.00, 'Réparation et Maintenance', '3 ans d''expérience', 67, true, NOW()),

-- Jean Dupont - Nettoyage
(3, 4, 20.00, 'Nettoyage et Ménage', '5 ans d''expérience', 78, true, NOW()),

-- Marie Laurent - Cuisine
(4, 5, 50.00, 'Services Culinaires', '8 ans d''expérience', 134, true, NOW()),

-- Ahmed Benali - Beauté
(5, 6, 30.00, 'Services de Beauté', '3 ans d''expérience', 45, true, NOW());

-- Afficher un message de confirmation
SELECT 'Base de données Fibaya créée avec succès!' as message;


