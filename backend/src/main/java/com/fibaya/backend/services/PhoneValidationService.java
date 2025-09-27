package com.fibaya.backend.services;

import com.fibaya.backend.models.PhoneFormat;
import com.fibaya.backend.repositories.PhoneFormatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.List;

@Service
public class PhoneValidationService {
    
    @Autowired
    private PhoneFormatRepository phoneFormatRepository;
    
    /**
     * Valide un numéro de téléphone selon le format du pays
     * @param phoneNumber Le numéro de téléphone à valider
     * @param countryName Le nom du pays
     * @return Map contenant le résultat de la validation
     */
    public Map<String, Object> validatePhoneNumber(String phoneNumber, String countryName) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Nettoyer le numéro (enlever espaces, tirets, etc.)
            String cleanNumber = phoneNumber.replaceAll("[^0-9]", "");
            
            if (cleanNumber.isEmpty()) {
                response.put("valid", false);
                response.put("message", "Numéro invalide");
                return response;
            }
            
            // Récupérer le format du pays
            Optional<PhoneFormat> formatOpt = phoneFormatRepository.findByCountryName(countryName);
            
            if (formatOpt.isEmpty()) {
                response.put("valid", false);
                response.put("message", "Format de numéro non disponible pour ce pays");
                return response;
            }
            
            PhoneFormat format = formatOpt.get();
            
            // Vérifier la longueur
            if (cleanNumber.length() != format.getTotalDigits()) {
                response.put("valid", false);
                response.put("message", "Numéro invalide");
                return response;
            }
            
            // Vérifier le préfixe mobile
            boolean validPrefix = false;
            for (String prefix : format.getMobilePrefixes()) {
                if (cleanNumber.startsWith(prefix)) {
                    validPrefix = true;
                    break;
                }
            }
            
            if (!validPrefix) {
                response.put("valid", false);
                response.put("message", "Numéro invalide");
                return response;
            }
            
