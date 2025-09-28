package com.fibaya.backend.controllers;

import com.fibaya.backend.models.Prestataire;
import com.fibaya.backend.models.PrestataireValide;
import com.fibaya.backend.services.PrestataireService;
import com.fibaya.backend.services.PrestataireValideService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/prestataires")
@CrossOrigin(origins = "*")
public class PrestataireController {

    @Autowired
    private PrestataireService prestataireService;
    
    @Autowired
    private PrestataireValideService prestataireValideService;

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
            // Vérifier si le numéro de téléphone existe déjà
            if (prestataireService.existsByTelephone(prestataire.getTelephone())) {
                return ResponseEntity.badRequest().build();
            }
            
            Prestataire newPrestataire = prestataireService.createPrestataire(prestataire);
            return ResponseEntity.ok(newPrestataire);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Créer un nouveau prestataire avec fichiers
    @PostMapping("/with-files")
    public ResponseEntity<Prestataire> createPrestataireWithFiles(
            @RequestParam("nom") String nom,
            @RequestParam("prenom") String prenom,
            @RequestParam("telephone") String telephone,
            @RequestParam("serviceType") String serviceType,
            @RequestParam("typeService") String typeService,
            @RequestParam("experience") String experience,
            @RequestParam("description") String description,
            @RequestParam(value = "adresse", required = false) String adresse,
            @RequestParam(value = "ville", required = false) String ville,
            @RequestParam(value = "codePostal", required = false) String codePostal,
            @RequestParam(value = "certifications", required = false) String certifications,
            @RequestParam(value = "versionDocument", required = false) String versionDocument,
            @RequestParam(value = "imageProfil", required = false) MultipartFile imageProfil,
            @RequestParam(value = "carteIdentiteRecto", required = false) MultipartFile carteIdentiteRecto,
            @RequestParam(value = "carteIdentiteVerso", required = false) MultipartFile carteIdentiteVerso,
            @RequestParam(value = "cv", required = false) MultipartFile cv,
            @RequestParam(value = "diplome", required = false) MultipartFile diplome) {
        try {
            // Vérifier si le numéro de téléphone existe déjà
            if (prestataireService.existsByTelephone(telephone)) {
                return ResponseEntity.badRequest().build();
            }

            // Créer le dossier uploads s'il n'existe pas
            File uploadDir = new File("uploads");
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Créer le prestataire
            Prestataire prestataire = new Prestataire();
            prestataire.setNom(nom);
            prestataire.setPrenom(prenom);
            prestataire.setTelephone(telephone);
            prestataire.setServiceType(serviceType);
            prestataire.setTypeService(typeService);
            prestataire.setExperience(experience);
            prestataire.setDescription(description);
            prestataire.setAdresse(adresse);
            prestataire.setVille(ville);
            prestataire.setCodePostal(codePostal);
            prestataire.setCertifications(certifications);
            prestataire.setVersionDocument(versionDocument != null ? versionDocument : "Pro");

            // Traiter les fichiers
            if (imageProfil != null && !imageProfil.isEmpty()) {
                String fileName = saveFile(imageProfil);
                prestataire.setImageProfil(fileName);
            }
            if (carteIdentiteRecto != null && !carteIdentiteRecto.isEmpty()) {
                String fileName = saveFile(carteIdentiteRecto);
                prestataire.setCarteIdentiteRecto(fileName);
            }
            if (carteIdentiteVerso != null && !carteIdentiteVerso.isEmpty()) {
                String fileName = saveFile(carteIdentiteVerso);
                prestataire.setCarteIdentiteVerso(fileName);
            }
            if (cv != null && !cv.isEmpty()) {
                String fileName = saveFile(cv);
                prestataire.setCv(fileName);
            }
            if (diplome != null && !diplome.isEmpty()) {
                String fileName = saveFile(diplome);
                prestataire.setDiplome(fileName);
            }

            Prestataire newPrestataire = prestataireService.createPrestataire(prestataire);
            return ResponseEntity.ok(newPrestataire);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    private String saveFile(MultipartFile file) throws IOException {
        String originalFileName = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        String fileName = UUID.randomUUID().toString() + fileExtension;
        Path targetLocation = Paths.get("uploads/" + fileName);
        Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
        return fileName;
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

    // Valider un prestataire (changer le statut vers DISPONIBLE et l'ajouter à la liste des validés)
    @PatchMapping("/{id}/valider")
    public ResponseEntity<Map<String, Object>> validerPrestataire(@PathVariable Long id, @RequestParam(defaultValue = "admin") String validePar) {
        try {
            Optional<Prestataire> prestataire = prestataireService.getPrestataireById(id);
            if (prestataire.isEmpty()) {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Prestataire non trouvé"
                );
                return ResponseEntity.notFound().build();
            }

            Prestataire p = prestataire.get();
            
            // Mettre à jour le statut vers DISPONIBLE
            Optional<Prestataire> updatedPrestataire = prestataireService.updateStatut(id, "DISPONIBLE");
            
            if (updatedPrestataire.isPresent()) {
                // Ajouter le prestataire à la liste des validés
                prestataireValideService.validerPrestataire(p, validePar);
                
                Map<String, Object> response = Map.of(
                    "success", true,
                    "message", "Prestataire validé avec succès et ajouté à la liste des validés",
                    "prestataire", updatedPrestataire.get(),
                    "telephone", p.getTelephone()
                );
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Erreur lors de la validation du prestataire"
                );
                return ResponseEntity.internalServerError().body(errorResponse);
            }
        } catch (Exception e) {
            Map<String, Object> errorResponse = Map.of(
                "success", false,
                "message", "Erreur interne du serveur: " + e.getMessage()
            );
            return ResponseEntity.internalServerError().body(errorResponse);
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

    // Vérifier si un numéro de téléphone est validé par l'administrateur
    @GetMapping("/check-validation/{telephone}")
    public ResponseEntity<Map<String, Object>> checkValidation(@PathVariable String telephone) {
        try {
            boolean isValide = prestataireValideService.isPrestataireValide(telephone);
            Map<String, Object> response = Map.of(
                "telephone", telephone,
                "isValide", isValide,
                "message", isValide ? "Numéro validé par l'administrateur" : "Numéro non validé"
            );
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = Map.of(
                "success", false,
                "message", "Erreur lors de la vérification: " + e.getMessage()
            );
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }

    // Suspendre un prestataire validé
    @PatchMapping("/{id}/suspendre")
    public ResponseEntity<Map<String, Object>> suspendrePrestataire(@PathVariable Long id, @RequestParam(defaultValue = "admin") String validePar) {
        try {
            Optional<Prestataire> prestataire = prestataireService.getPrestataireById(id);
            if (prestataire.isEmpty()) {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Prestataire non trouvé"
                );
                return ResponseEntity.notFound().build();
            }

            Prestataire p = prestataire.get();
            
            // Suspendre le prestataire dans la table des validés
            PrestataireValide prestataireSuspendu = prestataireValideService.suspendrePrestataire(p.getTelephone(), validePar);
            
            if (prestataireSuspendu != null) {
                Map<String, Object> response = Map.of(
                    "success", true,
                    "message", "Prestataire suspendu avec succès",
                    "prestataire", p,
                    "telephone", p.getTelephone(),
                    "statut", "SUSPENDU"
                );
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Prestataire non trouvé dans la liste des validés"
                );
                return ResponseEntity.badRequest().body(errorResponse);
            }
        } catch (Exception e) {
            Map<String, Object> errorResponse = Map.of(
                "success", false,
                "message", "Erreur interne du serveur: " + e.getMessage()
            );
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
}


