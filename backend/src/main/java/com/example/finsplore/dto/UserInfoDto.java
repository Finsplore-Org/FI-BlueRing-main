package com.example.finsplore.dto;

import java.time.ZonedDateTime;

public class UserInfoDto {
    private Long id;
    private String email;
    private String firstName;
    private String middleName;
    private String lastName;
    private String mobile;
    private String avatarUrl;
    private String basiqUserId;
    private ZonedDateTime createdAt;
    private ZonedDateTime updatedAt;

    // Default constructor
    public UserInfoDto() {}

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

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getBasiqUserId() { return basiqUserId; }
    public void setBasiqUserId(String basiqUserId) { this.basiqUserId = basiqUserId; }

    public ZonedDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(ZonedDateTime createdAt) { this.createdAt = createdAt; }

    public ZonedDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(ZonedDateTime updatedAt) { this.updatedAt = updatedAt; }
}