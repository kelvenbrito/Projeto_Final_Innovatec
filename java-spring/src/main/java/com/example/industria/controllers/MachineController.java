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
@RequestMapping("/machines")
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
        model.addAttribute("machines", machines);
        return "machines"; // Retorna para o template 'machines.html'
    }

    @GetMapping("/{id}")
    public String listarPecas(@PathVariable Long id, Model model) {
        Machine machine = machineRepository.findById(id).orElseThrow(() -> new RuntimeException("Máquina não encontrada!"));
        List<SparePart> spareParts = sparePartRepository.findByMachineId(id);
        model.addAttribute("machine", machine);
        model.addAttribute("spareParts", spareParts);
        return "spareParts"; // Retorna para o template 'spareParts.html'
    }
}
