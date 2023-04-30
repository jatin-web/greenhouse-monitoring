import 'package:flutter/material.dart';
import 'package:plant_monitor/analytics_tab.dart';
import 'package:plant_monitor/upload_data.dart';

import 'current_data_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currIndex = 0;

  List<Widget> pages = [
    const CurrentDataTab(),
    const AnalyticsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green House Monitoring'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadDataScreen()));
              },
              icon: const Icon(Icons.upload))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics), label: 'Analytics'),
          ],
          currentIndex: currIndex,
          onTap: (index) {
            setState(() {
              currIndex = index;
            });
          }),
      body: pages[currIndex],
    );
  }
}
