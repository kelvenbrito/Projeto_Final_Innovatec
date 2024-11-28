package com.example.industria.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.industria.models.Machine;

@Service
public class QRCodeScannerService {

    @Autowired
    private FirebaseService firebaseService;

    public Machine scanQRCode(String qrData) {
        return firebaseService.getMachineData(qrData);
    }

    public boolean validateQRCode(String qrData) {
            return false;
        // Lógica para validação
    }
}

