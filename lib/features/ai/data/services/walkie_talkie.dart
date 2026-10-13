// Clean Architecture: AI — Data walkie-talkie PTT service.
// Ports: WalkieTalkieAudioService.kt — channel voice segments recorded as
// 3GP/M4A, stored under walkie_talkie_logs with duration + transcript.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:buildhub/features/documents/data/datasources/firestore_paths.dart';

class WalkieTalkieVoiceSegment {
  final String id;
  final String channelId;
  final String senderName;
  final String role;
  final String language;
  final String audioPath;
  final String downloadUrl;
  final int durationSeconds;
  final String transcript;
  final String timestamp;
  const WalkieTalkieVoiceSegment({
    required this.id, required this.channelId, required this.senderName,
    required this.role, required this.language, required this.audioPath,
    this.downloadUrl = '', required this.durationSeconds,
    this.transcript = '', required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id, 'channelId': channelId, 'senderName': senderName,
        'role': role, 'language': language, 'audioPath': audioPath,
        'downloadUrl': downloadUrl, 'durationSeconds': durationSeconds,
        'transcript': transcript, 'timestamp': timestamp,
      };
}

class WalkieTalkieAudioService extends ChangeNotifier {
  final AudioRecorder _recorder = AudioRecorder();
  final List<WalkieTalkieVoiceSegment> _segments = [];

  bool isRecording = false;
  String statusMessageAr = '';
  String statusMessageEn = '';
  String? _audioPath;
  int _startEpoch = 0;

  List<WalkieTalkieVoiceSegment> channelLogs(String channelId) =>
      _segments.where((s) => s.channelId == channelId).toList();

  /// Firestore collection used on push (mirrors reference).
  String get collection => FirestorePaths.walkieTalkieLog('x').split('/').first;

  Future<bool> startRecording(String channelId) async {
    try {
      if (!await _recorder.hasPermission()) {
        statusMessageAr = 'يرجى منح إذن الميكروفون';
        statusMessageEn = 'Microphone permission required';
        notifyListeners();
        return false;
      }
      final dir = await getTemporaryDirectory();
      final pttDir = Directory('${dir.path}/walkie_talkie_audio');
      if (!pttDir.existsSync()) pttDir.createSync(recursive: true);
      _audioPath =
          '${pttDir.path}/ptt_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: _audioPath!,
      );
      _startEpoch = DateTime.now().millisecondsSinceEpoch;
      isRecording = true;
      notifyListeners();
      return true;
    } catch (_) {
      statusMessageAr = 'تعذر بدء التسجيل';
      statusMessageEn = 'Could not start recording';
      notifyListeners();
      return false;
    }
  }

  Future<WalkieTalkieVoiceSegment?> stopRecordingAndShare(
    String channelId,
    String senderName,
    String role,
    String language, {
    String transcript = '',
  }) async {
    try {
      await _recorder.stop();
    } catch (_) {}
    isRecording = false;
    final duration =
        ((DateTime.now().millisecondsSinceEpoch - _startEpoch) / 1000).round();
    final segment = WalkieTalkieVoiceSegment(
      id: const Uuid().v4(), channelId: channelId, senderName: senderName,
      role: role, language: language, audioPath: _audioPath ?? '',
      durationSeconds: duration, transcript: transcript,
      timestamp: DateTime.now().toIso8601String(),
    );
    _segments.add(segment);
    notifyListeners();
    // TODO: push segment.toJson() to FirestorePaths.walkieTalkieLog(id)
    // and upload the audio file to Storage.
    return segment;
  }

  Future<List<WalkieTalkieVoiceSegment>> fetchChannelVoiceLogs(
      String channelId) async {
    // TODO: query walkie_talkie_logs where channelId == channelId.
    return channelLogs(channelId);
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}
