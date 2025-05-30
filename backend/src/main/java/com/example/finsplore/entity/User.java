package com.example.finsplore.entity;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.example.finsplore.service.CategoryService;
import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * This class represents the `User` entity, designed to map to the `users` table in the database.
 * This entity encapsulates user information including their unique ID, name, email, mobile number, and basiq user id.
 */

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(unique = true, nullable = false)
    private String email;
    @Column(name = "first_name")
    private String firstName;
    @Column(name = "middle_name")
    private String middleName;
    @Column(name = "last_name")
    private String lastName;
    private String mobile;
    @Column(name = "basiq_user_id")
    private String basiqUserId;
    @Column(name = "avatar_url")
    private String avatarUrl;
    @Column(name = "created_at", columnDefinition = "TIMESTAMP WITH TIME ZONE DEFAULT now()")
    private java.time.ZonedDateTime createdAt;
    @Column(name = "updated_at", columnDefinition = "TIMESTAMP WITH TIME ZONE DEFAULT now()")
    private java.time.ZonedDateTime updatedAt;
    @Column(name = "goal")    
    private Double goal;
    @Column(name = "budget")    
    private Double budget;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<UserCredential> credentials;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<Transaction> transactions;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<Category> categories= new HashSet<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<Bill> bills= new HashSet<>();

    

    // Default constructor
    public User() {}
    // // Constructor with required fields
    public User(String email) {
        this.email = email;
        this.createdAt = java.time.ZonedDateTime.now();
        this.updatedAt = this.createdAt;
    }

    // New added: when dealing with more complicated case
    public User(String firstName, String middleName, String lastName, String email, String mobile) {
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.email = email;
        this.mobile = mobile;
        this.createdAt = java.time.ZonedDateTime.now();
        this.updatedAt = this.createdAt;
        initializeDefaultCategories();
    }


    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }



    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getMiddleName() { return middleName; }
    public void setMiddleName(String middleName) { this.middleName = middleName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getBasiqUserId() { return basiqUserId; }
    public void setBasiqUserId(String basiqUserId) { this.basiqUserId = basiqUserId; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public java.time.ZonedDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.time.ZonedDateTime createdAt) { this.createdAt = createdAt; }

    public java.time.ZonedDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.time.ZonedDateTime updatedAt) { this.updatedAt = updatedAt; }

    public List<UserCredential> getCredentials() { return credentials; }
    public void setCredentials(List<UserCredential> credentials) { this.credentials = credentials; }

    public String getPassword() {
        if (credentials != null && !credentials.isEmpty()) {
            return credentials.get(0).getPasswordHash();
        }
        return null;
    }
    public Double getGoal() {
        return goal;
    }
    public void setGoal(Double goal) {
        this.goal = goal;
    }
    public Double getBudget() {
        return budget;
    }
    public void setBudget(Double budget) {
        this.budget = budget;
    }

    public void addCategory(Category category) {
        categories.add(category);
    }

    public void deleteCategory(Category category) {
        categories.remove(category);
        
    }


    private void initializeDefaultCategories() {
        Category food = new Category("Food", this);
        categories.add(new Category("Income", this));
        categories.add(food);
        categories.add(new Category("Bill", this));
        
        System.out.println("12345"+ food.getId());

    }

}