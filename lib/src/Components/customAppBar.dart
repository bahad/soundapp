import 'package:flutter/material.dart';
import 'package:soundapp/src/Components/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? centerTitle;
  final bool? automaticallyImplyLeading;
  final Widget? leading;
  final List<Widget>? actions;
  const CustomAppBar(
      {this.title,
      this.centerTitle,
      this.automaticallyImplyLeading,
      this.leading,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          centerTitle: centerTitle,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading!,
          title: Text(
            title!,
            style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'OxygenBold',
                //fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          actions: actions),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44.0);
}
