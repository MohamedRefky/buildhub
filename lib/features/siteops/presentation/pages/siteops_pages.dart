// Clean Architecture: SiteOps — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// DailyReportAgentScreen, WeatherBrainScreen, GeoAttendanceScreen,
// ActivityDataEntryScreen, SmartOfflineSyncScreen, WorkerWelfareScreen,
// EsgSustainabilityScreen, GreenWalletAndEnergyCertificatesScreen,
// OrionGreenPassScreen, OrionRoadmapScreen, RiskHeatMapScreen,
// MarketIntelligenceScreen, PredictiveDelayScreen, HistoricalGanttBaselineScreen,
// AiBaselineSuiteScreen, ApprovalEngineScreen, ExceptionOverrideScreen,
// AutonomousAgentControlScreen, FirebaseCloudSyncScreen.

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/features/siteops/domain/entities/siteops_entities.dart';

// ---------------------------------------------------------------------------
// 1. AI DAILY REPORT AGENT SCREEN
// ---------------------------------------------------------------------------

class DailyReportFullScreen extends StatefulWidget {
  final String projectId;
  const DailyReportFullScreen({super.key, this.projectId = 'proj-01'});

  @override
  State<DailyReportFullScreen> createState() => _DailyReportFullScreenState();
}

class _DailyReportFullScreenState extends State<DailyReportFullScreen> {
  bool _isGenerating = false;
  String? _signedSuccessMsg;
  String _reportStatus = 'DRAFT';
  String? _signedHash;
  String? _signedBy;

  // Active report data
  final String _reportId = 'DPR-2026-09-28-001';
  final String _date = '2026-09-28';
  final double _tempMax = 42.5;
  final double _tempMin = 29.0;
  final int _humidity = 58;
  final double _windSpeedKmh = 18.0;
  final bool _middayBanObserved = true;

  final List<Map<String, dynamic>> _manpower = [
    {'trade': 'Rebar Fixers', 'subcontractor': 'Al Naboodah Steel', 'men': 28, 'hours': 224.0},
    {'trade': 'Carpenters', 'subcontractor': 'Arabtec Formwork', 'men': 22, 'hours': 176.0},
    {'trade': 'MEP Technicians', 'subcontractor': 'Drake & Scull', 'men': 15, 'hours': 120.0},
    {'trade': 'HSE Officers', 'subcontractor': 'Orion Safety Services', 'men': 4, 'hours': 32.0},
  ];

  final List<Map<String, dynamic>> _activities = [
    {
      'text': 'Level 12 Zone B slab reinforcement inspection passed with consultant Eng. Tariq.',
      'area': 'Level 12 - Zone B',
      'confidence': 0.94,
      'aiGenerated': true,
      'sources': ['audio_log_042', 'img_rebar_inspect_99'],
    },
    {
      'text': 'MEP chilled water pipes clash with architectural ceiling grid at axis F4 escalated via RFI-2026-088.',
      'area': 'Level 11 Corridor',
      'confidence': 0.88,
      'aiGenerated': true,
      'sources': ['audio_log_047'],
    },
    {
      'text': 'Concrete batch slump tests verified for 4 transit mixers (target 150mm ± 25mm).',
      'area': 'Ground Pump Station',
      'confidence': 0.65,
      'aiGenerated': true,
      'sources': ['photo_slump_truck4'],
    },
  ];

  final List<Map<String, String>> _deliveries = [
    {
      'material': 'Ready-mix C40 Concrete',
      'supplier': 'Unibeton Ready Mix',
      'quantity': '48 m³',
      'ticket': 'DXB-77291',
      'status': 'SLUMP_PASSED',
    },
    {
      'material': 'Deformed Rebar 16mm/25mm',
      'supplier': 'Emirates Steel Arkan',
      'quantity': '35 Ton',
      'ticket': 'AUH-44102',
      'status': 'INSPECTED',
    },
  ];

  final List<Map<String, String>> _issues = [
    {
      'desc': 'MEP coordination clash at grid F4 corridor ceiling',
      'category': 'QUALITY',
      'severity': 'MAJOR',
    },
    {
      'desc': 'Heat index exceeded 41°C; outdoor activities halted during 12:30-15:30 midday ban',
      'category': 'SAFETY',
      'severity': 'MINOR',
    },
  ];

