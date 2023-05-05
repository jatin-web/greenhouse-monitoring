import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/line_titles.dart';
import 'package:plant_monitor/models/soil_data_model.dart';

class LineChartWidget extends StatelessWidget {
  LineChartWidget(
      {Key? key,
      required this.type,
      required this.minX,
      required this.maxX,
      required this.maxY,
      required this.minY,
      required this.data})
      : super(key: key);

  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final String type;
  final List<DataModel> data;
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                minX: minX - 200,
                maxX: maxX + 200,
                minY: minY - 5,
                maxY: maxY + 5,
                titlesData: LineTitles.getTitleData(),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 0.5,
                    );
                  },
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.map((e) {
                      double y = double.tryParse(e.val) ?? 5;
                      double x = double.tryParse(
                              e.time.millisecondsSinceEpoch.toString()) ??
                          0;
                      print(
                          "x: $x, y: $y, time: ${DateTime.fromMillisecondsSinceEpoch(x.toInt())}");

                      return FlSpot(x, y);
                    }).toList(),

                    isCurved: true,
                    // colors: gradientColors,
                    color: Colors.teal,
                    barWidth: 3,
                    belowBarData:
                        BarAreaData(color: Colors.teal.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
