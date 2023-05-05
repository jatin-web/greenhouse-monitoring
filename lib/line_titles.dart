import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          axisNameWidget: Text("Time -->"),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 15,
            getTitlesWidget: (value, meta) {
              if (value == meta.appliedInterval)
                return Text(
                  value.toString(),
                  style: const TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                );

              return Text("");
            },
          ),
        ),
        topTitles: AxisTitles(),
        rightTitles: AxisTitles(),
      );
}
