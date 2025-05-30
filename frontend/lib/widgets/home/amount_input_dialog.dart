import 'package:flutter/material.dart';

class AmountInputDialog extends StatelessWidget {
  final String title;
  final String labelText;
  final double? initialAmount;
  final Future<void> Function(double) onSetAmount;
  final String errorMessage;

  const AmountInputDialog({
    super.key,
    required this.title,
    required this.labelText,
    required this.initialAmount,
    required this.onSetAmount,
    this.errorMessage = 'Failed to set amount',
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: initialAmount?.toString() ?? '');
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFF004D40).withOpacity(0.88),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: labelText,
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixText: '\$',
                        prefixStyle: const TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up, color: Colors.white70),
                        onPressed: () {
                          final currentValue = double.tryParse(controller.text) ?? 0;
                          controller.text = (currentValue + 1).toStringAsFixed(2);
                        },
                        padding: const EdgeInsets.all(2),
                        constraints: const BoxConstraints(minHeight: 20, minWidth: 20),
                        iconSize: 16,
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                        onPressed: () {
                          final currentValue = double.tryParse(controller.text) ?? 0;
                          if (currentValue > 0) {
                            controller.text = (currentValue - 1).toStringAsFixed(2);
                          }
                        },
                        padding: const EdgeInsets.all(2),
                        constraints: const BoxConstraints(minHeight: 20, minWidth: 20),
                        iconSize: 16,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () async {
                    final amount = double.tryParse(controller.text);
                    if (amount != null && amount > 0) {
                      try {
                        await onSetAmount(amount);
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$errorMessage: ${e.toString()}')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid amount')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}