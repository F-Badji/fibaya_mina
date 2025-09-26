package com.fibaya.backend.services;

import com.fibaya.backend.models.Country;
import com.fibaya.backend.repositories.CountryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CountryService {
    
    @Autowired
    private CountryRepository countryRepository;
    
    public List<Country> getAllActiveCountries() {
        return countryRepository.findByIsActiveTrueOrderByNameAsc();
    }
    
    public List<Country> getCountriesByContinent(String continent) {
        return countryRepository.findByContinentAndIsActiveTrueOrderByNameAsc(continent);
    }
}
