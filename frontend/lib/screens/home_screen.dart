import 'package:flutter/material.dart';
import 'package:frontend/widgets/home/account_shimmer.dart';
import 'package:frontend/widgets/home/transaction_details_dialog.dart';
import 'package:frontend/widgets/home/transaction_filter_panel.dart';
import 'package:frontend/widgets/home/transaction_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../services/mock_data_service.dart';
import '../services/transaction_service.dart';
import '../services/account_service.dart';
import '../services/goal_service.dart';
import '../services/category_service.dart';
import '../services/budget_service.dart';
import '../providers/account_provider.dart';
import '../services/auth_service.dart';
import '../services/bill_service.dart';
import '../services/chat_service.dart';
import '../widgets/home/budget_dialog.dart';
import '../widgets/home/amount_input_dialog.dart';
import '../widgets/home/bill_reminder_dialog.dart';
import '../widgets/home/transaction_shimmer.dart';
import '../widgets/home/drawer_menu.dart';
import 'bills_screen.dart';
import 'suggestion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Account> _accounts = [];
  final AccountService _accountService = AccountService();
  final List<AccountType> _accountTypes = MockDataService.getAccountTypes();
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  final TransactionService _transactionService = TransactionService();
  final GoalService _goalService = GoalService();
  final CategoryService _categoryService = CategoryService();
  final BudgetService _budgetService = BudgetService();
  final BillService _billService = BillService();
  final ChatService _chatService = ChatService();
  double? _currentGoal;
  double? _currentBudget;
  bool _isLoading = false;
  bool _isLoadingAccounts = true;
  bool _isLoadingGoal = true;
  bool _isLoadingBudget = true;
  String? _error;
  
  // 过滤条件
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedAccount;
  double? _minAmount;
  double? _maxAmount;
  bool _showFilterPanel = false;

  final Map<String, IconData> _transactionIcons = {
    'groceries': Icons.shopping_basket,
    'dining': Icons.restaurant,
    'shopping': Icons.shopping_cart,
    'entertainment': Icons.movie,
    'transport': Icons.directions_car,
    'utilities': Icons.power,
    'housing': Icons.home,
    'healthcare': Icons.local_hospital,
    'education': Icons.school,
    'travel': Icons.flight,
    'subscriptions': Icons.subscriptions,
    'income': Icons.account_balance,
    'transfer': Icons.swap_horiz,
    'investment': Icons.trending_up,
    'savings': Icons.savings,
  };

  IconData _getTransactionIcon(Transaction transaction) {
    final category = transaction.transactionClass.toLowerCase();
    if (_transactionIcons.containsKey(category)) {
      return _transactionIcons[category]!;
    }
    return transaction.isCredit ? Icons.arrow_circle_down : Icons.arrow_circle_up;
  }
  
  double get _totalPositiveBalance {
    return _accounts
        .where((account) => account.balance > 0)
        .fold(0, (sum, account) => sum + account.balance);
  }

  double get _totalNegativeBalance {
    return _accounts
        .where((account) => account.balance < 0)
        .fold(0, (sum, account) => sum + account.balance.abs());
  }

  double get _totalBalance {
    return _accounts.fold(0, (sum, account) => sum + account.balance);
  }

  double _getBalancePercentage(Account account) {
    if (account.balance > 0) {
      return _totalPositiveBalance > 0 ? (account.balance / _totalPositiveBalance) * 100 : 0;
    } else {
      return _totalNegativeBalance > 0 ? (account.balance.abs() / _totalNegativeBalance) * 100 : 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _fetchCurrentGoal();
    _fetchCurrentBudget();
    _fetchAccounts();
    _fetchBillsAndShowReminder();
  }

  Future<void> _fetchCurrentBudget() async {
    setState(() {
      _isLoadingBudget = true;
    });
    try {
      final budget = await _budgetService.getBudget();
      setState(() {
        _currentBudget = budget;
        _isLoadingBudget = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBudget = false;
      });
    }
    
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isLoadingBudget) {
        setState(() {
          _isLoadingBudget = false;
        });
      }
    });
  }

  Future<void> _showBudgetDialog() async {
    return showDialog(
      context: context,
      builder: (context) => BudgetDialog(
        currentBudget: _currentBudget,
        onSetBudget: (amount) async {
          await _budgetService.setBudget(amount);
          setState(() {
            _currentBudget = amount;
          });
        },
      ),
    );
  }

  Future<void> _fetchAccounts() async {
    setState(() {
      _isLoadingAccounts = true;
    });
    try {
      final accounts = await _accountService.getAccounts();
      setState(() {
        _accounts = accounts;
        _isLoadingAccounts = false;
      });
      context.read<AccountProvider>().setAccounts(accounts);
    } catch (e) {
      setState(() {
        _isLoadingAccounts = false;
      });
    }
  }

  Future<void> _fetchCurrentGoal() async {
    setState(() {
      _isLoadingGoal = true;
    });
    try {
      final goal = await _goalService.getGoal();
      setState(() {
        _currentGoal = goal;
        _isLoadingGoal = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingGoal = false;
      });
    }
    
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isLoadingGoal) {
        setState(() {
          _isLoadingGoal = false;
        });
      }
    });
  }

  Future<void> _showGoalDialog() async {
    final TextEditingController controller = TextEditingController(
      text: _currentGoal?.toString() ?? '');
    
    return showDialog(
      context: context,
      builder: (context) => AmountInputDialog(
        title: 'Set Target Amount',
        labelText: 'Target Amount',
        initialAmount: _currentGoal,
        onSetAmount: (amount) async {
          await _goalService.setGoal(amount);
          setState(() {
            _currentGoal = amount;
          });
        },
        errorMessage: 'Failed to set target',
      ),
    );
  }

  Future<void> _fetchBillsAndShowReminder() async {
    try {
      final bills = await _billService.getAllBills();
      if (bills.isNotEmpty) {
        final now = DateTime.now();
        final formattedTime = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        final message = 'Current Time: $formattedTime\nBills: ${bills.toString()}';
        final response = await _chatService.sendBillReminder(message);
        if (mounted) {
          _showBillReminderDialog(response);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gettign Bills Error: ${e.toString()}')),
        );
      }
    }
  }

  void _showBillReminderDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => BillReminderDialog(message: message),
    );
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final transactions = await _transactionService.getTransactions();
      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  // 过滤交易记录
  void _filterTransactions() {
    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        // 检查日期范围
        if (_startDate != null || _endDate != null) {
          final transactionDate = DateTime.parse(transaction.postDate);
          if (_startDate != null && transactionDate.isBefore(_startDate!)) {
            return false;
          }
          if (_endDate != null) {
            // 添加一天以包含结束日期当天
            final endDatePlusOne = _endDate!.add(const Duration(days: 1));
            if (transactionDate.isAfter(endDatePlusOne)) {
              return false;
            }
          }
        }
        
        // 检查账户
        if (_selectedAccount != null && _selectedAccount!.isNotEmpty && 
            transaction.account != _selectedAccount) {
          return false;
        }
        
        // 检查金额范围
        final amount = transaction.amountValue.abs();
        if (_minAmount != null && amount < _minAmount!) {
          return false;
        }
        if (_maxAmount != null && amount > _maxAmount!) {
          return false;
        }
        
        return true;
      }).toList();
    });
  }
  
  // 重置过滤条件
  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedAccount = null;
      _minAmount = null;
      _maxAmount = null;
      _filteredTransactions = _transactions;
    });
  }

  Future<void> _updateTransactionCategory(Transaction transaction, String newCategory) async {
    try {
      await _categoryService.updateCategory(transaction.id, newCategory);
      await _fetchTransactions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed update category: ${e.toString()}')),
        );
      }
    }
  }

  void _showTransactionDetails(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => TransactionDetailsDialog(
        transaction: transaction,
        transactionIcon: _getTransactionIcon(transaction),
        onUpdateCategory: _updateTransactionCategory,
      ),
    );
  }



  Widget _buildDrawer() {
    return DrawerMenu(totalBalance: _totalBalance);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          // const Icon(Icons.search, color: Colors.black87),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          const SizedBox(width: 16),
        ],
        title: const Text(
          'Finsplore',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          // Horizontal scrolling tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BillsScreen()),
                    );
                  },
                  child: _buildTab('Recurring'),
                ),
                GestureDetector(
                  onTap: _showGoalDialog,
                  child: _buildTab('Goals'),
                ),
                GestureDetector(
                  onTap: _showBudgetDialog,
                  child: _buildTab('Budget ${_currentBudget != null ? "(\$${_currentBudget!.toStringAsFixed(2)})" : ""}'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SuggestionScreen()),
                    );
                  },
                  child: _buildTab('Suggestion'),
                ),
              ],
            ),
          ),
          // Account cards
          SizedBox(
            height: 120,
            child: _isLoadingAccounts
              ? _buildAccountShimmer()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _accounts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _accounts.length) {
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: InkWell(
                          onTap: () async {
                            final authService = Provider.of<AuthService>(context, listen: false);
                            final authLink = await authService.getAuthLink();
                            if (authLink != null) {
                              if (!mounted) return;
                              if (await canLaunch(authLink)) {
                                await launch(authLink);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Unable to open authentication link')),
                                );
                              }
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to get authentication link')),
                              );
                            }
                          },
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Link Bank',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    final account = _accounts[index];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                          ? const Color.fromARGB(222, 195, 2, 2)
                          : const Color.fromRGBO(255, 215, 0, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              account.name,
                              style: TextStyle(
                                color: index % 2 == 0 ? const Color.fromARGB(255, 255, 255, 255) : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${account.balance.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: index % 2 == 0 ? Colors.white : Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_getBalancePercentage(account).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: account.balance >= 0 ? const Color.fromARGB(164, 11, 54, 28) : Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
          // Account types list
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Account types
                  Expanded(
                    child: ListView.builder(
                      itemCount: _accountTypes.length,
                      itemBuilder: (context, index) {
                        final type = _accountTypes[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(type.name),
                              trailing: type.canConnect
                                  ? TextButton(
                                      onPressed: () {},
                                      child: const Text('+ Connect'),
                                    )
                                  : Text(
                                      '\$${type.name == "Net Worth" ? _totalBalance.toStringAsFixed(2) : type.totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            if (type.name == 'Net Worth' && _currentGoal != null && _currentGoal! > 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LinearProgressIndicator(
                                      value: (_totalBalance / _currentGoal!).clamp(0.0, 1.0),
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _totalBalance >= _currentGoal! ? Colors.green : Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Goal Completion: ${((_totalBalance / _currentGoal!) * 100).clamp(0.0, 100.0).toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (index < _accountTypes.length - 1)
                              const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                  // Transactions section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _showFilterPanel ? Icons.filter_list_off : Icons.filter_list,
                              color: _showFilterPanel ? const Color(0xFF004D40) : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _showFilterPanel = !_showFilterPanel;
                              });
                            },
                          ),
                          if (_startDate != null || _endDate != null || 
                              _selectedAccount != null || _minAmount != null || _maxAmount != null)
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.grey),
                              onPressed: _resetFilters,
                              tooltip: 'Reset Filter',
                            ),
                        ],
                      ),
                    ],
                  ),
                  TransactionFilterPanel(
                    startDate: _startDate,
                    endDate: _endDate,
                    selectedAccount: _selectedAccount,
                    minAmount: _minAmount,
                    maxAmount: _maxAmount,
                    accounts: _accounts,
                    onStartDateChanged: (date) {
                      setState(() {
                        _startDate = date;
                      });
                      _filterTransactions();
                    },
                    onEndDateChanged: (date) {
                      setState(() {
                        _endDate = date;
                      });
                      _filterTransactions();
                    },
                    onAccountChanged: (value) {
                      setState(() {
                        _selectedAccount = value;
                      });
                      _filterTransactions();
                    },
                    onMinAmountChanged: (amount) {
                      setState(() {
                        _minAmount = amount;
                      });
                      _filterTransactions();
                    },
                    onMaxAmountChanged: (amount) {
                      setState(() {
                        _maxAmount = amount;
                      });
                      _filterTransactions();
                    },
                    onResetFilters: _resetFilters,
                    showFilterPanel: _showFilterPanel,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TransactionList(
                      isLoading: _isLoading,
                      error: _error,
                      transactions: _filteredTransactions,
                      getTransactionIcon: _getTransactionIcon,
                      onTransactionTap: _showTransactionDetails,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildTab(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _buildTransactionShimmer() {
    return const TransactionShimmer();
  }

  Widget _buildAccountShimmer() {
    return const AccountShimmer();
  }

  Widget _buildErrorWidget() {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.error, color: Colors.red),
          title: Text('Failed Loading: $_error'),
        ),
      ],
    );
  }
}