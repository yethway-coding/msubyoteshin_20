import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/key_code.dart';

class KeyCodeListener extends StatelessWidget {
  final FocusNode focusNode;
  final Widget child;
  final VoidCallback? upClick;
  final VoidCallback? downClick;
  final VoidCallback? leftClick;
  final VoidCallback? rightClick;
  final VoidCallback? centerClick;
  final VoidCallback? otherClick;
  const KeyCodeListener({
    super.key,
    required this.child,
    required this.focusNode,
    this.upClick,
    this.downClick,
    this.leftClick,
    this.rightClick,
    this.centerClick,
    this.otherClick,
  });

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: focusNode,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent &&
              event.data is RawKeyEventDataAndroid) {
            final rawKeyEventData = event.data as RawKeyEventDataAndroid;
            // debugPrint('KEY Code : ${rawKeyEventData.keyCode}');
            switch (rawKeyEventData.keyCode) {
              case centerKEY:
                if (centerClick != null) centerClick!();
                break;
              case centerKEYPC:
                if (centerClick != null) centerClick!();
                break;
              case upKEY:
                if (upClick != null) upClick!();
                break;
              case downKEY:
                if (downClick != null) downClick!();
                break;
              case leftKEY:
                if (leftClick != null) leftClick!();
                break;
              case rightKEY:
                if (rightClick != null) rightClick!();
                break;
              default:
                if (otherClick != null) otherClick!();
                break;
            }
          }
        },
        child: child);
  }
}
