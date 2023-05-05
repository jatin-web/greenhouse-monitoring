import 'package:flutter/material.dart';
import 'package:plant_monitor/tabs/analytics_tab.dart';
import 'package:plant_monitor/tabs/current_data_tab.dart';
import 'package:plant_monitor/tabs/upload_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currIndex = 2;

  List<Widget> pages = [
    const CurrentDataTab(),
    const AnalyticsTab(),
    const UploadDataScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green House Monitoring'),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics), label: 'Analytics'),
            BottomNavigationBarItem(
                icon: Icon(Icons.upload), label: 'Manage Data'),
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
