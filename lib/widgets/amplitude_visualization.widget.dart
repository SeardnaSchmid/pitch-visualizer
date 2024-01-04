import 'package:flutter/material.dart';
import 'package:record/record.dart';

class AmplitudeVisualizer extends StatelessWidget {
  final Stream<Amplitude> amplitudeStream;

  const AmplitudeVisualizer({Key? key, required this.amplitudeStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Amplitude>(
      stream: amplitudeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Amplitude amplitude = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 40),
              Text('Current: ${amplitude.current}'),
              Text('Max: ${amplitude.max}'),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        // The stream will be null when the recorder is not recording
        return Container();
      },
    );
  }
}