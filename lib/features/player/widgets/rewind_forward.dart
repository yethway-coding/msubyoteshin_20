import 'package:flutter/material.dart';

class RewindForward extends StatelessWidget {
  final bool isFocused;

  ///to check rewind or forward
  final bool isRewind;

  const RewindForward({
    super.key,
    required this.isRewind,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(.3),
        border: isFocused
            ? Border.all(
                width: 2,
                color: Colors.white,
              )
            : null,
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(
                    0,
                    0,
                  ), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Icon(
        isRewind ? Icons.fast_rewind_rounded : Icons.fast_forward_rounded,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
