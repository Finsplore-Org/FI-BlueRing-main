class Account {
  final String id;
  final String name;
  final double balance;
  final double monthOverMonthChange;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.monthOverMonthChange,
  });
}

class AccountType {
  final String name;
  final double totalAmount;
  final bool canConnect;

  AccountType({
    required this.name,
    required this.totalAmount,
    this.canConnect = false,
  });
}