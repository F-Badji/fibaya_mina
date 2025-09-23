-- Script de mise à jour du schéma de la base de données Fibaya
-- Ce script synchronise la base de données avec l'application Flutter

-- Se connecter à la base de données Fibaya
\c "Fibaya";

-- Supprimer le champ email de la table users (n'existe pas dans l'app)
ALTER TABLE users DROP COLUMN IF EXISTS email;
ALTER TABLE users DROP COLUMN IF EXISTS password;

-- Ajouter le champ country_code pour le nouveau formulaire d'authentification
ALTER TABLE users ADD COLUMN IF NOT EXISTS country_code VARCHAR(10) DEFAULT '+221';

-- Créer la table country_codes pour le sélecteur de pays
CREATE TABLE IF NOT EXISTS country_codes (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    flag VARCHAR(10) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Insérer les codes pays du sélecteur
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
('Nouvelle-Zélande', '+64', '🇳🇿')
ON CONFLICT (code) DO NOTHING;

-- Créer un index pour optimiser les recherches
CREATE INDEX IF NOT EXISTS idx_country_codes_code ON country_codes(code);
CREATE INDEX IF NOT EXISTS idx_country_codes_name ON country_codes(name);

-- Mettre à jour les utilisateurs existants avec le code pays par défaut
UPDATE users SET country_code = '+221' WHERE country_code IS NULL;

-- Créer la table sms_verification_codes si elle n'existe pas
CREATE TABLE IF NOT EXISTS sms_verification_codes (
    id BIGSERIAL PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL,
    country_code VARCHAR(10) NOT NULL,
    code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    is_used BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Créer un index pour optimiser les recherches
CREATE INDEX IF NOT EXISTS idx_sms_verification_phone ON sms_verification_codes(phone_number, country_code);
CREATE INDEX IF NOT EXISTS idx_sms_verification_expires ON sms_verification_codes(expires_at);

-- Créer la table user_sessions si elle n'existe pas
CREATE TABLE IF NOT EXISTS user_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Créer un index pour optimiser les recherches
CREATE INDEX IF NOT EXISTS idx_user_sessions_token ON user_sessions(session_token);
CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_expires ON user_sessions(expires_at);

-- Afficher un message de confirmation
SELECT 'Schema updated successfully!' as message;
