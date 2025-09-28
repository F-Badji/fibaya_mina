package com.fibaya.backend.models;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "prestataires")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Prestataire {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String nom;
    
    @Column(nullable = false)
    private String prenom;
    
    @Column(nullable = false, unique = true)
    private String telephone;
    
    @Column
    private String adresse;
    
    @Column
    private String ville;
    
    @Column
    private String codePostal;
    
    @Column(nullable = false)
    private String serviceType;
    
    @Column
    private String experience;
    
    @Column(nullable = false)
    private String statut = "DISPONIBLE";
    
    @Column
    private String typeService = "LES_DEUX";
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(columnDefinition = "TEXT")
    private String certifications;
    
    @Column
    private String versionDocument = "Pro";
    
    @Column
    private String carteIdentiteRecto;
    
    @Column
    private String carteIdentiteVerso;
    
    @Column
    private String cv;
    
    @Column
    private String diplome;
    
    @Column
    private String imageProfil;
    
    @Column(nullable = false)
    private LocalDateTime dateCreation = LocalDateTime.now();
    
    @Column
    private LocalDateTime dateModification;
    
    @PreUpdate
    protected void onUpdate() {
        dateModification = LocalDateTime.now();
    }
}