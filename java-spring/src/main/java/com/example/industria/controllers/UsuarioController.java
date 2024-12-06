package com.example.industria.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.industria.models.Usuario;
import com.example.industria.repositories.UsuarioRepository;

@Controller
public class UsuarioController {

    private final UsuarioRepository usuarioRepository;

    public UsuarioController(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    // Exibir a página de login
    @GetMapping("/login")
    public String exibirLogin(@RequestParam(value = "error", required = false) String error,
                              @RequestParam(value = "logout", required = false) String logout,
                              Model model) {
        if (error != null) {
            model.addAttribute("loginError", "Credenciais inválidas. Por favor, tente novamente.");
        }
        if (logout != null) {
            model.addAttribute("logoutMessage", "Você saiu com sucesso.");
        }
        return "login"; // Retorna o template 'login.html'
    }

    // Método POST para validar o login
    @PostMapping("/login")
    public String login(@RequestParam("email") String email,  // Alterado para e-mail
                        @RequestParam("senha") String senha,
                        Model model) {
        Usuario usuario = usuarioRepository.findByEmail(email);  // Busca pelo e-mail

        if (usuario != null && usuario.getSenha().equals(senha)) {
            return "redirect:/almox";  // Redireciona para a página principal após login bem-sucedido
        } else {
            model.addAttribute("loginError", "Usuário ou senha incorretos!"); // Mensagem de erro
            return "login";  // Retorna ao template de login
        }
    }


    
}
