package com.example.industria.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.industria.models.Usuario;
import com.example.industria.repositories.UsuarioRepository;

@Controller
@RequestMapping("/usuarios")
public class UsuarioController {

    private final UsuarioRepository usuarioRepository;

    public UsuarioController(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    // Método de login
    @PostMapping("/login")
    public String login(@RequestParam("username") String username, 
                        @RequestParam("password") String password, 
                        Model model) {
        Usuario usuario = usuarioRepository.findByEmail(username);

        if (usuario != null && usuario.getSenha().equals(password)) {
            return "redirect:/home";  // Login bem-sucedido, redireciona para a home
        } else {
            model.addAttribute("error", "Usuário ou senha incorretos!");
            return "login";  // Retorna para a página de login com erro
        }
    }
}
