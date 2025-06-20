import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;

/// Service for checking dates in the web page.
class DateCheckerService {
  /// Private constructor to prevent instantiation.
  DateCheckerService._();

  /// Gets the color status based on the date in the web page.
  static Future<Color> getDateStatus(dynamic controller) async {
    try {
      String dateText;
      if (Platform.isLinux) {
        final result = await (controller as webview_flutter.WebViewController)
            .runJavascriptReturningResult('''
          (function() {
            const tab = document.querySelector('li.active a');
            return tab ? tab.textContent.trim() : '';
          })();
        ''');
        dateText = result as String;
      } else {
        dateText =
            await (controller as InAppWebViewController).evaluateJavascript(
                  source: '''
          (function() {
            const tab = document.querySelector('li.active a');
            return tab ? tab.textContent.trim() : '';
          })();
        ''',
                )
                as String;
      }

      if (dateText.isEmpty) {
        return Colors.red;
      }

      // Extract date from "Tellimus DD.MM.YYYY" format
      final dateMatch = RegExp(
        r'Tellimus (\d{2}\.\d{2}\.\d{4})',
      ).firstMatch(dateText);
      if (dateMatch == null) {
        return Colors.red;
      }

      final dateStr = dateMatch.group(1)!;
      final parts = dateStr.split('.');
      final date = DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      if (date.isAtSameMomentAs(todayStart)) {
        return Colors.blue;
      } else if (date.isAfter(todayStart)) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } catch (e) {
      return Colors.red;
    }
  }
}
