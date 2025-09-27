package com.fibaya.backend.controllers;

import com.fibaya.backend.services.PhoneValidationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/phone-validation")
@CrossOrigin(origins = "*")
public class PhoneValidationController {
    
    @Autowired
    private PhoneValidationService phoneValidationService;
    
    /**
     * Valide un numéro de téléphone selon le pays
     * GET /api/phone-validation/validate?phone=781234567&country=Sénégal
     */
    @GetMapping("/validate")
    public ResponseEntity<Map<String, Object>> validatePhoneNumber(
            @RequestParam String phone,
            @RequestParam String country) {
        
        // Décoder l'URL pour gérer les caractères spéciaux
        try {
            country = java.net.URLDecoder.decode(country, "UTF-8");
        } catch (Exception e) {
            // Si le décodage échoue, utiliser la valeur originale
        }
        
        Map<String, Object> response = phoneValidationService.validatePhoneNumber(phone, country);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Valide un numéro de téléphone avec le code pays
     * GET /api/phone-validation/validate-by-code?phone=781234567&countryCode=+221
     */
    @GetMapping("/validate-by-code")
    public ResponseEntity<Map<String, Object>> validatePhoneNumberByCode(
            @RequestParam String phone,
            @RequestParam String countryCode) {
        
        Map<String, Object> response = phoneValidationService.validatePhoneNumberByCode(phone, countryCode);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Obtient le format d'un pays
     * GET /api/phone-validation/format?country=Sénégal
     */
    @GetMapping("/format")
    public ResponseEntity<Map<String, Object>> getCountryFormat(
            @RequestParam String country) {
        
        // Décoder l'URL pour gérer les caractères spéciaux
        try {
            country = java.net.URLDecoder.decode(country, "UTF-8");
        } catch (Exception e) {
            // Si le décodage échoue, utiliser la valeur originale
        }
        
        Map<String, Object> response = phoneValidationService.getCountryFormatFlexible(country);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Valide un numéro de téléphone via POST
     * POST /api/phone-validation/validate
     * Body: {"phone": "781234567", "country": "Sénégal"}
     */
    @PostMapping("/validate")
    public ResponseEntity<Map<String, Object>> validatePhoneNumberPost(
            @RequestBody Map<String, String> request) {
        
        String phone = request.get("phone");
        String country = request.get("country");
        
        if (phone == null || country == null) {
            Map<String, Object> errorResponse = Map.of(
                "valid", false,
                "message", "Paramètres manquants: phone et country requis"
            );
            return ResponseEntity.badRequest().body(errorResponse);
        }
        
        Map<String, Object> response = phoneValidationService.validatePhoneNumber(phone, country);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Valide un numéro de téléphone avec recherche flexible par nom de pays
     * GET /api/phone-validation/validate-flexible?phone=781234567&country=Senegal
     */
    @GetMapping("/validate-flexible")
    public ResponseEntity<Map<String, Object>> validatePhoneNumberFlexible(
            @RequestParam String phone,
            @RequestParam String country) {
        
        // Décoder l'URL pour gérer les caractères spéciaux
        try {
            country = java.net.URLDecoder.decode(country, "UTF-8");
        } catch (Exception e) {
            // Si le décodage échoue, utiliser la valeur originale
        }
        
        Map<String, Object> response = phoneValidationService.validatePhoneNumberFlexible(phone, country);
        return ResponseEntity.ok(response);
    }
}
