import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Progressbar extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isFocused;
  const Progressbar({
    super.key,
    required this.controller,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (ctx, value, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _durToTime(value.position),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                decoration: BoxDecoration(
                  border: isFocused
                      ? Border.all(
                          width: 2,
                          color: Colors.white,
                        )
                      : null,
                  color: Colors.grey.withOpacity(.3),
                  borderRadius: BorderRadius.circular(8),
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
                padding: const EdgeInsets.all(10),
                child: ProgressBar(
                  barHeight: 10,
                  baseBarColor: Colors.grey,
                  timeLabelLocation: TimeLabelLocation.none,
                  timeLabelTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  progress: value.position,
                  thumbRadius: 4,
                  thumbGlowRadius: 15,
                  thumbColor: Colors.white,
                  progressBarColor: Colors.white,
                  bufferedBarColor: Colors.blue.shade100,
                  buffered: value.buffered.isEmpty
                      ? Duration.zero
                      : value.buffered.last.end,
                  total: value.duration,
                  onSeek: (dur) {
                    controller.seekTo(dur);
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _durToTime(value.duration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        );
      },
    );
  }

  String _durToTime(Duration dur) {
    final hh = (dur.inHours).toString().padLeft(2, '0');
    final mm = (dur.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (dur.inSeconds % 60).toString().padLeft(2, '0');
    return hh == "00" ? '$mm:$ss' : '$hh:$mm:$ss';
  }
}
