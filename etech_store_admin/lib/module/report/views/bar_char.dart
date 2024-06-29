import 'package:etech_store_admin/module/oerder_manage/view/desktop/order_manage_screen_desktop.dart';
import 'package:etech_store_admin/module/report/controllers/order_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final orderController = Get.put(OrderController());

class BarChartSalesInMonth extends StatelessWidget {
  const BarChartSalesInMonth(
      {required this.weak1,
      required this.weak2,
      required this.weak3,
      required this.weak4,
      required this.extant,
      required this.width});
  final double weak1;
  final double weak2;
  final double weak3;
  final double weak4;
  final double extant;
  final double width;

  @override
  Widget build(BuildContext context) {
    double max() {
      double max = weak1;
      if (weak2 > max) {
        max = weak2;
      }
      if (weak3 > max) {
        max = weak3;
      }
      if (weak4 > max) {
        max = weak4;
      }
      if (extant > max) {
        max = extant;
      }
      return max;
    }

    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: max() * 1.25,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              priceFormat(rod.toY.round()),
              const TextStyle(
                color: Color(0xFF383CA0),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFF383CA0),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '1 - 7';
        break;
      case 1:
        text = '8 - 14';
        break;
      case 2:
        text = '15 - 21';
        break;
      case 3:
        text = '22 - 28';
        break;
      case 4:
        text = '29 ->';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Color.fromARGB(255, 4, 6, 73),
          Color.fromARGB(255, 112, 115, 196),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: weak1,
              gradient: _barsGradient,
              width: width / 50,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: weak2,
              gradient: _barsGradient,
              width: width / 50,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: weak3,
              gradient: _barsGradient,
              width: width / 50,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: weak4,
              gradient: _barsGradient,
              width: width / 50,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: extant,
              gradient: _barsGradient,
              width: width / 50,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}
