import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'reset_password_screen.dart';
import 'security_settings_screen.dart';
import 'login_screen.dart';
import 'dart:math'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
final List<String> _savingTips = [
  "This month's saving tip: Save 10% of your income every month and accumulate wealth over time!",
  "Small savings add up. Every penny saved is a step toward your future security.",
  "Remember to save before you spend. Make saving a habit.",
  "Set a monthly saving goal for yourself and stick to it for a pleasant surprise!",
  "Financial management starts with saving. Today’s persistence is tomorrow’s confidence.",
  "Cut unnecessary expenses and save the difference.",
  "Set up automatic transfers to your savings account to make saving easier.",
  "Save for your dreams. Every bit brings you closer to your goals.",
  "Saving is the best self-discipline and an investment in your future.",
  "Save a little every month for greater peace of mind in the future.",
  "Keep saving and your wealth will grow naturally.",
];
late String _currentTip = _savingTips[0];
  User? _user;
  bool _isLoading = true;
  String? _error;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _currentTip = _savingTips[random.nextInt(_savingTips.length)];
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _fetchUserInfo();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showChangePasswordDialog() {
    if (_user?.email != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(email: _user!.email, source:'profile'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to get user email information')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchUserInfo, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF004D40), Color(0xFF004D40)],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetchUserInfo,
          child: ListView(
            children: [_buildProfileHeader(), _buildProfileDetails()],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchUserInfo() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final userData = await _authService.getUserInfo();
      setState(() {
        _user = userData != null
            ? User.fromJson(userData as Map<String, dynamic>)
            : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load user info: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _showUpdatePhoneDialog() async {
    final TextEditingController _phoneController =
        TextEditingController(text: _user?.mobile ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Phone'),
        content: TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Enter new phone number',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPhone = _phoneController.text.trim();
              if (newPhone.isNotEmpty && _user?.email != null) {
                final success = await _authService.updatePhone(newPhone);
                Navigator.of(context).pop();

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Phone updated successfully')),
                  );
                  _fetchUserInfo();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update phone')),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF004D40), Color(0xFF004D40)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Hero(
              tag: 'profile_avatar',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: _user?.avatarUrl != null
                      ? NetworkImage(_user!.avatarUrl!)
                      : null,
                  child: _user?.avatarUrl == null
                      ? const Icon(Icons.person, size: 45, color: Color(0xFF004D40))
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeTransition(
              opacity: _animation,
              child: Text(
                '${_user?.firstName ?? ''} ${_user?.middleName ?? ''} ${_user?.lastName ?? ''}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _user?.email ?? '',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value ?? 'Not set')),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 每月储蓄提示卡片
  Card(
    color: Colors.lightGreen[50],
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.savings, color: Colors.green, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
            '${_user?.firstName ?? _user?.email ?? "User"}, $_currentTip',
            style: TextStyle(fontSize: 16, color: Colors.green[900]),
          ),
          ),
        ],
      ),
    ),
  ),
            Row(
              children: [
                const Icon(Icons.person_outline, color: Color(0xFF004D40)),
                const SizedBox(width: 8),
                Text('Profile Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Color(0xFF004D40),
                          fontWeight: FontWeight.bold,
                        )),
              ],
            ),
            const Divider(height: 32),
            _buildInfoItem(
              'Full Name',
              [_user?.firstName, _user?.middleName, _user?.lastName]
                  .where((name) => name != null && name.trim().isNotEmpty)
                  .join(' '),
            ),

            // Phone row clickable
            GestureDetector(
              onTap: _showUpdatePhoneDialog,
              child: _buildInfoItem('Phone', _user?.mobile),
            ),

            _buildInfoItem('Email', _user?.email),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final authLink = await _authService.getAuthLink();
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004D40),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.verified_user, color: Colors.white),
                label: const Text(
                  'Link Your Bank Card',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 账户统计信息卡片
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.analytics_outlined, color: Color(0xFF004D40)),
                      const SizedBox(width: 8),
                      Text(
                        'Account Statistics',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Color(0xFF004D40),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  _buildInfoItem(
                    'Account Creation Time',
                    _user?.createdAt != null
                        ? DateFormat('yyyy-MM-dd HH:mm').format(_user!.createdAt!)
                        : '未知',
                  ),
                ],
              ),
            ),
            // 账户操作区域卡片
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.settings_outlined, color: Color(0xFF004D40)),
                      const SizedBox(width: 8),
                      Text(
                        'Account Operations',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Color(0xFF004D40),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: Color(0xFF004D40)),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showChangePasswordDialog,
                  ),
                  ListTile(
                    leading: const Icon(Icons.security_outlined, color: Color(0xFF004D40)),
                    title: const Text('Security Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecuritySettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Log out'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await context.read<AuthService>().logout();
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
