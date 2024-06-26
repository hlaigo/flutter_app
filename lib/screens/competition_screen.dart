import 'dart:async';

import 'package:aigo/widgets/situation_icon.dart';
import 'package:aigo/widgets/stream_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:video_player/video_player.dart';

class CompetitionStreamScreen extends StatefulWidget {
  // String videoResource;
  CompetitionStreamScreen({
    super.key,
    // this.videoResource =
    //     "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8",
  });

  @override
  State<CompetitionStreamScreen> createState() =>
      _CompetitionStreamScreenState();
}

class _CompetitionStreamScreenState extends State<CompetitionStreamScreen> {
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
    _controller = VideoPlayerController.asset("assets/videos/tested_video.mp4",
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _controller.value.isInitialized
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
                                _timer = Timer.periodic(
                                    Duration(milliseconds: 3000), (_) {
                                  setState(() {
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
                                    shape: MaterialStatePropertyAll(
                                        CircleBorder(
                                            side: BorderSide(
                                                color: Colors.white)))),
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
                                  _timer = Timer.periodic(
                                      Duration(milliseconds: 3000), (_) {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ValueListenableBuilder(
                                            valueListenable: _timelineNotifier!,
                                            builder: (_, value, __) {
                                              String _timeLine =
                                                  _changeTimeLine(value);
                                              return Text(
                                                '${_timeLine}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            },
                                          ),
                                          Text(
                                            '/' +
                                                _changeTimeLine(
                                                    _controller.value.duration),
                                            style:
                                                TextStyle(color: Colors.white),
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
                : Container(),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.025),
              height: MediaQuery.of(context).size.height * 0.08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '실시간 영상',
                    style: TextStyle(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.bold),
                  ),
                  TimerBuilder.periodic(
                    Duration(milliseconds: 500),
                    builder: (context) {
                      return Text(DateFormat('yyyy-MM-dd HH:MM:ss')
                          .format(DateTime.now()));
                    },
                  )
                ],
              ),
            ),
            Flexible(
                child: Container(
              color: Colors.amber,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.025,
                  ),
                  child: SizedBox.expand(
                    child: Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ℹ️ 이벤트 로그',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "NotoSansKR",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // 추후 리스트 빌더로 변경
                          ListEventLog(
                            eventDateTime: DateFormat('yyyy-MM-dd HH:MM:ss')
                                .format(DateTime.now()),
                            eventType: '낙상',
                          ),
                        ],
                      ),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class ListEventLog extends StatelessWidget {
  String eventDateTime;
  String eventType;
  ListEventLog(
      {super.key, required this.eventDateTime, required this.eventType});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              eventDateTime,
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: -0.4,
                  fontFamily: "NotoSansKR",
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SituationIcon(situation: eventType),
                ),
                Text(
                  '감지',
                  style: TextStyle(
                    fontFamily: "NotoSansKR",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          visualDensity: VisualDensity(vertical: -4),
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: Icon(Icons.play_circle_outline_rounded),
        )
      ],
    );
  }
}
