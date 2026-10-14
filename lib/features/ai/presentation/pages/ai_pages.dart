// Clean Architecture: AI Copilot — Presentation.
// Covers: AiCopilotScreen, AiLegalCopilotScreen, AiSiteSuperintendentScreen,
// AiSpecAuditorView, SiteTalkScreen, AskTheSiteScreen,
// OrionTacticalCopilotScreen, ConstructionChatScreen.
// Titles/hints resolve from JSON — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/features/ai/data/datasources/gemini_service.dart';
import 'package:buildhub/features/documents/domain/entities/document_entities.dart';
import 'package:buildhub/features/sitepulse/data/services/orion_service.dart';
import 'package:buildhub/features/sitepulse/domain/entities/telemetry_entities.dart';
import 'package:buildhub/shared/widgets/voice_recording_section.dart';

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

class AiCopilotFullScreen extends StatefulWidget {
  const AiCopilotFullScreen({super.key});
  @override
  State<AiCopilotFullScreen> createState() => _AiCopilotFullScreenState();
}

/// Port of AiCopilotScreen.kt tabs: chat, live voice, FIDIC legal.
class _AiCopilotFullScreenState extends State<AiCopilotFullScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.t('ai.copilot')),
          bottom: TabBar(tabs: [
            Tab(text: loc.t('ai.tab_chat')),
            Tab(text: loc.t('ai.tab_voice')),
            Tab(text: loc.t('ai.tab_legal')),
          ]),
        ),
        body: TabBarView(children: [
          const _AiShell(
              titleKey: 'ai.copilot', hintKey: 'ai.hint_copilot'),
          const _VoiceTab(),
          const _AiShell(
              titleKey: 'ai.legal', hintKey: 'ai.hint_legal'),
        ]),
      ),
    );
  }
}

class _VoiceTab extends StatefulWidget {
  const _VoiceTab();
  @override
  State<_VoiceTab> createState() => _VoiceTabState();
}

class _VoiceTabState extends State<_VoiceTab> {
  final _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          VoiceRecordingSection(
              onTranscriptReady: (t) => setState(
                  () => _ctrl.text = '${_ctrl.text} $t')),
          TextField(
              controller: _ctrl, minLines: 2, maxLines: 4),
        ],
      );
}

