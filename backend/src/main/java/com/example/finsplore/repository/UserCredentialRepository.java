package com.example.finsplore.repository;

import com.example.finsplore.entity.UserCredential;
import com.example.finsplore.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserCredentialRepository extends JpaRepository<UserCredential, Long> {

}
