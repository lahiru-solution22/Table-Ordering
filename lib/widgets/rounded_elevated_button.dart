import 'package:flutter/material.dart';

import '../config.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton({
    Key? key,
    this.title,
    this.onPressed,
    this.padding,
    this.buttonColor,
  }) : super(key: key);

  final String? title;
  final Color? buttonColor;
  final onPressed, padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title!,
          //maxLines: 1,
        ),
        style: ElevatedButton.styleFrom(
            //padding: padding,
            primary: buttonColor ?? kPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))));
  }
}
