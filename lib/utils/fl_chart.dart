import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/utils/styles.dart';

class FLChart extends StatelessWidget {
  final List<FlSpot> spots;

  final List<Hourly> timeList;

  final double y;

  FLChart(
      {Key? key, required this.spots, required this.y, required this.timeList})
      : super(key: key);

  @override
  Widget build(BuildContext context) => LineChart(LineChartData(
          minY: y - 20,
          maxY: y + 20,
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes
                .map((e) => TouchedSpotIndicatorData(
                    FlLine(color: Colors.black12, strokeWidth: 4),
                    FlDotData(
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                              color: Styles.whiteColor,
                              strokeColor: Styles.whiteColor,
                              strokeWidth: 6),
                    )))
                .toList(),
            touchTooltipData: LineTouchTooltipData(
              tooltipMargin: 25.0,
              tooltipBgColor: Colors.black45,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  return LineTooltipItem("${barSpot.y.toInt()} \u2103",Styles().hourlyForecastText);
                }).toList();
              },
            ),
          ),
          titlesData: getTitleData(),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              colors: [Colors.white],
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.white].map((e) => e.withOpacity(0.2)).toList(),
              ),
            )
          ]));
  getTitleData() => FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => Styles().hourlyForecastText,
          getTitles: (value) {
            for (int i = 0; i < 24; i++) {
              if (value == i)
                return DateFormat.Hm().format(
                    DateTime.fromMillisecondsSinceEpoch(
                        timeList[i].time * 1000));
              i++;
            }
            return "";
          },
        ),
        topTitles: SideTitles(),
        rightTitles: SideTitles(),
        leftTitles: SideTitles(),
      );
}
