package com.fibaya.backend.services;

import com.fibaya.backend.models.Service;
import com.fibaya.backend.repositories.ServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;

@org.springframework.stereotype.Service
public class ServiceService {
    
    @Autowired
    private ServiceRepository serviceRepository;
    
    public List<Service> getAllServices() {
        return serviceRepository.findAll();
    }
    
    public List<Service> getServicesByCategory(String category) {
        return serviceRepository.findByCategory(category);
    }
}
