import 'package:flutter/material.dart';
import 'package:pitch_visualizer/widgets/waveform.widget.dart';

import 'audio_input_controller.dart';

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
  late AudioInputController _audioInputController;

  @override
  void initState() {
    super.initState();
    _audioInputController = AudioInputController();
    _audioInputController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Visualizer'),
      ),
      body: Center(
        child: Column(
          children: [
            // AmplitudeVisualizer(
            //     amplitudeStream: _audioInputController.amplitudeStream),
            WaveformWidget(stream: _audioInputController.soundDataStream),
            // SoundDataStreamWidget(
            //     soundDataStream: _audioInputController.soundDataStream,
            //     amplitudeStream: _audioInputController.amplitudeStream),
          ],
        ),
      ),
      floatingActionButton: const Icon(Icons.mic),
    );
  }

  @override
  void dispose() {
    _audioInputController.stop();
    _audioInputController.dispose();
    super.dispose();
  }
}
