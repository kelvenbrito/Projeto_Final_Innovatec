package com.example.industria.services;

import com.example.industria.models.Tarefa;
import com.example.industria.repositories.TarefaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TarefaService {

    @Autowired
    private TarefaRepository tarefaRepository;  // Injeção de dependência do repositório

    // Método para listar todas as tarefas
    public List<Tarefa> listarTarefas() {
        return tarefaRepository.findAll();  // Retorna todas as tarefas
    }

    // Método para encontrar uma tarefa pelo ID
    public Tarefa encontrarPorId(Long id) {
        return tarefaRepository.findById(id).orElse(null);  // Retorna a tarefa ou null se não encontrada
    }

    // Método para salvar uma nova tarefa
    public Tarefa salvarTarefa(Tarefa tarefa) {
        return tarefaRepository.save(tarefa);  // Salva a tarefa no banco de dados
    }

    // Método para excluir uma tarefa
    public void excluirTarefa(Long id) {
        tarefaRepository.deleteById(id);  // Exclui a tarefa pelo ID
    }
}
