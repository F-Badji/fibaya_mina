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
    private String email;
    
    @Column
    private String adresse;
    
    @Column
    private Double latitude;
    
    @Column
    private Double longitude;
    
    @Column(nullable = false)
    private String serviceType;
    
    @Column(precision = 3, scale = 2)
    private BigDecimal rating = BigDecimal.ZERO;
    
    @Column
    private Integer nombreEvaluations = 0;
    
    @Column
    private String prixParHeure;
    
    @Column
    private String experience;
    
    @Column
    private Integer jobsCompletes = 0;
    
    @Column(nullable = false)
    private String statut = "DISPONIBLE";
    
    @Column
    private String typeService = "LES_DEUX";
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
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