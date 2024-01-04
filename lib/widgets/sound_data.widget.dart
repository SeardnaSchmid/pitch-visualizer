import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SoundDataStreamWidget extends StatelessWidget {
  final Stream<List<int>> soundDataStream;

  SoundDataStreamWidget({required this.soundDataStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: soundDataStream,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Awaiting sound data...');
          default:
            if (snapshot.hasData) {
              List<FlSpot> spots = snapshot.data!
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                  .toList();

              return SizedBox(
                width: 300,
                height: 160,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 2,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Text('No sound data');
            }
        }
      },
    );
  }
}
