import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';

class AudioInputController {
  late final AudioRecorder _audioRecorder;
  final int sampleRate;
  final AudioEncoder audioEncoder;
  final StreamController<Uint8List> soundDataStreamController = StreamController<Uint8List>();

  Stream<Uint8List> get soundDataStream => soundDataStreamController.stream;

  AudioInputController(this.sampleRate, {this.audioEncoder = AudioEncoder.pcm16bits}) {
    _audioRecorder = AudioRecorder();
  }

  // Start recording
  Future<void> start() async {
    var config = RecordConfig(
        encoder: audioEncoder, numChannels: 1, sampleRate: sampleRate);

    soundDataStreamController
        .addStream(await _audioRecorder.startStream(config));
  }

  Future<void> stop() async {
    await _audioRecorder.stop();
    soundDataStreamController.close();
  }

  Future<void> pause() async {
    // Pause recording
    await _audioRecorder.pause();
  }

  Future<void> resume() async {
    // Resume recording
    await _audioRecorder.resume();
  }

  void dispose() {
    soundDataStreamController.close();
  }
}
