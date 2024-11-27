package com.example.industria.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.industria.models.SparePart;

@Repository
public interface SparePartRepository extends JpaRepository<SparePart, String> {
}

