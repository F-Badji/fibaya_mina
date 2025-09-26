package com.fibaya.backend.repositories;

import com.fibaya.backend.models.Country;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CountryRepository extends JpaRepository<Country, Long> {
    
    List<Country> findByIsActiveTrueOrderByNameAsc();
    
    List<Country> findByContinentAndIsActiveTrueOrderByNameAsc(String continent);
}
