import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? humidity;
  int? temperature;
  int? soilData;
  int? lightData;

  @override
  void initState() {
    super.initState();
    getData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green House Monitoring'),
        actions: [
          IconButton(
              onPressed: () {
                getData();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
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
                  _showInfo("Soil Data : $soilData"),
                  _showInfo("Light Data : $lightData"),
                  _showInfo("Temperature : $temperature"),
                  _showInfo("Humidity : $humidity"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
