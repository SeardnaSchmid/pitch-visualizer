import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'recorder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? audioPath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Recorder(
            onStop: (path) {
              if (kDebugMode) print('Recorded file path: $path');
              setState(() {
                audioPath = path;
              });
            },
          ),
        ),
      ),
    );
  }
}