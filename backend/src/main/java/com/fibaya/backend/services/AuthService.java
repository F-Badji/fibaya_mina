package com.fibaya.backend.services;

import com.fibaya.backend.models.User;
import com.fibaya.backend.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Map;
import java.util.HashMap;

@Service
public class AuthService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PhoneValidationService phoneValidationService;
    
    public Map<String, Object> checkUserExists(String phone) {
        Map<String, Object> response = new HashMap<>();
        boolean exists = userRepository.existsByPhone(phone);
        response.put("exists", exists);
        
        if (exists) {
            User user = userRepository.findByPhone(phone).orElse(null);
            if (user != null) {
                response.put("firstName", user.getFirstName());
                response.put("lastName", user.getLastName());
            }
        }
        
        return response;
    }
    
    public Map<String, Object> getUserInfo(String phone) {
        Map<String, Object> response = new HashMap<>();
        User user = userRepository.findByPhone(phone).orElse(null);
        
        if (user != null) {
            response.put("firstName", user.getFirstName());
            response.put("lastName", user.getLastName());
            response.put("phone", user.getPhone());
            response.put("countryCode", user.getCountryCode());
        }
        
        return response;
    }
    
    public User registerUser(String phone, String countryCode, String firstName, String lastName) {
        // Valider le numéro de téléphone avant l'enregistrement
        Map<String, Object> validationResult = phoneValidationService.validatePhoneNumberByCode(phone, countryCode);
        
        if (!(Boolean) validationResult.get("valid")) {
            throw new IllegalArgumentException("Numéro de téléphone invalide: " + validationResult.get("message"));
        }
        
        User user = new User();
        user.setPhone(phone);
        user.setCountryCode(countryCode);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setUserType(User.UserType.CLIENT);
        user.setIsActive(true);
        
        return userRepository.save(user);
    }
}