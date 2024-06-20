import 'dart:async';
import 'dart:ui';

import 'package:aigo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class streamPlayer extends StatefulWidget {
  String videoResource;
  streamPlayer({
    super.key,
    required this.videoResource,
  });

  @override
  State<streamPlayer> createState() => _streamPlayerState();
}

class _streamPlayerState extends State<streamPlayer> {
  late VideoPlayerController _controller;

  Future<void> initializePlayer() async {}
  bool _onTouch = false;
  late Timer _timer;
  ValueNotifier<Duration>? _timelineNotifier = ValueNotifier(Duration.zero);

  void _listener() {
    _timelineNotifier!.value = _controller.value.position;
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoResource),
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.addListener(_listener);
        });
      });
    super.initState();
  }

  String _changeTimeLine(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours == '00'
        ? minutes + ':' + seconds
        : hours + ':' + minutes + ':' + seconds;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timelineNotifier?.dispose();
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? IntrinsicHeight(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Visibility(
                  replacement: SizedBox.expand(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _onTouch = true;
                        });
                        // Auto dismiss overlay after 1 second
                        _timer =
                            Timer.periodic(Duration(milliseconds: 3000), (_) {
                          setState(() {
                            logger.d('Test');
                            _onTouch = false;
                            _timer.cancel();
                          });
                        });
                      },
                    ),
                  ),
                  visible: _onTouch,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '거실',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      TextButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(CircleBorder(
                                side: BorderSide(color: Colors.white)))),
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _onTouch = !_onTouch;

                          // pause while video is playing, play while video is pausing
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });

                          // Auto dismiss overlay after 1 second
                          _timer =
                              Timer.periodic(Duration(milliseconds: 3000), (_) {
                            setState(() {
                              _onTouch = false;
                              _timer.cancel();
                            });
                          });
                        },
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: _timelineNotifier!,
                                    builder: (_, value, __) {
                                      String _timeLine = _changeTimeLine(value);
                                      return Text(
                                        '${_timeLine}',
                                        style: TextStyle(color: Colors.white),
                                      );
                                    },
                                  ),
                                  Text(
                                    '/' +
                                        _changeTimeLine(
                                            _controller.value.duration),
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.fullscreen_rounded),
                                color: Colors.white,
                              )
                            ],
                          ),
                          VideoProgressIndicator(_controller,
                              allowScrubbing: true),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
