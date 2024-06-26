import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SituationIcon extends StatelessWidget {
  SituationIcon({
    super.key,
    required this.situation,
  });

  final String situation;
  late Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    switch (situation) {
      case "낙상":
        backgroundColor = Color(0xFFFF3737);
        break;
      case "실족":
        backgroundColor = Color(0xFFFF823C);
        break;
      case "배회":
        backgroundColor = Color(0xFFFFBB37);
        break;
      case "침입":
        backgroundColor = Color(0xFFE30A0A);
        break;
      default:
        backgroundColor = Color(0xFFFF3737);
        break;
    }

    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      child: Text(
        situation,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "NanumGothic",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
