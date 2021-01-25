// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart';

// import 'package:emotion_vis/controllers/visualization_controller.dart';
// import 'package:emotion_vis/models/person_model.dart';
// import 'package:emotion_vis/time_series/models/MTSerie.dart';
// import 'package:get/get.dart';
// import 'package:ml_linalg/linalg.dart';

// class PersonDataPoint {
//   double x;
//   double y;
//   PersonModel personModel;
//   PersonDataPoint({this.personModel, this.x, this.y});
// }

// class DimensionReductionController extends GetxController {
//   VisualizationController visualizationController = Get.find();

//   int get t => visualizationController.personMtSerie.mtSerie.lengths[0];
//   int get k => visualizationController.personMtSerie.mtSerie.timeSeries.length;
//   int get n => visualizationController.queries.length;

//   Map<String, PersonModel> get queries => visualizationController.queries;

//   List<PersonDataPoint> personDataPoints = [];

//   // MTSerie x_i(int i) => visualizationController.queries.

//   Future<void> calculate_D() async {
//     print("N: $n          K: $k            T: $t");
//     // List<ar> d_ks = List.generate(k, (index) => Matrix.scalar(0, n));
//     var d_ks = List.generate(k, (index) => makeMatrix(n, n));

//     List<PersonModel> x = [];
//     List<String> keys = queries.keys.toList();

//     print("Lenght: ${keys.length}");

//     for (var i = 0; i < keys.length; i++) {
//       x.add(queries[keys[i]]);
//     }
//     print("here");

//     // calculate D_ks
//     for (var i = 0; i < n; i++) {
//       for (var j = 0; j < n; j++) {
//         for (var d = 0; d < k; d++) {
//           d_ks[d][i][j] = k_distance(x[i].mtSerie, x[j].mtSerie, d);
//         }
//       }
//     }

//     print("here2");

//     // calculate D
//     var d_t = makeMatrix(n, n);
//     for (var i = 0; i < n; i++) {
//       for (var j = 0; j < n; j++) {
//         double sum = 0.0;
//         for (var d = 0; d < k; d++) {
//           sum = sum + pow(d_ks[d][i][j], 2);
//         }
//         d_t[i][j] = pow(sum, 1 / 2);
//       }
//     }

//     // print(d_t);
//     // print(d_t.length);
//     // print(d_t[0].length);

//     String strMatrix = matrix2Str(d_t);
//     print(strMatrix);

//     print("-------------");
//     print((await getMDScoordinates(strMatrix))[0]);
//     var response = await getMDScoordinates(strMatrix);
//     // print(response[0]);
//     List<double> ldouble = response.cast<double>();
//     // print(ldouble);

//     // String coord_str = response[0];
//     // print(coord_str);
//     // coord_str = coord_str.substring(1, coord_str.length - 1);
//     // print("??????????");
//     // print(coord_str);

//     // List<double> ldouble = lstring.map(double.parse).toList();
//     // print("ldouble");
//     // print(ldouble);
//     // print(x.length);
//     // print(ldouble.length);
//     personDataPoints = [];
//     for (var i = 0; i < ldouble.length / 2; i++) {
//       personDataPoints.add(PersonDataPoint(
//           personModel: x[i], x: ldouble[i * 2], y: ldouble[i * 2 + 1]));
//     }
//     update();
//   }

//   String matrix2Str(List<List<double>> matrix) {
//     String result = "";
//     for (var i = 0; i < matrix.length; i++) {
//       for (var j = 0; j < matrix[0].length; j++) {
//         result = result + matrix[i][j].toString() + " ";
//       }
//       if (i != matrix.length - 1) result = result + "; ";
//     }
//     return result;
//   }

//   Future getMDScoordinates(String matrix) async {
//     var url = 'http://127.0.0.1:5000/';
//     var response = await post(url, body: {'D': matrix});
//     return jsonDecode(response.body);
//   }

//   makeMatrix(rows, cols) =>
//       List.generate(rows, (index) => List.generate(cols, (index) => 0.0));

//   double k_distance(MTSerie x_1, MTSerie x_2, int k) {
//     double sum = 0;
//     String dimension = x_1.dimensions[k];
//     for (var i = 0; i < x_1.length; i++) {
//       sum = sum + pow(x_1.at(i, dimension) - x_2.at(i, dimension), 2);
//     }
//     return sum;
//   }
// }
