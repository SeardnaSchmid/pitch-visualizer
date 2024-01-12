import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:record/record.dart';

class SoundDataStreamWidget extends StatefulWidget {
  final Stream<Uint8List> soundDataStream;
  final Stream<Amplitude> amplitudeStream;

  SoundDataStreamWidget(
      {super.key,
      required this.soundDataStream,
      required Stream<Amplitude> amplitudeStream})
      : amplitudeStream = amplitudeStream.asBroadcastStream();

  @override
  State<SoundDataStreamWidget> createState() => _SoundDataStreamWidgetState();
}

class _SoundDataStreamWidgetState extends State<SoundDataStreamWidget> {
  final double _maxAmplitudeInitial = -10000;
  double _maxAmplitude = -10000;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Amplitude>(
      stream: widget.amplitudeStream,
      builder:
          (BuildContext context, AsyncSnapshot<Amplitude> amplitudeSnapshot) {
        if (amplitudeSnapshot.hasData &&
            amplitudeSnapshot.data!.current > _maxAmplitude &&
            amplitudeSnapshot.data!.current.isFinite) {
          _maxAmplitude = amplitudeSnapshot.data!.current;
        }
        return StreamBuilder<Uint8List>(
          stream: widget.soundDataStream,
          builder:
              (BuildContext context, AsyncSnapshot<Uint8List> soundSnapshot) {
            if (soundSnapshot.hasError || amplitudeSnapshot.hasError) {
              return Text(
                  'Error: ${soundSnapshot.error ?? amplitudeSnapshot.error}');
            }
            switch (soundSnapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Awaiting sound data...');
              default:
                if (soundSnapshot.hasData && amplitudeSnapshot.hasData) {
                  List<FlSpot> spots = soundSnapshot.data!
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(),
                          (e.value / _maxAmplitude).toDouble()))
                      .toList();

                  return Column(
                    children: [
                      Text('Current: ${amplitudeSnapshot.data?.current}'),
                      Text('Max: $_maxAmplitude'),
                      SizedBox(
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
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _maxAmplitude = _maxAmplitudeInitial;
                          });
                        },
                        child: const Text('Reset Max Amplitude'),
                      ),
                    ],
                  );
                } else {
                  return const Text('No sound data');
                }
            }
          },
        );
      },
    );
  }
}
