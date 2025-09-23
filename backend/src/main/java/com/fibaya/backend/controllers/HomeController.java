package com.fibaya.backend.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class HomeController {
    
    @GetMapping("/")
    public Map<String, Object> home() {
        return Map.of(
            "message", "FIBAYA Backend API",
            "status", "running",
            "version", "1.0.0",
            "endpoints", Map.of(
                "auth", "/api/auth/*",
                "check-user", "/api/auth/check-user-exists",
                "register", "/api/auth/register",
                "user-info", "/api/auth/user-info"
            )
        );
    }
}


