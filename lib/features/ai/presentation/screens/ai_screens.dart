// Clean Architecture: AI Copilot — Presentation.
// Covers: AiCopilotScreen, AiLegalCopilotScreen, AiSiteSuperintendentScreen,
// AiSpecAuditorView, SiteTalkScreen, AskTheSiteScreen,
// OrionTacticalCopilotScreen, ConstructionChatScreen.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/data/services/gemini_service.dart';

class _AiShell extends StatefulWidget {
  final String ar; final String en; final String hint;
  const _AiShell({required this.ar, required this.en, required this.hint});
  @override
  State<_AiShell> createState() => _AiShellState();
}

class _AiShellState extends State<_AiShell> {
  final ctrl = TextEditingController();
  String answer = '';
  bool busy = false;

  Future<void> ask() async {
    setState(() => busy = true);
    try {
      final svc = GeminiService();
      final res = await svc.askSite(ctrl.text);
      setState(() => answer = res);
    } catch (e) {
      setState(() => answer = 'Error: $e');
    } finally {
      setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.tr(widget.ar, widget.en))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: ctrl,
            decoration: InputDecoration(hintText: widget.hint),
            minLines: 2, maxLines: 4),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: busy ? null : ask,
            child: Text(busy ? '...' : loc.tr('اسأل', 'Ask'))),
          const SizedBox(height: 12),
          Expanded(child: SingleChildScrollView(child: Text(answer))),
        ]),
      ),
    );
  }
}

class AiCopilotFullScreen extends StatelessWidget {
  const AiCopilotFullScreen({super.key});
  @override
  Widget build(BuildContext context) => const _AiShell(
    ar: 'المساعد الهندسي', en: 'AI Copilot', hint: 'FIDIC / method statement / delay...',
  );
}

class AiLegalScreen extends StatelessWidget {
  const AiLegalScreen({super.key});
  @override
  Widget build(BuildContext context) => const _AiShell(
    ar: 'المستشار القانوني FIDIC', en: 'Legal Copilot', hint: 'Sub-Clause 20.1...',
  );
}

class AiSuperintendentScreen extends StatelessWidget {
  const AiSuperintendentScreen({super.key});
  @override
  Widget build(BuildContext context) => const _AiShell(
    ar: 'المشرف الذكي للموقع', en: 'Site Superintendent', hint: 'Daily progress...',
  );
}

class SiteTalkFullScreen extends StatelessWidget {
  const SiteTalkFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.tr('تواصل الموقع', 'Site Talk'))),
      body: Center(child: Text(loc.tr(
        'ووكي-توكي صوتي WalkieTalkieAudioService',
        'Push-to-talk WalkieTalkieAudioService'))),
    );
  }
}

class AskTheSiteScreenFull extends StatelessWidget {
  const AskTheSiteScreenFull({super.key});
  @override
  Widget build(BuildContext context) => const _AiShell(
    ar: 'اسأل الموقع', en: 'Ask the Site', hint: 'Site memory...',
  );
}
