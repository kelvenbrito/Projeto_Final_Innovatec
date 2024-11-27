package com.example.industria.models;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;

@Entity
public class Request {
    @Id
    private String id;

    private String userId;
    private String machineId;

    @OneToMany(cascade = CascadeType.ALL)
    private List<SparePartRequest> requestedParts;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getMachineId() {
        return machineId;
    }

    public void setMachineId(String machineId) {
        this.machineId = machineId;
    }

    public List<SparePartRequest> getRequestedParts() {
        return requestedParts;
    }

    public void setRequestedParts(List<SparePartRequest> requestedParts) {
        this.requestedParts = requestedParts;
    }

    public LocalDateTime getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(LocalDateTime requestDate) {
        this.requestDate = requestDate;
    }

    private LocalDateTime requestDate;

    // Getters e Setters
}

