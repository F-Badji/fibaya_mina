package com.fibaya.backend.services;

import com.fibaya.backend.models.Prestataire;
import com.fibaya.backend.repositories.PrestataireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;

@Service
public class PrestataireService {

    @Autowired
    private PrestataireRepository prestataireRepository;

    // Obtenir tous les prestataires disponibles
    public List<Prestataire> getPrestatairesDisponibles() {
        return prestataireRepository.findByStatut("DISPONIBLE");
    }

    // Obtenir un prestataire par ID
    public Optional<Prestataire> getPrestataireById(Long id) {
        return prestataireRepository.findById(id);
    }

    // Rechercher des prestataires par nom, prénom ou service
    public List<Prestataire> searchPrestataires(String query) {
        String searchQuery = "%" + query.toLowerCase() + "%";
        return prestataireRepository.findByNomContainingIgnoreCaseOrPrenomContainingIgnoreCaseOrServiceTypeContainingIgnoreCase(
                searchQuery, searchQuery, searchQuery);
    }

    // Obtenir les prestataires par type de service
    public List<Prestataire> getPrestatairesByService(String serviceType) {
        return prestataireRepository.findByServiceTypeContainingIgnoreCase(serviceType);
    }

    // Obtenir les prestataires par type de service (À domicile/En présence)
    public List<Prestataire> getPrestatairesByTypeService(String typeService) {
        if ("LES_DEUX".equals(typeService)) {
            return prestataireRepository.findByTypeService("LES_DEUX");
        } else if ("A_DOMICILE".equals(typeService)) {
            return prestataireRepository.findByTypeServiceIn(List.of("A_DOMICILE", "LES_DEUX"));
        } else if ("EN_PRESENCE".equals(typeService)) {
            return prestataireRepository.findByTypeServiceIn(List.of("EN_PRESENCE", "LES_DEUX"));
        }
        return List.of();
    }

    // Créer un nouveau prestataire
    public Prestataire createPrestataire(Prestataire prestataire) {
        prestataire.setDateCreation(LocalDateTime.now());
        prestataire.setDateModification(LocalDateTime.now());
        return prestataireRepository.save(prestataire);
    }

    // Mettre à jour un prestataire
    public Optional<Prestataire> updatePrestataire(Long id, Prestataire prestataireDetails) {
        return prestataireRepository.findById(id).map(prestataire -> {
            prestataire.setNom(prestataireDetails.getNom());
            prestataire.setPrenom(prestataireDetails.getPrenom());
            prestataire.setTelephone(prestataireDetails.getTelephone());
            prestataire.setEmail(prestataireDetails.getEmail());
            prestataire.setAdresse(prestataireDetails.getAdresse());
            prestataire.setLatitude(prestataireDetails.getLatitude());
            prestataire.setLongitude(prestataireDetails.getLongitude());
            prestataire.setServiceType(prestataireDetails.getServiceType());
            prestataire.setRating(prestataireDetails.getRating());
            prestataire.setNombreEvaluations(prestataireDetails.getNombreEvaluations());
            prestataire.setPrixParHeure(prestataireDetails.getPrixParHeure());
            prestataire.setExperience(prestataireDetails.getExperience());
            prestataire.setJobsCompletes(prestataireDetails.getJobsCompletes());
            prestataire.setStatut(prestataireDetails.getStatut());
            prestataire.setTypeService(prestataireDetails.getTypeService());
            prestataire.setDescription(prestataireDetails.getDescription());
            prestataire.setImageProfil(prestataireDetails.getImageProfil());
            prestataire.setDateModification(LocalDateTime.now());
            
            return prestataireRepository.save(prestataire);
        });
    }

    // Mettre à jour le statut d'un prestataire
    public Optional<Prestataire> updateStatut(Long id, String statut) {
        return prestataireRepository.findById(id).map(prestataire -> {
            prestataire.setStatut(statut);
            prestataire.setDateModification(LocalDateTime.now());
            return prestataireRepository.save(prestataire);
        });
    }

    // Obtenir les statistiques des prestataires
    public Map<String, Object> getStatistiquesPrestataires() {
        List<Prestataire> allPrestataires = prestataireRepository.findAll();
        
        Map<String, Object> statistiques = new HashMap<>();
        statistiques.put("totalPrestataires", allPrestataires.size());
        statistiques.put("prestatairesDisponibles", 
            allPrestataires.stream().filter(p -> "DISPONIBLE".equals(p.getStatut())).count());
        statistiques.put("prestatairesOccupe", 
            allPrestataires.stream().filter(p -> "OCCUPE".equals(p.getStatut())).count());
        statistiques.put("prestatairesHorsLigne", 
            allPrestataires.stream().filter(p -> "HORS_LIGNE".equals(p.getStatut())).count());
        
        // Note moyenne
        double noteMoyenne = allPrestataires.stream()
            .mapToDouble(p -> p.getRating().doubleValue())
            .average()
            .orElse(0.0);
        statistiques.put("noteMoyenne", noteMoyenne);
        
        // Répartition par type de service
        Map<String, Long> repartitionTypeService = new HashMap<>();
        repartitionTypeService.put("A_DOMICILE", 
            allPrestataires.stream().filter(p -> "A_DOMICILE".equals(p.getTypeService())).count());
        repartitionTypeService.put("EN_PRESENCE", 
            allPrestataires.stream().filter(p -> "EN_PRESENCE".equals(p.getTypeService())).count());
        repartitionTypeService.put("LES_DEUX", 
            allPrestataires.stream().filter(p -> "LES_DEUX".equals(p.getTypeService())).count());
        statistiques.put("repartitionTypeService", repartitionTypeService);
        
        return statistiques;
    }

    // Supprimer un prestataire
    public boolean deletePrestataire(Long id) {
        if (prestataireRepository.existsById(id)) {
            prestataireRepository.deleteById(id);
            return true;
        }
        return false;
    }
}


