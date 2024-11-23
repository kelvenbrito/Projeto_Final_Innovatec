package com.example.industria.services;

import com.example.industria.models.Usuario;
import com.example.industria.repositories.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service  // Indica que essa classe é um serviço do Spring
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;  // Injeção de dependência do repositório

    // Método para listar todos os usuários
    public List<Usuario> listarUsuarios() {
        return usuarioRepository.findAll();  // Retorna todos os usuários
    }

    // Método para encontrar um usuário pelo ID
    public Usuario encontrarPorId(Long id) {
        Optional<Usuario> usuario = usuarioRepository.findById(id);
        return usuario.orElse(null);  // Retorna o usuário ou null se não encontrado
    }

    // Método para salvar um novo usuário
    public Usuario salvarUsuario(Usuario usuario) {
        return usuarioRepository.save(usuario);  // Salva o usuário no banco de dados
    }

    // Método para excluir um usuário
    public void excluirUsuario(Long id) {
        usuarioRepository.deleteById(id);  // Exclui o usuário pelo ID
    }
}
