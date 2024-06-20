import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  DateTime refreshDate = DateTime(2024, 6, 18);
  DateTime nextPaymentDate = DateTime(2024, 7, 17);

  List<Map<String, String>> noticeList = [
    {'title': 'AIGO 서비스 점검 안내', 'isFixed': 'true'},
    {'title': '개인 정보 수집 관련 안내', 'isFixed': 'false'},
    {'title': '서비스 이용 약관 개정 안내', 'isFixed': 'false'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 프로필
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/default_profile_img.png',
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                // ShaderMask(
                //   shaderCallback: (bounds) => LinearGradient(
                //           begin: Alignment.topCenter,
                //           end: Alignment.bottomCenter,
                //           colors: <Color>[Colors.black, Colors.purple],
                //           transform: GradientRotation(pi / 2))
                //       .createShader(bounds),
                //   child: Text(
                //     'OOO님',
                //     style: TextStyle(
                //       fontSize: 40,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                Text(
                  'OOO님',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        Offset.zero,
                        Offset(30, 50),
                        <Color>[Colors.black, Colors.pink],
                      ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Divider(
                    thickness: 3,
                  ),
                ),
                Text(
                    '서비스 갱신일: ${DateFormat('yyyy.MM.dd').format(refreshDate)}'),
                Text(
                    '다음 결제 예정일: ${DateFormat('yyyy.MM.dd').format(nextPaymentDate)}'),
              ],
            ),
          ),
          // 공지사항
          Container(
            decoration: BoxDecoration(
              color: Color(0x00D9D9D9),
              border: Border.all(
                color: Color(0xFFDEDEDE),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFAFAF),
                        borderRadius: BorderRadius.circular(21)),
                    child: Text(
                      '공지사항',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      String title = noticeList[index]['title']!;
                      bool isFixed = noticeList[index]['isFixed']! == 'true'
                          ? true
                          : false;
                      return Column(
                        children: [
                          Row(
                            children: [
                              isFixed
                                  ? Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFE6E6E6),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        '공지',
                                        style: TextStyle(),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text('$title'),
                              )
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          //계정 관리
          Container(
            decoration: BoxDecoration(
              color: Color(0x00D9D9D9),
              border: Border.all(
                color: Color(0xFFDEDEDE),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(21)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Image.asset(
                          'assets/images/account_setting_icon.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Text(
                        '계정 관리',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('개인 정보 변경'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('구독 취소하기  '),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
