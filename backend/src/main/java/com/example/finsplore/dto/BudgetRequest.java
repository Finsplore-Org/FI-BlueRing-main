package com.example.finsplore.dto;

public class BudgetRequest {
    private Long userId;
    private Double amount;

    // Default constructor
    public BudgetRequest(Long userId, Double amount) {
        this.userId = userId;
        this.amount = amount;

    }

    // Getters and setters

    public Long getUserId() {
        return userId;
    }
    public Double getAmount() {
        return amount;
    }

}
