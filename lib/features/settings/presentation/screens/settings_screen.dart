import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/constants.dart';
import '../../../../exceptions/exceptions.dart';

/// The settings screen of the application.
class SettingsScreen extends StatefulWidget {
  /// Creates a new instance of [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _codeController.text = prefs.getString(AppConstants.codeKey) ?? '';
        _passwordController.text =
            prefs.getString(AppConstants.passwordKey) ?? '';
      });
    } on Exception catch (e) {
      _showError('Failed to load credentials: $e');
    }
  }

  Future<void> _saveCredentials() async {
    try {
      final code = _codeController.text.trim();
      final password = _passwordController.text.trim();

      if (code.isEmpty || password.isEmpty) {
        throw const MissingCredentialsException();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.codeKey, code);
      await prefs.setString(AppConstants.passwordKey, password);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Settings saved')));
      }
    } on MissingCredentialsException catch (e) {
      _showError(e.message);
    } on Exception catch (e) {
      _showError('Failed to save credentials: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Enter your code',
                helperText: 'Enter the code you use to log in',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Enter your password',
                helperText: 'Enter the password you use to log in',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCredentials,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
