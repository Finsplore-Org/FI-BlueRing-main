package com.example.finsplore.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.finsplore.entity.Transaction;

public interface TransactionRepository extends JpaRepository<Transaction, String> {
    List<Transaction> findByUserId(Long userId);
    
    List<Transaction> findTop500ByUserIdOrderByTransactionDateDesc(Long userId);

    List<Transaction> findByUserIdAndAccount(Long userId, String account);
    
    List<Transaction> findTop500ByUserIdAndAccountOrderByTransactionDateDesc(Long userId, String account);
}