  void _regenerateReport() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _isGenerating = false;
      _signedSuccessMsg = 'Daily report re-synthesized from 14 audio logs & 38 photos!';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI Daily report draft updated & cached')),
    );
  }

  void _signReportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.verified, color: AppColors.verifiedGreen),
            SizedBox(width: 8),
            Text('Digital SHA-256 Sign-off'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign this daily report digitally as Project Director. A cryptographic SHA-256 hash will be generated to guarantee legal non-repudiation for UAE authorities & consultants.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Signer: Eng. Abdelfattah (Project Director)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('Standard: UAE Digital Signature & Federal Law No. 46', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.verifiedGreen, foregroundColor: Colors.white),
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Confirm & Sign'),
            onPressed: () {
              final timestamp = DateTime.now().millisecondsSinceEpoch;
              final signer = 'Eng. Abdelfattah (Project Director)';
              final content = '${_reportId}_${_date}_${signer}_$timestamp';
              final hash = sha256.convert(utf8.encode(content)).toString();

              setState(() {
                _reportStatus = 'SIGNED';
                _signedBy = signer;
                _signedHash = hash;
                _signedSuccessMsg = 'Report signed with SHA-256: ${hash.substring(0, 16)}... and queued for cloud sync!';
              });
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.t('ops.daily'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const Text('Room SQLite & Cloud Sync • Voice, Photos & Attendance', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _reportStatus == 'SIGNED' ? AppColors.verifiedGreen.withValues(alpha: 0.2) : AppColors.cautionAmber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _reportStatus == 'SIGNED' ? AppColors.verifiedGreen : AppColors.cautionAmber),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _reportStatus == 'SIGNED' ? Icons.check_circle : Icons.sync,
                  size: 14,
                  color: _reportStatus == 'SIGNED' ? AppColors.verifiedGreen : AppColors.cautionAmber,
                ),
                const SizedBox(width: 4),
                Text(
                  _reportStatus,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _reportStatus == 'SIGNED' ? AppColors.verifiedGreen : AppColors.cautionAmber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_signedSuccessMsg != null)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.verifiedGreen),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, color: AppColors.verifiedGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_signedSuccessMsg!, style: const TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.w600, fontSize: 12)),
                        if (_signedBy != null)
                          Text('Signed by: $_signedBy', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Multi-Source Synthesis Card
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.smart_toy, color: AppColors.accentCyan),
                      SizedBox(width: 8),
                      Text('Multi-Source Daily Synthesizer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('• 14 Walkie-Talkie voice logs processed & transcribed', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Text('• 38 Site progress photos indexed with GPS & timestamp', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Text('• Geo-Attendance check-in: 69 workers across 4 trades', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Text('• Weather telemetry: Max 42.5°C, Midday ban observed 12:30-15:30', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                      onPressed: _isGenerating ? null : _regenerateReport,
                      icon: _isGenerating
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Icon(Icons.auto_awesome, size: 16),
                      label: Text(_isGenerating ? 'Synthesizing Draft...' : 'Regenerate AI Daily Report Draft'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header Card
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Report ID: $_reportId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(_date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const Divider(height: 20),
                  // Weather telemetry
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.wb_sunny, color: Colors.orange, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$_tempMax°C (Max) / $_tempMin°C (Min) • Humidity $_humidity%', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text('Wind: $_windSpeedKmh km/h • Midday Ban: ${_middayBanObserved ? 'Observed (12:30-15:30)' : 'Exempt'}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: const Text('BAN COMPLIANT', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Manpower Card
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Manpower Attendance (69 Total)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('552 Man-hours', style: TextStyle(fontSize: 12, color: AppColors.accentCyan, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._manpower.map((m) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m['trade'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                Text(m['subcontractor'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                            Text('${m['men']} Men (${m['hours'].toInt()}h)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // AI Synthesized Activities
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Synthesized Field Activities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  ..._activities.map((a) {
                    final conf = (a['confidence'] as double);
                    final isLow = conf < 0.7;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isLow ? AppColors.cautionAmber : Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                                child: Text(a['area'], style: const TextStyle(fontSize: 10, color: AppColors.accentCyan, fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome, size: 12, color: isLow ? AppColors.cautionAmber : AppColors.verifiedGreen),
                                  const SizedBox(width: 4),
                                  Text('${(conf * 100).toInt()}% conf', style: TextStyle(fontSize: 11, color: isLow ? AppColors.cautionAmber : AppColors.verifiedGreen, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(a['text'], style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 6),
                          Text('Sources: ${(a['sources'] as List).join(', ')}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Deliveries & Concrete Slump
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Material Deliveries & Inspections', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  ..._deliveries.map((d) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.local_shipping, color: AppColors.accentCyan),
                        title: Text(d['material']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        subtitle: Text('${d['supplier']} • Ticket: ${d['ticket']}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(d['status']!, style: const TextStyle(color: AppColors.verifiedGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Issues & Incidents
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quality & Safety Issues', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  ..._issues.map((i) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: i['severity'] == 'MAJOR' ? AppColors.criticalRed.withValues(alpha: 0.1) : AppColors.cautionAmber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: i['severity'] == 'MAJOR' ? AppColors.criticalRed.withValues(alpha: 0.3) : AppColors.cautionAmber.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: i['severity'] == 'MAJOR' ? AppColors.criticalRed : AppColors.cautionAmber, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(i['desc']!, style: const TextStyle(fontSize: 12))),
                            Text(i['severity']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: i['severity'] == 'MAJOR' ? AppColors.criticalRed : AppColors.cautionAmber)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sign Off Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _reportStatus == 'SIGNED' ? AppColors.verifiedGreen : AppColors.accentCyan,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(_reportStatus == 'SIGNED' ? Icons.check_circle : Icons.draw),
              label: Text(
                _reportStatus == 'SIGNED' ? 'Report Signed & Cryptographically Sealed' : 'Review & Sign Report (Eng. Abdelfattah)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _reportStatus == 'SIGNED' ? null : _signReportDialog,
            ),
          ),
          if (_signedHash != null) ...[
            const SizedBox(height: 8),
            Center(
              child: Text('SHA-256: $_signedHash', style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace')),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. WEATHER BRAIN INTELLIGENCE SCREEN
// ---------------------------------------------------------------------------

class WeatherFullScreen extends StatelessWidget {
  const WeatherFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    final activities = [
      {'name': 'Tower Crane Lifts', 'status': 'CAUTION', 'window': '06:00 - 11:30', 'reason': 'Gusts exceed 35 km/h afternoon'},
      {'name': 'Concrete Pours (ACI 305R)', 'status': 'HOLD', 'window': '12:30 - 15:30', 'reason': 'Evaporation rate > 1.0 kg/m²/h during midday ban'},
      {'name': 'External Façade Painting', 'status': 'GO', 'window': '07:00 - 12:00', 'reason': 'Humidity and temperature within optimal range'},
      {'name': 'Heavy Outdoor Earthworks', 'status': 'HOLD', 'window': '12:30 - 15:30', 'reason': 'Heat index extreme zone'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.t('ops.weather'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const Text('ACI 305R Menzel Evaporation & Crane Gust Limits', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Midday Ban Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.criticalRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.criticalRed, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: AppColors.criticalRed, shape: BoxShape.circle),
                  child: const Icon(Icons.wb_sunny, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Midday Work Ban Active (12:30 - 15:30)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.criticalRed)),
                      SizedBox(height: 4),
                      Text('Temperature: 42.5°C | Wind Gusts: 38 km/h (Caution)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Real-time telemetry cards
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.thermostat, size: 18, color: Colors.orange),
                            SizedBox(width: 6),
                            Text('Ambient', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text('42.5°C', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('WBGT: 33.2°C (High)', style: TextStyle(fontSize: 10, color: AppColors.criticalRed)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.air, size: 18, color: AppColors.accentCyan),
                            SizedBox(width: 6),
                            Text('Crane Wind', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text('18.0 km/h', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Gusts: 38 km/h (Limit: 38)', style: TextStyle(fontSize: 10, color: AppColors.cautionAmber)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.water_drop, size: 18, color: Colors.blue),
                            SizedBox(width: 6),
                            Text('Evaporation', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text('1.15 kg/m²', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('ACI 305R Exceeded', style: TextStyle(fontSize: 10, color: AppColors.criticalRed)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Activity Windows
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Activity Go / Caution / Hold Windows (Today)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 14),
                  ...activities.map((a) {
                    final status = a['status']!;
                    final color = status == 'GO'
                        ? AppColors.verifiedGreen
                        : status == 'CAUTION'
                            ? AppColors.cautionAmber
                            : AppColors.criticalRed;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(a['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                                child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Optimal Window: ${a['window']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                          Text('Reason: ${a['reason']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Weather Claim Evidence Log
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Adverse-Weather Claim Evidence Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  const Text('• Total hours held this week: 14.5 hours', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Text('• Formatted for FIDIC EOT (Extension of Time) claims under Sub-Clause 8.4', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf, size: 16),
                      label: const Text('Export Weather Claim Package (PDF)'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('FIDIC Sub-Clause 8.4 Adverse Weather package exported')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. GEO-ATTENDANCE SCREEN
// ---------------------------------------------------------------------------

class GeoAttendanceFullScreen extends StatefulWidget {
  const GeoAttendanceFullScreen({super.key});

  @override
  State<GeoAttendanceFullScreen> createState() => _GeoAttendanceFullScreenState();
}

class _GeoAttendanceFullScreenState extends State<GeoAttendanceFullScreen> {
  int _selectedFilter = 0; // 0: All, 1: Present, 2: Absent, 3: Late
  bool _isCheckedIn = true;

  final List<Map<String, String>> _records = [
    {'name': 'Ahmed Al Rashidi', 'role': 'Site Engineer', 'loc': 'Level 12 – Grid A', 'hours': '7h 28m', 'checkIn': 'in 07:02', 'code': 'AE', 'status': 'present'},
    {'name': 'Rajiv Kumar', 'role': 'MEP Foreman', 'loc': 'Level 11 – MEP Zone', 'hours': '7h 15m', 'checkIn': 'in 07:15', 'code': 'IN', 'status': 'present'},
    {'name': 'Suresh Babu', 'role': 'Carpenter', 'loc': 'Level 12 – Formwork', 'hours': '7h 32m', 'checkIn': 'in 06:58', 'code': 'IN', 'status': 'present'},
    {'name': 'Ali Hassan', 'role': 'Safety Officer', 'loc': 'Site-wide Inspection', 'hours': '7h 45m', 'checkIn': 'in 06:45', 'code': 'EG', 'status': 'present'},
    {'name': 'Ramesh Prasad', 'role': 'Ironworker', 'loc': 'Level 11 – Rebar', 'hours': '5h 45m', 'checkIn': 'in 08:45', 'code': 'NP', 'status': 'late'},
    {'name': 'Pradeep Nair', 'role': 'Mason', 'loc': 'Off-site', 'hours': '0h 00m', 'checkIn': 'Absent', 'code': 'IN', 'status': 'absent'},
    {'name': 'Omar Al Farsi', 'role': 'Electrician', 'loc': 'Off-site', 'hours': '0h 00m', 'checkIn': 'Absent', 'code': 'AE', 'status': 'absent'},
  ];

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    final filtered = _records.where((r) {
      if (_selectedFilter == 1) return r['status'] == 'present';
      if (_selectedFilter == 2) return r['status'] == 'absent';
      if (_selectedFilter == 3) return r['status'] == 'late';
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.t('ops.geo'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const Text('Marina Tower • GPS Geofenced Check-in', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.gps_fixed, size: 14, color: AppColors.verifiedGreen),
                SizedBox(width: 4),
                Text('GPS Active', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Geofence Card
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.location_on, color: AppColors.accentCyan),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Site Boundary Active (200m Radius)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Dubai Marina, Parcel 4B • Auto check-in verified', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Check-in toggle button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCheckedIn ? AppColors.verifiedGreen : AppColors.accentCyan,
                foregroundColor: Colors.black,
              ),
              icon: Icon(_isCheckedIn ? Icons.check_circle : Icons.fingerprint),
              label: Text(_isCheckedIn ? 'You are Checked-In on Site (07:02 AM)' : 'Geofenced Biometric Check-In'),
              onPressed: () {
                setState(() => _isCheckedIn = !_isCheckedIn);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_isCheckedIn ? 'Biometric check-in verified at Level 12' : 'Checked out of site boundary')),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: Text('All (${_records.length})'),
                  selected: _selectedFilter == 0,
                  onSelected: (_) => setState(() => _selectedFilter = 0),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Present (4)'),
                  selected: _selectedFilter == 1,
                  onSelected: (_) => setState(() => _selectedFilter = 1),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Late (1)'),
                  selected: _selectedFilter == 3,
                  onSelected: (_) => setState(() => _selectedFilter = 3),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Absent (2)'),
                  selected: _selectedFilter == 2,
                  onSelected: (_) => setState(() => _selectedFilter = 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Workers list
          ...filtered.map((r) {
            final isPres = r['status'] == 'present';
            final isLate = r['status'] == 'late';
            final col = isPres ? AppColors.verifiedGreen : isLate ? AppColors.cautionAmber : AppColors.criticalRed;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: col.withValues(alpha: 0.15),
                  child: Text(r['code']!, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                title: Text(r['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('${r['role']} • ${r['loc']}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(r['hours']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(r['checkIn']!, style: TextStyle(fontSize: 10, color: col)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. ACTIVITY DATA ENTRY SCREEN
// ---------------------------------------------------------------------------

class ActivityEntryScreen extends StatefulWidget {
  const ActivityEntryScreen({super.key});

  @override
  State<ActivityEntryScreen> createState() => _ActivityEntryScreenState();
}

class _ActivityEntryScreenState extends State<ActivityEntryScreen> {
  final _areaController = TextEditingController(text: 'Level 12 - Zone B');
  final _descController = TextEditingController(text: 'Conducted slab reinforcement pre-pour check.');
  String _selectedTrade = 'Structural Rebar';
  int _menCount = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Field Activity Data Entry')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Log New Site Activity / Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          TextField(
            controller: _areaController,
            decoration: const InputDecoration(labelText: 'Location / Area / Grid', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedTrade,
            decoration: const InputDecoration(labelText: 'Trade / Work Package', border: OutlineInputBorder()),
            items: ['Structural Rebar', 'Formwork & Shuttering', 'Concrete Casting', 'MEP Chilled Water', 'Masonry Blockwork']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _selectedTrade = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Activity Description & Observations', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Labor Headcount:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(onPressed: () => setState(() => _menCount = (_menCount > 1 ? _menCount - 1 : 1)), icon: const Icon(Icons.remove)),
              Text('$_menCount Men', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => setState(() => _menCount++), icon: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.save),
            label: const Text('Submit Activity to Daily Log'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Activity logged to local SQLite & queued for AI synthesis')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. SMART OFFLINE SYNC SCREEN
// ---------------------------------------------------------------------------

class OfflineSyncScreen extends StatelessWidget {
  const OfflineSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Offline Sync & SQLite')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cloud_done, color: AppColors.verifiedGreen),
                      SizedBox(width: 8),
                      Text('Offline-First Architecture', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('All project drawings, daily logs, safety passports, and purchase orders are stored locally in Room / SQLite database with automatic background conflict resolution.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Divider(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Local SQLite Database Size:'),
                      Text('142.8 MB', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cached BIM Models & Drawings:'),
                      Text('18 Files (Ready Offline)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pending Outbox Sync Queue:'),
                      Text('0 Records (All in Sync)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.sync),
            label: const Text('Trigger Full Cloud Sync Now'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Synced with Firestore & Cloud Storage successfully')),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. WORKER WELFARE & COMPLIANCE
// ---------------------------------------------------------------------------

class WelfareScreen extends StatelessWidget {
  const WelfareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worker Welfare & Compliance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user, color: AppColors.accentCyan, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('WPS Payroll: 100% Compliant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accentCyan)),
                      Text('Central Bank UAE Wage Protection System verified for latest month', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _welfareCard('Midday Break Shaded Cool Rooms', '3 Air-conditioned rest pavilions active on site with ice electrolyte distribution.', Icons.ac_unit, AppColors.verifiedGreen),
          _welfareCard('Labor Accommodation Inspection', 'Sonapur Camp inspected by Dubai Municipality & MOHRE. Rating: A Grade.', Icons.hotel, AppColors.verifiedGreen),
          _welfareCard('Medical Clinic & First Aid Evac', 'Licensed registered paramedic stationed on Level Ground, emergency ambulance link.', Icons.local_hospital, AppColors.accentCyan),
          _welfareCard('Heat Stress Hydration Stations', 'Cooling water dispensers at every 2 floors with digital WBGT advisory displays.', Icons.water_drop, AppColors.verifiedGreen),
        ],
      ),
    );
  }

  Widget _welfareCard(String title, String desc, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 11)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. ESG & GREEN SUSTAINABILITY
// ---------------------------------------------------------------------------

class EsgScreen extends StatelessWidget {
  const EsgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ESG & Green Sustainability')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.verifiedGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.verifiedGreen),
            ),
            child: const Row(
              children: [
                Icon(Icons.eco, color: AppColors.verifiedGreen, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Project Carbon Footprint: -18.4% vs Baseline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.verifiedGreen)),
                      Text('Estidama 4-Pearl & LEED Gold Certification Target', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: _EsgMetricCard(title: 'Waste Recycled', val: '78.2%', subtitle: 'Target: 75%')),
              Expanded(child: _EsgMetricCard(title: 'Green Concrete', val: '62.0%', subtitle: 'GGBS / Fly ash')),
              Expanded(child: _EsgMetricCard(title: 'Solar Clean kWh', val: '42.5 MWh', subtitle: 'Diesel Offset')),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Material Embodied Carbon Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  const Text('• Ready-mix Concrete C40: 240 kg CO₂e/m³ (Standard: 320 kg)', style: TextStyle(fontSize: 12)),
                  const Text('• Emirates Steel Arkan Rebar: EPD Certified 1.15 t CO₂e/t', style: TextStyle(fontSize: 12)),
                  const Text('• On-site Solar Generator: Saved 14,800 Liters of Diesel', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download Al Sa\'fat Environmental Certificate'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EsgMetricCard extends StatelessWidget {
  final String title;
  final String val;
  final String subtitle;
  const _EsgMetricCard({required this.title, required this.val, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. GREEN WALLET & ENERGY CERTIFICATES
// ---------------------------------------------------------------------------

class GreenWalletScreen extends StatelessWidget {
  const GreenWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Green Wallet & I-REC Energy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.verifiedGreen.withValues(alpha: 0.2), AppColors.accentCyan.withValues(alpha: 0.2)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.verifiedGreen),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Clean Energy Carbon Credits', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    Icon(Icons.energy_savings_leaf, color: AppColors.verifiedGreen),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('4,850 AED Balance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                const SizedBox(height: 6),
                const Text('92.4 MWh certified renewable power generated from MBR Solar Park & Site PV.', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Active I-REC Certificates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          _certTile('IREC-DXB-2026-081', 'DEWA MBR Solar Park Phase V', '50.0 MWh', 'Active & Certified', AppColors.verifiedGreen),
          _certTile('IREC-DXB-2026-082', 'Site Rooftop Solar Array', '24.5 MWh', 'Retired for Audit', AppColors.accentCyan),
          _certTile('IREC-DXB-2026-083', 'On-Site Hybrid Generator', '17.9 MWh', 'Pending Issuance', AppColors.cautionAmber),
        ],
      ),
    );
  }

  Widget _certTile(String code, String source, String energy, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text('$source • $energy'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
          child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class GreenPassScreen extends StatelessWidget {
  const GreenPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orion Green Pass Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_2, size: 100, color: AppColors.verifiedGreen),
            const SizedBox(height: 16),
            const Text('Orion B Green Pass #GP-2026-44', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Estidama & Al Sa\'fat Official Contractor Green Passport\nValid until Dec 2026', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. ROADMAP & DECISION GATES
// ---------------------------------------------------------------------------

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phases = [
      {'phase': 'Phase 0', 'title': 'Core Architecture Foundation', 'status': 'COMPLETED', 'gate': 'Gate 0 Passed'},
      {'phase': 'Phase 1', 'title': 'Multi-Source Daily Reports & Audio Logs', 'status': 'ACTIVE', 'gate': 'Gate 1 Review'},
      {'phase': 'Phase 2', 'title': 'Unified Procurement Hub & QR MIRs', 'status': 'ACTIVE', 'gate': 'Gate 2 In Progress'},
      {'phase': 'Phase 3', 'title': 'BIM 3D Model Viewer & Drawings Pins', 'status': 'PLANNED', 'gate': 'Gate 3 Scheduled'},
      {'phase': 'Phase 4', 'title': 'FIDIC Contract AI Claims & Variations', 'status': 'PLANNED', 'gate': 'Gate 4 Scheduled'},
      {'phase': 'Phase 5', 'title': 'Heavy Machinery Dubizzle Marketplace', 'status': 'PLANNED', 'gate': 'Gate 5 Scheduled'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Phased Roadmap & Decision Gates')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('14 Implementation Phases • Decision Gates 0–12', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          ...phases.map((p) {
            final isDone = p['status'] == 'COMPLETED';
            final isActive = p['status'] == 'ACTIVE';
            final color = isDone ? AppColors.verifiedGreen : isActive ? AppColors.accentCyan : Colors.grey;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(isDone ? Icons.check : isActive ? Icons.play_arrow : Icons.schedule, color: color, size: 20),
                ),
                title: Text('${p['phase']}: ${p['title']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('Status: ${p['status']} • ${p['gate']}'),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. RISK HEAT-MAP SCREEN
// ---------------------------------------------------------------------------

class RiskHeatMapFullScreen extends StatelessWidget {
  final List<RiskItem> risks;
  const RiskHeatMapFullScreen({super.key, this.risks = const []});

  @override
  Widget build(BuildContext context) {
    final defaultRisks = [
      {'title': 'Ready-mix batch plant delay during midday ban', 'level': 'HIGH', 'impact': '3 Days delay • 45,000 AED', 'prob': '85%'},
      {'title': 'HVAC Chilled water pipe clash at corridor F4', 'level': 'MEDIUM', 'impact': 'RFI turnaround • 12,000 AED', 'prob': '65%'},
      {'title': 'RTA road access permit renewal pending', 'level': 'HIGH', 'impact': 'Gate transit halt • 30,000 AED', 'prob': '75%'},
      {'title': 'Tower crane wind gusts exceeding 38 km/h', 'level': 'MEDIUM', 'impact': 'Lift halts • Weather EOT Claim', 'prob': '55%'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Risk Heat-Map & Delay Forecast')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _riskStatCard('High Risk', '2 Items', AppColors.criticalRed)),
              Expanded(child: _riskStatCard('Medium', '2 Items', AppColors.cautionAmber)),
              Expanded(child: _riskStatCard('Low / Resolved', '8 Items', AppColors.verifiedGreen)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Active Site Operational Risks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ...defaultRisks.map((r) {
            final isHigh = r['level'] == 'HIGH';
            final color = isHigh ? AppColors.criticalRed : AppColors.cautionAmber;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(Icons.warning_amber_rounded, color: color),
                title: Text(r['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('Impact: ${r['impact']}'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text('${r['level']} (${r['prob']})', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _riskStatCard(String title, String val, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 11. MARKET INTELLIGENCE & PRICE INDEX
// ---------------------------------------------------------------------------

class MarketIntelScreen extends StatelessWidget {
  const MarketIntelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final materials = [
      {'name': 'Deformed Steel Rebar 16-25mm', 'price': '2,450 AED / Ton', 'change': '+1.8%', 'signal': 'HOLD'},
      {'name': 'Ready-mix Concrete C40', 'price': '225 AED / m³', 'change': '-0.5%', 'signal': 'BUY'},
      {'name': 'Portland Cement Type I OPC', 'price': '14.50 AED / Bag', 'change': '0.0%', 'signal': 'BUY'},
      {'name': 'Diesel Fuel (Site Gen-set)', 'price': '3.15 AED / L', 'change': '+2.4%', 'signal': 'WAIT'},
      {'name': 'Copper Electrical Cable 4-Core', 'price': '48.00 AED / m', 'change': '+3.1%', 'signal': 'HOLD'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Market Intelligence & Price Index')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.goldEmirates.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.goldEmirates),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.goldEmirates),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Purchasing Advisor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.goldEmirates)),
                      Text('Steel rebar prices expected to soften by 2.3% next month. Lock in ready-mix concrete contracts for Q4 now.', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('UAE Construction Commodities Benchmark', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ...materials.map((m) {
            final isBuy = m['signal'] == 'BUY';
            final isHold = m['signal'] == 'HOLD';
            final color = isBuy ? AppColors.verifiedGreen : isHold ? AppColors.cautionAmber : AppColors.criticalRed;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('Price: ${m['price']} (${m['change']})'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(m['signal']!, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 12. PREDICTIVE DELAY SCREEN
// ---------------------------------------------------------------------------

class PredictiveDelayFullScreen extends StatelessWidget {
  const PredictiveDelayFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predictive Schedule Delay AI')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Critical Path Variance (CPM Engine)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  const Text('AI simulation based on 42 historical UAE tower projects.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Divider(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Forecasted Handover Variance:'),
                      Text('+8 Days Delay', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.criticalRed)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Critical Path Bottleneck:'),
                      Text('Level 12 Zone B Slab Pour', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mitigation Recommendation:'),
                      Text('Shift pour to night shift (20:00)', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 13. GANTT BASELINE & AI BASELINE SUITE
// ---------------------------------------------------------------------------

class GanttBaselineScreen extends StatelessWidget {
  const GanttBaselineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historical Gantt Baseline & WBS')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('WBS Work Package Milestones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  _ganttRow('Substructure & Piling', 1.0, 'Completed (100%)', AppColors.verifiedGreen),
                  _ganttRow('Superstructure Level 1-12', 0.88, 'In Progress (88%)', AppColors.accentCyan),
                  _ganttRow('MEP First Fix Rough-in', 0.65, 'In Progress (65%)', AppColors.cautionAmber),
                  _ganttRow('Façade Unitized Curtain Wall', 0.40, 'In Progress (40%)', AppColors.cautionAmber),
                  _ganttRow('Finishing & Testing/Commissioning', 0.10, 'Planned (10%)', Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ganttRow(String title, double progress, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: progress, color: color, backgroundColor: Colors.white12),
        ],
      ),
    );
  }
}

class BaselineSuiteScreen extends StatelessWidget {
  const BaselineSuiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GanttBaselineScreen();
  }
}

// ---------------------------------------------------------------------------
// 14. CENTRAL APPROVAL ENGINE
// ---------------------------------------------------------------------------

class ApprovalEngineFullScreen extends StatelessWidget {
  const ApprovalEngineFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pending = [
      {'code': 'PO-2026-081', 'title': 'Steel Rebar Procurement (35 Ton)', 'val': '85,750 AED', 'sla': '14h remaining', 'author': 'Procurement Lead'},
      {'code': 'MIR-2026-042', 'title': 'Ready-mix Concrete Slump Certificate', 'val': 'Quality Inspection', 'sla': '2h remaining', 'author': 'QA/QC Engineer'},
      {'code': 'IPC-2026-006', 'title': 'Subcontractor Monthly Payment Interim Cert', 'val': '240,000 AED', 'sla': '28h remaining', 'author': 'Commercial Manager'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Central Approval Engine')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _stat('Pending Approval', '3 Items', AppColors.cautionAmber)),
              Expanded(child: _stat('Approved', '48 Items', AppColors.verifiedGreen)),
              Expanded(child: _stat('Exposure', '325K AED', AppColors.accentCyan)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Requests Awaiting Your Authority', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ...pending.map((p) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p['code']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accentCyan)),
                          Text(p['sla']!, style: const TextStyle(color: AppColors.cautionAmber, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(p['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('${p['val']} • Requested by ${p['author']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(onPressed: () {}, child: const Text('Reject')),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.verifiedGreen, foregroundColor: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p['code']} approved')));
                            },
                            child: const Text('Approve'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _stat(String label, String val, Color c) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: c)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 15. EXCEPTION & OVERRIDE CONTROL
// ---------------------------------------------------------------------------

class ExceptionOverrideFullScreen extends StatelessWidget {
  const ExceptionOverrideFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controlled Exception Overrides')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.cautionAmber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cautionAmber)),
            child: const Row(
              children: [
                Icon(Icons.gavel, color: AppColors.cautionAmber),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Zero Silent Bypasses Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.cautionAmber)),
                      Text('All emergency site overrides have automatic expiry timers and mandatory post-action audit reviews.', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: roundedCornerShape12,
            child: ListTile(
              leading: const Icon(Icons.timer, color: AppColors.criticalRed),
              title: const Text('Emergency Night Concrete Pour Override', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Authorized by Eng. Abdelfattah • Expires in 4h 12m'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.criticalRed.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                child: const Text('ACTIVE', style: TextStyle(color: AppColors.criticalRed, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 16. AUTONOMOUS SITE AGENT
// ---------------------------------------------------------------------------

class AutonomousAgentScreen extends StatelessWidget {
  const AutonomousAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autonomous Site Superintendent AI')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: roundedCornerShape12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.precision_manufacturing, color: AppColors.accentCyan),
                      SizedBox(width: 8),
                      Text('Active Autonomous Agents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _agentTile('Site Vision Drone Scanner', 'Flight completed at 07:00 AM • 3D Point cloud synchronized with BIM', AppColors.verifiedGreen),
                  _agentTile('Voice Log Auto-Drafter', '14 Audio clips transcribed and converted to Daily Report draft', AppColors.verifiedGreen),
                  _agentTile('Safety Heat-Stress Guard', 'Continuous monitoring of WBGT sensors across Levels 1–12', AppColors.accentCyan),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _agentTile(String name, String desc, Color c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 10, color: c),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const roundedCornerShape12 = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)));
