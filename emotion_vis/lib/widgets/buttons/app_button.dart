import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;
  const AppButton(
      {Key key, @required this.text, @required this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: color ?? Get.theme.primaryColor,
      onPressed: onPressed,
      child: Text(
        text,
      ),
    );
  }
}
