import 'package:flutter/material.dart';
import 'package:plant_monitor/constants.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({super.key});

  TextStyle titleStyle =
      const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              // ------------ About The Project ------------
              Text(
                "About the project",
                style: titleStyle,
              ),
              const SizedBox(height: 15),
              Text(
                aboutProject,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              // ------------ Our Team ------------
              // Text("Our Team", style: titleStyle),
            ],
          ),
        ),
      ),
    );
  }
}
