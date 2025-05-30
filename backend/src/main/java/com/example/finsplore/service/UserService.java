package com.example.finsplore.service;

import com.example.finsplore.entity.User;
import com.example.finsplore.entity.UserCredential;
import com.example.finsplore.repository.UserRepository;

import jakarta.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

/**
 * Service class build for managing user-related operations.
 * Responsibilities:
 * - Handles the logic for registering a new user.
 * - Interacts with external services (e.g., Basiq) and the database to create and persist user data.
 */

@Service
public class UserService {

    // Provide access to user data in the database
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // Interact with the Basiq API for user-related actions
    @Autowired
    private BasiqService basiqService;

    public User saveUser(User user) {
        return userRepository.save(user);
    }

    public Optional<User> getUserByEmail(String email) {
        return Optional.ofNullable(userRepository.findByEmail(email));
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    public Optional<User> updateUser(Long userId, User updatedUser) {
        return userRepository.findById(userId)
                .map(existingUser -> {
                    existingUser.setEmail(updatedUser.getEmail());
                    return userRepository.save(existingUser);
                });
    }
    public Optional<User> updateUserBudget(Long userId, Double budget) {
        return userRepository.findById(userId)
                .map(existingUser -> {
                    existingUser.setBudget(budget);
                    return userRepository.save(existingUser);
                });
    }
    public Optional<Double> getUserBudget(Long userId) {
        return userRepository.findById(userId)
                .map(User::getBudget); 
    }
    public Optional<User> updateUserGoal(Long userId, Double goal) {
        return userRepository.findById(userId)
                .map(existingUser -> {
                    existingUser.setGoal(goal);
                    return userRepository.save(existingUser);
                });
    }
    public Optional<Double> getUserGoal(Long userId) {
        return userRepository.findById(userId)
                .map(User::getGoal); 
    }

    public boolean resetPassword(String email, String newPassword) {

        User user = userRepository.findByEmail(email);
        if (user == null) {
            System.out.println("User Not Found:" + email);
            return false;
        }

        if (user.getCredentials() == null || user.getCredentials().isEmpty()) {
            System.out.println("No credentials exist for the user:" + email);
            return false;
        }

        UserCredential credential = user.getCredentials().stream()
                .filter(c -> "email".equals(c.getProvider()))
                .findFirst()
                .orElse(null);

        if (credential == null) {
            System.out.println("Cannot find credentials of type 'email'：" + email);
            return false;
        }

        credential.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        return true;
    }

    public User registerNewUser(String firstName, String middleName, String lastName, String email, String mobile) {
        // Check for duplicate user
        if (userRepository.findByEmail(email) != null) {
            throw new RuntimeException("User with this email already exists.");
        }

        // Create the user in Basiq: require email and mobile number
        String basiqUserId = basiqService.createUser(email, mobile, firstName, lastName);

        // Create the user entity with the Basiq user ID
        User user = new User(firstName, middleName, lastName, email, mobile);
        user.setBasiqUserId(basiqUserId);

        // Save the user to the database
        return userRepository.save(user);
    }

    public String generateAuthLinkForUser(String basiqUserId) {

        if (basiqUserId == null || basiqUserId.isEmpty()) {
            throw new RuntimeException("Basiq User ID cannot be null or empty");
        }

        return basiqService.generateAuthLink(basiqUserId);
    }

    @Transactional
    public User updateMobileByEmail(String email, String newMobile) {
        Optional<User> optionalUser = Optional.of(userRepository.findByEmail(email));
        if (optionalUser.isEmpty()) {
            throw new RuntimeException("User not found with email: " + email);
        }

        User user = optionalUser.get();
        user.setMobile(newMobile);
        user.setUpdatedAt(java.time.ZonedDateTime.now());

        return userRepository.save(user);
    }

}



