import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';

class AudioInputController {
  late final AudioRecorder _audioRecorder;

  final StreamController<Uint8List> _soundDataStreamController =
      StreamController<Uint8List>();
  final StreamController<Amplitude> _amplitudeStreamController =
      StreamController<Amplitude>();

  StreamSubscription<RecordState>? _audioRecorderStateSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Stream<Uint8List> get soundDataStream => _soundDataStreamController.stream;
  Stream<Amplitude> get amplitudeStream => _amplitudeStreamController.stream;
  static const int sampleRate = 44100;
  static const AudioEncoder audioEncoder = AudioEncoder.pcm16bits;

  AudioInputController() {
    _audioRecorder = AudioRecorder();
    _audioRecorderStateSub =
        _audioRecorder.onStateChanged().listen((recordState) {});
    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 200))
        .listen((amplitude) {
      _amplitudeStreamController.add(amplitude);
    });
  }

  // Start recording
  start() async {
    const config = RecordConfig(
        encoder: audioEncoder, numChannels: 1, sampleRate: sampleRate);

    _soundDataStreamController
        .addStream(await _audioRecorder.startStream(config));
  }

  Future<void> stop() async {
    await _audioRecorder.stop();
    _soundDataStreamController.close();
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
    _audioRecorderStateSub?.cancel();
    _amplitudeSub?.cancel();
    _soundDataStreamController.close();
    _amplitudeStreamController.close();
  }
}
