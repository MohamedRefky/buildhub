// Shared UI: live voice input section.
// Ports: ActiveVoiceRecordingSection.kt — status header + gain slider +
// mic button with live equalizer + quick voice samples + recognized text.
// Driven by VoiceInputManager (provider). Labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/ai/data/services/voice_input.dart';

class VoiceRecordingSection extends StatefulWidget {
  final void Function(String transcript) onTranscriptReady;
  final void Function(String base64)? onAudioBase64Ready;
  const VoiceRecordingSection({
    super.key,
    required this.onTranscriptReady,
    this.onAudioBase64Ready,
  });
  @override
  State<VoiceRecordingSection> createState() =>
      _VoiceRecordingSectionState();
}

class _VoiceRecordingSectionState extends State<VoiceRecordingSection> {
  double _gain = 1.0;
  bool _showGain = false;

  String _mmss(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:'
      '${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final voice = context.watch<VoiceInputManager>();
    final active = voice.isListening || voice.isRecordingAudio;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(children: [
            Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? Colors.red : Colors.grey)),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
                    loc.t(active
                        ? 'widgets.voice_active'
                        : 'widgets.voice_idle'))),
            if (voice.isRecordingAudio)
              Text(_mmss(voice.recordingDurationSeconds)),
            IconButton(
                icon: const Icon(Icons.tune, size: 18),
                onPressed: () =>
                    setState(() => _showGain = !_showGain)),
          ]),
          if (_showGain)
            Row(children: [
              Expanded(
                  child: Text(
                      '${loc.t('widgets.voice_gain')} ${(_gain * 100).toInt()}%')),
              Expanded(
                flex: 2,
                child: Slider(
                    value: _gain,
                    min: 0.2,
                    max: 2.0,
                    onChanged: (v) => setState(() => _gain = v)),
              ),
            ]),
          Row(children: [
            IconButton.filled(
              icon: Icon(active ? Icons.stop : Icons.mic),
              onPressed: () => _toggle(context, voice),
            ),
            const SizedBox(width: 8),
            Expanded(child: _Equalizer(level: voice.soundRmsDb)),
            const SizedBox(width: 8),
            Expanded(
                flex: 2,
                child: Text(
                    active
                        ? loc.t('widgets.voice_listening')
                        : loc.t('widgets.voice_tap'),
                    style: Theme.of(context).textTheme.labelSmall)),
          ]),
          Row(children: [
            Text('${loc.t('widgets.voice_samples')} ',
                style: Theme.of(context).textTheme.labelSmall),
            TextButton(
                onPressed: () => widget.onTranscriptReady(
                    loc.t('widgets.voice_sample1_text')),
                child: Text(loc.t('widgets.voice_sample1'))),
            TextButton(
                onPressed: () => widget.onTranscriptReady(
                    loc.t('widgets.voice_sample2_text')),
                child: Text(loc.t('widgets.voice_sample2'))),
          ]),
          if (voice.liveTranscript.isNotEmpty)
            Row(children: [
              const Icon(Icons.check_circle,
                  size: 14, color: Colors.green),
              const SizedBox(width: 4),
              Expanded(child: Text(voice.liveTranscript)),
            ]),
          if (voice.statusMessageAr.isNotEmpty ||
              voice.statusMessageEn.isNotEmpty)
            Text(loc.tr(voice.statusMessageAr, voice.statusMessageEn),
                style: Theme.of(context).textTheme.labelSmall),
        ]),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, VoiceInputManager voice) async {
    if (voice.isListening || voice.isRecordingAudio) {
      await voice.stopSpeechRecognition();
      if (voice.isRecordingAudio) {
        final (_, base64) = await voice.stopAudioRecording();
        if (base64 != null) widget.onAudioBase64Ready?.call(base64);
      }
      if (voice.liveTranscript.isNotEmpty) {
        widget.onTranscriptReady(voice.liveTranscript);
      }
    } else {
      await voice.startSpeechRecognition(
          onResult: widget.onTranscriptReady);
    }
  }
}

class _Equalizer extends StatelessWidget {
  final double level;
  const _Equalizer({required this.level});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 16; i++)
            Container(
              width: 3,
              height: 4 + 20 * ((level * (0.4 + 0.6 * ((i * 37) % 10) / 10))),
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      );
}
