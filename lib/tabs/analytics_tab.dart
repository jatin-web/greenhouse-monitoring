import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/line_chart_widget.dart';
import 'package:plant_monitor/models/soil_data_model.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  List<DataModel> soilDataList = [];
  List<DataModel> humidityDataList = [];
  List<DataModel> temperatureDataList = [];
  List<DataModel> lightDataList = [];
  int currGraph = 0;
  double? startTime = 4294967296;
  double? endTime = 0;
  late double minSoilData = 4294967296;
  late double maxSoilData = 0;
  late double minLightData = 4294967296;
  late double maxLightData = 0;
  late double minTemp = 4294967296;
  late double maxTemp = 0;
  late double minHumidity = 4294967296;
  late double maxHumidity = 0;

  @override
  void initState() {
    getSoilData();
    super.initState();
  }

  getSoilData() async {
    DatabaseReference db = FirebaseDatabase.instance.ref('ghm_data');
    DataSnapshot snapshot = await db.get();
    snapshot.children.forEach((element) {
      String humidity = element.child('humidity').value.toString();
      String temperature = element.child('temperature').value.toString();
      String soilData = element.child('soilData').value.toString();
      String lightData = element.child('lightData').value.toString();
      int time = int.parse(element.child('timestamp').value.toString());

      // -----------------------------------------------------------------------------------

      soilDataList.add(DataModel(
          val: soilData, time: DateTime.fromMillisecondsSinceEpoch(time)));
      humidityDataList.add(DataModel(
          val: humidity, time: DateTime.fromMillisecondsSinceEpoch(time)));
      temperatureDataList.add(DataModel(
          val: temperature, time: DateTime.fromMillisecondsSinceEpoch(time)));
      lightDataList.add(DataModel(
          val: lightData, time: DateTime.fromMillisecondsSinceEpoch(time)));

      minHumidity = min(minHumidity, double.tryParse(humidity) ?? 0);
      maxHumidity = max(maxHumidity, double.tryParse(humidity) ?? 0);
      minLightData = min(minLightData, double.tryParse(lightData) ?? 0);
      maxLightData = max(maxLightData, double.tryParse(lightData) ?? 0);
      minSoilData = min(minSoilData, double.tryParse(soilData) ?? 0);
      maxSoilData = max(maxSoilData, double.tryParse(soilData) ?? 0);
      minTemp = min(minTemp, double.tryParse(temperature) ?? 0);
      maxTemp = max(maxTemp, double.tryParse(temperature) ?? 0);

      startTime = min(startTime!, time.toDouble());
      endTime = max(endTime!, time.toDouble());

      setState(() {});
    });

    print("start time : $startTime");
    print("endTime : $endTime");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          DropdownButton(
              value: currGraph,
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text("Humidity"),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text("Temperature"),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("Soil Data"),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text("Light Data"),
                ),
              ],
              onChanged: (val) {
                setState(() {
                  currGraph = val!;
                });
              }),
          const SizedBox(height: 20),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(right: 15, bottom: 10),
            child: getChart(),
          )),
        ],
      ),
    );
  }

  getChart() {
    switch (currGraph) {
      case 0:
        return LineChartWidget(
          type: "humidity",
          data: humidityDataList,
          minX: startTime!,
          maxX: endTime!,
          minY: minHumidity,
          maxY: maxHumidity,
        );
      case 1:
        return LineChartWidget(
          type: "temperature",
          data: temperatureDataList,
          minX: startTime!,
          maxX: endTime!,
          minY: minTemp,
          maxY: maxTemp,
        );
      case 2:
        return LineChartWidget(
          type: "soilData",
          data: soilDataList,
          minX: startTime!,
          maxX: endTime!,
          minY: minSoilData,
          maxY: maxSoilData,
        );
      case 3:
        return LineChartWidget(
          type: "lightData",
          data: lightDataList,
          minX: startTime!,
          maxX: endTime!,
          minY: minLightData,
          maxY: maxLightData,
        );

      default:
        return LineChartWidget(
          type: "humidity",
          data: humidityDataList,
          minX: startTime!,
          maxX: endTime!,
          minY: minHumidity,
          maxY: maxHumidity,
        );
    }
  }
}
