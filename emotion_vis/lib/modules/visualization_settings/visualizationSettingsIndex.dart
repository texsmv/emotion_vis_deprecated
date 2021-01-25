import 'package:emotion_vis/visualizations/non_temporal/radar/radar.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisualizacionSettingsIndex extends StatefulWidget {
  VisualizacionSettingsIndex({Key key}) : super(key: key);

  @override
  _VisualizacionSettingsIndexState createState() =>
      _VisualizacionSettingsIndexState();
}

class _VisualizacionSettingsIndexState
    extends State<VisualizacionSettingsIndex> {
  // DataSettings dataSettings = Get.find();

  // DataFetcher dataFetcher = Get.find();

  DateTime rangeBegin = DateTime.now();
  DateTime rangeEnd = DateTime.now().add(Duration(days: 7));

  String selectedId = 1.toString();

  @override
  void initState() {
    super.initState();

    // for (int i = 0; i < dataFetcher.persons.length; i++) {
    //   String id = dataFetcher.persons[i].id;
    //   dataFetcher.queries[id] =
    //       dataFetcher.persons[i].mtSerie.dateTimeQuery(rangeBegin, rangeEnd);
    // }
    changeData();
  }

  void changeData() async {
    // for (int i = 0; i < 100; i++) {
    //   await Future.delayed(Duration(milliseconds: 1500));

    //   rangeBegin = DateTime.now().add(Duration(days: i));
    //   rangeEnd = DateTime.now().add(Duration(days: 7 + i));
    //   // print(rangeBegin);
    //   // print(rangeEnd);

    //   for (int i = 0; i < dataFetcher.persons.length; i++) {
    //     // print(dataFetcher.persons[i].mtSerie.dateTimes);
    //     // print(dataFetcher.persons[i].mtSerie.timeSeries[0].values);
    //     // print(dataFetcher.persons[i].mtSerie.timeSeries[0].dates);
    //     String id = dataFetcher.persons[i].id;
    //     dataFetcher.queries[id] =
    //         dataFetcher.persons[i].mtSerie.dateTimeQuery(rangeBegin, rangeEnd);
    //     // print(dataFetcher.queries[id].dateTimes);
    //     // print(dataFetcher.queries[id].timeSeries["Joy"].values);
    //     // print(dataFetcher.queries[id].timeSeries["Joy"].dates);
    //   }
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body: Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   child: Column(
      //     children: [
      //       Container(
      //         color: Colors.green.withAlpha(30),
      //         width: double.infinity,
      //         height: Get.height / 2,
      //         child: GridView.builder(
      //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 2,
      //                 childAspectRatio: Get.width * 2 / Get.height),
      //             itemCount: dataFetcher.persons.length,
      //             itemBuilder: (context, index) {
      //               return Align(
      //                 alignment: Alignment.center,
      //                 child: GestureDetector(
      //                   behavior: HitTestBehavior.opaque,
      //                   onTap: () {
      //                     setState(() {
      //                       selectedId = dataFetcher.persons[index].id;
      //                     });
      //                   },
      //                   child: Container(
      //                     color: Colors.green,
      //                     height: 300,
      //                     width: 650,
      //                     child: IgnorePointer(
      //                       ignoring: true,
      //                       child: TemporalLinearChart(
      //                         mtSerie: dataFetcher
      //                             .queries[dataFetcher.persons[index].id],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               );
      //             }),
      //       ),
      //       Row(
      //         children: [
      //           Container(
      //             width: Get.width * 0.7,
      //             height: Get.height * 0.4,
      //             child: TemporalLinearChart(
      //               mtSerie: dataFetcher.queries[selectedId],
      //             ),
      //           ),
      //           Container(
      //               width: Get.width * 0.3,
      //               height: Get.height * 0.4,
      //               child: InstantRadar(

      //                   // id: selectedId,
      //                   // emotionsLabels: dataSettings.emotionDimensions
      //                   //     .map((e) => e.name)
      //                   //     .toList(),
      //                   // emotionsValues: [
      //                   //   dataFetcher.queryDataset[selectedId].data[0].data
      //                   // ],
      //                   ))
      //         ],
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
