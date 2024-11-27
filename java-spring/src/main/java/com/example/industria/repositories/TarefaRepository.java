package com.example.industria.repositories;

import com.example.industria.models.Tarefa;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TarefaRepository extends JpaRepository<Tarefa, Long> {

    // Método para encontrar tarefas por status
    List<Tarefa> findByStatus(String status);

    // Método para encontrar tarefas por usuário
    List<Tarefa> findByUsuarioId(Long usuarioId);
}
