import 'package:flutter/material.dart';

enum Sizes {
  small,
  normal,
  big,
  title,
}

class CustomText extends StatelessWidget {
  final Sizes? sizes;
  final String? text;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  const CustomText(
      {this.text, this.color, this.sizes, this.textAlign, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Text(text!,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        maxLines: 2,
        style: sizes == Sizes.normal
            ? TextStyle(
                color: color,
                fontFamily: 'OxygenRegular',
                fontWeight: fontWeight,
                fontSize: size.width < 390
                    ? 14
                    : size.width > 500
                        ? 22
                        : 16)
            : sizes == Sizes.title
                ? TextStyle(
                    color: color,
                    fontFamily: 'OxygenBold',
                    fontSize: size.width < 390
                        ? 16
                        : size.width > 500
                            ? 24
                            : 18)
                : sizes == Sizes.small
                    ? TextStyle(
                        color: color,
                        fontFamily: 'OxygenRegular',
                        fontWeight: fontWeight,
                        fontSize: size.width < 390
                            ? 12
                            : size.width > 500
                                ? 20
                                : 14)
                    : TextStyle(
                        color: color,
                        fontFamily: 'OxygenRegular',
                        fontWeight: fontWeight,
                        fontSize: size.width < 390
                            ? 16
                            : size.width > 500
                                ? 24
                                : 18));
  }
}
