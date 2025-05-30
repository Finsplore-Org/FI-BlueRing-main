package com.example.finsplore.dto;



import java.util.List;

public class TransactionResponse {
    private List<TransactionResponse> data;

    // Getters and setters
    public List<TransactionResponse> getData() {
        return data;
    }

    public void setData(List<TransactionResponse> data) {
        this.data = data;
    }
}