class Transaction {
  final String id;
  final String status;
  final String description;
  final String amount;
  final String account;
  final String balance;
  final String direction;
  final String transactionClass;
  final String currency;
  final String postDate;

  Transaction({
    required this.id,
    required this.status,
    required this.description,
    required this.amount,
    required this.account,
    required this.balance,
    required this.direction,
    required this.transactionClass,
    required this.currency,
    required this.postDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      amount: json['amount'] as String,
      account: json['account'] as String,
      balance: json['balance'] as String,
      direction: json['direction'] as String,
      transactionClass: json['subclass'] as String,
      currency: json['currency'] as String,
      postDate: json['postDate'] as String,
    );
  }

  double get amountValue => double.parse(amount);
  double get balanceValue => double.parse(balance);
  bool get isCredit => direction == 'credit';
}