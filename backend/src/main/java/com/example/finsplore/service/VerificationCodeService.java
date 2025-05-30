package com.example.finsplore.service;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
public class VerificationCodeService {
    private final StringRedisTemplate redisTemplate;
    private final EmailService emailService;
    private static final long EXPIRE_MINUTES = 5;

    public VerificationCodeService(StringRedisTemplate redisTemplate, EmailService emailService) {
        this.redisTemplate = redisTemplate;
        this.emailService = emailService;
    }

    public boolean sendVerificationCode(String email) {
        try {
            String code = generateVerificationCode();
            // store verify code in Redis，5mins expire
            String key = "verification:" + email;
            redisTemplate.opsForValue().set(key, code, EXPIRE_MINUTES, TimeUnit.MINUTES);
            
            // send email with verification code
            emailService.sendVerificationCode(email, code);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean verifyCode(String email, String code) {
        if (code == null || code.trim().isEmpty()) {
            return false;
        }

        String key = "verification:" + email;
        String storedCode = redisTemplate.opsForValue().get(key);
        
        if (storedCode != null && storedCode.equals(code)) {
            // delete code after verification
            redisTemplate.delete(key);
            return true;
        }
        return false;
    }

    private String generateVerificationCode() {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }
}
