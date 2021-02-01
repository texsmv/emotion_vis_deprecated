import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeseries_charts/visualization_nt_test.dart';
import 'package:timeseries_charts/visualization_test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VisualizationNtTest(),
    );
  }
}
