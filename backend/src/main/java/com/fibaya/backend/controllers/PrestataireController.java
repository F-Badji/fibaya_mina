package com.fibaya.backend.controllers;

import com.fibaya.backend.models.Prestataire;
import com.fibaya.backend.services.PrestataireService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/prestataires")
@CrossOrigin(origins = "*")
public class PrestataireController {

    @Autowired
    private PrestataireService prestataireService;

    // Obtenir tous les prestataires disponibles
    @GetMapping("/disponibles")
    public ResponseEntity<List<Prestataire>> getPrestatairesDisponibles() {
        try {
            List<Prestataire> prestataires = prestataireService.getPrestatairesDisponibles();
            return ResponseEntity.ok(prestataires);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Obtenir un prestataire par ID
    @GetMapping("/{id}")
    public ResponseEntity<Prestataire> getPrestataireById(@PathVariable Long id) {
        try {
            Optional<Prestataire> prestataire = prestataireService.getPrestataireById(id);
            return prestataire.map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Rechercher des prestataires
    @GetMapping("/search")
    public ResponseEntity<List<Prestataire>> searchPrestataires(@RequestParam String q) {
        try {
            List<Prestataire> prestataires = prestataireService.searchPrestataires(q);
            return ResponseEntity.ok(prestataires);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Obtenir les prestataires par service
    @GetMapping("/service/{serviceType}")
    public ResponseEntity<List<Prestataire>> getPrestatairesByService(@PathVariable String serviceType) {
        try {
            List<Prestataire> prestataires = prestataireService.getPrestatairesByService(serviceType);
            return ResponseEntity.ok(prestataires);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Obtenir les prestataires par type de service (À domicile/En présence)
    @GetMapping("/type/{typeService}")
    public ResponseEntity<List<Prestataire>> getPrestatairesByTypeService(@PathVariable String typeService) {
        try {
            List<Prestataire> prestataires = prestataireService.getPrestatairesByTypeService(typeService);
            return ResponseEntity.ok(prestataires);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Créer un nouveau prestataire
    @PostMapping
    public ResponseEntity<Prestataire> createPrestataire(@RequestBody Prestataire prestataire) {
        try {
            Prestataire newPrestataire = prestataireService.createPrestataire(prestataire);
            return ResponseEntity.ok(newPrestataire);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Mettre à jour un prestataire
    @PutMapping("/{id}")
    public ResponseEntity<Prestataire> updatePrestataire(@PathVariable Long id, @RequestBody Prestataire prestataire) {
        try {
            Optional<Prestataire> updatedPrestataire = prestataireService.updatePrestataire(id, prestataire);
            return updatedPrestataire.map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Mettre à jour le statut d'un prestataire
    @PatchMapping("/{id}/statut")
    public ResponseEntity<Prestataire> updateStatut(@PathVariable Long id, @RequestParam String statut) {
        try {
            Optional<Prestataire> updatedPrestataire = prestataireService.updateStatut(id, statut);
            return updatedPrestataire.map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Obtenir les statistiques des prestataires
    @GetMapping("/statistiques")
    public ResponseEntity<Object> getStatistiquesPrestataires() {
        try {
            Object statistiques = prestataireService.getStatistiquesPrestataires();
            return ResponseEntity.ok(statistiques);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Supprimer un prestataire
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePrestataire(@PathVariable Long id) {
        try {
            boolean deleted = prestataireService.deletePrestataire(id);
            return deleted ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}


