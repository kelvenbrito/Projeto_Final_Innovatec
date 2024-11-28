package com.example.industria.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class SparePartRequest {
    @Id
    private String sparePartId;
    public String getSparePartId() {
        return sparePartId;
    }
    public void setSparePartId(String sparePartId) {
        this.sparePartId = sparePartId;
    }
    public int getQuantityRequested() {
        return quantityRequested;
    }
    public void setQuantityRequested(int quantityRequested) {
        this.quantityRequested = quantityRequested;
    }
    private int quantityRequested;

    // Getters e Setters
}