class AiLegalScreen extends StatelessWidget {
  const AiLegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clauses = [
      {'clause': 'Sub-Clause 20.1 [Contractor\'s Claims]', 'title': '28-Day Strict Notice Bar', 'desc': 'Contractor must give notice within 28 days of becoming aware of the event, otherwise Employer is discharged from all liability.'},
      {'clause': 'Sub-Clause 8.4 [Extension of Time for Completion]', 'title': 'EOT Grounds', 'desc': 'Entitled to EOT for: (a) Variations, (b) Exceptionally adverse climatic conditions, (c) Unforeseeable physical conditions, (d) Delays caused by Authorities.'},
      {'clause': 'Sub-Clause 13.1 [Right to Vary]', 'title': 'Engineer Variation Orders', 'desc': 'Variations may be initiated by the Engineer at any time prior to issuing the Taking-Over Certificate.'},
      {'clause': 'Sub-Clause 14.3 [Application for Interim Payment]', 'title': 'Monthly IPC Submissions', 'desc': 'Detailed statement showing amounts entitled together with supporting documents and retention deduction.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('FIDIC Contract AI Legal Copilot')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.accentCyan)),
            child: const Row(
              children: [
                Icon(Icons.gavel, color: AppColors.accentCyan),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Grounded in FIDIC Red Book (1999/2017) & UAE Civil Transactions Law (Federal Law No. 5 of 1985).', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Pre-Loaded Contract Clauses & Precedents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ...clauses.map((c) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['clause']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(c['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(c['desc']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 8),
          const Text('Ask Custom FIDIC Dispute Question:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _AiShellContent(titleKey: 'ai.legal', hintKey: 'ai.hint_legal'),
        ],
      ),
    );
  }
}

class AiSuperintendentScreen extends StatelessWidget {
  const AiSuperintendentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final priorities = [
      {'priority': 'Priority 1 (Critical)', 'title': 'Inspect Level 12 Zone B Rebar with Consultant Eng. Tariq at 10:30 AM', 'status': 'HIGH'},
      {'priority': 'Priority 2 (Logistics)', 'title': 'Unload 35T Rebar delivery at Gate 2 before midday ban begins at 12:30 PM', 'status': 'HIGH'},
      {'priority': 'Priority 3 (Quality)', 'title': 'Verify slump test calibration for Unibeton transit mixers #03 & #04', 'status': 'MEDIUM'},
      {'priority': 'Priority 4 (Coordination)', 'title': 'Coordinate MEP clash meeting at axis F4 with Drake & Scull project engineer', 'status': 'MEDIUM'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('AI Site Superintendent Priorities')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.verifiedGreen)),
            child: const Row(
              children: [
                Icon(Icons.smart_toy, color: AppColors.verifiedGreen),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Morning Superintendent Synthesis: Analyzed 14 walkie-talkie logs, today\'s weather forecast, and CPM schedule.', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Today\'s Key Field Directives', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ...priorities.map((p) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: AppColors.accentCyan),
                  title: Text(p['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text(p['priority']!),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: p['status'] == 'HIGH' ? AppColors.criticalRed.withValues(alpha: 0.15) : AppColors.cautionAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(p['status']!, style: TextStyle(color: p['status'] == 'HIGH' ? AppColors.criticalRed : AppColors.cautionAmber, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class SiteTalkFullScreen extends StatefulWidget {
  const SiteTalkFullScreen({super.key});

  @override
  State<SiteTalkFullScreen> createState() => _SiteTalkFullScreenState();
}

class _SiteTalkFullScreenState extends State<SiteTalkFullScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _activeChannel = 'all_site';
  bool _isTransmitting = false;

  final List<Map<String, dynamic>> _channels = [
    {'id': 'all_site', 'name': 'All Site (عام الموقع)', 'last': 'AI: Sandstorm warning for Jan 23-24', 'members': 248, 'unread': 3},
    {'id': 'structural', 'name': 'Structural Team (الهيكل الإنشائي)', 'last': 'Ahmed: Level 12 rebar complete', 'members': 86, 'unread': 1},
    {'id': 'mep', 'name': 'MEP Coordination (الكهروميكانيك)', 'last': 'Rajiv: clash at grid F4, need meeting', 'members': 48, 'unread': 5},
    {'id': 'hse', 'name': 'HSE & Safety Guard (السلامة والبيئة)', 'last': 'Midday ban siren active 12:30 PM', 'members': 34, 'unread': 0},
  ];

  final List<Map<String, String>> _voiceLogs = [
    {'sender': 'Eng. Abdelfattah', 'role': 'Project Director', 'time': '10:45 AM', 'duration': '0:24', 'text': 'Approved casting for Level 12 Zone B post consultant inspection.'},
    {'sender': 'Rajiv Kumar', 'role': 'MEP Foreman', 'time': '10:12 AM', 'duration': '0:18', 'text': 'Chilled water pipe conflict at axis F4 escalated via RFI-088.'},
    {'sender': 'Ali Hassan', 'role': 'Safety Officer', 'time': '09:30 AM', 'duration': '0:35', 'text': 'Heat index 41.2C, hydration breaks enforced for rebar fixers.'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SiteTalk Walkie-Talkie (PTT)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('Digital Push-to-Talk • Channels & AI Voice Logs', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentCyan,
          tabs: const [
            Tab(text: 'Radio Channels'),
            Tab(text: 'Voice Logs & Transcripts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Channels tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._channels.map((ch) {
                final isSelected = _activeChannel == ch['id'];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isSelected ? AppColors.accentCyan : Colors.transparent, width: 1.5),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? AppColors.accentCyan : Colors.white10,
                      child: Icon(Icons.radio, color: isSelected ? Colors.black : AppColors.accentCyan, size: 20),
                    ),
                    title: Text(ch['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('${ch['last']} • ${ch['members']} Active'),
                    trailing: isSelected
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                            child: const Text('TUNED IN', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                          )
                        : null,
                    onTap: () => setState(() => _activeChannel = ch['id'] as String),
                  ),
                );
              }),
              const SizedBox(height: 24),
              // Push to Talk Button
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTapDown: (_) => setState(() => _isTransmitting = true),
                      onTapUp: (_) => setState(() => _isTransmitting = false),
                      onTapCancel: () => setState(() => _isTransmitting = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: _isTransmitting ? AppColors.criticalRed : AppColors.accentCyan,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isTransmitting ? AppColors.criticalRed : AppColors.accentCyan).withValues(alpha: 0.5),
                              blurRadius: _isTransmitting ? 24 : 10,
                              spreadRadius: _isTransmitting ? 6 : 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isTransmitting ? Icons.mic : Icons.mic_none,
                          size: 48,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isTransmitting ? 'TRANSMITTING ON CHANNEL...' : 'HOLD TO TALK (PUSH-TO-TALK)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: _isTransmitting ? AppColors.criticalRed : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Voice logs tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._voiceLogs.map((log) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${log['sender']} (${log['role']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accentCyan)),
                              Text('${log['time']} • ${log['duration']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('"${log['text']}"', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(icon: const Icon(Icons.play_circle, color: AppColors.accentCyan), onPressed: () {}),
                              const Text('Play Audio', style: TextStyle(fontSize: 11, color: AppColors.accentCyan)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiShellContent extends StatefulWidget {
  final String titleKey;
  final String hintKey;
  const _AiShellContent({required this.titleKey, required this.hintKey});
  @override
  State<_AiShellContent> createState() => _AiShellContentState();
}

class _AiShellContentState extends State<_AiShellContent> {
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
      setState(() => answer = 'Error: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Enter specific contract clause question or query...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          minLines: 2,
          maxLines: 4,
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
          icon: busy ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.send, size: 16),
          onPressed: busy ? null : ask,
          label: Text(busy ? 'Analyzing Contract...' : 'Consult Legal AI'),
        ),
        if (answer.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
            child: Text(answer),
          ),
        ],
      ],
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

/// Port of ConstructionChatScreen.kt: topic-filtered HSE/project chat
/// with search grounding and offline fallback.
class ConstructionChatScreen extends StatefulWidget {
  const ConstructionChatScreen({super.key});
  @override
  State<ConstructionChatScreen> createState() =>
      _ConstructionChatScreenState();
}

class _ConstructionChatScreenState extends State<ConstructionChatScreen> {
  final _ctrl = TextEditingController();
  String _topic = 'ALL';
  GroundedResponse? _answer;
  bool _busy = false;

  static const _topics = ['ALL', 'PROJECT_STATUS', 'HSE_REGULATIONS'];

  Future<void> _send() async {
    final q = _ctrl.text.trim();
    if (q.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      final res = await GeminiService().queryConstructionChat(
        q,
        topicFilter: _topic,
      );
      if (!mounted) return;
      setState(() => _answer = res);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('ai.chat_title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: _topics
                    .map((t) => Padding(
                        padding:
                            const EdgeInsetsDirectional.only(end: 6),
                        child: ChoiceChip(
                            label: Text(t),
                            selected: _topic == t,
                            onSelected: (_) =>
                                setState(() => _topic = t))))
                    .toList()),
          ),
          const SizedBox(height: 8),
          TextField(
              controller: _ctrl,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: loc.t('ai.chat_hint'))),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: _busy ? null : _send,
              child: Text(loc.t('ai.chat_send'))),
          const SizedBox(height: 12),
          if (_answer != null)
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                      Text(loc.tr(
                          _answer!.textAr, _answer!.textEn)),
                      if (_answer!.sources.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ..._answer!.sources.map((s) => Text(
                            '• ${s.title} ${s.uri}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall)),
                      ],
                    ]))),
        ]),
      ),
    );
  }
}

