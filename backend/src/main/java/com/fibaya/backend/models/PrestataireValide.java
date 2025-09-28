package com.fibaya.backend.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "prestataires_valides")
public class PrestataireValide {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "telephone", nullable = false, unique = true)
    private String telephone;
    
    @Column(name = "nom", nullable = false)
    private String nom;
    
    @Column(name = "prenom", nullable = false)
    private String prenom;
    
    @Column(name = "date_validation", nullable = false)
    private LocalDateTime dateValidation;
    
    @Column(name = "valide_par")
    private String validePar; // ID ou nom de l'administrateur qui a validé
    
    @Column(name = "statut", nullable = false)
    private String statut = "VALIDE"; // VALIDE, SUSPENDU, etc.
    
    // Constructeurs
    public PrestataireValide() {}
    
    public PrestataireValide(String telephone, String nom, String prenom, String validePar) {
        this.telephone = telephone;
        this.nom = nom;
        this.prenom = prenom;
        this.validePar = validePar;
        this.dateValidation = LocalDateTime.now();
    }
    
    // Getters et Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTelephone() {
        return telephone;
    }
    
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public String getPrenom() {
        return prenom;
    }
    
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    
    public LocalDateTime getDateValidation() {
        return dateValidation;
    }
    
    public void setDateValidation(LocalDateTime dateValidation) {
        this.dateValidation = dateValidation;
    }
    
    public String getValidePar() {
        return validePar;
    }
    
    public void setValidePar(String validePar) {
        this.validePar = validePar;
    }
    
    public String getStatut() {
        return statut;
    }
    
    public void setStatut(String statut) {
        this.statut = statut;
    }
}
