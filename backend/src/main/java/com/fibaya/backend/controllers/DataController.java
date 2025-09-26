package com.fibaya.backend.controllers;

import com.fibaya.backend.models.Country;
import com.fibaya.backend.models.Service;
import com.fibaya.backend.services.CountryService;
import com.fibaya.backend.services.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class DataController {
    
    @Autowired
    private CountryService countryService;
    
    @Autowired
    private ServiceService serviceService;
    
    @GetMapping("/countries")
    public ResponseEntity<List<Country>> getAllCountries() {
        try {
            List<Country> countries = countryService.getAllActiveCountries();
            return ResponseEntity.ok(countries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/countries/continent/{continent}")
    public ResponseEntity<List<Country>> getCountriesByContinent(@PathVariable String continent) {
        try {
            List<Country> countries = countryService.getCountriesByContinent(continent);
            return ResponseEntity.ok(countries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/services")
    public ResponseEntity<List<Service>> getAllServices() {
        try {
            List<Service> services = serviceService.getAllServices();
            return ResponseEntity.ok(services);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
