import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;
  const SectionContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color.fromARGB(255, 235, 235, 235),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: child);
  }
}