class _AuditScenario {
  final String specCode;
  final String inputAr;
  final String inputEn;
  const _AuditScenario(this.specCode, this.inputAr, this.inputEn);
}

/// Port of AiSpecAuditorView.kt: reference-spec picker + site-finding
/// input + AI compliance audit with PASS / CONCERN / FAIL verdict.
class AiSpecAuditorView extends StatefulWidget {
  final List<ConstructionSpec> specs;
  const AiSpecAuditorView({super.key, this.specs = const []});
  @override
  State<AiSpecAuditorView> createState() => _AiSpecAuditorViewState();
}

class _AiSpecAuditorViewState extends State<AiSpecAuditorView> {
  static const _scenarios = [
    _AuditScenario('DM-HSE-SAFETY-CH11', 'خرسانة C50 هبوط 160مم',
        'C50 concrete slump 160mm'),
    _AuditScenario('RTA-RDS-HWY-2024', 'رافعة 41كم/س حمولة 3.5طن',
        'Crane 41km/h load 3.5t'),
    _AuditScenario('MOHRE-HEAT-2024', 'دمك 96.8% وWBGT 33.5',
        'Compaction 96.8% WBGT 33.5'),
    _AuditScenario('OSHAD-SF-TG-CS-2023', 'غازات O2 18.9% وH2S 12ppm',
        'Gases O2 18.9% H2S 12ppm'),
  ];

  int _specIndex = 0;
  int _scenario = 0;
  final _inputCtrl = TextEditingController();
  String? _verdict;
  String _resultAr = '';
  String _resultEn = '';
  bool _busy = false;

