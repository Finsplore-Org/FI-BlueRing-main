package com.example.finsplore.entity;
import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.persistence.*;

@Entity
@Table(name = "transactions") // Specify the table name in the database
@JsonIgnoreProperties(ignoreUnknown = true) // Ignore unknown properties during JSON serialization/deserialization
public class Transaction {

    @Id
    private String id;
    @Column(name = "description")
    private String description;
    @Column(name = "amount")
    private BigDecimal amount;
    @Column(name = "account")
    private String account;

    @Column(name = "subclass")
    private String subclass;

    @JsonProperty("postDate")
    @Column(name = "transactionDate")
    private String transactionDate;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "Id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    

    // Getters and setters

    public String getSubclass() {
        return subclass;
    }
    
    public void setSubclass(String subclass) {
        this.subclass = subclass;
    }
    
    public String getId() {
        return id;
    }


    public void setId(String id) {
        this.id = id;
    }

    public String getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(String transactionDate) {
        this.transactionDate = transactionDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }
    public User getUser() {
        return user;
    }
    public void setUser(User user) {
        this.user = user;
    }
    public Category getCategory() {
        return category;
    }
    public void setCategory(Category category) {
        this.category = category;
    }
}

