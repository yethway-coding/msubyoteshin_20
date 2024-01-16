import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

enum TType { fail, success, warning }

class Toast {
  static show({required TType tType, String? message}) {
    switch (tType) {
      case TType.success:
        _show(type: tType, message: message ?? "Success");
        break;
      case TType.warning:
        _show(type: tType, message: message ?? "Warning");
        break;
      case TType.fail:
        _show(type: tType, message: message ?? "Error");
        break;
      // default:
    }
  }

  static _show({required TType type, required String message}) {
    BotToast.showCustomText(
      align: Alignment.topRight,
      onlyOne: true,
      toastBuilder: (_) => _box(type: type, message: message),
    );
  }

  static _box({required TType type, required String message}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(20),
      constraints: const BoxConstraints(minWidth: 200),
      decoration: BoxDecoration(
        color: _color(type),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF272B35),
              child: Icon(
                _icon(type),
                size: 16,
                color: const Color(0xFF9D9FA5),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9D9FA5)),
            )
          ],
        ),
      ),
    );
  }

  static _color(TType type) {
    switch (type) {
      case TType.success:
        return Colors.green;
      case TType.warning:
        return const Color(0xFF1C222B);
      case TType.fail:
        return Colors.red;
    }
  }

  static _icon(TType type) {
    switch (type) {
      case TType.success:
        return Icons.check;
      case TType.warning:
        return Icons.warning;
      case TType.fail:
        return Icons.error;
    }
  }
}
