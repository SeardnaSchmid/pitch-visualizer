import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

// Events
abstract class AudioInputEvent {}

class StartRecordingEvent extends AudioInputEvent {}
class StopRecordingEvent extends AudioInputEvent {}

// States
abstract class AudioInputState {}

class RecordingState extends AudioInputState {
  final StreamController<Uint8List> soundDataStreamController;

  RecordingState(this.soundDataStreamController);
}

class IdleState extends AudioInputState {}

// Bloc
class AudioInputBloc extends Bloc<AudioInputEvent, AudioInputState> {
  // Instance of AudioRecorder to handle audio recording functionality
  late final AudioRecorder _audioRecorder;

  // Constructor to initialize the Bloc with default values and create an instance of AudioRecorder
  AudioInputBloc({
    int sampleRate = 44100,
    AudioEncoder audioEncoder = AudioEncoder.pcm16bits,
  }) : super(IdleState()) {
    _audioRecorder = AudioRecorder();

    // Register event handlers within the constructor
    on<StartRecordingEvent>((event, emit) => _mapStartRecordingToState(emit));
    on<StopRecordingEvent>((event, emit) => _mapStopRecordingToState(emit));
  }

  // Method to handle the StartRecordingEvent
  void _mapStartRecordingToState(Emitter<AudioInputState> emit) async {
    // Create a StreamController to handle the stream of audio data
    final soundDataStreamController = StreamController<Uint8List>();
    // Transition to the RecordingState and provide the StreamController
    emit(RecordingState(soundDataStreamController));

    // Configure the audio recording parameters
    var config = const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      numChannels: 1,
      sampleRate: 44100,
    );

    // Start streaming audio data and add it to the StreamController
    soundDataStreamController.addStream(await _audioRecorder.startStream(config));
  }

  // Method to handle the StopRecordingEvent
  void _mapStopRecordingToState(Emitter<AudioInputState> emit) async {
    // Stop the audio recording
    await _audioRecorder.stop();

    // Check if the current state is a RecordingState
    if (state is RecordingState) {
      // Close the stream controller associated with the RecordingState
      (state as RecordingState).soundDataStreamController.close();
      // Transition to the IdleState
      emit(IdleState());
    }
  }
}
