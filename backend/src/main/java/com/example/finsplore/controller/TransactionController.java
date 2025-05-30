package com.example.finsplore.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;
import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.finsplore.entity.Transaction;
import com.example.finsplore.service.TransactionService;
import com.example.finsplore.util.TransactionAnalyzer;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.finsplore.service.BasiqService;
import com.example.finsplore.entity.User;
import com.example.finsplore.repository.UserRepository;

@RestController
@RequestMapping("/transactions")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;
    @Autowired
    private BasiqService basiqService;
    @Autowired
    private UserRepository userRepository;

    // Get all transactions and save them to the database
    @PostMapping
    public ResponseEntity<String> fetchTransactions(@RequestBody Map<String, String> request)
            throws JsonProcessingException {
        String userId = request.get("userId");
        if (userId.isEmpty()) {
            return ResponseEntity.badRequest().body("User ID is required");
        }

        try {
            String transactionJson = basiqService.fetchAllTransactions(userId);
            List<Transaction> transactions = convertTotransactions(transactionJson, userId);
            transactionService.saveAllTransactions(transactions);
            
            // 将分类信息添加到原始的JSON响应中
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(transactionJson);
            JsonNode data = root.get("data");
            
            for (int i = 0; i < data.size(); i++) {
                ((com.fasterxml.jackson.databind.node.ObjectNode) data.get(i)).put("subclass", transactions.get(i).getSubclass());
            }
            
            return ResponseEntity.ok(mapper.writeValueAsString(root));
            // return ResponseEntity.ok("Transactions fetched and saved successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.status(500).body("Failed to fetch transactions: " + e.getMessage());
        }
    }

    // convert JSON to transaction object
    public List<Transaction> convertTotransactions(String json, String userId) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        mapper.findAndRegisterModules(); // enables JavaTimeModule for LocalDate

        JsonNode root = mapper.readTree(json);
        JsonNode data = root.get("data");

        List<Transaction> transactions = mapper.readerForListOf(Transaction.class).readValue(data.toString());
        User user = userRepository.findByBasiqUserId(userId);
        if (user == null) {
            throw new IllegalStateException("User not found for Basiq User ID: " + userId);
        }

        for (Transaction t : transactions) {
            t.setUser(user);
        }
        return transactions;
    }


    
    // Get account balance (return all account balances under that user basiq id)
    @PostMapping("/balance")
    public ResponseEntity<String> getAccountBalance(@RequestBody Map<String, String> request) throws Exception {
        String userId = request.get("userId");

        if (userId.isEmpty()) {
            return ResponseEntity.badRequest().body("User ID is required");
        }
        
        try {
            String accountJson = basiqService.fetchAccountBalance(userId);
            String accountSummary = convertToAccountSummary(accountJson);
            
            return ResponseEntity.ok(accountSummary);
        } catch (RuntimeException e) {
            return ResponseEntity.status(500).body("Failed to fetch transactions: " + e.getMessage());
        }
    }
    public String convertToAccountSummary(String json) throws Exception{
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(json);
        JsonNode accounts = root.path("data");

        List<Map<String, String>> result = new ArrayList<>();

        for (JsonNode account : accounts) {
            String name = account.path("name").asText();
            String balance = account.path("balance").asText();
            String accountId = account.path("id").asText();

            result.add(Map.of(
                "name", name,
                "balance", balance,
                "id", accountId
            ));
        }
        String response = mapper.writeValueAsString(result);
        return response;
    }

    @PostMapping("/classify")
    public ResponseEntity<?> classifyTransaction(@RequestBody Map<String, String> request) {
        String userIdStr = request.get("userId");
        
        if (userIdStr == null || userIdStr.isEmpty()) {
            return ResponseEntity.badRequest().body("User ID is required");
        }
        
        Long userId;
        try {
            userId = Long.parseLong(userIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        }
        
        try {
            List<Transaction> transactions = transactionService.get500TransactionsByUserId(userId);
            List<Map<String, Object>> classificationResults = new ArrayList<>();
            
            for (Transaction transaction : transactions) {
                String subclass = transactionService.classifyTransaction(transaction);
                transaction.setSubclass(subclass);
                transactionService.saveTransaction(transaction);
                
                BigDecimal amount = transaction.getAmount().abs();
                
                classificationResults.add(Map.of(
                    "transactionId", transaction.getId(),
                    "description", transaction.getDescription(),
                    "classification", subclass,
                    "amount", amount
                ));
            }
            
            return ResponseEntity.ok(Map.of(
                "userId", userId,
                "classifications", classificationResults
            ));
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Failed to classify transactions: " + e.getMessage());
        }
    }

    @PostMapping("/user")
    public ResponseEntity<?> getTransactionSummary(@RequestBody Map<String, String> request) {
        String userIdStr = request.get("userId");
        if (userIdStr == null || userIdStr.isEmpty()) {
            return ResponseEntity.badRequest().body("User ID is required");
        }
    
        Long userId;
        try {
            userId = Long.parseLong(userIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        }
    
        try {
            List<Transaction> transactions = transactionService.get500TransactionsByUserId(userId);
    
            List<Map<String, Object>> summary = TransactionAnalyzer.summarizeTransactions(transactions);
            System.out.println("Summary result: " + summary);
    
            return ResponseEntity.ok(summary);
        } catch (RuntimeException e) {
            return ResponseEntity.status(500).body("Failed to retrieve transactions: " + e.getMessage());
        }
    }
    
    @PostMapping("/account")
    public ResponseEntity<?> getAccountTransactions(@RequestBody Map<String, String> request) {
        String userIdStr = request.get("userId");
        String account = request.get("account");
        
        if (userIdStr == null || userIdStr.isEmpty()) {
            return ResponseEntity.badRequest().body("User ID is required");
        }
        if (account == null || account.isEmpty()) {
            return ResponseEntity.badRequest().body("Account ID is required");
        }
        
        Long userId;
        try {
            userId = Long.parseLong(userIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        }
        
        try {
            List<Transaction> transactions = transactionService.get500TransactionsByUserIdAndAccount(userId, account);
            List<Map<String, Object>> summary = TransactionAnalyzer.summarizeTransactions(transactions);
            
            return ResponseEntity.ok(summary);
        } catch (RuntimeException e) {
            return ResponseEntity.status(500).body("Failed to retrieve transactions: " + e.getMessage());
        }
    }

    @PostMapping("/top-categories")
    public ResponseEntity<?> getTopCategories(@RequestBody Map<String, String> request) {
        String userIdStr = request.get("userId");
        
        if (userIdStr == null || userIdStr.isEmpty()) {
            return ResponseEntity.badRequest().body("User ID is required");
        }
        
        Long userId;
        try {
            userId = Long.parseLong(userIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        }
        
        try {
            List<Transaction> transactions = transactionService.get500TransactionsByUserId(userId);
            Map<String, BigDecimal> categoryAmounts = new HashMap<>();
            
            for (Transaction transaction : transactions) {
                String subclass = transaction.getSubclass();
                if (subclass != null && !subclass.isEmpty()) {
                    BigDecimal amount = transaction.getAmount().abs();
                    categoryAmounts.merge(subclass, amount, BigDecimal::add);
                }
            }
            
            List<Map.Entry<String, BigDecimal>> sortedCategories = categoryAmounts.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .collect(Collectors.toList());
            
            List<Map<String, Object>> allCategories = sortedCategories.stream()
                .<Map<String, Object>>map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("category", entry.getKey());
                    map.put("totalAmount", entry.getValue());
                    return map;
                })
                .collect(Collectors.toList());
            
            return ResponseEntity.ok(Map.of(
                "userId", userId,
                "categories", allCategories
            ));
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Failed to get top categories: " + e.getMessage());
        }
    }

    @PostMapping("/top-categories/account")
    public ResponseEntity<?> getTopCategoriesByAccount(@RequestBody Map<String, String> request) {
        String userIdStr = request.get("userId");
        String account = request.get("account");
        
        if (userIdStr == null || userIdStr.isEmpty()) {
            return ResponseEntity.badRequest().body("User ID is required");
        }
        if (account == null || account.isEmpty()) {
            return ResponseEntity.badRequest().body("Account ID is required");
        }
        
        Long userId;
        try {
            userId = Long.parseLong(userIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        }
        
        try {
            List<Transaction> transactions = transactionService.get500TransactionsByUserIdAndAccount(userId, account);
            Map<String, BigDecimal> categoryAmounts = new HashMap<>();
            
            for (Transaction transaction : transactions) {
                String subclass = transaction.getSubclass();
                if (subclass != null && !subclass.isEmpty()) {
                    BigDecimal amount = transaction.getAmount().abs();
                    categoryAmounts.merge(subclass, amount, BigDecimal::add);
                }
            }
            
            List<Map.Entry<String, BigDecimal>> sortedCategories = categoryAmounts.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .collect(Collectors.toList());
            
            List<Map<String, Object>> allCategories = sortedCategories.stream()
                .<Map<String, Object>>map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("category", entry.getKey());
                    map.put("totalAmount", entry.getValue());
                    return map;
                })
                .collect(Collectors.toList());
            
            return ResponseEntity.ok(Map.of(
                "userId", userId,
                "account", account,
                "categories", allCategories
            ));
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Failed to get top categories: " + e.getMessage());
        }
    }

    @PostMapping("/updateCategory")
    public ResponseEntity<?> updateTransactionCategory(@RequestBody Map<String, String> request) {
        String userIdStr = request.get("userId");
        String transactionId = request.get("id");
        String category = request.get("category");
        System.out.println("userId: " + userIdStr);
        System.out.println("transactionId: " + transactionId);
        System.out.println("category: " + category);
        // 验证必要参数
        if (userIdStr == null || userIdStr.isEmpty()) {
            return ResponseEntity.badRequest().body("User ID is required");
        }
        if (transactionId == null || transactionId.isEmpty()) {
            return ResponseEntity.badRequest().body("Transaction ID is required");
        }
        if (category == null || category.isEmpty()) {
            return ResponseEntity.badRequest().body("Category is required");
        }

        Long userId;
        try {
            userId = Long.parseLong(userIdStr);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        }

        try {
            // 查找交易记录
            java.util.Optional<Transaction> transactionOpt = transactionService.findById(transactionId);
            if (!transactionOpt.isPresent()) {
                return ResponseEntity.status(404).body("Transaction not found");
            }

            Transaction transaction = transactionOpt.get();
            
            // 验证用户权限
            if (!transaction.getUser().getId().equals(userId)) {
                return ResponseEntity.status(403).body("Not authorized to update this transaction");
            }

            // 更新分类
            transaction.setSubclass(category);
            Transaction updatedTransaction = transactionService.saveTransaction(transaction);

            // 返回更新后的交易信息
            return ResponseEntity.ok(Map.of(
                "transactionId", updatedTransaction.getId(),
                "category", updatedTransaction.getSubclass(),
                "message", "Category updated successfully"
            ));

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Failed to update transaction category: " + e.getMessage());
        }
    }

}