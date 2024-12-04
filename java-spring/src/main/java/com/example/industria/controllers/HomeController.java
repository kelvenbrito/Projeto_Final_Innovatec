package com.example.industria.controllers;

import com.example.industria.models.Usuario;
import com.example.industria.services.UsuarioService;
import com.example.industria.models.Tarefa;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private UsuarioService usuarioService;

    // Página inicial
    @GetMapping("/")
    public String home() {
        return "index";
    }
    
    // rota pagina interna almoxarifado
     @GetMapping("/almoxarifado")
    public String exibirPaginaAlmoxarifado() {
        return "interna/interna-almoxarifado"; // Nome do arquivo HTML na pasta templates
    }


    // Página de criação de tarefa
    @GetMapping("/tarefas/nova")
    public String novaTarefa(Model model) {
        List<Usuario> usuarios = usuarioService.listarUsuarios();
        model.addAttribute("usuarios", usuarios);
        model.addAttribute("tarefa", new Tarefa());
        return "tarefas-nova";
    }


    @GetMapping("/usuarios/novo")
    public String about() {
        return "cadastrar-usuario"; // Nome do arquivo HTML para outra página
    }
}
