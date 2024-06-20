import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/aigo_logo_only.png',
                width: 60,
                height: 60,
              ),
              Text(
                'AiGO',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.bell,
                weight: 0.1,
              ))
        ],
      ),
    );
  }
}
