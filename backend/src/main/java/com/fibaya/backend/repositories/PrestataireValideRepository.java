package com.fibaya.backend.repositories;

import com.fibaya.backend.models.PrestataireValide;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface PrestataireValideRepository extends JpaRepository<PrestataireValide, Long> {
    
    /**
     * Vérifier si un numéro de téléphone est déjà validé
     */
    boolean existsByTelephone(String telephone);
    
    /**
     * Trouver un prestataire validé par son numéro de téléphone
     */
    Optional<PrestataireValide> findByTelephone(String telephone);
    
    /**
     * Vérifier si un numéro de téléphone est validé et actif
     */
    boolean existsByTelephoneAndStatut(String telephone, String statut);
}
