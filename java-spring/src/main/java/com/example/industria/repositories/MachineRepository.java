package com.example.industria.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.industria.models.Machine;

@Repository
public interface MachineRepository extends JpaRepository<Machine, Long> {
    
    

}
