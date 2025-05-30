package com.example.finsplore;

import com.example.finsplore.entity.Transaction;
import com.example.finsplore.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.example.finsplore.service.BasiqService;
import com.example.finsplore.controller.TransactionController;
import java.util.List;
import com.example.finsplore.entity.User;

/**
 * The main entry point for the Finsplore application.
 * This class is responsible for bootstrapping the Spring Boot application and executing application-specific logic.
 */


@SpringBootApplication
public class FinsploreApplication implements CommandLineRunner {

	// Injecting the UserService instance to handle registration logic
	@Autowired
	private UserService userService;
	@Autowired
	private BasiqService basiqService;
	@Autowired
	private TransactionController transactionController;

	public static void main(String[] args) {
		SpringApplication.run(FinsploreApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		// String json = basiqService.fetchAllTransactions("db7e553b-6ed9-4e8f-b66a-243b8200934f");
		// // System.out.println("Transaction JSON: " + json);
		// List<Transaction> transactions = transactionController.convertTotransactions(json, "db7e553b-6ed9-4e8f-b66a-243b8200934f");
		// for (Transaction t : transactions) {
		// 	System.out.println("Id: " + t.getId());
		// 	System.out.println("Amount: " + t.getAmount());
		// 	System.out.println("Des: " + t.getUser().getFirstName());
		// }
	}
}
