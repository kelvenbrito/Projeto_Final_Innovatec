package com.example.industria.controllers;

import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.industria.models.SparePart;
import com.example.industria.repositories.SparePartRepository;

@Controller
public class SparePartController {

    private final SparePartRepository sparePartRepository;

    // Injeção do repositório
    public SparePartController(SparePartRepository sparePartRepository) {
        this.sparePartRepository = sparePartRepository;
    }

    @PostMapping("/spareParts/update")
    public String updateSparePartQuantity(@RequestParam("id") Long id,
                                          @RequestParam("newQuantity") int newQuantity,
                                          RedirectAttributes redirectAttributes) {
        Optional<SparePart> optionalSparePart = sparePartRepository.findById(id);

        if (optionalSparePart.isPresent()) {
            SparePart sparePart = optionalSparePart.get();
            sparePart.setQuantityAvailable(newQuantity); // Atualiza a quantidade
            sparePartRepository.save(sparePart); // Salva no banco

            redirectAttributes.addFlashAttribute("msg", "Quantidade atualizada com sucesso!");
            redirectAttributes.addFlashAttribute("msgType", "success");
        } else {
            redirectAttributes.addFlashAttribute("msg", "Peça não encontrada!");
            redirectAttributes.addFlashAttribute("msgType", "danger");
        }

        return "redirect:/spareParts"; // Redireciona para a lista de peças
    }
}
