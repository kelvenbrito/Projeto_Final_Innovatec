package com.example.industria.models;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter

public class Machine {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)  // Geração automática do ID
    private Long id;
    private String name;
    private String description;

    @OneToMany(mappedBy = "machine", cascade = CascadeType.ALL)
    private List<SparePart> spareParts;

    // Getters e Setters
}
    

