package com.example.industria.controllers;

import com.example.industria.models.Tarefa;
import com.example.industria.repositories.TarefaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/tarefas")
public class TarefaController {

    @Autowired
    private TarefaRepository tarefaRepository;

    // Endpoint para cadastrar uma nova tarefa (vai receber dados via POST)
    @PostMapping("/nova")
    public ResponseEntity<Tarefa> cadastrarTarefa(@RequestBody Tarefa tarefa) {
        Tarefa novaTarefa = tarefaRepository.save(tarefa);
        return new ResponseEntity<>(novaTarefa, HttpStatus.CREATED);
    }

    // Endpoint para listar todas as tarefas
    @GetMapping
    public List<Tarefa> listarTarefas() {
        return tarefaRepository.findAll();
    }

    // Endpoint para listar tarefas por status
    @GetMapping("/status/{status}")
    public List<Tarefa> listarTarefasPorStatus(@PathVariable String status) {
        return tarefaRepository.findByStatus(status); // Supondo que exista esse método no repositório
    }

    // Endpoint para listar tarefas de um usuário específico
    @GetMapping("/usuario/{usuarioId}")
    public List<Tarefa> listarTarefasPorUsuario(@PathVariable Long usuarioId) {
        return tarefaRepository.findByUsuarioId(usuarioId); // Supondo que exista esse método no repositório
    }

    // Endpoint para atualizar uma tarefa existente
    @PutMapping("/{id}")
    public ResponseEntity<Tarefa> atualizarTarefa(@PathVariable Long id, @RequestBody Tarefa tarefaAtualizada) {
        Optional<Tarefa> tarefaOptional = tarefaRepository.findById(id);
        
        if (tarefaOptional.isPresent()) {
            Tarefa tarefa = tarefaOptional.get();
            tarefa.setStatus(tarefaAtualizada.getStatus());
            tarefa.setPrioridade(tarefaAtualizada.getPrioridade());
            Tarefa tarefaSalva = tarefaRepository.save(tarefa);
            return new ResponseEntity<>(tarefaSalva, HttpStatus.OK);
        }
        
        return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Retorna 404 se a tarefa não for encontrada
    }

    // Endpoint para deletar uma tarefa
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarTarefa(@PathVariable Long id) {
        Optional<Tarefa> tarefaOptional = tarefaRepository.findById(id);
        
        if (tarefaOptional.isPresent()) {
            tarefaRepository.deleteById(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT); // Retorna 204 se a tarefa for deletada com sucesso
        }
        
        return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Retorna 404 se a tarefa não for encontrada
    }
}
