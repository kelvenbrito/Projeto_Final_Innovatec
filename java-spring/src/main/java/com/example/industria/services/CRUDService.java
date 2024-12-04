package com.example.industria.services;

import java.util.concurrent.ExecutionException;

import org.springframework.stereotype.Service;

import com.example.industria.models.CRUD;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import com.google.firebase.cloud.FirestoreClient;

@Service
public class CRUDService {

    private final Firestore dbFirestore;

    public CRUDService() {
        this.dbFirestore = FirestoreClient.getFirestore();
    }

    public String createCRUD(CRUD crud) throws InterruptedException, ExecutionException {
        ApiFuture<WriteResult> collectionsApiFuture = dbFirestore
                .collection("crud_user")
                .document(crud.getDocumentId()) // Corrigido para pegar o documentId ao invés do nome, dependendo da lógica de nomeação.
                .set(crud);

        return collectionsApiFuture.get().getUpdateTime().toString();
    }

    public CRUD getCRUD(String documentId) throws InterruptedException, ExecutionException {
        ApiFuture<DocumentSnapshot> future = dbFirestore.collection("crud_user").document(documentId).get();
        DocumentSnapshot document = future.get();

        if (document.exists()) {
            return document.toObject(CRUD.class); // Converte o documento para o objeto CRUD
        } else {
            throw new RuntimeException("Documento com ID: " + documentId + " não encontrado.");
        }
    }

    public String updateCRUD(CRUD crud) throws InterruptedException, ExecutionException {
        ApiFuture<WriteResult> future = dbFirestore
                .collection("crud_user")
                .document(crud.getDocumentId())
                .set(crud);

        return future.get().getUpdateTime().toString();
    }

    public String deleteCRUD(String documentId) throws InterruptedException, ExecutionException {
        ApiFuture<WriteResult> future = dbFirestore.collection("crud_user").document(documentId).delete();
        future.get(); // Aguarda a execução da exclusão.
        return "Documento " + documentId + " deletado com sucesso!";
    }
}
