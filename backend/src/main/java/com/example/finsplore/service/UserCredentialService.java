package com.example.finsplore.service;

import com.example.finsplore.entity.User;
import com.example.finsplore.entity.UserCredential;
import com.example.finsplore.repository.UserCredentialRepository;
import com.example.finsplore.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


@Service
public class UserCredentialService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserCredentialRepository userCredentialRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private BasiqService basiqService;

    // Registers a new user with the given name details, email, mobile and password.
    public User registerUser(String firstName, String middleName, String lastName, String email, String mobile, String password) {
        // check if email already exists in the database
        if (userRepository.findByEmail(email) != null) {
            throw new RuntimeException("Email already exists");
        }
        String basiqUserId = basiqService.createUser(email, mobile, firstName, lastName);
        // create new user
        User user = new User(firstName, middleName, lastName, email, mobile);
        user.setBasiqUserId(basiqUserId);
        userRepository.save(user);
    
        // hash password and save to database
        String encodedPassword = passwordEncoder.encode(password);
        UserCredential credential = new UserCredential(user, "email");
        credential.setPasswordHash(encodedPassword);
        userCredentialRepository.save(credential);
        return user;
    }

    public boolean validateCredentials(String email, String password) {
        User user = userRepository.findByEmail(email);
        if (user == null) {
            return false;
        }
        // get User hashed password in database
        String passwordHash = user.getPassword();
        return passwordEncoder.matches(password, passwordHash);
    }
}