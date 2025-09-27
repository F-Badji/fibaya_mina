package com.fibaya.backend.repositories;

import com.fibaya.backend.models.PhoneFormat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface PhoneFormatRepository extends JpaRepository<PhoneFormat, Long> {
    
    Optional<PhoneFormat> findByCountryName(String countryName);
    
    Optional<PhoneFormat> findByCountryCode(String countryCode);
    
    @Query("SELECT pf FROM PhoneFormat pf WHERE pf.countryName = :countryName")
    Optional<PhoneFormat> findFormatByCountryName(@Param("countryName") String countryName);
    
    boolean existsByCountryName(String countryName);
}
