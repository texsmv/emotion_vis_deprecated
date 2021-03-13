import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialSettingsTab extends StatelessWidget {
  final String title;
  final int tabIndex;
  final bool canVisit;
  InitialSettingsTab({
    Key key,
    this.title = "No title",
    this.tabIndex = 0,
    this.canVisit = true,
  }) : super(key: key);

  InitialSettingsUiController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getSelectedStyle(tabIndex, canVisit),
    );
  }

  TextStyle getSelectedStyle(int index, bool canVisit) {
    if (index == controller.stackIndex.value) {
      return GoogleFonts.quicksand(
          fontSize: 15, color: pColorPrimary, fontWeight: FontWeight.w600);
    } else {
      if (canVisit)
        return GoogleFonts.quicksand(
            fontSize: 15, color: pColorAccent, fontWeight: FontWeight.w400);
      else
        return GoogleFonts.quicksand(
            fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400);
    }
  }
}
