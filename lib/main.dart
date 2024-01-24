import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pitch_visualizer/audio_input_controller.dart';
import 'package:pitch_visualizer/bloc/audioInput.bloc.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AudioInputBloc>(
          create: (_) => AudioInputBloc(sampleRate: 44100),
        ),
      ],
      child: const MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  late AudioInputBloc _audioInputBloc;

  @override
  void initState() {
    super.initState();
    _audioInputBloc = context.read<AudioInputBloc>();
    _audioInputBloc.add(StartRecordingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Visualizer'),
      ),
      body: BlocBuilder<AudioInputBloc, AudioInputState>(
        builder: (context, audioState) {
          List<FlSpot> mySpots = [];

          if (audioState is RecordingState) {
            // Process and convert audio data to FLSpots
            // For now, let's use a placeholder
            mySpots = _processAudioData(audioState.soundDataStreamController.stream);
          }

          return LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: mySpots,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: const Icon(Icons.mic),
    );
  }
List<FlSpot> _processAudioData(Stream<Uint8List> audioDataStream) {
  // Define the maximum possible byte value (assuming 8-bit audio)
  const double maxByteValue = 255.0;

  // List to store the processed FLSpots
  List<FlSpot> processedSpots = [];

  // Counter to track the index for x-coordinate
  int index = 0;

  audioDataStream.listen((Uint8List audioData) {
    // Process each byte in the audio data
    for (int byteValue in audioData) {
      // Normalize the byte value to a range of [0, 1]
      double normalizedValue = byteValue / maxByteValue;

      // Create a FlSpot with the current index as x and normalized value as y
      FlSpot spot = FlSpot(index.toDouble(), normalizedValue);

      // Add the FlSpot to the list
      processedSpots.add(spot);

      // Increment the index for the next x-coordinate
      index++;
    }
  });

  return processedSpots;
}

  @override
  void dispose() {
    _audioInputBloc.add(StopRecordingEvent());
    super.dispose();
  }
}