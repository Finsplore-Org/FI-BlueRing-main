package com.example.finsplore.service;

import com.example.finsplore.entity.Suggestion;
import com.example.finsplore.repository.SuggestionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SuggestionService {

    @Autowired
    private SuggestionRepository suggestionRepository;

    public Suggestion saveSuggestion(Suggestion suggestion) {
        return suggestionRepository.save(suggestion);
    }

    public List<Suggestion> getSuggestionsByUserId(Long userId) {
        return suggestionRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public void deleteSuggestion(Long id) {
        suggestionRepository.deleteById(id);
    }
}