package com.example.industria.repositories;

import com.example.industria.models.SparePart;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SparePartRepository extends JpaRepository<SparePart, Long> {
    List<SparePart> findByMachineId(Long machineId);
}
