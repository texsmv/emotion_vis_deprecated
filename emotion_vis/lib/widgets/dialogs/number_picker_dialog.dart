import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class IntegerPickerDialog extends StatefulWidget {
  int currentValue;

  IntegerPickerDialog({Key key, this.currentValue}) : super(key: key);

  @override
  _IntegerPickerDialogState createState() => _IntegerPickerDialogState();
}

class _IntegerPickerDialogState extends State<IntegerPickerDialog> {
  int value;

  @override
  void initState() {
    if (widget.currentValue != null) {
      value = widget.currentValue;
    } else
      value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 150,
        child: Column(
          children: [
            NumberPicker.integer(
                initialValue: value,
                minValue: 0,
                maxValue: 100,
                onChanged: (number) {
                  setState(() {
                    value = number;
                  });
                }),
          ],
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Get.back(result: value);
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Cancel"),
        )
      ],
    );
  }
}