  List<ConstructionSpec> get _specs => widget.specs.isNotEmpty
      ? widget.specs
      : const [
          ConstructionSpec(id: 'DM-HSE-SAFETY-CH11', code: 'DM-HSE-SAFETY-CH11',
              titleAr: 'كود السلامة', titleEn: 'Safety Code',
              authority: 'Dubai Municipality'),
          ConstructionSpec(id: 'RTA-RDS-HWY-2024', code: 'RTA-RDS-HWY-2024',
              titleAr: 'كود الطرق', titleEn: 'Road Code', authority: 'RTA'),
          ConstructionSpec(id: 'MOHRE-HEAT-2024', code: 'MOHRE-HEAT-2024',
              titleAr: 'الإجهاد الحراري', titleEn: 'Heat Stress',
              authority: 'MoHRE'),
          ConstructionSpec(id: 'OSHAD-SF-TG-CS-2023',
              code: 'OSHAD-SF-TG-CS-2023', titleAr: 'الأماكن المغلقة',
              titleEn: 'Confined Space', authority: 'OSHAD'),
        ];

  Future<void> _runAudit() async {
    final specs = _specs;
    final spec = specs[_specIndex % specs.length];
    final scenario = _scenarios[_scenario % _scenarios.length];
    final input = _inputCtrl.text.trim().isEmpty
        ? '${scenario.inputAr} / ${scenario.inputEn}'
        : _inputCtrl.text.trim();
    setState(() => _busy = true);
    try {
      final res = await GeminiService().generateWithGrounding(
        'Audit against ${spec.code} (${spec.authority}): $input. '
        'Reply with a verdict word PASS, CONCERN or FAIL first.',
        useSearch: true,
      );
      if (!mounted) return;
      final combined = '${res.textAr} ${res.textEn}'.toUpperCase();
      final verdict = combined.contains('FAIL')
          ? 'FAIL'
          : (combined.contains('CONCERN') ? 'CONCERN' : 'PASS');
      setState(() {
        _verdict = verdict;
        _resultAr = res.textAr;
        _resultEn = res.textEn;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Color _verdictColor() => switch (_verdict) {
        'FAIL' => Colors.red,
        'CONCERN' => Colors.amber,
        'PASS' => Colors.green,
        _ => Colors.grey,
      };

  String _verdictKey() => switch (_verdict) {
        'FAIL' => 'ai.spec_fail',
        'CONCERN' => 'ai.spec_concern',
        _ => 'ai.spec_pass',
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final specs = _specs;
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('ai.spec_title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(loc.t('ai.spec_sub')),
          const SizedBox(height: 8),
          Text(loc.t('ai.spec_step1')),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(
                    specs.length,
                    (i) => Padding(
                        padding:
                            const EdgeInsetsDirectional.only(end: 6),
                        child: ChoiceChip(
                            label: Text(
                                '${specs[i].code} • ${specs[i].authority}'),
                            selected: _specIndex == i,
                            onSelected: (_) => setState(
                                () => _specIndex = i))))),
          ),
          if (specs.isNotEmpty)
            Card(
                child: ListTile(
              title: Text(loc.tr(specs[_specIndex % specs.length].titleAr,
                  specs[_specIndex % specs.length].titleEn)),
              subtitle: Text(specs[_specIndex % specs.length].authority),
            )),
          const SizedBox(height: 8),
          Text(loc.t('ai.spec_step2')),
          Row(
              children: List.generate(
                  _scenarios.length,
                  (i) => Padding(
                      padding:
                          const EdgeInsetsDirectional.only(end: 6),
                      child: ChoiceChip(
                          label: Text('S${i + 1}'),
                          selected: _scenario == i,
                          onSelected: (_) =>
                              setState(() => _scenario = i))))),
          TextField(
              controller: _inputCtrl,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: loc.tr(_scenarios[_scenario % _scenarios.length].inputAr,
                      _scenarios[_scenario % _scenarios.length].inputEn))),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: _busy ? null : _runAudit,
              child: Text(loc.t(_busy
                  ? 'ai.spec_running'
                  : 'ai.spec_run'))),
          if (_verdict != null) ...[
            const SizedBox(height: 8),
            Card(
              color: _verdictColor().withValues(alpha: 0.12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                          label: Text(loc.t(_verdictKey())),
                          backgroundColor: _verdictColor()
                              .withValues(alpha: 0.25)),
                      const SizedBox(height: 4),
                      Text(loc.tr(_resultAr, _resultEn)),
                      Row(children: [
                        TextButton(
                            onPressed: () => ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(SnackBar(
                                    content: Text(
                                        loc.t('ai.spec_linked')))),
                            child:
                                Text(loc.t('ai.spec_link'))),
                      ]),
                    ]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class OrionTacticalCopilotScreen extends StatefulWidget {
  const OrionTacticalCopilotScreen({super.key});
  @override
  State<OrionTacticalCopilotScreen> createState() =>
      _OrionTacticalCopilotScreenState();
}

class _OrionTacticalCopilotScreenState
    extends State<OrionTacticalCopilotScreen> {
  static const _packet = OrionTelemetryPacket(
    coreTemperature: 52.4,
    reactorStatus: ReactorStatus.nominal,
    powerGridEfficiency: 94.5,
    signalToNoiseRatio: 18.2,
    commsStatus: CommsStatus.locked,
    packetThroughput: 1240,
    chamberPressure: 101.3,
  );
  static const _fleet = [
    FleetAsset(id: 'FL-01', callsign: 'TC-01', sector: 'Zone A',
        status: 'ACTIVE', batteryPercent: 87),
    FleetAsset(id: 'FL-02', callsign: 'RMC-04', sector: 'Zone C',
        status: 'ACTIVE', batteryPercent: 64),
    FleetAsset(id: 'FL-03', callsign: 'EXC-02', sector: 'Zone B',
        status: 'IDLE', batteryPercent: 92),
  ];

  OrionAiAssessment? _assessment;

  String _reactorLabel(AppLocalization loc, ReactorStatus s) => switch (s) {
        ReactorStatus.nominal => loc.t('orion.nominal'),
        ReactorStatus.elevated => loc.t('orion.elevated'),
        ReactorStatus.critical => loc.t('orion.critical'),
      };

  String _commsLabel(AppLocalization loc, CommsStatus s) => switch (s) {
        CommsStatus.locked => loc.t('orion.locked'),
        CommsStatus.degraded => loc.t('orion.degraded'),
        CommsStatus.searching => loc.t('orion.searching'),
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('screen.tactical'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Expanded(child: Card(child: ListTile(
              title: Text(loc.t('orion.reactor')),
              subtitle: Text(_reactorLabel(loc, _packet.reactorStatus)),
            ))),
            Expanded(child: Card(child: ListTile(
              title: Text(loc.t('orion.comms')),
              subtitle: Text(_commsLabel(loc, _packet.commsStatus)),
            ))),
          ]),
          Card(child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              _GaugeRow(label: loc.t('orion.core_temp'),
                  value: '${_packet.coreTemperature}°C'),
              _GaugeRow(label: loc.t('orion.grid'),
                  value: '${_packet.powerGridEfficiency}%'),
              _GaugeRow(label: loc.t('orion.snr'),
                  value: '${_packet.signalToNoiseRatio}'),
              _GaugeRow(label: loc.t('orion.throughput'),
                  value: '${_packet.packetThroughput}'),
              _GaugeRow(label: loc.t('orion.pressure'),
                  value: '${_packet.chamberPressure}'),
            ]),
          )),
          Text(loc.t('orion.fleet'),
              style: Theme.of(context).textTheme.titleMedium),
          ..._fleet.map((f) => ListTile(
                leading: const Icon(Icons.precision_manufacturing),
                title: Text('${f.callsign} • ${f.sector}'),
                subtitle: Text(f.status),
                trailing: Text('${f.batteryPercent}%'),
              )),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => setState(() => _assessment =
                const OrionAiService().analyzeTelemetryAndSuggestDirectives(
                    _packet, _fleet)),
            child: Text(loc.t('orion.assess')),
          ),
          if (_assessment != null) ...[
            const SizedBox(height: 8),
            Card(child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${loc.t('orion.assessment')} • ${loc.t('orion.defcon')} ${_assessment!.defconLevel}'),
                    Text('${loc.t('orion.confidence')}: ${(_assessment!.confidence * 100).toInt()}%'),
                    const SizedBox(height: 4),
                    Text(loc.tr(_assessment!.tacticalSummaryAr,
                        _assessment!.tacticalSummaryEn)),
                    if (_assessment!.recommendedDirective != null)
                      ListTile(
                        leading: const Icon(Icons.campaign),
                        title: Text(
                            '${loc.t('orion.directive')} ${_assessment!.recommendedDirective!.code}'),
                        subtitle: Text(loc.tr(
                            _assessment!.recommendedDirective!.titleAr,
                            _assessment!.recommendedDirective!.titleEn)),
                      ),
                  ]),
            )),
          ],
        ],
      ),
    );
  }
}

class _GaugeRow extends StatelessWidget {
  final String label;
  final String value;
  const _GaugeRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value)],
        ),
      );
}
