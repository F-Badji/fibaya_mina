-- Insertion des services par défaut
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

-- Insertion des utilisateurs (clients et prestataires)
INSERT INTO users (email, password, first_name, last_name, phone, user_type, profile_image, latitude, longitude, address, city, country, is_active, created_at) VALUES
-- Clients
('client1@fibaya.com', 'password123', 'Marie', 'Dubois', '+33 6 12 34 56 78', 'CLIENT', 'assets/images/marie_dubois.jpg', 48.8566, 2.3522, '123 Rue de la Paix', 'Paris', 'France', true, NOW()),
('client2@fibaya.com', 'password123', 'Pierre', 'Martin', '+33 6 23 45 67 89', 'CLIENT', 'assets/images/pierre_martin.jpg', 48.8576, 2.3532, '456 Avenue des Champs', 'Paris', 'France', true, NOW()),

-- Prestataires
('jean.dupont@fibaya.com', 'password123', 'Jean', 'Dupont', '+33 6 12 34 56 78', 'PROVIDER', 'assets/images/jean_dupont.jpg', 48.8576, 2.3532, 'Liberté 6, Dakar', 'Dakar', 'Sénégal', true, NOW()),
('marie.laurent@fibaya.com', 'password123', 'Marie', 'Laurent', '+33 6 23 45 67 89', 'PROVIDER', 'assets/images/marie_laurent.jpg', 48.8556, 2.3512, 'Liberté 6, Dakar', 'Dakar', 'Sénégal', true, NOW()),
('ahmed.benali@fibaya.com', 'password123', 'Ahmed', 'Benali', '+33 6 34 56 78 90', 'PROVIDER', 'assets/images/ahmed_benali.jpg', 48.8586, 2.3542, 'Liberté 6, Dakar', 'Dakar', 'Sénégal', true, NOW());

-- Insertion des services de prestataires
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














