import 'package:emotion_vis/controllers/data_fetcher.dart';
import 'package:emotion_vis/controllers/data_settings.dart';
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
  DataSettings dataSettings = Get.find();
  DataFetcher dataFetcher = Get.find();

  DateTime rangeBegin = DateTime.now();
  DateTime rangeEnd = DateTime.now().add(Duration(days: 7));

  String selectedId = 1.toString();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < dataFetcher.ids.length; i++) {
      String id = dataFetcher.ids[i];
      dataFetcher.queryDataset[id] =
          dataFetcher.dataset[id].dataInRange(rangeBegin, rangeEnd);
    }
    changeData();
  }

  void changeData() async {
    for (int i = 0; i < 1000; i++) {
      await Future.delayed(Duration(milliseconds: 1500));

      rangeBegin = DateTime.now().add(Duration(days: i));
      rangeEnd = DateTime.now().add(Duration(days: 7 + i));

      for (int i = 0; i < dataFetcher.ids.length; i++) {
        String id = dataFetcher.ids[i];
        dataFetcher.queryDataset[id] =
            dataFetcher.dataset[id].dataInRange(rangeBegin, rangeEnd);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              color: Colors.green.withAlpha(30),
              width: double.infinity,
              height: Get.height / 2,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: Get.width * 2 / Get.height),
                  itemCount: dataFetcher.ids.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            selectedId = dataFetcher.ids[index];
                          });
                        },
                        child: Container(
                          color: Colors.green,
                          height: 300,
                          width: 650,
                          child: IgnorePointer(
                            ignoring: true,
                            child: TemporalLinearChart(
                              emotions: dataFetcher
                                  .queryDataset[dataFetcher.ids[index]],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Row(
              children: [
                Container(
                  width: Get.width * 0.7,
                  height: Get.height * 0.4,
                  child: TemporalLinearChart(
                    emotions: dataFetcher.queryDataset[selectedId],
                  ),
                ),
                Container(
                    width: Get.width * 0.3,
                    height: Get.height * 0.4,
                    child: InstantRadar(
                      id: selectedId,
                      // emotionsLabels: dataSettings.emotionDimensions
                      //     .map((e) => e.name)
                      //     .toList(),
                      // emotionsValues: [
                      //   dataFetcher.queryDataset[selectedId].data[0].data
                      // ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
