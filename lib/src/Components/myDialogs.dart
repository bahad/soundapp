import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundapp/src/Components/customText.dart';
import 'package:soundapp/src/Providers/favProvider.dart';

class MyDialog {
  static confirmDilaog(context, size, FavProvider favProvider, id) {
    CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
      title: Text('Delete Content !'),
      content: Column(
        children: [
          Image.asset(
            'assets/images/warning.png',
            height: size.height * 0.061,
          ),
          const SizedBox(height: 15),
          CustomText(
            sizes: Sizes.normal,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
            text:
                'Are you sure you want to remove the selected item from the favorite list ?',
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CupertinoButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text('Submit'),
              onPressed: () {
                favProvider.deleteFav(id);
                favProvider.getFav();
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      ],
    );
    showModal(
        configuration: FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 600)),
        context: context,
        builder: (BuildContext context) {
          return Transform.scale(
              scale: size.width < 500 ? 1.0 : 1.5,
              child: Theme(
                data: ThemeData.from(
                    colorScheme: ColorScheme.fromSwatch(
                  brightness: Brightness.dark,
                  primarySwatch: Colors.pink,
                )),
                child: cupertinoAlertDialog,
              ));
        });
  }
}
