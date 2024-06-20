import 'package:aigo/main.dart';
import 'package:aigo/screens/stream_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _gridView = true;
  final List<Map<String, String>> _camController = [
    {
      "camName": "연구실",
      "isOn": "true",
      "videoResource": "http://soompyo.com:8080/hls/test/index.m3u8"
    },
    {
      "camName": "도로",
      "isOn": "false",
      "videoResource":
          "http://210.99.70.120:1935/live/cctv003.stream/playlist.m3u8"
    },
    {"camName": "Test", "isOn": "true", "videoResource": ""},
  ];

  void _changeView(bool isGrid) {
    setState(() {
      _gridView = isGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: IconButton(
                    onPressed: () {},
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Transform.rotate(
                        angle: 30,
                        child: Icon(Icons.replay_rounded),
                      ),
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _changeView(!_gridView);
                      },
                      icon: Icon(Icons.grid_view_rounded),
                    ),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.table_rows_rounded))
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          _gridView
              ? GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _camController.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridView ? 2 : 1, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                    mainAxisSpacing: 15, //수평 Padding
                    crossAxisSpacing: 15, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, String> item = _camController[index];
                    String camName = item['camName']!;
                    bool isOn = item['isOn']! == 'true' ? true : false;
                    String videoResource = item['videoResource']!;
                    return GridButton(
                      camName: camName,
                      isOn: isOn,
                      videoResource: videoResource,
                    );
                  },
                )
              : SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: _camController.length,
                    itemBuilder: (context, index) {
                      logger.d('$index');
                      Map<String, String> item = _camController[index];
                      String camName = item['camName']!;
                      bool isOn = item['isOn']! == 'true' ? true : false;
                      String videoResource = item['videoResource']!;
                      return Card(
                        child: GridButton(
                          camName: camName,
                          isOn: isOn,
                          videoResource: videoResource,
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}

class GridButton extends StatelessWidget {
  String camName;
  bool isOn;
  String videoResource;
  GridButton({
    super.key,
    required this.camName,
    this.isOn = true,
    required this.videoResource,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StreamScreen(
            videoResource: videoResource,
          ),
        ));
      },
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.172,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/cctv.png',
                  width: 36,
                  height: 36,
                ),
                IconButton(
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity(vertical: -4),
                  onPressed: () {},
                  icon: Icon(isOn
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                )
              ],
            ),
            Text(
              camName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListButton extends StatelessWidget {
  const ListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        child: Container(
          child: Text('test'),
        ));
  }
}
