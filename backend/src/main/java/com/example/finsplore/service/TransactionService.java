package com.example.finsplore.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.finsplore.entity.Transaction;
import com.example.finsplore.repository.TransactionRepository;

@Service
public class TransactionService {

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private OpenAIService openAIService;

    @Autowired
    private CategoryService categoryService;

    public void saveAllTransactions(List<Transaction> transactions) {
        try {
            // 获取已存在的交易记录
            List<Transaction> existingTransactions = transactionRepository.findByUserId(transactions.get(0).getUser().getId());
            
            for (Transaction transaction : transactions) {
                // 查找是否存在相同ID的交易记录
                Transaction existingTransaction = existingTransactions.stream()
                    .filter(t -> t.getId().equals(transaction.getId()))
                    .findFirst()
                    .orElse(null);
                
                if (existingTransaction != null && existingTransaction.getSubclass() != null && !existingTransaction.getSubclass().isEmpty()) {
                    // 如果已存在的交易有分类信息，保留原有分类
                    transaction.setSubclass(existingTransaction.getSubclass());
                } else if (transaction.getSubclass() == null || transaction.getSubclass().isEmpty()) {
                    // 如果是新交易或原有交易没有分类，进行分类
                    String classifiedSubclass = classifyTransaction(transaction);
                    transaction.setSubclass(classifiedSubclass);
                }
            }
            transactionRepository.saveAll(transactions);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to save transactions", e);
        }
    }

    public List<Transaction> getTransactionsByUserId(Long userId) {
        try {
            return transactionRepository.findByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve transactions for userId: " + userId, e);
        }
    }

    public String classifyTransaction(Transaction transaction) {
        if (transaction.getSubclass() != null && !transaction.getSubclass().isEmpty()) {
            return transaction.getSubclass();
        }
        
        Long userId = transaction.getUser().getId();
        List<String> predefinedSubclasses = categoryService.getPredefinedSubclasses();
        List<String> customSubclasses = categoryService.getCustomSubclassesByUser(userId);
        
        return openAIService.classifyTransaction(
            transaction.getDescription(),
            predefinedSubclasses,
            customSubclasses
        );
    }

    public java.util.Optional<Transaction> findById(String id) {
        return transactionRepository.findById(id);
    }

    public Transaction saveTransaction(Transaction transaction) {
        return transactionRepository.save(transaction);
    }

    public List<Transaction> get500TransactionsByUserId(Long userId) {
        try {
            return transactionRepository.findTop500ByUserIdOrderByTransactionDateDesc(userId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve latest 500 transactions for userId: " + userId, e);
        }
    }

    public List<Transaction> getTransactionsByUserIdAndAccount(Long userId, String account) {
        try {
            return transactionRepository.findByUserIdAndAccount(userId, account);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve transactions for userId: " + userId + " and account: " + account, e);
        }
    }

    public List<Transaction> get500TransactionsByUserIdAndAccount(Long userId, String account) {
        try {
            return transactionRepository.findTop500ByUserIdAndAccountOrderByTransactionDateDesc(userId, account);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve latest 500 transactions for userId: " + userId + " and account: " + account, e);
        }
    }
}