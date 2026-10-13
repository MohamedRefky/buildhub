// Clean Architecture: AI — Data voice input service.
// Ports: VoiceInputManager.kt — live speech recognition (ar-AE/en) with
// automatic fallback to M4A/AAC file recording, RMS level stream for the
// equalizer UI, duration timer and base64 export. Constructor is cheap;
// platform channels open only when recording starts.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceInputManager extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();
  final AudioRecorder _recorder = AudioRecorder();

  bool isListening = false;
  bool isRecordingAudio = false;
  double soundRmsDb = 0.1;
  String liveTranscript = '';
  int recordingDurationSeconds = 0;
  String statusMessageAr = '';
  String statusMessageEn = '';

  Timer? _amplitudeTimer;
  Timer? _durationTimer;
  String? _audioPath;
  bool _speechAvailable = false;

  Future<void> startSpeechRecognition({
    String language = 'ar-AE',
    void Function(String text)? onResult,
  }) async {
    try {
      _speechAvailable = await _speech.initialize();
    } catch (_) {
      _speechAvailable = false;
    }
    if (!_speechAvailable) {
      statusMessageAr = 'التعرف الصوتي غير متاح — بدء التسجيل الصوتي';
      statusMessageEn = 'Speech recognition unavailable — recording audio';
      notifyListeners();
      await startAudioRecording();
      return;
    }
    liveTranscript = '';
    isListening = true;
    notifyListeners();
    try {
      await _speech.listen(
        listenOptions: SpeechListenOptions(
          localeId: language,
          partialResults: true,
        ),
        onResult: (r) {
          liveTranscript = r.recognizedWords;
          notifyListeners();
          if (r.finalResult) onResult?.call(r.recognizedWords);
        },
      );
    } catch (_) {
      isListening = false;
      statusMessageAr = 'تعذر بدء الاستماع';
      statusMessageEn = 'Could not start listening';
      notifyListeners();
    }
  }

  Future<void> stopSpeechRecognition() async {
    try {
      await _speech.stop();
    } catch (_) {}
    isListening = false;
    notifyListeners();
  }

  Future<File?> startAudioRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final audioDir = Directory('${dir.path}/audio_records');
        if (!audioDir.existsSync()) audioDir.createSync(recursive: true);
        _audioPath =
            '${audioDir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: _audioPath!,
        );
        isRecordingAudio = true;
        recordingDurationSeconds = 0;
        _durationTimer?.cancel();
        _durationTimer =
            Timer.periodic(const Duration(seconds: 1), (_) {
          recordingDurationSeconds++;
          notifyListeners();
        });
        _amplitudeTimer?.cancel();
        _amplitudeTimer =
            Timer.periodic(const Duration(milliseconds: 120), (_) async {
          try {
            final amp = await _recorder.getAmplitude();
            final level = (amp.current.abs() / 25000).clamp(0.1, 1.0);
            soundRmsDb = level;
            notifyListeners();
          } catch (_) {}
        });
        notifyListeners();
        return File(_audioPath!);
      }
      statusMessageAr = 'يرجى منح إذن الميكروفون';
      statusMessageEn = 'Microphone permission required';
      notifyListeners();
    } catch (_) {
      statusMessageAr = 'تعذر بدء التسجيل';
      statusMessageEn = 'Could not start recording';
      notifyListeners();
    }
    return null;
  }

  /// Stops file recording; returns (file, base64) pair.
  Future<(File?, String?)> stopAudioRecording() async {
    String? base64;
    File? file;
    try {
      final path = await _recorder.stop();
      if (path != null && _audioPath != null) {
        file = File(path);
        if (file.existsSync()) {
          base64 = base64Encode(file.readAsBytesSync());
        }
      }
    } catch (_) {}
    isRecordingAudio = false;
    soundRmsDb = 0.1;
    _amplitudeTimer?.cancel();
    _durationTimer?.cancel();
    notifyListeners();
    return (file, base64);
  }

  Future<void> stopAll() async {
    await stopSpeechRecognition();
    if (isRecordingAudio) await stopAudioRecording();
  }

  @override
  void dispose() {
    _amplitudeTimer?.cancel();
    _durationTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }
}
