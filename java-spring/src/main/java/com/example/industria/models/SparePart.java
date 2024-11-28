package com.example.industria.models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class SparePart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private int quantityAvailable;
    private String code;

    @ManyToOne
    @JoinColumn(name = "machine_id")
    private Machine machine;

    public void updateStock(int quantity) {
        this.quantityAvailable += quantity;
    }
}
