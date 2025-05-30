import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _authService = AuthService();
  bool _isValidEmail = false;
  bool _isSendingCode = false;
  bool _isVerifying = false;
  DateTime? _lastSendTime;

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _onEmailChanged(String value) {
    setState(() {
      _isValidEmail = _isEmailValid(value);
    });
  }

  bool _canSendCode() {
    if (_lastSendTime == null) return true;
    final now = DateTime.now();
    return now.difference(_lastSendTime!) >= const Duration(seconds: 1);
  }

  Future<bool> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return false;
    
    try {
      final verifySuccess = await _authService.verifyCode(
        _emailController.text,
        _verificationCodeController.text,
      );

      if (!mounted) return false;

      if (verifySuccess) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid verification code')),
        );
        return false;
      }
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification failed: Network error')),
      );
      return false;
    }
  }

  Future<void> _handleSendCode() async {
    if (!_isValidEmail || _isSendingCode || !_canSendCode()) return;

    setState(() {
      _isSendingCode = true;
      _lastSendTime = DateTime.now();
    });

    try {
      final success = await _authService.sendVerificationCode(_emailController.text);
      if (success) {
        setState(() {
          _isVerifying = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code has been sent to your email')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send verification code')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send verification code: Network error')),
      );
    } finally {
      setState(() {
        _isSendingCode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004D40),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Please enter your email address, we will send you a verification code',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  onChanged: _onEmailChanged,
                  decoration: InputDecoration(
                    hintText: 'Email address',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: _isValidEmail
                        ? TextButton(
                            onPressed: (_isSendingCode || !_canSendCode())
                                ? null
                                : _handleSendCode,
                            child: Text(
                              'Send Code',
                              style: TextStyle(
                                color: (_isSendingCode || !_canSendCode())
                                    ? Colors.grey
                                    : const Color(0xFF004D40),
                              ),
                            ),
                          )
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!_isEmailValid(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                if (_isVerifying) ...[  // 只在发送验证码成功后显示验证码输入框
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _verificationCodeController,
                    decoration: const InputDecoration(
                      hintText: 'Verification code',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter verification code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF004D40),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (await _verifyCode()) {
                        if (!mounted) return;
                        Navigator.pushNamed(
                          context,
                          '/reset-password',
                          arguments: _emailController.text,
                        );
                      }
                    },
                    child: const Text('Verify'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}