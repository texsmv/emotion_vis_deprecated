import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/modules/home/home_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StackTabBar extends GetView<HomeUiController> {
  const StackTabBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.only(top: 5),
      child: Stack(
        children: [
          Positioned(
            bottom: -10,
            child: Container(
              height: 50,
              width: 300,
              child: Row(
                children: [
                  TabBarItem(
                    index: 0,
                    text: "plots",
                  ),
                  TabBarItem(index: 1, text: "projection"),
                  TabBarItem(
                    index: 2,
                    text: "summary",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabBarItem extends GetView<HomeUiController> {
  final int index;
  final String text;
  const TabBarItem({
    Key key,
    this.index,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.stackIndex.value = index;
      },
      child: Obx(
        () => Container(
          width: 100,
          height: double.infinity,
          decoration: BoxDecoration(
            color: controller.stackIndex.value == index
                ? pColorBackground
                : Colors.white,
            // border: controller.stackIndex.value == index
            //     ? Border(
            //         top: BorderSide(
            //           color: Colors.grey,
            //           width: 1,
            //         ),
            //         left: BorderSide(
            //           color: Colors.grey,
            //           width: 1,
            //         ),
            //         right: BorderSide(
            //           color: Colors.grey,
            //           width: 1,
            //         ),
            //         bottom: BorderSide(
            //           color: Colors.white,
            //           width: 1,
            //         ),
            //       )
            //     : Border.all(
            //         color: Colors.transparent,
            //       ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: controller.stackIndex.value == index
                    ? Colors.grey
                    : pColorPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
