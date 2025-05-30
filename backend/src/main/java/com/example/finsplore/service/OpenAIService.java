package com.example.finsplore.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
public class OpenAIService {
    
    @Value("${openai.api.key}")
    private String apiKey;
    
    private final RestTemplate restTemplate = new RestTemplate();
    
    public String classifyTransaction(String description, List<String> predefinedSubclasses, List<String> customSubclasses) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);
        
        // 合并两个类别列表到一个新列表
        List<String> allSubclasses = new ArrayList<>(predefinedSubclasses);
        if (customSubclasses != null && !customSubclasses.isEmpty()) {
            allSubclasses.addAll(customSubclasses);
        }
        
        // 构建提示信息
        String prompt = "As an AI assistant, classify the following transaction into one of these categories. " +
                "Return ONLY the category name without any additional text or explanation.\n\n" +
                "Transaction description: \"" + description + "\"\n\n" +
                "Available categories: " + String.join(", ", allSubclasses);
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", "gpt-4.1-nano");
        
        Map<String, String> systemMessage = new HashMap<>();
        systemMessage.put("role", "system");
        systemMessage.put("content", "You are a financial transaction classifier. You must classify transactions into the provided categories. Only respond with the exact category name.");
        
        Map<String, String> userMessage = new HashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", prompt);
        
        requestBody.put("messages", List.of(systemMessage, userMessage));
        requestBody.put("temperature", 0.3);
        requestBody.put("max_tokens", 20);
        
        // 发送请求
        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
        ResponseEntity<Map> response = restTemplate.postForEntity(
                "https://api.openai.com/v1/chat/completions", 
                request, 
                Map.class
        );
        
        // 解析响应
        Map<String, Object> responseBody = response.getBody();
        if (responseBody != null && responseBody.containsKey("choices")) {
            List<Map<String, Object>> choices = (List<Map<String, Object>>) responseBody.get("choices");
            if (!choices.isEmpty()) {
                Map<String, Object> firstChoice = choices.get(0);
                Map<String, String> message = (Map<String, String>) firstChoice.get("message");
                String content = message.get("content").trim();
                
                // 验证返回的类别是否在列表中
                if (allSubclasses.contains(content)) {
                    return content;
                } else {
                    // 如果返回的类别不在列表中，则默认返回一个通用类别
                    return "Other";
                }
            }
        }
        
        // 如果API调用失败或无法解析响应，返回默认类别
        return "Uncategorized";
    }

    public String chat(Long userId, String userMessage) {
        // 准备请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);
        
        // 构建消息列表
        List<Map<String, String>> messages = new ArrayList<>();
        
        // 添加系统消息
        Map<String, String> systemMessage = new HashMap<>();
        systemMessage.put("role", "system");
        systemMessage.put("content",
            "You are a distinguished financial strategist with deep expertise across global markets, portfolio management, risk assessment, and wealth preservation. Offer authoritative, data‑driven recommendations tailored to each client's goals, supported by clear rationale and actionable steps. Communicate in precise, professional English without unnecessary elaboration. Less than 100 words is the maximum length of your response. make sure each response must be unique and significantly diff from your last response, for better understanding you can add some emoji if needed. "
        );
        messages.add(systemMessage);
        
        // 添加用户消息
        Map<String, String> userMessageMap = new HashMap<>();
        userMessageMap.put("role", "user");
        userMessageMap.put("content", userMessage);
        messages.add(userMessageMap);
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", "gpt-4.1-nano");
        requestBody.put("messages", messages);
        requestBody.put("temperature", 0.7);
        requestBody.put("max_tokens", 100);
        
        return sendChatRequest(requestBody, headers);
    }

    public String generateBillReminder(Long userId, String message) {
        // 准备请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);
        
        // 构建消息列表
        List<Map<String, String>> messages = new ArrayList<>();
        
        // 添加系统消息
        Map<String, String> systemMessage = new HashMap<>();
        systemMessage.put("role", "system");
        systemMessage.put("content",
            "You are a smart, reliable, and proactive Bills Reminder Assistant. Your job is to help me track, manage, and stay ahead of all my upcoming bills. Most importantly, always provide one or two quick, actionable saving tips for each bill when I add it. If I add an internet bill of $80/month, you might say: \"Consider switching to a provider with a similar plan for $60/month, or check if your current provider has unlisted loyalty discounts. Also, do you need that high of a speed tier?\" This is a straightforward tip. Do not include any rhetorical or follow-up questions. And don't response about you know what I mean, just give me tips, pure tips. Also add some emoji, do not tell me you got it, based on current time you can also give a little tip"
        );
        messages.add(systemMessage);
        
        // 添加用户消息
        Map<String, String> userMessageMap = new HashMap<>();
        userMessageMap.put("role", "user");
        userMessageMap.put("content", message);
        messages.add(userMessageMap);
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", "gpt-4.1-nano");
        requestBody.put("messages", messages);
        requestBody.put("temperature", 0.7);
        requestBody.put("max_tokens", 150);
        
        return sendChatRequest(requestBody, headers);
    }

    private String sendChatRequest(Map<String, Object> requestBody, HttpHeaders headers) {
        // 发送请求
        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
        ResponseEntity<Map> response = restTemplate.postForEntity(
                "https://api.openai.com/v1/chat/completions",
                request,
                Map.class
        );
        
        // 解析响应
        Map<String, Object> responseBody = response.getBody();
        if (responseBody != null && responseBody.containsKey("choices")) {
            List<Map<String, Object>> choices = (List<Map<String, Object>>) responseBody.get("choices");
            if (!choices.isEmpty()) {
                Map<String, Object> firstChoice = choices.get(0);
                Map<String, String> message = (Map<String, String>) firstChoice.get("message");
                return message.get("content").trim();
            }
        }
        
        return "Sorry, Cannot handle your message right now.";
    }

    public String generateSuggestion(Long userId, String message) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);
        
        List<Map<String, String>> messages = new ArrayList<>();
        
        Map<String, String> systemMessage = new HashMap<>();
        systemMessage.put("role", "system");
        systemMessage.put("content",
            "You are a financial advisor assistant. Generate a concise financial suggestion category based on the user's message. " +
            "Your response must be in the following JSON format ONLY:\n" +
            "{\"suggestion_text\": \"category name\", \"saving_amount\": \"amount\"}\n" +
            "Rules for suggestion_text:\n" +
            "1. Must be 1-5 words only\n" +
            "2. Use categories like 'Less Shopping', 'Cook at Home', 'Cancel Subscriptions', etc.\n" +
            "3. Be clear and actionable\n" +
            "The saving_amount should be a reasonable monthly saving estimate in numbers only. And range between 50-1000\n"
        );
        messages.add(systemMessage);
        
        // 添加用户消息
        Map<String, String> userMessageMap = new HashMap<>();
        userMessageMap.put("role", "user");
        userMessageMap.put("content", message);
        messages.add(userMessageMap);
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", "gpt-4.1-nano");
        requestBody.put("messages", messages);
        requestBody.put("temperature", 0.3);
        requestBody.put("max_tokens", 30);
        
        return sendChatRequest(requestBody, headers);
    }
}
