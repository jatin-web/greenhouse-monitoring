import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CurrentDataTab extends StatefulWidget {
  const CurrentDataTab({super.key});

  @override
  State<CurrentDataTab> createState() => _CurrentDataTabState();
}

class _CurrentDataTabState extends State<CurrentDataTab> {
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
      setState(() {});
    });
  }

  TextStyle style = const TextStyle(fontSize: 18);

  _showInfo(String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data, style: style),
        Divider(),
      ],
    );
  }

  _infoBox(String key, String val) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.teal.withOpacity(0.5)),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            val,
            style: TextStyle(fontSize: 20),
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
          Expanded(child: Lottie.asset("assets/lottie/plant_growth.json")),
          Material(
            elevation: 3,
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 5 / 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    children: [
                      _infoBox("Soil Data ", soilData.toString()),
                      _infoBox("Light Data ", lightData.toString()),
                      _infoBox("Temperature ", temperature.toString()),
                      _infoBox("Humidity ", humidity.toString()),
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
