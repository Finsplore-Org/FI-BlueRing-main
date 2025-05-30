package com.example.finsplore.entity;

import jakarta.persistence.*;
import java.time.ZonedDateTime;

@Entity
@Table(name = "suggestions")
public class Suggestion {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "suggestion_seq")
    @SequenceGenerator(name = "suggestion_seq", sequenceName = "suggestions_id_seq", allocationSize = 1)
    @Column(name = "id", nullable = false)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "suggestion_text", nullable = false)
    private String suggestionText;

    @Column(name = "expected_save_amount")
    private Double expectedSaveAmount;

    @Column(name = "created_at")
    private ZonedDateTime createdAt;

    // Default constructor
    public Suggestion() {}

    // Constructor with required fields
    public Suggestion(User user, String suggestionText, Double expectedSaveAmount) {
        this.user = user;
        this.suggestionText = suggestionText;
        this.expectedSaveAmount = expectedSaveAmount;
        this.createdAt = ZonedDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getSuggestionText() {
        return suggestionText;
    }

    public void setSuggestionText(String suggestionText) {
        this.suggestionText = suggestionText;
    }

    public Double getExpectedSaveAmount() {
        return expectedSaveAmount;
    }

    public void setExpectedSaveAmount(Double expectedSaveAmount) {
        this.expectedSaveAmount = expectedSaveAmount;
    }

    public ZonedDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(ZonedDateTime createdAt) {
        this.createdAt = createdAt;
    }
}