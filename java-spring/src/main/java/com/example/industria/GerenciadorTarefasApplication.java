package com.example.industria;

import java.io.FileInputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

@SpringBootApplication
public class GerenciadorTarefasApplication {

    public static void main(String[] args) {
        try {
            if (FirebaseApp.getApps().isEmpty()) { // Verifica se o Firebase já foi inicializado
                ClassLoader classLoader = GerenciadorTarefasApplication.class.getClassLoader();
                URL resource = classLoader.getResource("serviceAccountKey.json");
                if (resource == null) {
                    throw new IOException("Arquivo serviceAccountKey.json não encontrado.");
                }

                Path path = Paths.get(resource.toURI());
                try (FileInputStream serviceAccount = new FileInputStream(path.toFile())) {
                    FirebaseOptions options = FirebaseOptions.builder()
                            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                            .build();
                    FirebaseApp.initializeApp(options);
                }
            }

            SpringApplication.run(GerenciadorTarefasApplication.class, args);
        } catch (IOException | URISyntaxException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao inicializar a aplicação.", e);
        }
    }
}
