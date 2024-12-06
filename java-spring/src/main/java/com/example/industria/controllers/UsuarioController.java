package com.example.industria.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class UsuarioController {

    // Exibir a página de login
    @GetMapping("/login")
    public String exibirLogin(@RequestParam(value = "error", required = false) String error,
                              @RequestParam(value = "logout", required = false) String logout,
                              Model model) {
        if ("unauthorized".equals(error)) {
            model.addAttribute("loginError", "Você precisa fazer login para acessar esta página.");
        } else if (error != null) {
            model.addAttribute("loginError", "Credenciais inválidas. Por favor, tente novamente.");
        }

        if (logout != null) {
            model.addAttribute("logoutMessage", "Você saiu com sucesso.");
        }

        return "login"; // Retorna o template 'login.html'
    }
}
