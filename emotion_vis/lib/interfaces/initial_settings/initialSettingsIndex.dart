import 'dart:convert';
import 'dart:io';

import 'package:emotion_vis/controllers/data_fetcher.dart';
import 'package:emotion_vis/interfaces/visualization_settings/visualizationSettingsIndex.dart';
import 'package:emotion_vis/models/temporal_edata.dart';
import 'package:emotion_vis/tests/linear_chart_test.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InitialSettingsIndex extends StatefulWidget {
  InitialSettingsIndex({Key key}) : super(key: key);

  @override
  _InitialSettingsIndexState createState() => _InitialSettingsIndexState();
}

class _InitialSettingsIndexState extends State<InitialSettingsIndex> {
  int count = 0;
  DataFetcher dataFetcher = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Inserte archivo con formato *.EmotionML"),
            FloatingActionButton.extended(
                heroTag: "select",
                onPressed: () {
                  print("--------------------------");
                  loadNewEML();
                },
                label: Text("Seleccionar"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "float",
          onPressed: () {
            if (count != 0) {
              Get.to(VisualizacionSettingsIndex());
            } else {
              Get.snackbar("Error", "Tienes que ingresar al menos un archivo");
            }
          },
          label: Text("Siguiente")),
    );
  }

  void loadNewEML() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      count++;
      File file = File(result.files.single.path);
      String xmlString = String.fromCharCodes(result.files.single.bytes);
      XmlDocument emotionsXml = XmlDocument.parse(xmlString);
      TemporalEData temporalEData = TemporalEData.fromEmotionML(emotionsXml);

      String id = count.toString();
      dataFetcher.ids.add(id);
      dataFetcher.dataset[id] = temporalEData;
      print("Loaded " + id);
      // Get.to(LinearChartTest(
      //   temporalEData: temporalEData.dataInRange(
      //       DateTime.now(), DateTime.now().add(Duration(days: 5))),
      // ));
    }
  }
}
