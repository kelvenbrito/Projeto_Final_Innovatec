package com.example.industria.controllers;

import java.util.concurrent.ExecutionException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.industria.models.CRUD;
import com.example.industria.services.CRUDService;

@RestController
public class CRUDController {

    private final CRUDService crudService;

    // Injeção de dependência via construtor
    @Autowired
    public CRUDController(CRUDService crudService) {
        this.crudService = crudService;
    }

    @PostMapping("/create")
    public String createCRUD(@RequestBody CRUD crud) {
        try {
            return crudService.createCRUD(crud);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
            return "Erro ao criar o CRUD: " + e.getMessage();
        }
    }

    @GetMapping("/get")
    public CRUD getCRUD(@RequestParam String documentId) {
        try {
            return crudService.getCRUD(documentId);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PutMapping("/update")
    public String updateCRUD(@RequestBody CRUD crud) {
        try {
            return crudService.updateCRUD(crud);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
            return "Erro ao atualizar o CRUD: " + e.getMessage();
        }
    }

    @DeleteMapping("/delete")
    public String deleteCRUD(@RequestParam String documentId) {
        try {
            return crudService.deleteCRUD(documentId);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
            return "Erro ao deletar o CRUD: " + e.getMessage();
        }
    }
}
