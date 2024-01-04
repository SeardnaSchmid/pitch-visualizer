import 'dart:async';
import 'package:record/record.dart';

class AudioInputController {
  late final AudioRecorder _audioRecorder;

  final StreamController<List<int>> _soundDataStreamController =
      StreamController<List<int>>();
  final StreamController<Amplitude> _amplitudeStreamController =
      StreamController<Amplitude>();

  StreamSubscription<RecordState>? _audioRecorderStateSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Stream<List<int>> get soundDataStream => _soundDataStreamController.stream;
  Stream<Amplitude> get amplitudeStream => _amplitudeStreamController.stream;

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
  Future<void> start() async {
    const config =
        const RecordConfig(encoder: AudioEncoder.pcm16bits, numChannels: 1);

    _audioRecorder.startStream(config).then((stream) {
      _soundDataStreamController.addStream(stream);
    });
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
