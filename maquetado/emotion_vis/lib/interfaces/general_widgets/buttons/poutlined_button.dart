import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:flutter/material.dart';

class POutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const POutlinedButton({
    Key key,
    this.onPressed,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 100,
      child: OutlinedButton(
        // style: ,
        style: OutlinedButton.styleFrom(
          // primary: Colors.white,
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: pColorPrimary,
          ),
        ),
        // style: ButtonStyle(
        //   foregroundColor: MaterialStateProperty.resolveWith(getColor),
        //   // shape:
        //   backgroundColor:
        //       MaterialStateProperty.resolveWith(getColorBackground),
        // ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: pColorPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.disabled,
    };
    if (states.any(interactiveStates.contains)) {
      return pColorPrimary;
    }
    return pColorError;
  }

  Color getColorBackground(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.disabled,
    };
    if (states.any(interactiveStates.contains)) {
      return pColorPrimary;
    }
    return pColorError;
  }
}
