package com.example.finsplore.controller;

import com.example.finsplore.entity.User;
import com.example.finsplore.entity.UserCredential;
import com.example.finsplore.dto.ResetPasswordDto;
import com.example.finsplore.dto.UserInfoDto;
import com.example.finsplore.dto.UserSignupDto;
import com.example.finsplore.service.UserCredentialService;
import com.example.finsplore.service.UserService;
import com.example.finsplore.service.VerificationCodeService;
import com.example.finsplore.util.JwtUtil;

import org.apache.el.stream.Optional;
import com.example.finsplore.service.BasiqService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import java.util.HashMap;


@RestController
public class UserController {

    @Autowired
    private UserCredentialService userCredentialService; 

    @Autowired
    private UserService userService; 

    @Autowired
    private PasswordEncoder passwordEncoder; 

    @Autowired
    private VerificationCodeService verificationCodeService;

    @GetMapping("/users/email/{email}")
    public ResponseEntity<?> getUserInfoByEmail(@PathVariable String email) {
        java.util.Optional<User> userOptional = userService.getUserByEmail(email);
        if (!userOptional.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        User user = userOptional.get();
        UserInfoDto userInfoDto = new UserInfoDto();
        userInfoDto.setId(user.getId());
        userInfoDto.setEmail(user.getEmail());
        userInfoDto.setFirstName(user.getFirstName());
        userInfoDto.setMiddleName(user.getMiddleName());
        userInfoDto.setLastName(user.getLastName());
        userInfoDto.setMobile(user.getMobile());
        userInfoDto.setAvatarUrl(user.getAvatarUrl());
        userInfoDto.setBasiqUserId(user.getBasiqUserId());
        userInfoDto.setCreatedAt(user.getCreatedAt());
        userInfoDto.setUpdatedAt(user.getUpdatedAt());

        return ResponseEntity.ok(userInfoDto);
    }
    @Autowired
    private BasiqService basiqService;

    // send verification code
    @PostMapping("/send-verification-code")
    public ResponseEntity<String> sendVerificationCode(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        if (email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().body("Email is required");
        }

        boolean sent = verificationCodeService.sendVerificationCode(email);
        if (sent) {
            return ResponseEntity.ok("Verification code sent successfully");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to send verification code");
        }
    }

    // verify code
    @PostMapping("/verify-code")
    public ResponseEntity<String> verifyCode(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String code = request.get("code");

        if (email == null || email.isEmpty() || code == null || code.isEmpty()) {
            return ResponseEntity.badRequest().body("Email and verification code are required");
        }

        boolean verified = verificationCodeService.verifyCode(email, code);
        if (verified) {
            return ResponseEntity.ok("Verification successful");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid verification code");
        }
    }

    // register
    @PostMapping("/signup")
    public ResponseEntity<String> createUser(@RequestBody UserSignupDto userSignupDto) {
        String email = userSignupDto.getEmail();
        String firstName = userSignupDto.getFirstName();
        String middleName = userSignupDto.getMiddleName();
        String lastName = userSignupDto.getLastName();
        String mobile = userSignupDto.getMobile();
        String password = userSignupDto.getPassword();
        
        // check if required fields are empty
        if (email.isEmpty() || password.isEmpty() || firstName.isEmpty() || lastName.isEmpty() || mobile.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Required fields must not be empty.");
        }

        try {
            userCredentialService.registerUser(firstName, middleName, lastName, email, mobile, password);
            return ResponseEntity.ok("Signup successful");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    // sign in
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<?> validateCredentials(@RequestBody UserSignupDto userSignupDto) {
        String email = userSignupDto.getEmail();
        String password = userSignupDto.getPassword();

        if (email.isEmpty() || password.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Email and password must not be empty.");
        }

        boolean isValid = userCredentialService.validateCredentials(email, password);

        if (isValid) {
            User user = userService.getUserByEmail(email).orElseThrow(() -> 
                new RuntimeException("User not found"));
            String token = jwtUtil.generateToken(user.getId().toString(), user.getEmail());
            
            Map<String, Object> response = new HashMap<>();
            response.put("userId", user.getId());
            response.put("email", user.getEmail());
            response.put("token", token);
            response.put("basiqUserId", user.getBasiqUserId());
            response.put("message", "Login successful");
            
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid email or password.");
        }
    }

    // reset password
    @PostMapping("/reset-password")
    public ResponseEntity<String> resetPassword(@RequestBody ResetPasswordDto resetPasswordDto) {
        String email = resetPasswordDto.getEmail();
        String newPassword = resetPasswordDto.getNewPassword();
        
        boolean success = userService.resetPassword(email, newPassword);
        
        if (success) {
            return ResponseEntity.ok("Password reset successful");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to reset password");
        }
    }


    // New added: generate an authentication link for the user
    @PostMapping("/{userId}/auth-link")
    public Map<String, String> generateAuthLink(@PathVariable String userId) {
        String authLink = userService.generateAuthLinkForUser(userId);

        Map<String, String> response = new HashMap<>();
        response.put("authLink", authLink);

        return response;
    }
    
    @PatchMapping("/users/phone")
    public ResponseEntity<?> updateUserPhone(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String newPhone = request.get("mobile");
    
        if (email == null || email.isEmpty() || newPhone == null || newPhone.isEmpty()) {
            return ResponseEntity.badRequest().body("Email and new phone number are required.");
        }
    
        try {
            User updatedUser = userService.updateMobileByEmail(email, newPhone);
    
            Map<String, Object> response = new HashMap<>();
            response.put("email", updatedUser.getEmail());
            response.put("mobile", updatedUser.getMobile());
            response.put("message", "Phone number updated successfully.");
    
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

}