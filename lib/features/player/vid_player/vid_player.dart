import '../../../common/utils/toast.dart';
import '../widgets/watermark.dart';
import '../widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import '/common/utils/reusable_widget.dart';
import '/common/widgets/background_widget.dart';
import '/common/widgets/key_code_listener.dart';
import 'package:video_player/video_player.dart';
import '/features/player/widgets/play_pause.dart';
import '/features/player/widgets/rewind_forward.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

enum ControlFocus {
  pre10s,
  next10s,
  pPause, //play-pause
  pBar, //progress-bar
  close
}

class VidPlayer extends StatefulWidget {
  final String url;
  final String title;
  const VidPlayer({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<VidPlayer> createState() => _VidPlayerState();
}

class _VidPlayerState extends State<VidPlayer> {
  late VideoPlayerController _controller;

  bool _showControl = true;
  final _focus = FocusNode();
  final _stopWatchTimer = StopWatchTimer();

  ControlFocus? controlFocus = ControlFocus.pPause;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_focus);
      _hideControl();

      _stopWatchTimer.secondTime.listen((value) {
        //after 4 sec , control will be hide
        if (value == 6) {
          setState(() {
            _showControl = false;
            controlFocus = null;
          });
          _stopWatchTimer.onResetTimer();
        }
      });
    });
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    )..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.onStopTimer();
    _controller.dispose();
  }

  _hideControl() async {
    if (_stopWatchTimer.isRunning) {
      _stopWatchTimer.onResetTimer();
      _stopWatchTimer.onStartTimer();
    } else {
      _stopWatchTimer.onStartTimer();
    }
  }

  _preSec(int sec) async {
    Duration? currentPos = await _controller.position;

    if (currentPos != null) {
      var newPos = currentPos.inSeconds - sec;
      if (newPos > 0) {
        _controller.seekTo(Duration(seconds: newPos));
        if (!_controller.value.isPlaying) {
          _controller.play();
        }
      } else {
        _controller.seekTo(Duration.zero);
        if (!_controller.value.isPlaying) {
          _controller.play();
        }
      }
    }
  }

  _nextSec(int sec) async {
    Duration? currentPos = await _controller.position;
    var totoalSec = _controller.value.duration.inSeconds;

    if (currentPos != null) {
      var newPos = currentPos.inSeconds + sec;
      if (newPos < totoalSec) {
        _controller.seekTo(Duration(seconds: newPos));
        if (!_controller.value.isPlaying) {
          _controller.play();
        }
      } else {
        _controller.seekTo(Duration(seconds: totoalSec));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showControl) {
          setState(() {
            _showControl = false;
          });
          return false;
        } else {
          // return true;
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            Toast.show(
                tType: TType.warning,
                message: 'ထွက်ရန် Back ကို နှစ်ချက်ဆက်တိုက် နှိပ်ပါ..!');
            return await Future.value(false);
          }
        }
        return await Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: KeyCodeListener(
          focusNode: _focus,
          centerClick: () async {
            if (_showControl) {
              if (_hasFocus(ControlFocus.pPause)) {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              } else if (_hasFocus(ControlFocus.pre10s)) {
                await _preSec(10);
              } else if (_hasFocus(ControlFocus.next10s)) {
                await _nextSec(10);
              } else if (_hasFocus(ControlFocus.close)) {
                Navigator.pop(context);
              } else if (_hasFocus(ControlFocus.pBar)) {
                ///
              }
            } else {
              controlFocus = ControlFocus.pPause;
              _showControl = true;
            }
            _hideControl();
            setState(() {});
          },
          downClick: () {
            if (_hasFocus(ControlFocus.pPause) ||
                _hasFocus(ControlFocus.pre10s) ||
                _hasFocus(ControlFocus.next10s)) {
              controlFocus = ControlFocus.pBar;
              _hideControl();
              setState(() {});
              return;
            } else if (_hasFocus(ControlFocus.close)) {
              controlFocus = ControlFocus.pPause;
              _hideControl();
              setState(() {});
            }
          },
          upClick: () {
            if (_hasFocus(ControlFocus.pBar)) {
              controlFocus = ControlFocus.pPause;
              _hideControl();
              setState(() {});
              return;
            } else if (_hasFocus(ControlFocus.pPause) ||
                _hasFocus(ControlFocus.pre10s) ||
                _hasFocus(ControlFocus.next10s)) {
              controlFocus = ControlFocus.close;
              _hideControl();
              setState(() {});
              return;
            }
          },
          leftClick: () async {
            if (_hasFocus(ControlFocus.pPause)) {
              controlFocus = ControlFocus.pre10s;
              _hideControl();
              setState(() {});
              return;
            } else if (_hasFocus(ControlFocus.next10s)) {
              controlFocus = ControlFocus.pPause;
              _hideControl();
              setState(() {});
              return;
            } else if (_hasFocus(ControlFocus.pBar)) {
              await _preSec(30);
            }
          },
          rightClick: () async {
            if (_hasFocus(ControlFocus.pPause)) {
              controlFocus = ControlFocus.next10s;
              _hideControl();
              setState(() {});
              return;
            } else if (_hasFocus(ControlFocus.pre10s)) {
              controlFocus = ControlFocus.pPause;
              _hideControl();
              setState(() {});
              return;
            } else if (_hasFocus(ControlFocus.pBar)) {
              await _nextSec(30);
            }
          },
          child: _controller.value.isInitialized
              ? Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(_controller),
                            if (_showControl)
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.black.withOpacity(.5),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Center(
                                      child: Stack(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RewindForward(
                                                isRewind: true,
                                                isFocused: _hasFocus(
                                                  ControlFocus.pre10s,
                                                ),
                                              ),
                                              const SizedBox(width: 40),
                                              Playpause(
                                                controller: _controller,
                                                isFocused: _hasFocus(
                                                  ControlFocus.pPause,
                                                ),
                                              ),
                                              const SizedBox(width: 40),
                                              RewindForward(
                                                isRewind: false,
                                                isFocused: _hasFocus(
                                                  ControlFocus.next10s,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                      ),
                                      child: Progressbar(
                                        controller: _controller,
                                        isFocused: _hasFocus(ControlFocus.pBar),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ///app logo

                            const Positioned(
                              right: 5,
                              top: 5,
                              child: Watermark(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : BackgroundWidget(
                  child: ReusableWidget.loading(isCenter: true),
                ),
        ),
      ),
    );
  }

  bool _hasFocus(ControlFocus focus) => controlFocus == focus;
}
