package com.example.industria.controllers;

import com.example.industria.models.Usuario;
import com.example.industria.services.UsuarioService;
import com.example.industria.models.Tarefa;
import com.example.industria.services.TarefaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private UsuarioService usuarioService;

    @Autowired
    private TarefaService tarefaService;

    // Página inicial
    @GetMapping("/")
    public String home() {
        return "index";
    }

    // Página de criação de tarefa
    @GetMapping("/tarefas/nova")
    public String novaTarefa(Model model) {
        List<Usuario> usuarios = usuarioService.listarUsuarios();
        model.addAttribute("usuarios", usuarios);
        model.addAttribute("tarefa", new Tarefa());
        return "tarefas-nova";
    }

    // Página de login
    @GetMapping("/login")
    public String login() {
        return "login"; // Nome do arquivo dentro de templates, sem a extensão .html
    }

    // Método para salvar nova tarefa
    @PostMapping("/tarefas/salvar")
    public String salvarTarefa(Tarefa tarefa, Model model) {
        try {
            tarefaService.salvarTarefa(tarefa);
            return "redirect:/";
        } catch (Exception e) {
            model.addAttribute("erro", "Ocorreu um erro ao salvar a tarefa.");
            List<Usuario> usuarios = usuarioService.listarUsuarios();  // Buscar usuários novamente
            model.addAttribute("usuarios", usuarios);  // Passar lista de usuários para a view
            model.addAttribute("tarefa", tarefa);  // Passar a tarefa atual
            return "tarefas-nova";  // Retorna para o formulário de criação de tarefa com mensagem de erro
        }
    }


    @GetMapping("/usuarios/novo")
    public String about() {
        return "cadastrar-usuario"; // Nome do arquivo HTML para outra página
    }
}
