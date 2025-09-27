package com.fibaya.backend.models;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "phone_formats")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PhoneFormat {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String countryName;
    
    @Column(nullable = false)
    private String countryCode;
    
    @Column(nullable = false)
    private Integer totalDigits;
    
    @Column(nullable = false, columnDefinition = "TEXT[]")
    private String[] mobilePrefixes;
    
    @Column(nullable = false)
    private String exampleNumber;
    
    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column
    private LocalDateTime updatedAt;
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
