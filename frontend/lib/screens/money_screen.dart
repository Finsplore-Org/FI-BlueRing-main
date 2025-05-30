import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/weekly_transaction_service.dart';
import '../services/category_service.dart';
import '../services/transaction_service.dart';
import '../providers/account_provider.dart';
import '../providers/chart_data_provider.dart';
import '../models/account.dart';
import '../models/transaction.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  final WeeklyTransactionService _weeklyTransactionService = WeeklyTransactionService();
  final CategoryService _categoryService = CategoryService();
  final TransactionService _transactionService = TransactionService();
  List<Transaction> _transactions = [];
  List<Map<String, dynamic>> _weekData = [];
  List<Map<String, dynamic>> _categoryData = [];
  bool _isLoading = false;
  String? _error;
  bool _isFirstLoad = true;
  List<String> _selectedCategories = [];
  List<String> _predefinedCategories = [
    "Groceries", "Dining", "Shopping", "Entertainment", "Transport",
    "Utilities", "Housing", "Healthcare", "Education", "Travel",
    "Subscriptions", "Income", "Transfer", "Investment", "Savings"
  ];



Future<void> _fetchTopCategories({String? accountId}) async {
  try {
    // 根据是否提供账户ID来获取不同的类别数据
    final categories = accountId == null || accountId.isEmpty
        ? await _categoryService.getTopCategories()
        : await _categoryService.getTopCategoriesByAccount(accountId);
    final top5Categories = categories.take(5).toList();

    // 创建一个包含所有选中类别的列表
    final List<Map<String, dynamic>> combinedCategories = [];
    
    // 只在首次加载时自动选择前五个类别
    if (_isFirstLoad) {
      setState(() {
        _selectedCategories = top5Categories.map((category) => category['name'] as String).toList();
        _isFirstLoad = false;
      });
    }

    // 添加选中的类别（包括自动选择的前五个和用户手动选择的）
    for (final selectedCategory in _selectedCategories) {
      final matchedCategory = categories.firstWhere(
        (item) => item['name'] == selectedCategory,
        orElse: () => {
          'name': selectedCategory,
          'amount': 0.0,
          'type': selectedCategory == 'Income' ? 'INCOME' : 'SPENDING',
        },
      );

      combinedCategories.add(matchedCategory);
    }
    
    // 按金额从大到小排序
    combinedCategories.sort((a, b) => (b['amount'] as num).compareTo(a['amount'] as num));

    // 更新状态
    setState(() {
      _categoryData = combinedCategories;
    });
    // 更新 Provider 中的数据
    context.read<ChartDataProvider>().setCategoryData(categories);

  } catch (e) {
    setState(() {
      _error = e.toString();
    });
  }
}


  Future<void> _fetchWeeklyTransactions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weeklyData = await _weeklyTransactionService.getWeeklyTransactions();
      setState(() {
        _weekData = weeklyData;
        _isLoading = false;
      });
      // 更新 Provider 中的数据
      context.read<ChartDataProvider>().setWeekData(weeklyData);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _selectedAccountId = '';
  String _selectedPeriod = 'Recent';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accounts = context.read<AccountProvider>().accounts;
      if (accounts.isNotEmpty) {
        setState(() {
          _selectedAccountId = accounts.first.id;
        });
        // 使用选中的账户ID获取数据
        _fetchWeeklyTransactions();
        _fetchTopCategories(accountId: _selectedAccountId);
      } else {
        // 如果没有账户，则获取所有数据
        _fetchWeeklyTransactions();
        _fetchTopCategories();
      }
    });
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    switch (name) {
      case 'groceries':
        return Icons.local_grocery_store;
      case 'dining':
        return Icons.restaurant_menu;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.sports_esports;
      case 'transport':
        return Icons.directions_bus;
      case 'utilities':
        return Icons.power;
      case 'housing':
        return Icons.house;
      case 'healthcare':
        return Icons.medical_services;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.card_travel;
      case 'subscriptions':
        return Icons.subscriptions;
      case 'income':
        return Icons.account_balance_wallet;
      case 'transfer':
        return Icons.swap_horiz;
      case 'investment':
        return Icons.show_chart;
      case 'savings':
        return Icons.savings;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Text('Track', style: TextStyle(color: Color(0xFF1C1C1E), fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Consumer<AccountProvider>(
                    builder: (context, accountProvider, child) {
                      final accounts = accountProvider.accounts;
                      final selectedAccount = accounts.isNotEmpty
                          ? accounts.firstWhere(
                              (account) => account.id == _selectedAccountId,
                              orElse: () => accounts.first,
                            )
                          : null;

                      return PopupMenuButton<String>(
                        onSelected: (String accountId) async {
                          setState(() {
                            _selectedAccountId = accountId;
                            _isLoading = true;
                          });
                          try {
                            // 获取周数据
                            final weeklyData = accountId.isEmpty
                                ? await _weeklyTransactionService.getWeeklyTransactions()
                                : await _weeklyTransactionService.getTransactionsByAccount(accountId);
                            
                            // 更新周数据
                            setState(() {
                              _weekData = weeklyData;
                            });
                            
                            // 更新Provider中的周数据
                            context.read<ChartDataProvider>().setWeekData(weeklyData);
                            
                            // 获取并更新分类数据
                            await _fetchTopCategories(accountId: accountId);
                            
                            setState(() {
                              _isLoading = false;
                            });
                          } catch (e) {
                            setState(() {
                              _error = e.toString();
                              _isLoading = false;
                            });
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          final menuItems = <PopupMenuItem<String>>[];
                          
                          // 只有当账户数量大于1时才添加'All Account'选项
                          if (accounts.length > 1) {
                            menuItems.add(
                              const PopupMenuItem<String>(
                                value: '',
                                child: Text('All Account'),
                              ),
                            );
                          }
                          
                          // 添加所有账户选项
                          menuItems.addAll(
                            accounts.map((Account account) {
                              return PopupMenuItem<String>(
                                value: account.id,
                                child: Text(account.name),
                              );
                            }),
                          );
                          
                          return menuItems;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5FE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedAccountId.isEmpty && accounts.length > 1
                                    ? 'All Account'
                                    : selectedAccount?.name ?? 'Select Account',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF1C1C1E)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5FE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedPeriod, style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E))),
                  const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF1C1C1E)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF004D40)))
            : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFF1C1C1E)),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      SizedBox(
                        height: 300,
                        child: CustomPaint(
                          painter: ChartPainter(_weekData),
                          child: Container(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade700,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Income',
                                      style: TextStyle(color: Color(0xFF666666)),
                                    ),
                                  ],
                                ),
                                Text(
                                  _weekData.fold<double>(
                                          0,
                                          (sum, item) =>
                                              sum + (item['income'] ?? 0))
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Color(0xFF1C1C1E),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Spending',
                                      style: TextStyle(color: Color(0xFF666666)),
                                    ),
                                  ],
                                ),
                                Text(
                                  _weekData.fold<double>(
                                          0,
                                          (sum, item) =>
                                              sum + (item['spending'] ?? 0))
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Color(0xFF1C1C1E),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Categories section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(color: Color(0xFF1C1C1E), fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // 根据当前选中的账户ID获取最新的类别数据
                              List<Map<String, dynamic>> latestCategories;
                              try {
                                latestCategories = _selectedAccountId.isEmpty
                                    ? await _categoryService.getTopCategories()
                                    : await _categoryService.getTopCategoriesByAccount(_selectedAccountId);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to load categories: ${e.toString()}'))
                                );
                                return;
                              }
                              
                              List<String> tempSelectedCategories = List.from(_selectedCategories);
                              
                              // 添加top5类别到临时选择列表中
                              for (final category in _categoryData) {
                                final categoryName = category['name'] as String;
                                if (!tempSelectedCategories.contains(categoryName)) {
                                  tempSelectedCategories.add(categoryName);
                                }
                              }
                              
                              if (!mounted) return;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Choose Categories',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1C1C1E),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close, color: Color(0xFF666666)),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setState) {
                                          return Flexible(
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 2.5,
                                                crossAxisSpacing: 12,
                                                mainAxisSpacing: 12,
                                              ),
                                              itemCount: _predefinedCategories.length,
                                              itemBuilder: (context, index) {
                                                final category = _predefinedCategories[index];
                                                final isSelected = tempSelectedCategories.contains(category);
                                                // 只使用tempSelectedCategories来决定是否激活，不再考虑isTop5
                                                final isActive = isSelected;

                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                  if (isSelected) {
                                                    // 如果类别已被选中，则取消选择
                                                    tempSelectedCategories.remove(category);
                                                  } else {
                                                    // 如果类别未被选中，则添加到选择列表
                                                    tempSelectedCategories.add(category);
                                                  }
                                                });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 200),
                                                    decoration: BoxDecoration(
                                                      color: isActive ? const Color(0xFF004D40) : Colors.white,
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(
                                                        color: isActive ? const Color(0xFF004D40) : Colors.grey.shade300,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          _getCategoryIcon(category),
                                                          color: isActive ? Colors.white : const Color(0xFF666666),
                                                          size: 20,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          category,
                                                          style: TextStyle(
                                                            color: isActive ? Colors.white : const Color(0xFF1C1C1E),
                                                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                side: BorderSide(color: Colors.grey.shade300),
                                              ),
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(color: Color(0xFF666666)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF004D40),
                                                padding: const EdgeInsets.symmetric(vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () async {
                                                try {
                                                  // 保存用户选择的类别到服务器
                                                  // 更新外部状态中的选择类别
                                                  setState(() {
                                                    // 只保存用户在对话框中选择的类别
                                                    _selectedCategories = List.from(tempSelectedCategories);
                                                  });
                                                  
                                                  // 重新获取类别数据，使用当前选中的账户ID
                                                  await _fetchTopCategories(accountId: _selectedAccountId);
                                                  
                                                  if (mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                } catch (e) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Failed choose category: ${e.toString()}')),
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                'Confirm',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5FE),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Customize',
                                style: TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                       // Categories container
                      if (_categoryData.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                size: 48,
                                color: Color(0xFF666666),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Please select a category to view detailed information.',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children: [
                            // Income Container
                            if (_categoryData.any((item) => item['type'] == 'INCOME'))
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Income',
                                        style: TextStyle(color: Color(0xFF666666)),
                                      ),
                                    ),
                                    ..._categoryData.where((item) => item['type'] == 'INCOME').map((entry) => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Row(
                                            children: [
                                              Icon(
                                                _getCategoryIcon(entry['name']),
                                                color: const Color(0xFF666666),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                entry['name'],
                                                style: const TextStyle(color: Color(0xFF1C1C1E)),
                                              ),
                                              const Spacer(),
                                              Text(
                                                entry['amount'].toStringAsFixed(2),
                                                style: const TextStyle(color: Color(0xFF1C1C1E)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (_categoryData.where((item) => item['type'] == 'INCOME').toList().indexOf(entry) != _categoryData.where((item) => item['type'] == 'INCOME').length - 1)
                                          const Divider(height: 1, color: Color(0xFFE0E0E0)),
                                      ],
                                    )).toList(),
                                  ],
                                ),
                              ),
                            if (_categoryData.any((item) => item['type'] == 'INCOME') && _categoryData.any((item) => item['type'] != 'INCOME'))
                              const SizedBox(height: 16),
                            // Spending Container
                            if (_categoryData.any((item) => item['type'] != 'INCOME'))
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Spending',
                                        style: TextStyle(color: Color(0xFF666666)),
                                      ),
                                    ),
                                    ..._categoryData.where((item) => item['type'] != 'INCOME').map((entry) => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Row(
                                            children: [
                                              Icon(
                                                _getCategoryIcon(entry['name']),
                                                color: const Color(0xFF666666),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                entry['name'],
                                                style: const TextStyle(color: Color(0xFF1C1C1E)),
                                              ),
                                              const Spacer(),
                                              Text(
                                                entry['amount'].toStringAsFixed(2),
                                                style: const TextStyle(color: Color(0xFF1C1C1E)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (_categoryData.where((item) => item['type'] != 'INCOME').toList().indexOf(entry) != _categoryData.where((item) => item['type'] != 'INCOME').length - 1)
                                          const Divider(height: 1, color: Color(0xFFE0E0E0)),
                                      ],
                                    )).toList(),
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
            ),
      );
  }
}

class ChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double barWidth = 20.0;
    final double maxValue = data.fold<double>(
        0,
        (max, item) =>
            [item['income'] ?? 0, item['spending'] ?? 0, max].reduce((a, b) => a > b ? a : b));
    final double chartHeight = size.height - 40;
    final Paint incomePaint = Paint()
      ..color = Colors.green.shade700
      ..style = PaintingStyle.fill;
    final Paint spendingPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.fill;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw horizontal grid lines and values
    for (int i = 0; i <= 5; i++) {
      final double y = chartHeight - (chartHeight * i / 5);
      final double value = maxValue * i / 5;
      canvas.drawLine(
        Offset(30, y),
        Offset(size.width - 30, y),
        Paint()
          ..color = const Color(0xFFE0E0E0)
          ..strokeWidth = 1,
      );
      textPainter.text = TextSpan(
        text: value.toStringAsFixed(0),
        style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, y - textPainter.height / 2),
      );
    }

    // Draw bars and day labels
    for (int i = 0; i < data.length; i++) {
      final double x = 50.0 + (size.width - 100) * i / (data.length - 1);
      final double incomeHeight =
          ((data[i]['income'] ?? 0) / maxValue) * chartHeight;
      final double spendingHeight =
          ((data[i]['spending'] ?? 0) / maxValue) * chartHeight;

      // Draw income bar
      canvas.drawRect(
        Rect.fromLTWH(
          x - barWidth + 10,
          chartHeight - incomeHeight,
          barWidth,
          incomeHeight,
        ),
        incomePaint,
      );

      // Draw spending bar
      canvas.drawRect(
        Rect.fromLTWH(
          x + 10,
          chartHeight - spendingHeight,
          barWidth,
          spendingHeight,
        ),
        spendingPaint,
      );

      // Draw day label
      textPainter.text = TextSpan(
        text: data[i]['day'],
        style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2+10, size.height - textPainter.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}