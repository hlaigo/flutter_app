import 'package:aigo/api/restful.dart';
import 'package:aigo/main.dart';
import 'package:aigo/models/event_log.dart';
import 'package:aigo/screens/stream_screen.dart';
import 'package:aigo/widgets/situation_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<DateTime, List<dynamic>> eventDateList = {};
  List<EventLog> eventLogs = [];

  DateTime _selectedDate = DateTime.now();

  static const double calendarFontSize = 24.0;
  static String calendarFontFamily = "Pacifico";

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this._selectedDate = selectedDate;
    });
  }

  TextStyle defualtCalendarTextStyle = TextStyle(
      fontSize: calendarFontSize,
      fontFamily: calendarFontFamily,
      fontWeight: FontWeight.bold,
      color: Color(0xFF7A7A7A));

  TextStyle weekendCalendarTextStyle = TextStyle(
    fontSize: calendarFontSize,
    color: Color(0xFF5A5A5A),
    fontFamily: calendarFontFamily,
  );

  String _getWeekDay(DateTime day) {
    String dayStr = '';
    switch (day.weekday) {
      case 1:
        dayStr = '월';
        break;
      case 2:
        dayStr = '화';
        break;
      case 3:
        dayStr = '수';
        break;
      case 4:
        dayStr = '목';
        break;
      case 5:
        dayStr = '금';
        break;
      case 6:
        dayStr = '토';
        break;
      case 7:
        dayStr = '일';
        break;
    }
    return dayStr;
  }

  List<bool> checkLastWeekend(DateTime day, String stringDay) {
    bool isLastSunday = false;
    bool isLastSaturday = false;

    int lastDay = int.parse(DateFormat('dd')
        .format(DateTime(day.year, day.month + 1, 0))); // 해당달 마지막날
    int numDay = int.parse(stringDay); // 일자 숫자로 변환
    String dayStr = _getWeekDay(day); // 요일 확인

    if (dayStr == '일') {
      // 마지막 일요일일 경우
      if (numDay + 7 > lastDay || numDay > lastDay - 7) {
        isLastSunday = true;
      }
    } else if (dayStr == '토') {
      // 마지막 토요일일 경우
      if (numDay == lastDay) {
        isLastSaturday = true;
      }
    }
    return [isLastSunday, isLastSaturday];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List<dynamic> tmpLogs = await Restful.getEventLog("test1234");
      for (int i = 0; i < tmpLogs.length; i++) {
        EventLog _eventlog = EventLog.fromJson(tmpLogs[i]);
        eventLogs.add(_eventlog);
        DateTime _tmpDate = _eventlog.eventDateTime;
        DateTime _eventDate =
            DateTime(_tmpDate.year, _tmpDate.month, _tmpDate.day);
        eventDateList.addAll({
          _eventDate: [1]
        });
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F7),
      body: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TableCalendar(
                shouldFillViewport: true,
                locale: 'ko_kr',
                daysOfWeekHeight: MediaQuery.of(context).size.height * 0.08,
                eventLoader: (DateTime day) {
                  return eventDateList.containsKey(day) ? [1] : [];
                },
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    late String dayStr;
                    dayStr = _getWeekDay(day);
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft:
                              dayStr == '일' ? Radius.circular(27) : Radius.zero,
                          topRight:
                              dayStr == '토' ? Radius.circular(27) : Radius.zero,
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          '$dayStr',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    String stringDay = DateFormat('dd').format(day);
                    List<bool> results = checkLastWeekend(day, stringDay);
                    bool isLastSunday = results[0];
                    bool isLastSaturday = results[1];
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              isLastSunday ? Radius.circular(27) : Radius.zero,
                          bottomRight: isLastSaturday
                              ? Radius.circular(27)
                              : Radius.zero,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          stringDay,
                          style: TextStyle(
                            fontSize: calendarFontSize,
                            fontFamily: calendarFontFamily,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A7A7A),
                            height: 0.9,
                          ),
                        ),
                      ),
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    bool isSaturday = false;
                    String onlyDay = DateFormat('dd').format(day);
                    String dayStr = _getWeekDay(day);
                    if (dayStr == '토') {
                      isSaturday = true;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight:
                                isSaturday ? Radius.circular(27) : Radius.zero),
                      ),
                      child: Center(
                        child: Text(
                          onlyDay,
                          style: TextStyle(
                            color: Color(0xFFAEAEAE),
                            fontSize: calendarFontSize,
                            fontFamily: calendarFontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    String stringDay = DateFormat('dd').format(day);
                    bool isLastSunday = false;
                    bool isLastSaturday = false;
                    if (focusedDay.month == day.month) {
                      List<bool> results = checkLastWeekend(day, stringDay);
                      isLastSunday = results[0];
                      isLastSaturday = results[1];
                    } else {
                      String dayStr = _getWeekDay(day);
                      if (dayStr == '토') {
                        isLastSaturday = true;
                      }
                    }
                    return Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              isLastSunday ? Radius.circular(27) : Radius.zero,
                          bottomRight: isLastSaturday
                              ? Radius.circular(27)
                              : Radius.zero,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(13),
                          color: Color(0xFFFF3737),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          stringDay,
                          style: defualtCalendarTextStyle.copyWith(
                            // fontFamily: "NotoSansKR",
                            height: 1,
                            fontWeight: FontWeight.normal,
                            fontSize: calendarFontSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  headerTitleBuilder: (context, day) {
                    String titleText = DateFormat('yyyy.M').format(day);
                    return SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.left_chevron,
                              )),
                          Text(
                            titleText,
                            style: TextStyle(
                                fontSize: 32,
                                fontFamily: calendarFontFamily,
                                height: 1),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              CupertinoIcons.right_chevron,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                focusedDay: _selectedDate,
                firstDay: DateTime(1900, 1, 1),
                lastDay: DateTime(2050, 12, 31),
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                onDaySelected: onDaySelected,
                headerStyle: HeaderStyle(
                  headerPadding: EdgeInsets.zero,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  formatButtonVisible: false,
                ),
                calendarStyle: CalendarStyle(isTodayHighlighted: false),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.warning_rounded,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '감지내역',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: eventLogs.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 5,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      DateFormat("yy.MM.dd HH:mm:ss").format(
                                          eventLogs[index].eventDateTime),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "NanumGothic",
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: SituationIcon(
                                      situation: eventLogs[index].situation),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
