package com.example.finsplore.controller;

import com.example.finsplore.entity.Bill;
import com.example.finsplore.service.BillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;
import com.example.finsplore.dto.BillDto;
import com.example.finsplore.entity.User;
import com.example.finsplore.repository.UserRepository;


@RestController
@RequestMapping("/api/bills")
public class BillController {

    @Autowired
    private BillService billService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/set")
    public ResponseEntity<Bill> createBill(@RequestBody BillDto billDto) {
        // Fetch user by ID
        User user = userRepository.findById(billDto.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        // Convert DTO to Entity
        Bill bill = new Bill(
            billDto.getName(),
            user,
            billDto.getAmount(),
            billDto.getDate()
        );
        Bill savedBill = billService.saveBill(bill);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedBill);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<Bill>> getAllBills(@PathVariable Long userId) {
        return ResponseEntity.ok(billService.getBillById(userId));
    }
    @DeleteMapping("/delete/{billId}")
    public ResponseEntity<Void> deleteBill(@PathVariable Long billId) {
        billService.deleteBillById(billId);
        return ResponseEntity.noContent().build(); // HTTP 204
    }

    // @GetMapping("/{id}")
    // public ResponseEntity<Bill> getBillById(@PathVariable Long id) {
    //     return billService.getBillById(id)
    //             .map(ResponseEntity::ok)
    //             .orElse(ResponseEntity.notFound().build());
    // }

    // @GetMapping("/user/{userId}")
    // public ResponseEntity<List<Bill>> getBillsByUserId(@PathVariable Long userId) {
    //     return ResponseEntity.ok(billService.getBillsByUserId(userId));
    // }
}
