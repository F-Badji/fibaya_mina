package com.fibaya.backend.controllers;

import com.fibaya.backend.models.User;
import com.fibaya.backend.services.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    
    @Autowired
    private AuthService authService;
    
    @GetMapping("/check-user-exists")
    public ResponseEntity<Map<String, Object>> checkUserExists(@RequestParam String phone) {
        Map<String, Object> response = authService.checkUserExists(phone);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/user-info")
    public ResponseEntity<Map<String, Object>> getUserInfo(@RequestParam String phone) {
        Map<String, Object> response = authService.getUserInfo(phone);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> registerUser(@RequestBody Map<String, String> request) {
        try {
            String phone = request.get("phone");
            String countryCode = request.get("countryCode");
            String firstName = request.get("firstName");
            String lastName = request.get("lastName");
            
            User user = authService.registerUser(phone, countryCode, firstName, lastName);
            
            Map<String, Object> response = Map.of(
                "success", true,
                "message", "Utilisateur enregistré avec succès",
                "userId", user.getId()
            );
            
            return ResponseEntity.status(201).body(response);
        } catch (Exception e) {
            Map<String, Object> response = Map.of(
                "success", false,
                "message", "Erreur lors de l'enregistrement: " + e.getMessage()
            );
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @PostMapping("/send-sms")
    public ResponseEntity<Map<String, Object>> sendSms(@RequestBody Map<String, String> request) {
        // Simulation d'envoi SMS
        Map<String, Object> response = Map.of(
            "success", true,
            "message", "Code SMS envoyé"
        );
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/verify-sms")
    public ResponseEntity<Map<String, Object>> verifySms(@RequestBody Map<String, String> request) {
        // Simulation de vérification SMS
        Map<String, Object> response = Map.of(
            "success", true,
            "message", "Code SMS vérifié"
        );
        return ResponseEntity.ok(response);
    }
}