import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../exceptions/exceptions.dart';
import '../../data/services/date_checker_service.dart';

/// The main screen of the application.
class MainScreen extends StatefulWidget {
  /// Creates a new instance of [MainScreen].
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _webViewController = Completer<InAppWebViewController>();
  bool _isLoading = true;
  bool _canRefresh = false;
  Color _dateStatusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _checkCredentials();
  }

  Future<void> _checkCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(AppConstants.codeKey);
      final password = prefs.getString(AppConstants.passwordKey);
      setState(() {
        _canRefresh = code != null && password != null;
      });
    } on Exception catch (e) {
      _showError('Failed to load credentials: $e');
    }
  }

  Future<void> _refreshAndAutoLogin() async {
    try {
      final controller = await _webViewController.future;
      await controller.reload();
      await _waitForPageLoad();
      await _performAutoLogin();

      await Future.delayed(const Duration(milliseconds: 400));
      await _updateDateStatus();
    } on WebPageLoadException catch (e) {
      _showError(e.message);
    } on JavaScriptExecutionException catch (e) {
      _showError(e.message);
    } on Exception catch (e) {
      _showError('An error occurred: $e');
    }
  }

  Future<void> _waitForPageLoad() async {
    try {
      final controller = await _webViewController.future;
      bool hasButtons = false;
      int attempts = 0;
      const maxAttempts = 50; // 5 seconds total

      while (!hasButtons && attempts < maxAttempts) {
        final result = await controller.evaluateJavascript(
          source: '!!document.querySelector("button.ok")',
        );
        hasButtons = result == true;
        if (!hasButtons) {
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
        }
      }

      if (!hasButtons) {
        throw const WebPageLoadException('Timeout waiting for login buttons');
      }
    } on Exception {
      throw const WebPageLoadException();
    }
  }

  Future<void> _performAutoLogin() async {
    try {
      final controller = await _webViewController.future;
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(AppConstants.codeKey) ?? '';
      final password = prefs.getString(AppConstants.passwordKey) ?? '';

      if (code.isEmpty || password.isEmpty) {
        throw const MissingCredentialsException();
      }

      await Future.delayed(const Duration(milliseconds: AppConstants.okButtonDelay));

      // Input code
      for (final digit in code.split('')) {
        await controller.evaluateJavascript(
          source: '''
          (function() {
            const buttons = Array.from(document.querySelectorAll('button'));
            const targetButton = buttons.find(btn => 
              !btn.classList.contains('ok') && 
              btn.textContent.trim() === '$digit'
            );
            if (targetButton) targetButton.click();
          })();
        ''',
        );
        await Future.delayed(
          const Duration(milliseconds: AppConstants.buttonClickDelay),
        );
      }
      await controller.evaluateJavascript(
        source: '''
        document.querySelector('button.ok').click();
      ''',
      );
      await Future.delayed(Duration(milliseconds: AppConstants.okButtonDelay));

      // Input password
      for (final digit in password.split('')) {
        await controller.evaluateJavascript(
          source: '''
          (function() {
            const buttons = Array.from(document.querySelectorAll('button'));
            const targetButton = buttons.find(btn => 
              !btn.classList.contains('ok') && 
              btn.textContent.trim() === '$digit'
            );
            if (targetButton) targetButton.click();
          })();
        ''',
        );
        await Future.delayed(
          Duration(milliseconds: AppConstants.buttonClickDelay),
        );
      }
      await controller.evaluateJavascript(
        source: '''
        document.querySelector('button.ok').click();
      ''',
      );
    } on Exception {
      throw const JavaScriptExecutionException();
    }
  }

  Future<void> _updateDateStatus() async {
    try {
      final controller = await _webViewController.future;
      final color = await DateCheckerService.getDateStatus(controller);
      setState(() {
        _dateStatusColor = color;
      });
    } catch (e) {
      setState(() {
        _dateStatusColor = Colors.grey;
      });
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
      appBar: AppBar(
        title: const Text('Toit'),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: _dateStatusColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _updateDateStatus,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(AppConstants.baseUrl)),
        onWebViewCreated: (controller) {
          _webViewController.complete(controller);
        },
        onLoadStart: (_, __) {
          setState(() => _isLoading = true);
        },
        onLoadStop: (_, __) async {
          setState(() => _isLoading = false);
          await _updateDateStatus();
        },
      ),
      floatingActionButton:
          _canRefresh
              ? FloatingActionButton(
                onPressed: _refreshAndAutoLogin,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.refresh),
              )
              : null,
    );
  }
}
