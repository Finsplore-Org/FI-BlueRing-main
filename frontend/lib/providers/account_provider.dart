import 'package:flutter/foundation.dart';
import '../models/account.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  void setAccounts(List<Account> accounts) {
    _accounts = accounts;
    notifyListeners();
  }
  
  List<Account> getSelectedAccount() {
    return _accounts;
  }
}