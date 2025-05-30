package com.example.finsplore.service;

import com.example.finsplore.entity.Bill;
import com.example.finsplore.repository.BillRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class BillService {

    @Autowired
    private BillRepository billRepository;

    public Bill saveBill(Bill bill) {
        return billRepository.save(bill);
    }

    // public List<Bill> getAllBills() {
    //     return billRepository.findAll();
    // }

    // public List<Bill> getBillsByUserId(Long userId) {
    //     return billRepository.findByUserId(userId);
    // }

    public List<Bill> getBillById(Long id) {
        return billRepository.findByUserIdOrderByDueDateAsc(id);
    }
    public void deleteBillById(Long billId) {
        billRepository.deleteById(billId);
    }
}