            // Numéro valide
            response.put("valid", true);
            response.put("message", "Numéro valide");
            response.put("formattedNumber", cleanNumber);
            response.put("countryCode", format.getCountryCode());
            response.put("totalDigits", format.getTotalDigits());
            
        } catch (Exception e) {
            response.put("valid", false);
            response.put("message", "Erreur lors de la validation: " + e.getMessage());
        }
        
        return response;
    }
    
    /**
     * Obtient le format d'un pays
     * @param countryName Le nom du pays
     * @return Map contenant les informations du format
     */
    public Map<String, Object> getCountryFormat(String countryName) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<PhoneFormat> formatOpt = phoneFormatRepository.findByCountryName(countryName);
            
            if (formatOpt.isEmpty()) {
                response.put("found", false);
                response.put("message", "Format non trouvé pour ce pays");
                return response;
            }
            
            PhoneFormat format = formatOpt.get();
            
            response.put("found", true);
            response.put("countryName", format.getCountryName());
            response.put("countryCode", format.getCountryCode());
            response.put("totalDigits", format.getTotalDigits());
            response.put("mobilePrefixes", format.getMobilePrefixes());
            response.put("exampleNumber", format.getExampleNumber());
            
        } catch (Exception e) {
            response.put("found", false);
            response.put("message", "Erreur lors de la récupération: " + e.getMessage());
        }
        
        return response;
    }
    
    /**
     * Obtient le format d'un pays avec recherche flexible
     * @param countryName Le nom du pays (peut être avec ou sans accents)
     * @return Map contenant les informations du format
     */
    public Map<String, Object> getCountryFormatFlexible(String countryName) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Optional<PhoneFormat> formatOpt = findCountryFlexible(countryName);
            
            if (formatOpt.isEmpty()) {
                response.put("found", false);
                response.put("message", "Format non trouvé pour ce pays");
                return response;
            }
            
            PhoneFormat format = formatOpt.get();
            
            response.put("found", true);
            response.put("countryName", format.getCountryName());
            response.put("countryCode", format.getCountryCode());
            response.put("totalDigits", format.getTotalDigits());
            response.put("mobilePrefixes", format.getMobilePrefixes());
            response.put("exampleNumber", format.getExampleNumber());
            
        } catch (Exception e) {
            response.put("found", false);
            response.put("message", "Erreur lors de la récupération: " + e.getMessage());
        }
        
        return response;
    }
    
    /**
     * Valide un numéro de téléphone avec le code pays
     * @param phoneNumber Le numéro de téléphone à valider
     * @param countryCode Le code du pays (ex: +221)
     * @return Map contenant le résultat de la validation
     */
    public Map<String, Object> validatePhoneNumberByCode(String phoneNumber, String countryCode) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Récupérer le format par code pays
            Optional<PhoneFormat> formatOpt = phoneFormatRepository.findByCountryCode(countryCode);
            
            if (formatOpt.isEmpty()) {
                response.put("valid", false);
                response.put("message", "Format de numéro non disponible pour ce code pays");
                return response;
            }
            
            PhoneFormat format = formatOpt.get();
            
            // Utiliser la validation standard
            return validatePhoneNumber(phoneNumber, format.getCountryName());
            
        } catch (Exception e) {
            response.put("valid", false);
            response.put("message", "Erreur lors de la validation: " + e.getMessage());
        }
        
        return response;
    }
    
    /**
     * Valide un numéro de téléphone avec recherche flexible par nom de pays
     * Gère les variations de noms (avec/sans accents, etc.)
     * @param phoneNumber Le numéro de téléphone à valider
     * @param countryName Le nom du pays (peut être avec ou sans accents)
     * @return Map contenant le résultat de la validation
     */
    public Map<String, Object> validatePhoneNumberFlexible(String phoneNumber, String countryName) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Nettoyer le numéro (enlever espaces, tirets, etc.)
            String cleanNumber = phoneNumber.replaceAll("[^0-9]", "");
            
            if (cleanNumber.isEmpty()) {
                response.put("valid", false);
                response.put("message", "Numéro invalide");
                return response;
            }
            
            // Recherche flexible du pays
            Optional<PhoneFormat> formatOpt = findCountryFlexible(countryName);
            
            if (formatOpt.isEmpty()) {
                response.put("valid", false);
                response.put("message", "Format de numéro non disponible pour ce pays");
                return response;
            }
            
            PhoneFormat format = formatOpt.get();
            
            // Vérifier la longueur
            if (cleanNumber.length() != format.getTotalDigits()) {
                response.put("valid", false);
                response.put("message", "Numéro invalide");
                return response;
            }
            
            // Vérifier le préfixe mobile
            boolean validPrefix = false;
            for (String prefix : format.getMobilePrefixes()) {
                if (cleanNumber.startsWith(prefix)) {
                    validPrefix = true;
                    break;
                }
            }
            
            if (!validPrefix) {
                response.put("valid", false);
                response.put("message", "Numéro invalide");
                return response;
            }
            
            // Numéro valide
            response.put("valid", true);
            response.put("message", "Numéro valide");
            response.put("formattedNumber", cleanNumber);
            response.put("countryCode", format.getCountryCode());
            response.put("totalDigits", format.getTotalDigits());
            response.put("foundCountry", format.getCountryName());
            
        } catch (Exception e) {
            response.put("valid", false);
            response.put("message", "Erreur lors de la validation: " + e.getMessage());
        }
        
        return response;
    }
    
    /**
     * Recherche flexible d'un pays par nom
     * Gère les variations de noms (avec/sans accents, etc.)
     * @param countryName Le nom du pays à rechercher
     * @return Optional contenant le format du pays s'il est trouvé
     */
    private Optional<PhoneFormat> findCountryFlexible(String countryName) {
        // Normaliser le nom du pays (enlever accents, espaces, etc.)
        String normalizedSearch = normalizeCountryName(countryName);
        
        // Recherche exacte d'abord
        Optional<PhoneFormat> exactMatch = phoneFormatRepository.findByCountryName(countryName);
        if (exactMatch.isPresent()) {
            return exactMatch;
        }
        
        // Recherche flexible
        List<PhoneFormat> allFormats = phoneFormatRepository.findAll();
        for (PhoneFormat format : allFormats) {
            String normalizedFormat = normalizeCountryName(format.getCountryName());
            if (normalizedFormat.equals(normalizedSearch)) {
                return Optional.of(format);
            }
        }
        
        return Optional.empty();
    }
    
    /**
     * Normalise un nom de pays pour la recherche
     * @param countryName Le nom du pays à normaliser
     * @return Le nom normalisé
     */
    private String normalizeCountryName(String countryName) {
        if (countryName == null) return "";
        
        return countryName
            .toLowerCase()
            .replaceAll("[àáâãäå]", "a")
            .replaceAll("[èéêë]", "e")
            .replaceAll("[ìíîï]", "i")
            .replaceAll("[òóôõö]", "o")
            .replaceAll("[ùúûü]", "u")
            .replaceAll("[ç]", "c")
            .replaceAll("[ñ]", "n")
            .replaceAll("[ýÿ]", "y")
            .replaceAll("[\\s-]", "")
            .trim();
    }
}
