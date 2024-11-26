package com.example.industria.controllers;

import com.example.industria.models.Usuario;
import com.example.industria.services.UsuarioService;  // Serviço para buscar os usuários
import com.example.industria.models.Tarefa;
import com.example.industria.services.TarefaService;  // Serviço para manipular tarefas
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private UsuarioService usuarioService;  // Serviço para buscar usuários

    @Autowired
    private TarefaService tarefaService;  // Serviço para manipular tarefas

    // Página inicial
    @GetMapping("/")
    public String home() {
        return "index";  // Nome do arquivo dentro de templates, sem a extensão .html
    }

    

    // Página de criação de tarefa
    @GetMapping("/tarefas/nova")
    public String novaTarefa(Model model) {
        List<Usuario> usuarios = usuarioService.listarUsuarios();  // Buscar usuários
        model.addAttribute("usuarios", usuarios);  // Passar lista de usuários para a view
        model.addAttribute("tarefa", new Tarefa());  // Passar objeto de tarefa vazio
        return "tarefas-nova";  // Nome do arquivo nova-tarefa.html dentro de templates
    }

    

    

    // Método para salvar nova tarefa
    @PostMapping("/tarefas/salvar")
    public String salvarTarefa(Tarefa tarefa, Model model) {
        try {
            tarefaService.salvarTarefa(tarefa);  // Salvar a tarefa usando o serviço
            return "redirect:/";  // Redireciona para a página inicial após salvar
        } catch (Exception e) {
            model.addAttribute("erro", "Ocorreu um erro ao salvar a tarefa.");
            List<Usuario> usuarios = usuarioService.listarUsuarios();  // Buscar usuários novamente
            model.addAttribute("usuarios", usuarios);  // Passar lista de usuários para a view
            model.addAttribute("tarefa", tarefa);  // Passar a tarefa atual
            return "tarefas-nova";  // Retorna para o formulário de criação de tarefa com mensagem de erro
        }
    }
}
