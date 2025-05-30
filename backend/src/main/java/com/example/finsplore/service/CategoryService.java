package com.example.finsplore.service;


import org.springframework.beans.factory.annotation.Autowired;

import com.example.finsplore.entity.Category;
import com.example.finsplore.entity.User;
import com.example.finsplore.repository.CategoryRepository;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CategoryService {
    @Autowired
    private CategoryRepository categoryRepository;

    // 预定义的交易子类别
    private static final List<String> PREDEFINED_SUBCLASSES = Arrays.asList(
        "Groceries", "Dining", "Shopping", "Entertainment", "Transport",
        "Utilities", "Housing", "Healthcare", "Education", "Travel",
        "Subscriptions", "Income", "Transfer", "Investment", "Savings"
    );

    public Category saveCategory(Category category) {
        return categoryRepository.save(category);
    }

    // 获取预定义子类别
    public List<String> getPredefinedSubclasses() {
        return PREDEFINED_SUBCLASSES;
    }

    // 获取特定用户的自定义子类别
    public List<String> getCustomSubclassesByUser(Long userId) {
        List<Category> userCategories = categoryRepository.findByUserId(userId);
        return userCategories.stream()
                .map(Category::getName)
                .collect(Collectors.toList());
    }

    // 添加自定义子类别
    public Category addCustomSubclass(Long userId, String subclassName, User user) {
        Category category = new Category(subclassName, user);
        return categoryRepository.save(category);
    }
}
