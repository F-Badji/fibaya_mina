package com.fibaya.backend.services;

import com.fibaya.backend.models.Prestataire;
import com.fibaya.backend.models.PrestataireValide;
import com.fibaya.backend.repositories.PrestataireValideRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class PrestataireValideService {
    
    @Autowired
    private PrestataireValideRepository prestataireValideRepository;
    
    /**
     * Vérifier si un numéro de téléphone est validé par l'administrateur
     */
    public boolean isPrestataireValide(String telephone) {
        // Normaliser le numéro de téléphone (enlever le préfixe +221 si présent)
        String normalizedPhone = normalizePhoneNumber(telephone);
        
        // Vérifier avec le numéro normalisé
        return prestataireValideRepository.existsByTelephoneAndStatut(normalizedPhone, "VALIDE");
    }
    
    /**
     * Normaliser un numéro de téléphone en enlevant le préfixe +221
     */
    private String normalizePhoneNumber(String phone) {
        if (phone == null) return null;
        
        // Enlever les espaces et caractères spéciaux
        String cleaned = phone.replaceAll("[\\s\\-()]", "");
        
        // Si le numéro commence par +221, l'enlever
        if (cleaned.startsWith("+221")) {
            return cleaned.substring(4);
        }
        
        // Si le numéro commence par 221, l'enlever aussi
        if (cleaned.startsWith("221")) {
            return cleaned.substring(3);
        }
        
        return cleaned;
    }
    
    /**
     * Ajouter un prestataire à la liste des validés
     */
    public PrestataireValide validerPrestataire(Prestataire prestataire, String validePar) {
        // Vérifier si déjà validé
        if (prestataireValideRepository.existsByTelephone(prestataire.getTelephone())) {
            // Mettre à jour le statut existant
            Optional<PrestataireValide> existing = prestataireValideRepository.findByTelephone(prestataire.getTelephone());
            if (existing.isPresent()) {
                PrestataireValide prestataireValide = existing.get();
                prestataireValide.setStatut("VALIDE");
                prestataireValide.setValidePar(validePar);
                return prestataireValideRepository.save(prestataireValide);
            }
        }
        
        // Créer un nouveau prestataire validé
        PrestataireValide prestataireValide = new PrestataireValide(
            prestataire.getTelephone(),
            prestataire.getNom(),
            prestataire.getPrenom(),
            validePar
        );
        
        return prestataireValideRepository.save(prestataireValide);
    }
    
    /**
     * Suspendre un prestataire validé
     */
    public PrestataireValide suspendrePrestataire(String telephone, String validePar) {
        Optional<PrestataireValide> prestataireValide = prestataireValideRepository.findByTelephone(telephone);
        if (prestataireValide.isPresent()) {
            PrestataireValide pv = prestataireValide.get();
            pv.setStatut("SUSPENDU");
            pv.setValidePar(validePar);
            return prestataireValideRepository.save(pv);
        }
        return null;
    }
    
    /**
     * Obtenir les détails d'un prestataire validé
     */
    public Optional<PrestataireValide> getPrestataireValide(String telephone) {
        return prestataireValideRepository.findByTelephone(telephone);
    }
}
