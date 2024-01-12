import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as chart;
import 'package:mutex/mutex.dart';

class WaveformWidget extends StatefulWidget {
  final Stream<Uint8List> stream;

  // Ensure that the stream provided matches the expected Stream<Uint8List>.
  // Make sure the data being passed to the stream is valid and correctly formatted.
  const WaveformWidget({Key? key, required this.stream}) : super(key: key);

  @override
  WaveformWidgetState createState() => WaveformWidgetState();
}

class WaveformWidgetState extends State<WaveformWidget> {
  final mutex = Mutex();

  StreamSubscription<Uint8List>? _soundSubscription;
  final _spots = StreamController<List<chart.FlSpot>>.broadcast();
  double _maxValue = 1;

  @override
  void initState() {
    super.initState();
    _soundSubscription = widget.stream.listen(_micListener);
  }

  void _micListener(Uint8List samples) {
    try {
      mutex.acquire();
      final data = _calculateWaveSamples(samples);
      final spots = List<chart.FlSpot>.generate(data.length, (n) {
        final y = data[n];
        _maxValue = _maxValue > y ? _maxValue : y;
        return chart.FlSpot(n.toDouble(), y);
      });
      _maxValue = spots.map((spot) => spot.y.abs()).reduce(max);
      _spots.add(spots);
    } finally {
      mutex.release();
    }
  }

  static List<double> _calculateWaveSamples(Uint8List samples) {
    final x = List<double>.filled(samples.length ~/ 2, 0);
    for (int i = 0; i < x.length; i++) {
      int msb = samples[i * 2 + 1];
      int lsb = samples[i * 2];
      if (msb > 128) msb -= 255;
      if (lsb > 128) lsb -= 255;
      x[i] = lsb + msb * 128;
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<chart.FlSpot>>(
      stream: _spots.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || _hasInvalidValues(snapshot.data)) {
          return Container(
            child: Center(
              child: Text(
                'No valid data available',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        return chart.LineChart(
          chart.LineChartData(
            lineBarsData: [
              chart.LineChartBarData(
                spots: snapshot.data!,
                dotData: const chart.FlDotData(show: false),
              ),
            ],
            maxY: _maxValue,
            minY: -_maxValue,
          ),
        );
      },
    );
  }

  bool _hasInvalidValues(List<chart.FlSpot>? data) {
    if (data == null) {
      return true;
    }

    for (final spot in data) {
      if (spot.y.isInfinite || spot.y.isNaN) {
        return true;
      }
    }

    return false;
  }

  @override
  void dispose() {
    _soundSubscription?.cancel();
    super.dispose();
  }
}
