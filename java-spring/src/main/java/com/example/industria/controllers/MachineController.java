package com.example.industria.controllers;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;

import com.example.industria.models.Machine;
import com.example.industria.models.SparePart;
import com.example.industria.repositories.MachineRepository;
import com.example.industria.repositories.SparePartRepository;

import java.util.List;

@Controller
@RequestMapping("/almox")
public class MachineController {

    private final MachineRepository machineRepository;
    private final SparePartRepository sparePartRepository;

    public MachineController(MachineRepository machineRepository, SparePartRepository sparePartRepository) {
        this.machineRepository = machineRepository; 
        this.sparePartRepository = sparePartRepository;
    }

    @GetMapping
    public String listarMachines(Model model) {
        List<Machine> machines = machineRepository.findAll();
        model.addAttribute("almox", machines);
        return "interna/interna-almoxarifado"; // Retorna para o template
    }

    @GetMapping("/{id}")
    public String listarSparePart(@PathVariable Long id, Model model) {
        // Recuperando a máquina com o ID
        Machine machine = machineRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Máquina não encontrada!"));

        // Recuperando a peça de reposição associada à máquina
        List<SparePart> spareParts = sparePartRepository.findByMachineId(id); // Deve ser uma lista

        // Adicionando atributos ao modelo
        model.addAttribute("machine", machine);
        model.addAttribute("spareParts", spareParts); // Usando spareParts no plural aqui

        // Retornando para o template 'spareParts.html'
        return "interna/spareParts";  // Especificando o caminho dentro da pasta 'interna'

    }
}