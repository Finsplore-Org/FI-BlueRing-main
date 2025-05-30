import 'package:flutter/material.dart';
import '../../models/account.dart';

class TransactionFilterPanel extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedAccount;
  final double? minAmount;
  final double? maxAmount;
  final List<Account> accounts;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(String?) onAccountChanged;
  final Function(double?) onMinAmountChanged;
  final Function(double?) onMaxAmountChanged;
  final VoidCallback onResetFilters;
  final bool showFilterPanel;

  const TransactionFilterPanel({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedAccount,
    required this.minAmount,
    required this.maxAmount,
    required this.accounts,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onAccountChanged,
    required this.onMinAmountChanged,
    required this.onMaxAmountChanged,
    required this.onResetFilters,
    required this.showFilterPanel,
  });

  @override
  Widget build(BuildContext context) {
    if (!showFilterPanel) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter Options', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      onStartDateChanged(date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      startDate != null 
                          ? '${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}' 
                          : 'Start Date',
                      style: TextStyle(
                        color: startDate != null ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('To'),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      onEndDateChanged(date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      endDate != null 
                          ? '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}' 
                          : 'End Date',
                      style: TextStyle(
                        color: endDate != null ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Account',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            value: selectedAccount,
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Accounts'),
              ),
              ...accounts.map((account) => DropdownMenuItem<String>(
                value: account.id,
                child: Text(account.name),
              )).toList(),
            ],
            onChanged: onAccountChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Minimum Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: minAmount?.toString(),
                  onChanged: (value) {
                    final amount = double.tryParse(value);
                    onMinAmountChanged(amount);
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Text('to'),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Maximum Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: maxAmount?.toString(),
                  onChanged: (value) {
                    final amount = double.tryParse(value);
                    onMaxAmountChanged(amount);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Filter'),
              onPressed: onResetFilters,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF004D40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}