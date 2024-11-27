package com.example.industria.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.industria.models.Request;

@Repository
public interface RequestRepository extends JpaRepository<Request, String> {
}

