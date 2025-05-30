package com.example.finsplore.controller;

import com.example.finsplore.entity.Suggestion;
import com.example.finsplore.entity.User;
import com.example.finsplore.service.SuggestionService;
import com.example.finsplore.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/suggestions")
public class SuggestionController {

    @Autowired
    private SuggestionService suggestionService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/create")
    public ResponseEntity<Suggestion> createSuggestion(@RequestBody Map<String, Object> request) {
        Long userId = Long.parseLong(request.get("userId").toString());
        String suggestionText = (String) request.get("suggestionText");
        Double expectedSaveAmount = Double.parseDouble(request.get("expectedSaveAmount").toString());

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        Suggestion suggestion = new Suggestion(user, suggestionText, expectedSaveAmount);
        Suggestion savedSuggestion = suggestionService.saveSuggestion(suggestion);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedSuggestion);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<Suggestion>> getSuggestionsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(suggestionService.getSuggestionsByUserId(userId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSuggestion(@PathVariable Long id) {
        suggestionService.deleteSuggestion(id);
        return ResponseEntity.noContent().build();
    }
}