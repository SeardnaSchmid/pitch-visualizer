
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pitch_visualizer/audio_input_controller.dart';
import 'dart:typed_data';
import 'package:mutex/mutex.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // late AudioInputController _audioInputController;

  @override
  void initState() {
    super.initState();
    // _audioInputController = AudioInputController();
    // _audioInputController.start();
  }

  @override
  Widget build(BuildContext context) {
    List<double> data = <double>[1,2,3,4,5,6,7,8,9];
    List<FlSpot> mySpots = data.mapIndexed((index, element) => FlSpot(index.toDouble(), element)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Visualizer'),
      ),
      body: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: mySpots,
            )
          ],
          maxY: 50,
          minY: 0
        ),
      ),
      floatingActionButton: const Icon(Icons.mic),
    );
  }

  @override
  void dispose() {
    // _audioInputController.stop();
    // _audioInputController.dispose();
    super.dispose();
  }
}
