package com.example.finsplore.repository;



import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.finsplore.entity.Category;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    
    List<Category> findByUserId(Long userId);
}