import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Playpause extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isFocused;
  const Playpause({
    super.key,
    required this.controller,
    required this.isFocused,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      width: 80,
      height: 80,
      alignment: Alignment.center,
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
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (ctx, value, _) {
          if (value.isBuffering) {
            return const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Colors.white,
                ),
              ),
            );
          }
          return Icon(
            value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 50,
            color: Colors.white,
          );
        },
      ),
    );
  }
}
