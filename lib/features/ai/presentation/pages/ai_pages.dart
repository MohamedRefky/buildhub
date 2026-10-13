// Clean Architecture: AI Copilot — Presentation.
// Covers: AiCopilotScreen, AiLegalCopilotScreen, AiSiteSuperintendentScreen,
// AiSpecAuditorView, SiteTalkScreen, AskTheSiteScreen,
// OrionTacticalCopilotScreen, ConstructionChatScreen.
// Titles/hints resolve from JSON — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
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
