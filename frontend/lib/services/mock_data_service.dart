import '../models/account.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';

class MockDataService {
  static List<Account> getAccounts() {
    return [
      Account(
        id: '1',
        name: 'Bank Account 1',
        balance: 5404,
        monthOverMonthChange: 20.0,
      ),
      Account(
        id: '2',
        name: 'Bank account 2',
        balance: 0.00,
        monthOverMonthChange: 33.0,
      ),
    ];
  }

  static List<AccountType> getAccountTypes() {
    return [
      // AccountType(name: 'Bank Accounts', totalAmount: 51007.90),
      // AccountType(name: 'Loans', totalAmount: 0, canConnect: true),
      AccountType(name: 'Micro Investing', totalAmount: 0, canConnect: true),
      AccountType(name: 'Credit Cards', totalAmount: 0, canConnect: true),
      AccountType(name: 'Net Worth', totalAmount: 51007.90),
    ];
  }



  static List<Map<String, dynamic>> getWeekData() {
    return [
      {'day': 'Mon', 'income': 500.0, 'spending': 100.0},
      {'day': 'Tue', 'income': 500.0, 'spending': 100.0},
      {'day': 'Wed', 'income': 600.0, 'spending': 150.0},
      {'day': 'Thu', 'income': 500.0, 'spending': 100.0},
      {'day': 'Fri', 'income': 450.0, 'spending': 700.0},
      {'day': 'Sat', 'income': 500.0, 'spending': 450.0},
      {'day': 'Sun', 'income': 700.0, 'spending': 900.0},
    ];
  }

  static List<Map<String, dynamic>> getCategories() {
    return [
      {'type': 'Income', 'name': 'Salary', 'amount': 4100.00, 'icon': Icons.attach_money},
      {'type': 'Spending', 'name': 'Food', 'amount': 600.00, 'icon': Icons.restaurant},
      {'type': 'Spending', 'name': 'Clothes', 'amount': 1000.00, 'icon': Icons.shopping_bag},
      {'type': 'Spending', 'name': 'Rent', 'amount': 700.00, 'icon': Icons.home},
    ];
  }
}