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
          Text(
            "min : $minY, max : $maxY",
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: minX - 100,
                maxX: maxX + 100,
                minY: minY - 5,
                maxY: maxY + 5,
                titlesData: LineTitles.getTitleData(),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 1,
                    );
                  },
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: const Color(0xff37434d),
                      strokeWidth: 1,
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
                    // spots: [
                    //   FlSpot(0, 3),
                    //   FlSpot(2.6, 2),
                    //   FlSpot(4.9, 5),
                    //   FlSpot(6.8, 3.1),
                    //   FlSpot(8, 4),
                    //   FlSpot(9.5, 3),
                    //   FlSpot(11, 4),
                    // ],
                    isCurved: true,
                    // colors: gradientColors,
                    color: Colors.yellow,
                    barWidth: 3,
                    // dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                        show: true,
                        // colors: gradientColors
                        //     .map((color) => color.withOpacity(0.3))
                        //     .toList(),
                        color: Colors.yellow.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
