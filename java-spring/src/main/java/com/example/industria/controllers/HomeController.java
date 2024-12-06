package com.example.industria.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    // Página inicial
    @GetMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/usuarios/novo")
    public String about() {
        return "cadastrar-usuario"; // Nome do arquivo HTML para outra página
    }
}
