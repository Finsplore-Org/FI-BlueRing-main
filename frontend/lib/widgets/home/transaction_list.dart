import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import 'transaction_shimmer.dart';

class TransactionList extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<Transaction> transactions;
  final IconData Function(Transaction) getTransactionIcon;
  final Function(Transaction) onTransactionTap;

  const TransactionList({
    super.key,
    required this.isLoading,
    required this.error,
    required this.transactions,
    required this.getTransactionIcon,
    required this.onTransactionTap,
  });

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            error ?? 'An error occurred',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const TransactionShimmer();
    }

    if (error != null) {
      return _buildErrorWidget();
    }

    if (transactions.isEmpty) {
      return const Center(
        child: Text('No transaction records meet the criteria'),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return InkWell(
          onTap: () => onTransactionTap(transaction),
          child: ListTile(
            leading: Icon(
              getTransactionIcon(transaction),
              color: transaction.isCredit ? Colors.green : Colors.red,
            ),
            title: Text(transaction.description),
            subtitle: Text(transaction.postDate),
            trailing: Text(
              '${transaction.isCredit ? '+' : '-'}\$${transaction.amountValue.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.isCredit ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}