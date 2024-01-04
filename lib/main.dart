import 'package:flutter/material.dart';
import 'package:pitch_visualizer/widgets/amplitude_visualization.widget.dart';
import 'package:pitch_visualizer/widgets/sound_data.widget.dart';

import 'audio_input_controller.dart';

void main() {
  runApp(MyApp());
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            SoundDataStreamWidget(
                soundDataStream: _audioInputController.soundDataStream,
                amplitudeStream: _audioInputController.amplitudeStream),
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
