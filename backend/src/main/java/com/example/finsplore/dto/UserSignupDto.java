package com.example.finsplore.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Getter
public class UserSignupDto {
    private Long id;
    private String email;
    private String firstName;
    private String middleName;
    private String lastName;
    private String mobile;
    private String password;
    private String verificationCode;
    
    public String getEmail(){
        return this.email;
    }
    public String getPassword(){
        return this.password;
    }
    public String getFirstName(){
        return this.firstName;
    }
    public String getMiddleName(){
        return this.middleName;
    }
    public String getLastName(){
        return this.lastName;
    }
    public String getMobile(){
        return this.mobile;
    }
    public String getVerificationCode(){
        return this.verificationCode;
    }
}