-- Script de mise à jour du schéma de la table prestataires
-- Suppression des colonnes obsolètes et ajout des nouvelles colonnes

-- Supprimer les colonnes obsolètes
ALTER TABLE prestataires DROP COLUMN IF EXISTS email;
ALTER TABLE prestataires DROP COLUMN IF EXISTS latitude;
ALTER TABLE prestataires DROP COLUMN IF EXISTS longitude;
ALTER TABLE prestataires DROP COLUMN IF EXISTS rating;
ALTER TABLE prestataires DROP COLUMN IF EXISTS nombre_evaluations;
ALTER TABLE prestataires DROP COLUMN IF EXISTS prix_par_heure;
ALTER TABLE prestataires DROP COLUMN IF EXISTS jobs_completes;
ALTER TABLE prestataires DROP COLUMN IF EXISTS image_profil;

-- Ajouter les nouvelles colonnes
ALTER TABLE prestataires ADD COLUMN IF NOT EXISTS ville VARCHAR(255);
ALTER TABLE prestataires ADD COLUMN IF NOT EXISTS code_postal VARCHAR(20);
ALTER TABLE prestataires ADD COLUMN IF NOT EXISTS certifications TEXT;
ALTER TABLE prestataires ADD COLUMN IF NOT EXISTS version_document VARCHAR(20) DEFAULT 'Pro';

-- Mettre à jour les contraintes si nécessaire
-- (Les contraintes existantes restent en place)

-- Afficher la structure finale de la table
\d prestataires;
