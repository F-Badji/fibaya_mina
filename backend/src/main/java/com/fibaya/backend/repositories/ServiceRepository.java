package com.fibaya.backend.repositories;

import com.fibaya.backend.models.Service;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ServiceRepository extends JpaRepository<Service, Long> {
    List<Service> findByIsActiveTrue();
    List<Service> findByCategory(String category);
}