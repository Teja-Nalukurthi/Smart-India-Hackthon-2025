import 'package:flutter/foundation.dart';

/// A utility to replace all print statements with safe debug prints
/// This prevents DebugService null errors in Flutter web

void safePrint(dynamic message) {
  // Completely disable all print output in web mode to prevent DebugService errors
  if (kDebugMode && !kIsWeb) {
    final safeMessage = message?.toString() ?? '[null]';
    if (safeMessage != 'null' && safeMessage.isNotEmpty) {
      // Use Flutter's built-in debugPrint which is safer for web
      debugPrint(safeMessage);
    }
  }
}
