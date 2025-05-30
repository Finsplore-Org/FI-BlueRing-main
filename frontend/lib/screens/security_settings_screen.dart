import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({Key? key}) : super(key: key);

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final AuthService _authService = AuthService();
  bool _twoFactorEnabled = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _loginHistory = [];
  List<Map<String, dynamic>> _devices = [];
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
  }

  Future<void> _loadSecuritySettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Get security settings from backend
      // final settings = await _authService.getSecuritySettings();
      // setState(() {
      //   _twoFactorEnabled = settings.twoFactorEnabled;
      //   _loginHistory = settings.loginHistory;
      //   _devices = settings.devices;
      //   _notificationsEnabled = settings.notificationsEnabled;
      // });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load security settings: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildTwoFactorAuth(),
                _buildNotificationSettings(),
                _buildLoginHistory(),
                _buildDeviceManagement(),
              ],
            ),
    );
  }

  Widget _buildTwoFactorAuth() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.security, color: Color(0xFF004D40)),
            title: const Text('Two-Factor Authentication (2FA)'),
            subtitle: const Text('Use authenticator app or SMS for two-factor authentication'),
            trailing: Switch(
              value: _twoFactorEnabled,
              onChanged: (value) async {
                // TODO: Implement two-factor authentication toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Two-factor authentication coming soon')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications, color: Color(0xFF004D40)),
            title: const Text('Account Activity Notifications'),
            subtitle: const Text('Receive notifications for logins and important activities'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) async {
                // TODO: Implement notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings coming soon')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHistory() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF004D40)),
            title: const Text('Login History'),
            subtitle: const Text('View recent login activities'),
          ),
          // TODO: Display login history list
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Login history coming soon'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceManagement() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.devices, color: Color(0xFF004D40)),
            title: const Text('Device Management'),
            subtitle: const Text('View and manage logged-in devices'),
          ),
          // TODO: Display device list
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Device management coming soon'),
          ),
        ],
      ),
    );
  }
}