import 'package:aigo/widgets/stream_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class StreamScreen extends StatefulWidget {
  String videoResource;
  StreamScreen({
    super.key,
    this.videoResource =
        "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8",
  });

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            streamPlayer(
              videoResource: widget.videoResource,
            ),
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
                            'ℹ️이벤트 로그',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          // 추후 리스트 빌더로 변경
                          EventLog(
                            eventDateTime: DateFormat('yyyy-MM-dd HH:MM:ss')
                                .format(DateTime.now()),
                            eventType: '실족',
                          ),
                          EventLog(
                            eventDateTime: DateFormat('yyyy-MM-dd HH:MM:ss')
                                .format(DateTime.now().add(Duration(days: -1))),
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

class EventLog extends StatelessWidget {
  String eventDateTime;
  String eventType;
  EventLog({super.key, required this.eventDateTime, required this.eventType});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              eventDateTime,
              style: TextStyle(fontSize: 14),
            ),
            Row(
              children: [
                Text(
                  ' [$eventType]',
                  style: TextStyle(
                    color: Colors.lightBlue.shade400,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '감지',
                  style: TextStyle(fontSize: 14),
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
