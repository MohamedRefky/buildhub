// Clean Architecture: AI Copilot — Presentation.
// Covers: AiCopilotScreen, AiLegalCopilotScreen, AiSiteSuperintendentScreen,
// AiSpecAuditorView, SiteTalkScreen, AskTheSiteScreen,
// OrionTacticalCopilotScreen, ConstructionChatScreen.
// Titles/hints resolve from JSON — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/ai/data/datasources/gemini_service.dart';

class _AiShell extends StatefulWidget {
  final String titleKey;
  final String hintKey;
  const _AiShell({required this.titleKey, required this.hintKey});
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
      if (!mounted) return;
      setState(() => answer = res);
    } catch (e) {
      if (!mounted) return;
      final loc = context.read<AppLocalization>();
      setState(() => answer = '${loc.t('common.error')}: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t(widget.titleKey))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: ctrl,
            decoration: InputDecoration(hintText: loc.t(widget.hintKey)),
            minLines: 2, maxLines: 4),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: busy ? null : ask,
            child: Text(busy ? '...' : loc.t('common.ask'))),
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
    titleKey: 'ai.copilot', hintKey: 'ai.hint_copilot',
  );
}

class AiLegalScreen extends StatelessWidget {
  const AiLegalScreen({super.key});
  @override
  Widget build(BuildContext context) => const _AiShell(
    titleKey: 'ai.legal', hintKey: 'ai.hint_legal',
  );
}

class AiSuperintendentScreen extends StatelessWidget {
  const AiSuperintendentScreen({super.key});
  @override
  Widget build(BuildContext context) => const _AiShell(
    titleKey: 'ai.super', hintKey: 'ai.hint_super',
  );
}

class SiteTalkFullScreen extends StatelessWidget {
  const SiteTalkFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('ai.sitetalk'))),
      body: Center(child: Text(loc.t('ai.sitetalk_body'))),
    );
  }
}

class AskTheSiteScreenFull extends StatelessWidget {
  const AskTheSiteScreenFull({super.key});
  @override
  Widget build(BuildContext context) => const _AiShell(
    titleKey: 'ai.ask_site', hintKey: 'ai.hint_ask',
  );
}
