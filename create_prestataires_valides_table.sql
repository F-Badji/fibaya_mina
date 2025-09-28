-- Script SQL pour créer la table des prestataires validés
-- Ce script doit être exécuté dans la base de données PostgreSQL

CREATE TABLE IF NOT EXISTS prestataires_valides (
    id BIGSERIAL PRIMARY KEY,
    telephone VARCHAR(20) NOT NULL UNIQUE,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_validation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valide_par VARCHAR(100),
    statut VARCHAR(20) NOT NULL DEFAULT 'VALIDE'
);

-- Créer un index sur le téléphone pour des recherches rapides
CREATE INDEX IF NOT EXISTS idx_prestataires_valides_telephone ON prestataires_valides(telephone);

-- Créer un index sur le statut
CREATE INDEX IF NOT EXISTS idx_prestataires_valides_statut ON prestataires_valides(statut);

-- Commentaires sur la table
COMMENT ON TABLE prestataires_valides IS 'Table pour stocker les prestataires validés par l''administrateur';
COMMENT ON COLUMN prestataires_valides.telephone IS 'Numéro de téléphone complet avec code pays (ex: +221781234567)';
COMMENT ON COLUMN prestataires_valides.nom IS 'Nom de famille du prestataire';
COMMENT ON COLUMN prestataires_valides.prenom IS 'Prénom du prestataire';
COMMENT ON COLUMN prestataires_valides.date_validation IS 'Date et heure de validation par l''administrateur';
COMMENT ON COLUMN prestataires_valides.valide_par IS 'Identifiant de l''administrateur qui a validé';
COMMENT ON COLUMN prestataires_valides.statut IS 'Statut du prestataire: VALIDE, SUSPENDU, etc.';

-- Insérer quelques données de test (optionnel)
-- INSERT INTO prestataires_valides (telephone, nom, prenom, valide_par) VALUES 
-- ('+221781234567', 'Dupont', 'Jean', 'admin'),
-- ('+221781234568', 'Martin', 'Marie', 'admin');
