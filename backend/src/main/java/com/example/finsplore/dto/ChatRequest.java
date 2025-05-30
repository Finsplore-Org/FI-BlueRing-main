package com.example.finsplore.dto;

public class ChatRequest {
    private Long userId;
    private String message;

    // 默认构造函数
    public ChatRequest() {}

    // 带参数的构造函数
    public ChatRequest(Long userId, String message) {
        this.userId = userId;
        this.message = message;
    }

    // Getter和Setter方法
    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}