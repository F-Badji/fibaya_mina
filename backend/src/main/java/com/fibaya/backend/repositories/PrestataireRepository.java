package com.fibaya.backend.repositories;

import com.fibaya.backend.models.Prestataire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PrestataireRepository extends JpaRepository<Prestataire, Long> {

    // Trouver par statut
    List<Prestataire> findByStatut(String statut);

    // Recherche par nom, prénom ou type de service
    @Query("SELECT p FROM Prestataire p WHERE " +
           "LOWER(p.nom) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(p.prenom) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(p.serviceType) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Prestataire> findByNomContainingIgnoreCaseOrPrenomContainingIgnoreCaseOrServiceTypeContainingIgnoreCase(
            @Param("query") String nom, @Param("query") String prenom, @Param("query") String serviceType);

    // Trouver par type de service
    List<Prestataire> findByServiceTypeContainingIgnoreCase(String serviceType);

    // Trouver par type de service exact
    List<Prestataire> findByTypeService(String typeService);

    // Trouver par type de service dans une liste
    List<Prestataire> findByTypeServiceIn(List<String> typeServices);

    // Trouver par téléphone
    Optional<Prestataire> findByTelephone(String telephone);

    // Vérifier si un numéro de téléphone existe
    boolean existsByTelephone(String telephone);


    // Compter les prestataires par statut
    long countByStatut(String statut);

    // Compter les prestataires par type de service
    long countByTypeService(String typeService);
}