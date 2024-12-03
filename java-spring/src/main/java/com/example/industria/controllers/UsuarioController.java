package com.example.industria.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.industria.models.Usuario;
import com.example.industria.repositories.UsuarioRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class UsuarioController {

    private final UsuarioRepository usuarioRepository;

    public UsuarioController(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    // Método GET para exibir a página de login
    @GetMapping("/login")
    public String exibirLogin() {
        return "login";  // Retorna o template de login
    }

    // Método POST para validar o login
    @PostMapping("/login")
    public String login(@RequestParam("email") String email,  // Alterar nome para email
                        @RequestParam("senha") String senha,
                        Model model) {
        Usuario usuario = usuarioRepository.findByEmail(email);  // Usando findByEmail

        if (usuario != null && usuario.getSenha().equals(senha)) {
            return "redirect:/almox";  // Redireciona para a página principal após login bem-sucedido
        } else {
            model.addAttribute("loginError", "Usuário ou senha incorretos!");
            return "login";  // Retorna à página de login com a mensagem de erro
        }
    }

    

      // Método GET para realizar logout
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // Invalidar a sessão
        session.invalidate();
        return "redirect:/";  // Redireciona para a página inicial
            }

}
