import 'dart:convert';

import 'package:emotion_vis/enums/app_enums.dart';
import 'package:http/http.dart';

class ProjectionsRepository {
  static String urlRoot = 'http://127.0.0.1:5000/';

  static Future<Map<String, dynamic>> getMDScoords() async {
    var response = await post(urlRoot + "getMDS");
    Map<String, dynamic> coordsMap = jsonDecode(response.body);
    print(coordsMap);
    return coordsMap;
  }
}
