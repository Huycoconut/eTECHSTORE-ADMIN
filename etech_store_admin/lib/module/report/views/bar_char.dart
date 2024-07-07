import 'package:etech_store_admin/module/oerder_manage/view/desktop/order_manage_screen_desktop.dart';
import 'package:etech_store_admin/module/report/controllers/order_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final orderController = Get.put(OrderController());

class BarChartSalesInMonth extends StatelessWidget {
  const BarChartSalesInMonth(
      {super.key,
      required this.day,
      required this.width,
      required this.listIncome});
  final int day;
  final double width;
  final List<int> listIncome;
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceEvenly,
        maxY: listIncome
                .reduce((value, element) => value > element ? value : element)
                .toDouble() /
            0.9,
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
        text = '1';
        break;
      case 1:
        text = '2';
        break;
      case 2:
        text = '3';
        break;
      case 3:
        text = '4';
        break;
      case 4:
        text = '5';
        break;
      case 5:
        text = '6';
        break;
      case 6:
        text = '7';
        break;
      case 7:
        text = '8';
        break;
      case 8:
        text = '9';
        break;
      case 9:
        text = '10';
        break;
      case 10:
        text = '11';
        break;
      case 11:
        text = '12';
        break;
      case 12:
        text = '13';
        break;
      case 13:
        text = '14';
        break;
      case 14:
        text = '15';
        break;
      case 15:
        text = '16';
        break;
      case 16:
        text = '17';
        break;
      case 17:
        text = '18';
        break;
      case 18:
        text = '19';
        break;
      case 19:
        text = '20';
        break;
      case 20:
        text = '21';
        break;
      case 21:
        text = '22';
        break;
      case 22:
        text = '23';
        break;
      case 23:
        text = '24';
        break;
      case 24:
        text = '25';
        break;
      case 25:
        text = '26';
        break;
      case 26:
        text = '27';
        break;
      case 27:
        text = '28';
        break;
      case 28:
        text = '29';
        break;
      case 29:
        text = '30';
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
              toY: listIncome[0].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: listIncome[1].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: listIncome[2].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: listIncome[3].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: listIncome[4].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: listIncome[5].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: listIncome[6].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
              toY: listIncome[7].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
              toY: listIncome[8].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
              toY: listIncome[9].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
              toY: listIncome[10].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
              toY: listIncome[11].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 12,
          barRods: [
            BarChartRodData(
              toY: listIncome[12].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 13,
          barRods: [
            BarChartRodData(
              toY: listIncome[13].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 14,
          barRods: [
            BarChartRodData(
              toY: listIncome[14].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 15,
          barRods: [
            BarChartRodData(
              toY: listIncome[15].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 16,
          barRods: [
            BarChartRodData(
              toY: listIncome[16].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 17,
          barRods: [
            BarChartRodData(
              toY: listIncome[17].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 18,
          barRods: [
            BarChartRodData(
              toY: listIncome[18].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 19,
          barRods: [
            BarChartRodData(
              toY: listIncome[19].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 20,
          barRods: [
            BarChartRodData(
              toY: listIncome[20].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 21,
          barRods: [
            BarChartRodData(
              toY: listIncome[21].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 22,
          barRods: [
            BarChartRodData(
              toY: listIncome[22].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 23,
          barRods: [
            BarChartRodData(
              toY: listIncome[23].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 24,
          barRods: [
            BarChartRodData(
              toY: listIncome[24].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 25,
          barRods: [
            BarChartRodData(
              toY: listIncome[25].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 26,
          barRods: [
            BarChartRodData(
              toY: listIncome[26].toDouble(),
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 27,
          barRods: [
            BarChartRodData(
              toY: listIncome.length > 28 ? listIncome[27].toDouble() : 0,
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 28,
          barRods: [
            BarChartRodData(
              toY: listIncome.length > 28 ? listIncome[28].toDouble() : 0,
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 29,
          barRods: [
            BarChartRodData(
              toY: listIncome.length > 29 ? listIncome[29].toDouble() : 0,
              gradient: _barsGradient,
              width: width / 100,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}
