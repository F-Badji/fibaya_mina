-- Script pour créer les tables de notifications pour FIBAYA
-- Exécuter ce script dans la base de données Fibaya

-- Se connecter à la base de données Fibaya
\c "Fibaya";

-- Créer la table notifications
CREATE TABLE IF NOT EXISTS notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('BOOKING', 'PAYMENT', 'REVIEW', 'SYSTEM', 'PROMOTION')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('UNREAD', 'READ', 'ARCHIVED')),
    priority VARCHAR(10) NOT NULL DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    data JSONB, -- Données supplémentaires au format JSON
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    read_at TIMESTAMP
);

-- Créer la table notification_templates
CREATE TABLE IF NOT EXISTS notification_templates (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    title_template VARCHAR(255) NOT NULL,
    message_template TEXT NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('BOOKING', 'PAYMENT', 'REVIEW', 'SYSTEM', 'PROMOTION')),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Créer la table user_notification_preferences
CREATE TABLE IF NOT EXISTS user_notification_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    email_notifications BOOLEAN NOT NULL DEFAULT true,
    push_notifications BOOLEAN NOT NULL DEFAULT true,
    sms_notifications BOOLEAN NOT NULL DEFAULT false,
    booking_notifications BOOLEAN NOT NULL DEFAULT true,
    payment_notifications BOOLEAN NOT NULL DEFAULT true,
    review_notifications BOOLEAN NOT NULL DEFAULT true,
    system_notifications BOOLEAN NOT NULL DEFAULT true,
    promotion_notifications BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    UNIQUE(user_id)
);

-- Créer les index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_status ON notifications(status);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_notifications_is_active ON notifications(is_active);

CREATE INDEX IF NOT EXISTS idx_notification_templates_type ON notification_templates(type);
CREATE INDEX IF NOT EXISTS idx_notification_templates_active ON notification_templates(is_active);

CREATE INDEX IF NOT EXISTS idx_user_notification_preferences_user ON user_notification_preferences(user_id);

-- Insérer les templates de notifications par défaut
INSERT INTO notification_templates (name, title_template, message_template, type, is_active, created_at) VALUES
-- Notifications de réservation
('booking_confirmed', 'Réservation confirmée', 'Votre réservation pour {service_name} avec {provider_name} a été confirmée pour le {date} à {time}.', 'BOOKING', true, NOW()),
('booking_cancelled', 'Réservation annulée', 'Votre réservation pour {service_name} avec {provider_name} prévue le {date} a été annulée.', 'BOOKING', true, NOW()),
('booking_in_progress', 'Service en cours', 'Votre service {service_name} avec {provider_name} est maintenant en cours.', 'BOOKING', true, NOW()),
('booking_completed', 'Service terminé', 'Votre service {service_name} avec {provider_name} a été terminé avec succès.', 'BOOKING', true, NOW()),
('booking_reminder', 'Rappel de réservation', 'Rappel: Votre service {service_name} avec {provider_name} est prévu dans 1 heure.', 'BOOKING', true, NOW()),

-- Notifications de paiement
('payment_success', 'Paiement réussi', 'Votre paiement de {amount}€ pour le service {service_name} a été traité avec succès.', 'PAYMENT', true, NOW()),
('payment_failed', 'Échec du paiement', 'Le paiement de {amount}€ pour le service {service_name} a échoué. Veuillez réessayer.', 'PAYMENT', true, NOW()),
('payment_refund', 'Remboursement effectué', 'Un remboursement de {amount}€ a été effectué sur votre compte pour le service {service_name}.', 'PAYMENT', true, NOW()),

-- Notifications d'évaluation
('review_received', 'Nouvelle évaluation', 'Vous avez reçu une nouvelle évaluation de {client_name} pour votre service {service_name}.', 'REVIEW', true, NOW()),
('review_reminder', 'Évaluez votre service', 'N''oubliez pas d''évaluer votre expérience avec {provider_name} pour le service {service_name}.', 'REVIEW', true, NOW()),

-- Notifications système
('welcome', 'Bienvenue sur FIBAYA', 'Bienvenue sur FIBAYA! Découvrez nos services à domicile de qualité.', 'SYSTEM', true, NOW()),
('profile_updated', 'Profil mis à jour', 'Votre profil a été mis à jour avec succès.', 'SYSTEM', true, NOW()),
('password_changed', 'Mot de passe modifié', 'Votre mot de passe a été modifié avec succès.', 'SYSTEM', true, NOW()),

-- Notifications promotionnelles
('promotion_new_service', 'Nouveau service disponible', 'Découvrez notre nouveau service: {service_name}!', 'PROMOTION', true, NOW()),
('promotion_discount', 'Offre spéciale', 'Profitez de {discount}% de réduction sur {service_name} jusqu''au {end_date}!', 'PROMOTION', true, NOW());

-- Insérer les préférences de notifications par défaut pour les utilisateurs existants
INSERT INTO user_notification_preferences (user_id, email_notifications, push_notifications, sms_notifications, booking_notifications, payment_notifications, review_notifications, system_notifications, promotion_notifications, created_at)
SELECT 
    id as user_id,
    true as email_notifications,
    true as push_notifications,
    false as sms_notifications,
    true as booking_notifications,
    true as payment_notifications,
    true as review_notifications,
    true as system_notifications,
    true as promotion_notifications,
    NOW() as created_at
FROM users
WHERE id NOT IN (SELECT user_id FROM user_notification_preferences);

-- Afficher un message de confirmation
SELECT 'Tables de notifications créées avec succès!' as message;
