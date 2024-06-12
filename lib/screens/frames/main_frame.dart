import 'package:aigo/screens/history_screen.dart';
import 'package:aigo/screens/main_screen.dart';
import 'package:aigo/screens/mypage_screen.dart';
import 'package:flutter/material.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int bottomIndex = 0;
  void _changeIndex(int index) {
    bottomIndex = index;
    setState(() {});
  }

  List<Widget> screens = [MainScreen(), HistoryScreen(), MypageScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: screens[bottomIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _changeIndex(value);
        },
        currentIndex: bottomIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Mypage'),
        ],
      ),
    );
  }
}
