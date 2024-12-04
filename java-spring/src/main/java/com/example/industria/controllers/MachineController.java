package com.example.industria.controllers;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
        model.addAttribute("machines", machines);
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

    // Incrementar quantidade de peças
    @PostMapping("/spareParts/increment")
    public String incrementSparePartQuantity(
            @RequestParam Long id,
            @RequestParam int quantity,
            RedirectAttributes redirectAttributes) {

        // Buscar peça pelo ID
        SparePart sparePart = sparePartRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Peça não encontrada!"));

        // Incrementar a quantidade
        sparePart.setQuantityAvailable(sparePart.getQuantityAvailable() + quantity);
        sparePartRepository.save(sparePart); // Salvar no banco

        // Mensagem de sucesso
        redirectAttributes.addFlashAttribute("msg", "Quantidade incrementada com sucesso!");
        redirectAttributes.addFlashAttribute("msgType", "success");

        // Redirecionar para a página da máquina associada
        return "redirect:/almox/" + sparePart.getMachine().getId();
    }

    // Decrementar quantidade de peças
    @PostMapping("/spareParts/decrement")
    public String decrementSparePartQuantity(
            @RequestParam Long id,
            @RequestParam int quantity,
            RedirectAttributes redirectAttributes) {

        // Buscar peça pelo ID
        SparePart sparePart = sparePartRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Peça não encontrada!"));

        // Verificar se há quantidade suficiente para decrementar
        if (sparePart.getQuantityAvailable() >= quantity) {
            sparePart.setQuantityAvailable(sparePart.getQuantityAvailable() - quantity);
            sparePartRepository.save(sparePart); // Salvar no banco

            // Mensagem de sucesso
            redirectAttributes.addFlashAttribute("msg", "Quantidade decrementada com sucesso!");
            redirectAttributes.addFlashAttribute("msgType", "success");
        } else {
            // Mensagem de erro
            redirectAttributes.addFlashAttribute("msg", "Quantidade insuficiente no estoque!");
            redirectAttributes.addFlashAttribute("msgType", "error");
        }

        // Redirecionar para a página da máquina associada
        return "redirect:/almox/" + sparePart.getMachine().getId();
    }
}
