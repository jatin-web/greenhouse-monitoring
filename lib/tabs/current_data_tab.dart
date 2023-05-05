import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CurrentDataTab extends StatefulWidget {
  const CurrentDataTab({super.key});

  @override
  State<CurrentDataTab> createState() => _CurrentDataTabState();
}

class _CurrentDataTabState extends State<CurrentDataTab> {
  TextStyle style = const TextStyle(fontSize: 18);
  int? humidity;
  int? temperature;
  int? soilData;
  int? lightData;

  @override
  void initState() {
    super.initState();
    getData();
    getListData();
  }

  getListData() async {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('ghm_data');
    DataSnapshot data = await starCountRef.get();
    print(data.children.length);
  }

  Future<void> getData() async {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('ghm_real_time_data');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map;
      soilData = data['soilData'];
      lightData = data['lightData'];
      temperature = data['temperature'];
      humidity = data['humidity'];
      if (mounted) setState(() {});
    });
  }

  _infoBox(String key, String val, String unit,
      {bool isWaterContentLabel = false, bool isForLight = false}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 1.5, color: Colors.teal),
          color: Colors.teal.withOpacity(0.3)),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          isWaterContentLabel
              ? Text(
                  val == "1" ? "Absent" : "Present",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                )
              : isForLight
                  ? Text(
                      val == "1" ? "Present" : "Absent",
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "$val $unit",
                      style: const TextStyle(fontSize: 30),
                    ),
          const SizedBox(height: 10),
          Text(
            key,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Lottie.asset("assets/lottie/plant_growth.json"),
          )),
          Material(
            elevation: 3,
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              // decoration: const BoxDecoration(
              //     border: Border(top: BorderSide(color: Colors.black))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 5 / 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    children: [
                      _infoBox("Water Content ", soilData.toString(), "%",
                          isWaterContentLabel: true),
                      _infoBox("Light ", lightData.toString(), "lux",
                          isForLight: true),
                      _infoBox("Temperature ", temperature.toString(), "°C"),
                      _infoBox("Humidity ", humidity.toString(), "%"),
                    ],
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
