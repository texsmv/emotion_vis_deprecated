import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/modules/home/components/temporal_view.dart';
import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/modules/person_interface/person_inteface.dart';
import 'package:emotion_vis/widgets/containers/section_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'instant_view.dart';

class SelectedPersonView extends GetView<HomeController> {
  const SelectedPersonView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeriesController>(
      builder: (_) => Visibility(
        visible: controller.queriedPersonData != null,
        child: Container(
          height: 400,
          width: double.infinity,
          child: SectionContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 72,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Categorical features:",
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            "Numerical features:",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: controller.queriedPersonData != null
                                    ? ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            SizedBox(width: 10),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.queriedPersonData
                                            .categoricalLabels.length,
                                        itemBuilder: (context, pindex) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 30),
                                            child: Row(
                                              children: [
                                                Text(
                                                  controller.queriedPersonData
                                                              .categoricalLabels[
                                                          pindex] +
                                                      ":",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  controller.queriedPersonData
                                                          .categoricalValues[
                                                      pindex],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : SizedBox(),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: controller.queriedPersonData != null
                                    ? ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            SizedBox(width: 10),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.queriedPersonData
                                            .numericalLabels.length,
                                        itemBuilder: (context, pindex) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 30),
                                            child: Row(
                                              children: [
                                                Text(
                                                  controller.queriedPersonData
                                                              .numericalLabels[
                                                          pindex] +
                                                      ":",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  controller.queriedPersonData
                                                      .numericalValues[pindex]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Get.find<SeriesController>().selectedPerson =
                                  null;
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.expand,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Get.to(
                                PersonInterface(
                                  personModel: Get.find<SeriesController>()
                                      .selectedPerson,
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      // Temporal section
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Temporal view"),
                              Expanded(
                                child: GetBuilder<SeriesController>(
                                    builder: (_) => TemporalView()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Instant section
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              Text("Instant view"),
                              Expanded(
                                child: GetBuilder<SeriesController>(
                                    builder: (_) => InstantView()),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
