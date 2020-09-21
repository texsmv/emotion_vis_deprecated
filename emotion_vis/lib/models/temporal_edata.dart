import 'package:emotion_vis/models/edata.dart';
import 'package:xml/xml.dart';

class TemporalEData {
  List<EData> data;
  TemporalEData(this.data);
  TemporalEData.fromEmotionML(XmlDocument emotionML) {
    data = [];
    Iterable<XmlElement> emotions = emotionML.findAllElements("emotion");
    emotions.map((XmlElement element) {
      Map<String, double> data = {};
      element.findAllElements("category").map((XmlElement categoryElement) {
        return categoryElement;
      }).forEach((categoryElement) {
        String value = categoryElement.getAttribute("value");
        String name = categoryElement.getAttribute("name");
        data[name] = double.parse(value);
      });

      EData edata = EData(data,
          date: DateTime.fromMillisecondsSinceEpoch(
              double.parse(element.getAttribute("start")).toInt()));
      return edata;
    }).forEach((element) {
      data.add(element);
    });
    // print(data);
    // print(data[0].data["Joy"]);
    // print(data[0].date);
  }

  TemporalEData dataInRange(DateTime begin, DateTime end) {
    List<EData> newData = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i].date.isBefore(end) && data[i].date.isAfter(begin)) {
        newData.add(data[i]);
      }
    }
    return TemporalEData(newData);
  }
}
