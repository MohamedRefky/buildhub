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
const roundedCornerShape12 = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)));

// 4. ACTIVITY DATA ENTRY SCREEN (Jetpack Compose: ActivityDataEntryScreen.kt)
// ---------------------------------------------------------------------------

class ActivityEntryScreen extends StatefulWidget {
  const ActivityEntryScreen({super.key});

  @override
  State<ActivityEntryScreen> createState() => _ActivityEntryScreenState();
}

class _ActivityEntryScreenState extends State<ActivityEntryScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _activities = [
    {
      'id': 'act-101',
      'titleEn': 'Level 14 Slab Casting Preparation',
      'titleAr': 'تجهيز صب سقف الطابق 14',
      'area': 'Zone 1 - High Rise Core',
      'discipline': 'Structural / Concrete',
      'progress': 88,
      'status': 'IN_PROGRESS',
      'recentEntries': [
        'Reinforcement steel checked & approved',
        'Post-tensioning tendons profiled'
      ],
      'workerCount': 22,
      'lastUpdated': 'Today 10:30 AM',
    },
    {
      'id': 'act-102',
      'titleEn': 'Basement 2 Chilled Water Pipe Hydrotest',
      'titleAr': 'فحص ضغط شبكة المياه المثلجة بدروم 2',
      'area': 'B2 Central Plant Room',
      'discipline': 'MEP / HVAC',
      'progress': 62,
      'status': 'AWAITING_INSPECTION',
      'recentEntries': [
        '16 bar pressure held for 4 hours',
        'Consultant witness required at 14:00'
      ],
      'workerCount': 8,
      'lastUpdated': 'Today 09:15 AM',
    },
    {
      'id': 'act-103',
      'titleEn': 'Blockwork & Lintel Installation',
      'titleAr': 'أعمال البلوك والأعتاب الإسمنتية',
      'area': 'Level 8 Guest Rooms',
      'discipline': 'Architectural / Masonry',
      'progress': 40,
      'status': 'IN_PROGRESS',
      'recentEntries': [
        'AAC blocks delivery verified (40 pallets)',
        'DPC membrane laid under first course'
      ],
      'workerCount': 16,
      'lastUpdated': 'Yesterday 04:45 PM',
    },
    {
      'id': 'act-104',
      'titleEn': 'Façade Unitized Glass Panel Erection',
      'titleAr': 'تركيب ألواح الواجهات الزجاجية',
      'area': 'North Elevation Grid 4-12',
      'discipline': 'Façade Cladding',
      'progress': 95,
      'status': 'COMPLETED',
      'recentEntries': [
        'Floor brackets torqued & sealants applied',
        'Water-hose infiltration test passed'
      ],
      'workerCount': 14,
      'lastUpdated': 'Today 11:00 AM',
    },
  ];

  void _showQuickEntryModal([Map<String, dynamic>? item]) {
    final areaCtrl = TextEditingController(text: item?['area'] ?? 'Zone 2 - Podium Level');
    final titleCtrl = TextEditingController(text: item?['titleEn'] ?? '');
    String disc = item?['discipline'] ?? 'Structural / Concrete';
    double prog = (item?['progress'] ?? 50).toDouble();
    int workers = item?['workerCount'] ?? 12;
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF151F32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item != null ? 'Update Activity Progress' : 'Log New Site Activity',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Activity Name / Package',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: areaCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Location / Grid / Level',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: disc,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Discipline',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: ['Structural / Concrete', 'MEP / HVAC', 'Architectural / Masonry', 'Façade Cladding', 'QA/QC Inspection']
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setMState(() => disc = v!),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Completion Progress:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text('${prog.toInt()}%', style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Slider(
                value: prog,
                min: 0,
                max: 100,
                activeColor: AppColors.accentCyan,
                inactiveColor: const Color(0xFF1E293B),
                onChanged: (v) => setMState(() => prog = v),
              ),
              Row(
                children: [
                  const Text('Headcount on front:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => setMState(() => workers = workers > 1 ? workers - 1 : 1),
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.accentCyan),
                  ),
                  Text('$workers Men', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setMState(() => workers++),
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.accentCyan),
                  ),
                ],
              ),
              TextField(
                controller: notesCtrl,
                maxLines: 2,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Field Notes & Observations',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text('Save & Sync to Daily DPR', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    setState(() {
                      if (item != null) {
                        item['progress'] = prog.toInt();
                        item['workerCount'] = workers;
                        if (notesCtrl.text.isNotEmpty) {
                          (item['recentEntries'] as List).insert(0, notesCtrl.text);
                        }
                      } else {
                        _activities.insert(0, {
                          'id': 'act-${DateTime.now().millisecondsSinceEpoch % 1000}',
                          'titleEn': titleCtrl.text.isEmpty ? 'General Works' : titleCtrl.text,
                          'titleAr': 'أعمال الموقع',
                          'area': areaCtrl.text,
                          'discipline': disc,
                          'progress': prog.toInt(),
                          'status': 'IN_PROGRESS',
                          'recentEntries': notesCtrl.text.isNotEmpty ? [notesCtrl.text] : ['Field progress logged'],
                          'workerCount': workers,
                          'lastUpdated': 'Just now',
                        });
                      }
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Activity progress recorded and queued for AI synthesis!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _activities.where((a) {
      final matchesFilter = _selectedFilter == 'All' || a['discipline'].toString().contains(_selectedFilter);
      final matchesQuery = _searchQuery.isEmpty ||
          a['titleEn'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a['area'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Field Activity & Daily Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Real-time site data entry & micro-task logging', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showQuickEntryModal(),
            icon: const Icon(Icons.add_circle, color: AppColors.accentCyan),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Action Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFF151F32),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _quickActionChip('Progress %', Icons.build, () => _showQuickEntryModal()),
                  const SizedBox(width: 8),
                  _quickActionChip('Voice Log', Icons.mic, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recording voice memo... Transcribing with Gemini AI')),
                    );
                  }),
                  const SizedBox(width: 8),
                  _quickActionChip('Site Photo', Icons.camera_alt, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera opened: Computer Vision defect inspection')),
                    );
                  }),
                  const SizedBox(width: 8),
                  _quickActionChip('Manpower', Icons.people, () => _showQuickEntryModal()),
                  const SizedBox(width: 8),
                  _quickActionChip('Slump Test', Icons.local_shipping, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ASTM C94 Slump test entry: 150mm recorded')),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Search & Filter
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search by activity, area, or grid axis...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    filled: true,
                    fillColor: const Color(0xFF151F32),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Structural', 'MEP', 'Architectural', 'Façade'].map((filter) {
                      final selected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(filter, style: TextStyle(fontSize: 11, color: selected ? Colors.black : Colors.white)),
                          selected: selected,
                          selectedColor: AppColors.accentCyan,
                          backgroundColor: const Color(0xFF1E293B),
                          onSelected: (s) => setState(() => _selectedFilter = filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final a = filtered[i];
                final prog = a['progress'] as int;
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151F32),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              a['titleEn'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: prog == 100
                                  ? AppColors.verifiedGreen.withValues(alpha: 0.2)
                                  : AppColors.accentCyan.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              a['status'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: prog == 100 ? AppColors.verifiedGreen : AppColors.accentCyan,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(a['area'] as String, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(width: 12),
                          const Icon(Icons.category, size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(a['discipline'] as String, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress: $prog%', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                          Text('${a['workerCount']} Men on Front', style: const TextStyle(color: AppColors.goldEmirates, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: prog / 100.0,
                          backgroundColor: const Color(0xFF1E293B),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            prog == 100 ? AppColors.verifiedGreen : AppColors.accentCyan,
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...(a['recentEntries'] as List).map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: AppColors.accentCyan, fontSize: 12)),
                                Expanded(child: Text(entry, style: const TextStyle(color: Colors.white70, fontSize: 11))),
                              ],
                            ),
                          )),
                      const Divider(color: Color(0xFF1E293B), height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Updated: ${a['lastUpdated']}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          TextButton.icon(
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            icon: const Icon(Icons.edit, size: 14, color: AppColors.accentCyan),
                            label: const Text('Update Progress', style: TextStyle(fontSize: 11, color: AppColors.accentCyan)),
                            onPressed: () => _showQuickEntryModal(a),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionChip(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.accentCyan),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. SMART OFFLINE SYNC (Jetpack Compose: SmartOfflineSyncScreen.kt)
// ---------------------------------------------------------------------------

class OfflineSyncScreen extends StatefulWidget {
  const OfflineSyncScreen({super.key});

  @override
  State<OfflineSyncScreen> createState() => _OfflineSyncScreenState();
}

class _OfflineSyncScreenState extends State<OfflineSyncScreen> {
  bool _isOffline = false;
  bool _isSyncing = false;
  String _conflictPolicy = 'Consultant / Authority Priority';

  final List<Map<String, dynamic>> _syncItems = [
    {
      'id': 'MUT-9941',
      'type': 'DAILY_REPORT',
      'title': 'AI Daily Progress Report - Concrete Pour Zone B',
      'time': '10 mins ago',
      'size': '42.5 KB',
      'status': 'PENDING',
      'retries': 0,
    },
    {
      'id': 'MUT-9938',
      'type': 'SNAG_DEFECT',
      'title': 'Snag #204: Rebar Cover Spacers Missing Level 14',
      'time': '25 mins ago',
      'size': '128.0 KB',
      'status': 'PENDING',
      'retries': 0,
    },
    {
      'id': 'MUT-9930',
      'type': 'RFI_RECORD',
      'title': 'RFI-042: MEP Sleeve Penetration Clash Beam G-4',
      'time': '1 hour ago',
      'size': '34.2 KB',
      'status': 'CONFLICT_RESOLVED',
      'retries': 1,
    },
    {
      'id': 'MUT-9912',
      'type': 'SAFETY_TICKET',
      'title': 'DM 11.4 Anemometer Gust Warning (41.2 km/h)',
      'time': '2 hours ago',
      'size': '18.0 KB',
      'status': 'SYNCED',
      'retries': 0,
    },
  ];

  void _triggerSync() async {
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _isSyncing = false;
      for (var item in _syncItems) {
        item['status'] = 'SYNCED';
      }
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ 4 mutations synchronized with Firestore & SQLite successfully!'),
          backgroundColor: AppColors.verifiedGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _syncItems.where((i) => i['status'] != 'SYNCED').length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Offline Sync & SQLite Cache', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Room / SQLite offline-first with auto background merge', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _triggerSync,
            icon: _isSyncing
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentCyan))
                : const Icon(Icons.sync, color: AppColors.accentCyan),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Offline / Online Mode Toggle Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isOffline ? AppColors.cautionAmber : AppColors.verifiedGreen,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isOffline ? Icons.cloud_off : Icons.cloud_done,
                  color: _isOffline ? AppColors.cautionAmber : AppColors.verifiedGreen,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isOffline ? 'SIMULATED OFFLINE MODE (No Network)' : 'ONLINE - SYNCING TO CLOUD',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _isOffline ? AppColors.cautionAmber : AppColors.verifiedGreen,
                        ),
                      ),
                      Text(
                        _isOffline
                            ? 'Mutations queued locally in SQLite database'
                            : 'All transactions synchronized with Google Cloud backend',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isOffline,
                  activeColor: AppColors.cautionAmber,
                  onChanged: (v) => setState(() => _isOffline = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Cache Statistics Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.storage, color: AppColors.accentCyan, size: 18),
                    SizedBox(width: 8),
                    Text('Local Storage & Cache Telemetry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  ],
                ),
                const Divider(color: Color(0xFF334155), height: 20),
                _statRow('Local SQLite DB Size', '142.8 MB (Optimized)'),
                _statRow('Cached BIM Models & IFC', '18 Models (Offline Ready)'),
                _statRow('Local Drawing PDFs & Vault', '245 Sheets cached'),
                _statRow('Pending Outbox Mutations', '$pendingCount Transactions', pendingCount > 0 ? AppColors.cautionAmber : AppColors.verifiedGreen),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Conflict Resolution Policy
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Conflict Resolution Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _conflictPolicy,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: [
                    'Consultant / Authority Priority',
                    'Last Write Wins (LWW Timestamp)',
                    'Site Supervisor Override',
                  ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (v) => setState(() => _conflictPolicy = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Outbox Sync Queue List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Outbox Mutation Queue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
              Text('$pendingCount Pending', style: const TextStyle(color: AppColors.accentCyan, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ..._syncItems.map((item) {
            Color statusColor;
            switch (item['status']) {
              case 'SYNCED':
                statusColor = AppColors.verifiedGreen;
                break;
              case 'CONFLICT_RESOLVED':
                statusColor = AppColors.accentCyan;
                break;
              default:
                statusColor = AppColors.cautionAmber;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['type'],
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.accentCyan),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                        Text('${item['time']} • ${item['size']}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      item['status'],
                      style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isSyncing
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : const Icon(Icons.sync),
              label: Text(
                _isSyncing ? 'Synchronizing Outbox...' : 'Trigger Full Cloud Sync Now',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _isSyncing ? null : _triggerSync,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, [Color? valColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: TextStyle(color: valColor ?? Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. WORKER WELFARE & COMPLIANCE (Jetpack Compose: WorkerWelfareScreen.kt)
// ---------------------------------------------------------------------------

class WelfareScreen extends StatelessWidget {
  const WelfareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Worker Welfare & Compliance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Accommodation, heat-stress, WPS payroll & safety passports', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // WPS Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.accentCyan,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WPS Payroll Reconciliation: 100% Compliant',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accentCyan),
                          ),
                          Text(
                            'Central Bank UAE Wage Protection System verified for Sep 2026',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF1E293B), height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Active Workers: 1,420', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                    Text('Accommodation Camps: 3 audited', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _welfareCard(
            title: 'Heat Stress & Hydration Monitoring',
            icon: Icons.water_drop,
            color: AppColors.accentCyan,
            bullets: [
              'Automated electrolyte station reminders dispatched every 45 mins',
              'Wet Bulb Globe Temperature (WBGT) sensors active across 6 zones',
              'Zero heat-exhaustion incidents recorded this quarter',
            ],
          ),
          const SizedBox(height: 10),
          _welfareCard(
            title: 'Worker Safety Passports & Visa Expiry Alerts',
            icon: Icons.badge,
            color: AppColors.goldEmirates,
            bullets: [
              'Emirates ID & Labour Card status: 100% valid',
              'Mandatory Toolbox Talks: 14 sessions completed this week',
              'Medical fitness certificates current for all crane & hoist operators',
            ],
          ),
          const SizedBox(height: 10),
          _welfareCard(
            title: 'Midday Break Shaded Cool Rooms',
            icon: Icons.ac_unit,
            color: AppColors.verifiedGreen,
            bullets: [
              '3 Air-conditioned rest pavilions active on site with ice electrolyte distribution',
              'Compliant with MOHRE ministerial resolution on summer working hours',
              'Thermal imaging inspection logged at 12:30 PM daily',
            ],
          ),
          const SizedBox(height: 10),
          _welfareCard(
            title: 'Labor Accommodation Inspection (Sonapur & Al Quoz)',
            icon: Icons.hotel,
            color: AppColors.verifiedGreen,
            bullets: [
              'Dubai Municipality & MOHRE Joint Audit: Grade A rating',
              'Catering hygiene & potable water filtration tested weekly',
              'Dedicated recreation room & high-speed Wi-Fi provided',
            ],
          ),
          const SizedBox(height: 10),
          _welfareCard(
            title: 'Medical Clinic & First Aid Evacuation',
            icon: Icons.local_hospital,
            color: AppColors.criticalRed,
            bullets: [
              'Licensed registered paramedic stationed on Level Ground 24/7',
              'Emergency ambulance direct link with Dubai Health Authority',
              'Automated External Defibrillator (AED) tested on 1st of every month',
            ],
          ),
        ],
      ),
    );
  }

  Widget _welfareCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> bullets,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151F32),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: color, fontSize: 12)),
                    Expanded(
                      child: Text(b, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. ESG & GREEN SUSTAINABILITY (Jetpack Compose: EsgSustainabilityScreen.kt)
// ---------------------------------------------------------------------------

class EsgScreen extends StatelessWidget {
  const EsgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ESG & Green Sustainability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Carbon tracking, Estidama / LEED & waste recycling logs', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Carbon Footprint Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.verifiedGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.verifiedGreen, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.verifiedGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.eco, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Carbon Footprint: -18.4% vs Baseline',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.verifiedGreen),
                          ),
                          Text(
                            'Estidama 4-Pearl & LEED Gold Certification Target',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF1E293B), height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Embodied Carbon: 420 kgCO2e/m²', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                    Text('Recycled Materials: 34.2%', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _esgCard(
            title: 'Waste-to-Asset & Recycling Logs',
            icon: Icons.recycling,
            bullets: [
              'Concrete Rubble Diverted: 1,420 Tons (Crushed for sub-base roads)',
              'Steel Scrap Recycled: 310 Tons (Emirates Steel circular loop)',
              'Timber & Packaging Waste: 88 Tons sorted & salvaged',
              'Total Landfill Diversion Rate: 84.6% achieved',
            ],
          ),
          const SizedBox(height: 10),
          _esgCard(
            title: 'Energy & Water Conservation Dashboard',
            icon: Icons.bolt,
            bullets: [
              'Solar Tower Lighting: 45 units active (saving 120L diesel/day)',
              'Greywater Treatment Plant on site: 65% recycled for dust suppression',
              'Variable Frequency Drive (VFD) tower cranes reduce peak grid demand by 28%',
            ],
          ),
          const SizedBox(height: 10),
          _esgCard(
            title: 'Al Sa\'fat Dubai Green Building Regulations',
            icon: Icons.apartment,
            bullets: [
              'Low-VOC paints & sealants verified for 100% of internal finishes',
              'Regional materials sourcing: 48% sourced within 500km radius',
              'DEWA Smart Meters installed for real-time sub-metering of temporary power',
            ],
          ),
        ],
      ),
    );
  }

  Widget _esgCard({required String title, required IconData icon, required List<String> bullets}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151F32),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.verifiedGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white))),
            ],
          ),
          const SizedBox(height: 10),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 12)),
                    Expanded(child: Text(b, style: const TextStyle(fontSize: 11, color: Colors.white70))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. GREEN WALLET & ENERGY CERTIFICATES (Jetpack Compose: GreenWalletAndEnergyCertificatesScreen.kt)
// ---------------------------------------------------------------------------

class GreenWalletScreen extends StatefulWidget {
  const GreenWalletScreen({super.key});

  @override
  State<GreenWalletScreen> createState() => _GreenWalletScreenState();
}

class _GreenWalletScreenState extends State<GreenWalletScreen> {
  int _selectedTab = 0; // 0: All, 1: Active I-REC, 2: Retired for Audit

  final List<Map<String, dynamic>> _certificates = [
    {
      'id': 'rec-001',
      'certNumber': 'DXB-REC-2026-881',
      'source': 'Solar PV (MBR Solar Park)',
      'sourceAr': 'طاقة شمسية كهرودوئية (مجمع محمد بن راشد)',
      'issuer': 'Dubai Electricity & Water Authority (DEWA)',
      'volumeMwh': 450.0,
      'co2OffsetTons': 243.0,
      'status': 'ACTIVE_CERTIFIED',
      'expiry': 'Dec 2027',
    },
    {
      'id': 'rec-002',
      'certNumber': 'ONS-SOLAR-004',
      'source': 'On-Site Hybrid Solar Generators',
      'sourceAr': 'محطات طاقة شمسية هجينة بموقع العمل',
      'issuer': 'Orion Clean Energy',
      'volumeMwh': 120.0,
      'co2OffsetTons': 69.6,
      'status': 'ACTIVE_CERTIFIED',
      'expiry': 'Nov 2027',
    },
    {
      'id': 'rec-003',
      'certNumber': 'DEWA-HYD-991',
      'source': 'DEWA Green Hydrogen Power',
      'sourceAr': 'كهرباء الهيدروجين الأخضر النظيف (ديوا)',
      'issuer': 'DEWA Expo Facility',
      'volumeMwh': 300.0,
      'co2OffsetTons': 186.0,
      'status': 'RETIRED_FOR_AUDIT',
      'expiry': 'Retired for Al Sa\'fat Audit',
    },
    {
      'id': 'rec-004',
      'certNumber': 'IREC-UAE-4412',
      'source': 'DEWA Certified Green Grid (I-REC)',
      'sourceAr': 'شهادات شبكة ديوا الخضراء المعتمدة (I-REC)',
      'issuer': 'International REC Standard',
      'volumeMwh': 970.0,
      'co2OffsetTons': 485.0,
      'status': 'ACTIVE_CERTIFIED',
      'expiry': 'Jan 2028',
    },
  ];

  void _retireCertificate(Map<String, dynamic> cert) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151F32),
        title: const Text('Retire for Al Sa\'fat Audit', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'Are you sure you want to retire certificate ${cert['certNumber']} (${cert['volumeMwh']} MWh) for Dubai Municipality green building audit? This action is immutable.',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
            onPressed: () {
              setState(() {
                cert['status'] = 'RETIRED_FOR_AUDIT';
                cert['expiry'] = 'Retired for Al Sa\'fat Audit';
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Certificate retired and token locked for Estidama/LEED auditor')),
              );
            },
            child: const Text('Confirm Retirement'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _certificates.where((c) {
      if (_selectedTab == 1) return c['status'] == 'ACTIVE_CERTIFIED';
      if (_selectedTab == 2) return c['status'] == 'RETIRED_FOR_AUDIT';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Green Wallet & I-REC Certificates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('DEWA clean electricity tokens & carbon offset registry', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Wallet Balance Header
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF104030), Color(0xFF151F32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CLEAN ENERGY TOKENS', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('1,840.0 MWh', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.eco, color: AppColors.verifiedGreen, size: 16),
                          SizedBox(width: 4),
                          Text('983.6 tCO2e', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF1E293B), height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active Certificates: 3', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    Text('Retired for Al Sa\'fat: 1', style: TextStyle(color: AppColors.accentCyan, fontSize: 11)),
                    Text('Registry: DEWA / I-REC', style: TextStyle(color: AppColors.goldEmirates, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: ['All Certificates', 'Active (I-REC)', 'Retired for Audit'].asMap().entries.map((entry) {
                final idx = entry.key;
                final label = entry.value;
                final sel = _selectedTab == idx;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      label: Text(label, style: TextStyle(fontSize: 10, color: sel ? Colors.black : Colors.white)),
                      selected: sel,
                      selectedColor: AppColors.accentCyan,
                      backgroundColor: const Color(0xFF1E293B),
                      onSelected: (_) => setState(() => _selectedTab = idx),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Certificates List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final c = filtered[i];
                final isRetired = c['status'] == 'RETIRED_FOR_AUDIT';

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151F32),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isRetired ? AppColors.accentCyan.withValues(alpha: 0.4) : const Color(0xFF1E293B),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c['source'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                                Text(c['sourceAr'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (isRetired ? AppColors.accentCyan : AppColors.verifiedGreen).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isRetired ? 'RETIRED FOR AUDIT' : 'ACTIVE & VALID',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isRetired ? AppColors.accentCyan : AppColors.verifiedGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF1E293B), height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Volume MWh', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              Text('${c['volumeMwh']} MWh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CO2e Offset', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              Text('${c['co2OffsetTons']} Tons', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.verifiedGreen)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Certificate #', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              Text(c['certNumber'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.goldEmirates)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Issuer: ${c['issuer']}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(c['expiry'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          if (!isRetired)
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.accentCyan,
                                side: const BorderSide(color: AppColors.accentCyan),
                                visualDensity: VisualDensity.compact,
                              ),
                              icon: const Icon(Icons.lock_clock, size: 14),
                              label: const Text('Retire for Audit', style: TextStyle(fontSize: 11)),
                              onPressed: () => _retireCertificate(c),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. ORION GREEN PASS (Jetpack Compose: OrionGreenPassScreen.kt)
// ---------------------------------------------------------------------------

class GreenPassScreen extends StatefulWidget {
  const GreenPassScreen({super.key});

  @override
  State<GreenPassScreen> createState() => _GreenPassScreenState();
}

class _GreenPassScreenState extends State<GreenPassScreen> {
  bool _isReviewerMode = false;

  final List<Map<String, dynamic>> _passes = [
    {
      'id': 'GP-001',
      'entity': 'Al Naboodah Construction Group',
      'trade': 'Main Contractor - Tier 1',
      'tier': 'PLATINUM',
      'status': 'ACTIVE_VALID',
      'audits': '12/12 Passed',
      'co2Score': '94/100',
      'reviewer': 'Eng. Fatima Al Mansoori',
    },
    {
      'id': 'GP-002',
      'entity': 'Unibeton Ready Mix',
      'trade': 'Concrete & Batching Supplier',
      'tier': 'GOLD',
      'status': 'ACTIVE_VALID',
      'audits': '8/8 Passed',
      'co2Score': '88/100',
      'reviewer': 'Eng. Tariq Al Hashimi',
    },
    {
      'id': 'GP-003',
      'entity': 'Emirates Steel Arkan',
      'trade': 'Rebar & Steel Manufacturer',
      'tier': 'PLATINUM',
      'status': 'UNDER_AUDIT',
      'audits': 'Annual Recertification in Progress',
      'co2Score': '91/100',
      'reviewer': 'Eng. Tariq Al Hashimi',
    },
    {
      'id': 'GP-004',
      'entity': 'Drake & Scull Engineering',
      'trade': 'MEP Specialist Subcontractor',
      'tier': 'SILVER',
      'status': 'ACTIVE_VALID',
      'audits': '6/6 Passed',
      'co2Score': '79/100',
      'reviewer': 'Dr. Rashid Al Nuaimi',
    },
  ];

  void _showApplyModal() {
    final entityCtrl = TextEditingController();
    final licenseCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151F32),
        title: const Text('Apply for ORION Green Pass', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ORIONB Green Pass is an industrial compliance credential verifying sustainability audits, WPS wage records, and safety compliance. (Not a government pass).',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: entityCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(labelText: 'Company / Organization Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: licenseCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(labelText: 'UAE Trade License Number', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Application submitted! Compliance auditor will review credentials.')),
              );
            },
            child: const Text('Submit Application'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ORION Green Pass Credentials', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Human Reviewer Controlled • Zero Auto-Penalties', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showApplyModal,
            icon: const Icon(Icons.add_card, color: AppColors.accentCyan),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Explicit Disclaimer Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.goldEmirates.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.goldEmirates, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'NOTICE: ORION Green Pass is an internal industrial qualification. It is NOT a government pass or municipal certification. Data minimization strictly applied.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ),
                Switch(
                  value: _isReviewerMode,
                  activeColor: AppColors.accentCyan,
                  onChanged: (v) => setState(() => _isReviewerMode = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Credentials List
          ..._passes.map((p) {
            final isPlatinum = p['tier'] == 'PLATINUM';
            final tierColor = isPlatinum ? AppColors.accentCyan : (p['tier'] == 'GOLD' ? AppColors.goldEmirates : Colors.grey);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF151F32),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          p['entity'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: tierColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: tierColor),
                        ),
                        child: Text(
                          p['tier'] as String,
                          style: TextStyle(color: tierColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(p['trade'] as String, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const Divider(color: Color(0xFF1E293B), height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Audits: ${p['audits']}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text('Sustainability: ${p['co2Score']}', style: const TextStyle(color: AppColors.verifiedGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reviewer: ${p['reviewer']}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('Credential ID: ${p['id']}', style: const TextStyle(color: AppColors.accentCyan, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. PHASED ROADMAP & DECISION GATES (Jetpack Compose: OrionRoadmapScreen.kt)
// ---------------------------------------------------------------------------

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  int _selectedTab = 0; // 0: All Phases, 1: Active, 2: Decision Gates, 3: Summary

  final List<Map<String, dynamic>> _phases = [
    {
      'phase': 0,
      'titleEn': 'Site Mobilization & Enabling Works',
      'titleAr': 'التجهيز الموقعي والأعمال التمهيدية',
      'duration': 'Month 1-2',
      'status': 'COMPLETED',
      'gate': 'Gate 0: Site Access & Logistics Clearance',
      'deliverables': ['Site Hoarding & Offices', 'Dewatering Permits', 'Temporary Power & Water DEWA'],
    },
    {
      'phase': 1,
      'titleEn': 'Substructure & Piling Works',
      'titleAr': 'أعمال الأساسات والأوتاد الخرسانية',
      'duration': 'Month 3-5',
      'status': 'COMPLETED',
      'gate': 'Gate 1: Foundation Integrity & Raft Approval',
      'deliverables': ['184 Friction Piles Tested', 'Raft Concrete 4,200m³', 'Subterranean Waterproofing'],
    },
    {
      'phase': 2,
      'titleEn': 'Superstructure Concrete Core & Slabs',
      'titleAr': 'الهيكل الخرساني والأعمدة والأسقف',
      'duration': 'Month 6-12',
      'status': 'ACTIVE',
      'gate': 'Gate 2: Mid-Structure Structural Audit',
      'deliverables': ['Levels 1–28 Cast', 'Post-Tension Stressing Logs', 'Cube Crushing Strength 50MPa'],
    },
    {
      'phase': 3,
      'titleEn': 'Building Envelope & Unitized Façade',
      'titleAr': 'واجهات المبنى والتكسيات الزجاجية',
      'duration': 'Month 10-15',
      'status': 'ACTIVE',
      'gate': 'Gate 3: Water Tightness & CWCT Certification',
      'deliverables': ['Al Ghurair Façade Panels', 'Thermal Break Double Glazing', 'BMU Cradle Access'],
    },
    {
      'phase': 4,
      'titleEn': 'MEP 1st & 2nd Fix Services',
      'titleAr': 'التمديدات الكهروميكانيكية الأساسية',
      'duration': 'Month 11-16',
      'status': 'UPCOMING',
      'gate': 'Gate 4: Hydrostatic & Insulation Test Clearance',
      'deliverables': ['Chilled Water Risers', 'HVAC Ducting & VAVs', 'Fire Alarm & Sprinkler Networks'],
    },
    {
      'phase': 5,
      'titleEn': 'Testing, Commissioning & Authority Handover',
      'titleAr': 'الفحوصات والتشغيل واعتماد الدفاع المدني',
      'duration': 'Month 16-18',
      'status': 'UPCOMING',
      'gate': 'Gate 5: Civil Defense (DCD) & Municipality (BCC)',
      'deliverables': ['Building Completion Certificate', 'Smoke Evacuation Verification', 'Final Snag Clearance'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phased Roadmap & Decision Gates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('14 Phases • 12-18 Months • Formal Gates 0-12', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tab selection
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF151F32),
            child: Row(
              children: ['All Phases', 'Active Workfronts', 'Decision Gates', 'Roadmap Summary'].asMap().entries.map((entry) {
                final idx = entry.key;
                final label = entry.value;
                final sel = _selectedTab == idx;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ChoiceChip(
                      label: Text(label, style: TextStyle(fontSize: 9, color: sel ? Colors.black : Colors.white)),
                      selected: sel,
                      selectedColor: AppColors.accentCyan,
                      backgroundColor: const Color(0xFF1E293B),
                      onSelected: (_) => setState(() => _selectedTab = idx),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Phase List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _phases.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final p = _phases[i];
                final isComp = p['status'] == 'COMPLETED';
                final isActive = p['status'] == 'ACTIVE';

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151F32),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isActive ? AppColors.accentCyan : const Color(0xFF1E293B),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isComp
                                      ? AppColors.verifiedGreen
                                      : (isActive ? AppColors.accentCyan : const Color(0xFF1E293B)),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'P${p['phase']}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: (isComp || isActive) ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['titleEn'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                                  Text(p['duration'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isComp
                                  ? AppColors.verifiedGreen.withValues(alpha: 0.15)
                                  : (isActive ? AppColors.accentCyan.withValues(alpha: 0.15) : const Color(0xFF1E293B)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              p['status'] as String,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isComp ? AppColors.verifiedGreen : (isActive ? AppColors.accentCyan : Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.rule, color: AppColors.goldEmirates, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                p['gate'] as String,
                                style: const TextStyle(color: AppColors.goldEmirates, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(p['deliverables'] as List).map((d) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                const Text('• ', style: TextStyle(color: AppColors.accentCyan, fontSize: 11)),
                                Expanded(child: Text(d, style: const TextStyle(color: Colors.white70, fontSize: 11))),
                              ],
                            ),
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 11. RISK HEAT MAP 5x5 (Jetpack Compose: RiskHeatMapScreen.kt)
// ---------------------------------------------------------------------------

class RiskHeatMapFullScreen extends StatefulWidget {
  const RiskHeatMapFullScreen({super.key});

  @override
  State<RiskHeatMapFullScreen> createState() => _RiskHeatMapFullScreenState();
}

class _RiskHeatMapFullScreenState extends State<RiskHeatMapFullScreen> {
  int _selectedTab = 0; // 0: Matrix Grid, 1: Risk Register, 2: AI Strategies
  // selectedCategory

  final List<Map<String, dynamic>> _risks = [
    {
      'id': 'RSK-01',
      'titleEn': 'Curtain Wall Glazing Maritime Logistics Delay',
      'titleAr': 'تأخر شحن زجاج الواجهات عبر الموانئ',
      'category': 'SUPPLY_CHAIN',
      'prob': 4,
      'impact': 5,
      'owner': 'Procurement Lead',
      'mitigation': 'Issue urgent secondary purchase order to Dubai supplier',
    },
    {
      'id': 'RSK-02',
      'titleEn': 'Summer Heat Midday Ban Labor Productive Slump',
      'titleAr': 'انخفاض إنتاجية العمالة بفترة حظر العمل الصيفي',
      'category': 'SAFETY',
      'prob': 5,
      'impact': 3,
      'owner': 'Site Superintendent',
      'mitigation': 'Shift to night-time pours and shade pavilions',
    },
    {
      'id': 'RSK-03',
      'titleEn': 'MEP Corridor Axis F4 Structural Penetration Clash',
      'titleAr': 'تعارض مواسير التكييف مع الجسور الخرسانية محو F4',
      'category': 'QUALITY',
      'prob': 3,
      'impact': 4,
      'owner': 'MEP Coordinator',
      'mitigation': 'Reroute chilled water pipes with 45-degree offset',
    },
    {
      'id': 'RSK-04',
      'titleEn': 'Steel Rebar Market Price Surcharge Fluctuation',
      'titleAr': 'تذبذب أسعار حديد التسليح في السوق الإماراتي',
      'category': 'FINANCIAL',
      'prob': 3,
      'impact': 3,
      'owner': 'Commercial Director',
      'mitigation': 'Hedging contract locked with Emirates Steel',
    },
    {
      'id': 'RSK-05',
      'titleEn': 'Tower Crane High Wind Gust Warning > 40 km/h',
      'titleAr': 'رياح شديدة تعطل رافعات الأبراج (> 40 كم/س)',
      'category': 'SCHEDULE',
      'prob': 4,
      'impact': 2,
      'owner': 'HSE Manager',
      'mitigation': 'Anemometer telemetry automatic crane slewing brakes',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Construction Risk Heat Map & Matrix', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('5x5 Probability × Impact Risk Engine', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Top Metrics Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFF151F32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metricTile('Total Risks', '${_risks.length}', Colors.white),
                _metricTile('Critical (Score ≥15)', '2', AppColors.criticalRed),
                _metricTile('High (Score 10-14)', '1', AppColors.cautionAmber),
                _metricTile('Moderate (Score <10)', '2', AppColors.verifiedGreen),
              ],
            ),
          ),

          // Tabs
          Row(
            children: ['5x5 Matrix Grid', 'Risk Register', 'AI Mitigation'].asMap().entries.map((entry) {
              final idx = entry.key;
              final label = entry.value;
              final sel = _selectedTab == idx;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedTab = idx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: sel ? AppColors.accentCyan : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: sel ? AppColors.accentCyan : Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          Expanded(
            child: _selectedTab == 0 ? _buildMatrixGrid() : _buildRiskList(),
          ),
        ],
      ),
    );
  }

  Widget _metricTile(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMatrixGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Impact (1 = Low, 5 = Critical)', style: TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          for (int impact = 5; impact >= 1; impact--)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text('$impact', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  for (int prob = 1; prob <= 5; prob++)
                    Expanded(
                      child: Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: _getCellColor(prob, impact),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: _getRiskCountInCell(prob, impact) > 0
                            ? Text(
                                '${_getRiskCountInCell(prob, impact)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                              )
                            : null,
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 24),
              for (int prob = 1; prob <= 5; prob++)
                Expanded(
                  child: Center(
                    child: Text('$prob', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ),
                ),
            ],
          ),
          const Center(child: Text('Probability (1 = Rare, 5 = Frequent)', style: TextStyle(color: Colors.grey, fontSize: 11))),
        ],
      ),
    );
  }

  Color _getCellColor(int p, int i) {
    final score = p * i;
    if (score >= 15) return AppColors.criticalRed.withValues(alpha: 0.8);
    if (score >= 10) return AppColors.cautionAmber.withValues(alpha: 0.8);
    if (score >= 5) return Colors.amber.withValues(alpha: 0.5);
    return AppColors.verifiedGreen.withValues(alpha: 0.5);
  }

  int _getRiskCountInCell(int p, int i) {
    return _risks.where((r) => r['prob'] == p && r['impact'] == i).length;
  }

  Widget _buildRiskList() {
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: _risks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final r = _risks[i];
        final score = (r['prob'] as int) * (r['impact'] as int);
        Color badgeColor = score >= 15 ? AppColors.criticalRed : (score >= 10 ? AppColors.cautionAmber : AppColors.verifiedGreen);

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF151F32),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(r['titleEn'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Score $score (P${r['prob']}×I${r['impact']})',
                      style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Category: ${r['category']} • Owner: ${r['owner']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const Divider(color: Color(0xFF1E293B), height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield, color: AppColors.accentCyan, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Mitigation: ${r['mitigation']}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 12. MARKET INTELLIGENCE & PRICE ENGINE (Jetpack Compose: MarketIntelligenceScreen.kt)
// ---------------------------------------------------------------------------

class MarketIntelScreen extends StatefulWidget {
  const MarketIntelScreen({super.key});

  @override
  State<MarketIntelScreen> createState() => _MarketIntelScreenState();
}

class _MarketIntelScreenState extends State<MarketIntelScreen> {
  final _queryCtrl = TextEditingController();
  bool _isQuerying = false;
  String? _aiResponse;

  final List<Map<String, dynamic>> _commodities = [
    {
      'id': 'm1',
      'nameEn': 'Steel Rebar (High Tensile 12-32mm)',
      'nameAr': 'حديد تسليح (فولاذ عالي الشد 12-32 مم)',
      'unit': 'Metric Ton',
      'price': 2480.0,
      'change': -1.8,
      'signal': 'BUY',
    },
    {
      'id': 'm2',
      'nameEn': 'Ready-Mix Concrete (C40 Sulphate Resisting)',
      'nameAr': 'خرسانة جاهزة (C40 مقاوم للأملاح)',
      'unit': 'Cubic Meter',
      'price': 310.0,
      'change': 0.5,
      'signal': 'HOLD',
    },
    {
      'id': 'm3',
      'nameEn': 'Ordinary Portland Cement (CEM I 42.5)',
      'nameAr': 'أسمنت بورتلاندي عادي (فئة 42.5)',
      'unit': 'Metric Ton',
      'price': 385.0,
      'change': 1.2,
      'signal': 'WAIT',
    },
    {
      'id': 'm4',
      'nameEn': 'Aluminum Composite Panels (ACP Cladding)',
      'nameAr': 'ألوح الألمنيوم المركبة للواجهات (ACP)',
      'unit': 'Sq. Meter',
      'price': 115.0,
      'change': -2.4,
      'signal': 'BUY',
    },
    {
      'id': 'm5',
      'nameEn': 'Electrical Copper Cabling (99.9% Purity)',
      'nameAr': 'نحاس الكابلات الكهربائية (عالي النقاء)',
      'unit': 'Kilogram',
      'price': 36.5,
      'change': 3.8,
      'signal': 'WAIT',
    },
  ];

  void _askAi() async {
    if (_queryCtrl.text.isEmpty) return;
    setState(() {
      _isQuerying = true;
      _aiResponse = null;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _isQuerying = false;
      _aiResponse = 'Gemini Market Intelligence: Based on GCC scrap import duties and iron ore trends, steel rebar is forecasted to rebound +2.5% next month. Recommendation: Lock 2-month bulk supply orders at current AED 2,480/ton price.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Market Intelligence & Price Engine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Big Data analytics & UAE/GCC supplier price indices', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.goldEmirates.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.goldEmirates.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bar_chart, color: AppColors.goldEmirates, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GCC LIVE COMMODITY INDEX', style: TextStyle(color: AppColors.goldEmirates, fontSize: 11, fontWeight: FontWeight.bold)),
                      Text('Live Price Benchmarks for UAE Contractors', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // AI Query Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.accentCyan, size: 16),
                    SizedBox(width: 6),
                    Text('AI Commodity Procurement Advisor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _queryCtrl,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'e.g. Will concrete prices increase next quarter?',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 11),
                          filled: true,
                          fillColor: const Color(0xFF1E293B),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: AppColors.accentCyan),
                      onPressed: _isQuerying ? null : _askAi,
                      icon: _isQuerying
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Icon(Icons.send, color: Colors.black, size: 18),
                    ),
                  ],
                ),
                if (_aiResponse != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
                    ),
                    child: Text(_aiResponse!, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Price Index Cards
          const Text('Material Price Index & Signals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          const SizedBox(height: 8),
          ..._commodities.map((m) {
            final change = m['change'] as double;
            final isNeg = change < 0;
            final sig = m['signal'] as String;
            Color sigColor = sig == 'BUY' ? AppColors.verifiedGreen : (sig == 'HOLD' ? AppColors.cautionAmber : AppColors.criticalRed);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF151F32),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['nameEn'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                        Text(m['nameAr'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        const SizedBox(height: 4),
                        Text('Per ${m['unit']}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('AED ${m['price']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                      Row(
                        children: [
                          Icon(isNeg ? Icons.trending_down : Icons.trending_up, size: 14, color: isNeg ? AppColors.verifiedGreen : AppColors.criticalRed),
                          Text(
                            '${change > 0 ? '+' : ''}$change%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isNeg ? AppColors.verifiedGreen : AppColors.criticalRed,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: sigColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(sig, style: TextStyle(color: sigColor, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 13. PREDICTIVE DELAY SCREEN (Jetpack Compose: PredictiveDelayScreen.kt)
// ---------------------------------------------------------------------------

class PredictiveDelayFullScreen extends StatefulWidget {
  const PredictiveDelayFullScreen({super.key});

  @override
  State<PredictiveDelayFullScreen> createState() => _PredictiveDelayFullScreenState();
}

class _PredictiveDelayFullScreenState extends State<PredictiveDelayFullScreen> {
  final List<Map<String, dynamic>> _delays = [
    {
      'id': 'rf-01',
      'titleEn': 'Unitized Curtain Wall Submittal Approval Lag',
      'titleAr': 'تأخير اعتماد مواد الواجهات الزجاجية (Unitized Glass)',
      'category': 'Procurement & Submittals',
      'prob': 78,
      'delayDays': 18,
      'impactAed': 1250000.0,
      'severity': 'CRITICAL',
      'mitigation': 'Issue urgent purchase order to secondary Dubai-approved supplier and expedite consultant audit',
      'mitigated': false,
    },
    {
      'id': 'rf-02',
      'titleEn': 'Summer Heat Wave Impact on Mass Concrete Pours',
      'titleAr': 'موجة الحر الصيفية وتأثيرها على صب الخرسانة الكتلية',
      'category': 'Site Operations',
      'prob': 65,
      'delayDays': 7,
      'impactAed': 450000.0,
      'severity': 'HIGH',
      'mitigation': 'Switch to night-time pouring with ice flake additives and chilled ready-mix water',
      'mitigated': false,
    },
    {
      'id': 'rf-03',
      'titleEn': 'MEP Testing & Commissioning Schedule Bottleneck',
      'titleAr': 'ضغط جدول الفحوصات الكهروميكانيكية (MEP Testing)',
      'category': 'MEP & Quality',
      'prob': 72,
      'delayDays': 14,
      'impactAed': 820000.0,
      'severity': 'HIGH',
      'mitigation': 'Deploy 24/7 auxiliary testing crews and pre-coordinate with Civil Defense inspectors',
      'mitigated': false,
    },
    {
      'id': 'rf-04',
      'titleEn': 'Maritime Congestion & High-Speed Elevator Shipment Lag',
      'titleAr': 'ازدحام الشحن البحري وتأخر توريد مصاعد التروس الهوائية',
      'category': 'Supply Chain',
      'prob': 58,
      'delayDays': 22,
      'impactAed': 1950000.0,
      'severity': 'CRITICAL',
      'mitigation': 'Air-freight critical motor components and split installation into parallel workfronts',
      'mitigated': false,
    },
  ];

  void _executeMitigation(Map<String, dynamic> delay) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151F32),
        title: const Text('Execute AI Mitigation Action', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(delay['titleEn'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Text('Action: ${delay['mitigation']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            Text('Recovered Days: ${delay['delayDays']} Days', style: const TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
            onPressed: () {
              setState(() => delay['mitigated'] = true);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Mitigation executed! Baseline schedule updated.')),
              );
            },
            child: const Text('Execute Mitigation'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Predictive Delay & Early Warning Engine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Monte Carlo 1,000 simulations & proactive mitigation', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Early Warning Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.criticalRed.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.criticalRed, width: 1.5),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('EARLY WARNING SIGNAL', style: TextStyle(color: AppColors.criticalRed, fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('Monte Carlo Simulation', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                SizedBox(height: 8),
                Text('61 Days Cumulative Schedule Risk', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 4),
                Text('Total Financial Risk Exposure: AED 4,470,000', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Factors List
          const Text('Identified Critical Delay Risk Factors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          const SizedBox(height: 8),
          ..._delays.map((d) {
            final isCrit = d['severity'] == 'CRITICAL';
            final isMit = d['mitigated'] as bool;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF151F32),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isMit ? AppColors.verifiedGreen : (isCrit ? AppColors.criticalRed.withValues(alpha: 0.5) : const Color(0xFF1E293B)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(d['titleEn'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isMit
                              ? AppColors.verifiedGreen.withValues(alpha: 0.15)
                              : (isCrit ? AppColors.criticalRed.withValues(alpha: 0.15) : AppColors.cautionAmber.withValues(alpha: 0.15)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isMit ? 'MITIGATED' : d['severity'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isMit ? AppColors.verifiedGreen : (isCrit ? AppColors.criticalRed : AppColors.cautionAmber),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(d['category'] as String, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const Divider(color: Color(0xFF1E293B), height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Expected Delay: ${d['delayDays']} Days', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('Impact: AED ${((d['impactAed'] as double) / 1000).toInt()}k', style: const TextStyle(color: AppColors.criticalRed, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Mitigation: ${d['mitigation']}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMit ? const Color(0xFF1E293B) : AppColors.accentCyan,
                        foregroundColor: isMit ? Colors.grey : Colors.black,
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: Icon(isMit ? Icons.check_circle : Icons.flash_on, size: 14),
                      label: Text(isMit ? 'Mitigation Active' : 'Execute Mitigation Plan', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: isMit ? null : () => _executeMitigation(d),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 14. HISTORICAL GANTT BASELINE SCREEN (Jetpack Compose: HistoricalGanttBaselineScreen.kt)
// ---------------------------------------------------------------------------

class GanttBaselineScreen extends StatefulWidget {
  const GanttBaselineScreen({super.key});

  @override
  State<GanttBaselineScreen> createState() => _GanttBaselineScreenState();
}

class _GanttBaselineScreenState extends State<GanttBaselineScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'phase': 'Substructure & Piling',
      'volume': '4,500 m³ Concrete',
      'duration': '60 Days',
      'progress': 100,
      'isCritical': false,
    },
    {
      'phase': 'Superstructure Concrete Columns & Slabs',
      'volume': '28,000 m³ Concrete, 4,200 Tons Rebar',
      'duration': '180 Days',
      'progress': 48,
      'isCritical': true,
    },
    {
      'phase': 'Unitized Façade Curtain Wall',
      'volume': '14,500 m² Glazing',
      'duration': '120 Days',
      'progress': 20,
      'isCritical': true,
    },
    {
      'phase': 'MEP Primary Chilled Water & Power Risers',
      'volume': '18 Risers, 4 Plant Rooms',
      'duration': '90 Days',
      'progress': 35,
      'isCritical': false,
    },
    {
      'phase': 'Testing, Commissioning & Authority BCC',
      'volume': 'Full Building Handover',
      'duration': '45 Days',
      'progress': 0,
      'isCritical': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Historical Gantt Baseline Engine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Synthesized from 40+ completed UAE high-rise baselines', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Project Meta
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.goldEmirates.withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('BASELINE SYNTHESIS MODEL', style: TextStyle(color: AppColors.goldEmirates, fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('Accuracy 94.2%', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
                SizedBox(height: 6),
                Text('Tower 4 - Commercial & Residential G+42', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Work Volume: 45,000 m³ Concrete • 6,200 Tons Rebar • 18 Months Target', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // WBS Gantt Bars
          const Text('WBS Critical Path Gantt Schedule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          const SizedBox(height: 8),
          ..._tasks.map((t) {
            final isCrit = t['isCritical'] as bool;
            final prog = t['progress'] as int;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF151F32),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCrit ? AppColors.criticalRed.withValues(alpha: 0.4) : const Color(0xFF1E293B),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(t['phase'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      ),
                      if (isCrit)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.criticalRed.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('CRITICAL PATH', style: TextStyle(color: AppColors.criticalRed, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Volume: ${t['volume']} • Duration: ${t['duration']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progress: $prog%', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text('${t['duration']}', style: const TextStyle(color: AppColors.accentCyan, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: prog / 100.0,
                      backgroundColor: const Color(0xFF1E293B),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCrit ? AppColors.criticalRed : AppColors.accentCyan,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 15. AI BASELINE SUITE SCREEN (Jetpack Compose: AiBaselineSuiteScreen.kt)
// ---------------------------------------------------------------------------

class BaselineSuiteScreen extends StatefulWidget {
  const BaselineSuiteScreen({super.key});

  @override
  State<BaselineSuiteScreen> createState() => _BaselineSuiteScreenState();
}

class _BaselineSuiteScreenState extends State<BaselineSuiteScreen> {
  int _selectedTab = 0; // 0: WBS & Lifecycle, 1: Critical Path, 2: Procurement Links, 3: Revisions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Baseline Generator & Critical Path Suite', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Full Lifecycle • Procurement & QC Links • Zero Surprises', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF151F32),
            child: Row(
              children: ['WBS Lifecycle', 'Critical Path', 'Procurement Links', 'Revisions'].asMap().entries.map((entry) {
                final idx = entry.key;
                final label = entry.value;
                final sel = _selectedTab == idx;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ChoiceChip(
                      label: Text(label, style: TextStyle(fontSize: 9, color: sel ? Colors.black : Colors.white)),
                      selected: sel,
                      selectedColor: AppColors.accentCyan,
                      backgroundColor: const Color(0xFF1E293B),
                      onSelected: (_) => setState(() => _selectedTab = idx),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151F32),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('APPROVED CONTRACT BASELINE REV-02', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                      SizedBox(height: 6),
                      Text('Critical Path Duration: 480 Days (Variance: +2 Days)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('All 14 milestones locked with QA/QC prerequisites', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _baselineTile('Substructure Completion', 'Locked by RTA & Dewatering permits', 'Approved Rev-02'),
                _baselineTile('Structural Slab Level 24', 'Prerequisite: Post-tension stressing audit', 'On Schedule'),
                _baselineTile('Façade Installation Front', 'Prerequisite: PO-2026-881 Glass delivery', 'At Risk (-4 Days)'),
                _baselineTile('MEP Final Commissioning', 'Prerequisite: Civil Defense hydro-test', 'Scheduled Month 17'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _baselineTile(String title, String prereq, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151F32),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                Text(prereq, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: status.contains('Risk') ? AppColors.criticalRed.withValues(alpha: 0.15) : AppColors.verifiedGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status.contains('Risk') ? AppColors.criticalRed : AppColors.verifiedGreen,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 16. APPROVAL ENGINE SCREEN (Jetpack Compose: ApprovalEngineScreen.kt)
// ---------------------------------------------------------------------------

class ApprovalEngineFullScreen extends StatefulWidget {
  const ApprovalEngineFullScreen({super.key});

  @override
  State<ApprovalEngineFullScreen> createState() => _ApprovalEngineFullScreenState();
}

class _ApprovalEngineFullScreenState extends State<ApprovalEngineFullScreen> {
  int _selectedTab = 0; // 0: Pending Action, 1: All Requests, 2: Authority Matrix, 3: Overdue & Bottlenecks
  // selectedCategory

  final List<Map<String, dynamic>> _approvals = [
    {
      'id': 'PO-2026-881',
      'titleEn': 'Ready-Mix Concrete C40 Casting Pour 12',
      'category': 'Procurement',
      'initiator': 'Eng. Karim (Site Engineer)',
      'approver': 'Project Director (Eng. Tariq)',
      'valueAed': 480000.0,
      'due': 'in 4 hours',
      'status': 'PENDING_APPROVAL',
      'urgency': 'URGENT',
    },
    {
      'id': 'VO-2026-014',
      'titleEn': 'Basement 2 Deep Waterproofing Membrane Variation',
      'category': 'Commercial',
      'initiator': 'Consultant PM (KEO)',
      'approver': 'Commercial Director',
      'valueAed': 320000.0,
      'due': 'Tomorrow 10:00 AM',
      'status': 'UNDER_REVIEW',
      'urgency': 'NORMAL',
    },
    {
      'id': 'IPC-09',
      'titleEn': 'Interim Payment Certificate #09 (Al Naboodah)',
      'category': 'Finance',
      'initiator': 'Senior QS (F. Haddad)',
      'approver': 'Employer Representative',
      'valueAed': 2850000.0,
      'due': 'Overdue by 1 day',
      'status': 'PENDING_APPROVAL',
      'urgency': 'CRITICAL',
    },
    {
      'id': 'WIR-2026-104',
      'titleEn': 'Level 14 Rebar Inspection Request (WIR)',
      'category': 'QA/QC',
      'initiator': 'QC Inspector (Hassan)',
      'approver': 'Resident Engineer (Dar)',
      'valueAed': 0.0,
      'due': 'in 2 hours',
      'status': 'APPROVED',
      'urgency': 'NORMAL',
    },
  ];

  void _handleAction(Map<String, dynamic> item, String action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151F32),
        title: Text('$action Approval Request', style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item['id']}: ${item['titleEn']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                labelText: 'Decision Comments & Formal Remarks',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'REJECT' ? AppColors.criticalRed : AppColors.accentCyan,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              setState(() {
                item['status'] = action == 'APPROVE' ? 'APPROVED' : (action == 'REJECT' ? 'REJECTED' : 'RETURNED');
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Request ${item['id']} has been $action-ed!')),
              );
            },
            child: Text('Confirm $action'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Approval Ownership & Workflow Engine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Procurement, QA/QC, Commercial, Finance & Site Ops', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Metrics Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFF151F32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metric('Pending (6)', AppColors.cautionAmber),
                _metric('Overdue (2)', AppColors.criticalRed),
                _metric('Approved (18)', AppColors.verifiedGreen),
                _metric('Exposure: AED 4.2M', AppColors.goldEmirates),
              ],
            ),
          ),

          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF151F32),
            child: Row(
              children: ['Pending Action', 'All Requests', 'Authority Matrix', 'Bottlenecks'].asMap().entries.map((entry) {
                final idx = entry.key;
                final label = entry.value;
                final sel = _selectedTab == idx;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ChoiceChip(
                      label: Text(label, style: TextStyle(fontSize: 9, color: sel ? Colors.black : Colors.white)),
                      selected: sel,
                      selectedColor: AppColors.accentCyan,
                      backgroundColor: const Color(0xFF1E293B),
                      onSelected: (_) => setState(() => _selectedTab = idx),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Approval List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _approvals.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final item = _approvals[i];
                final status = item['status'] as String;
                final val = item['valueAed'] as double;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151F32),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(4)),
                            child: Text(item['id'], style: const TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: status == 'APPROVED' ? AppColors.verifiedGreen.withValues(alpha: 0.15) : AppColors.cautionAmber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: status == 'APPROVED' ? AppColors.verifiedGreen : AppColors.cautionAmber,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item['titleEn'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Initiator: ${item['initiator']} • Approver: ${item['approver']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      const Divider(color: Color(0xFF1E293B), height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (val > 0)
                            Text('Value: AED ${(val / 1000).toInt()}k', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12))
                          else
                            const Text('Non-monetary QA inspection', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          Text('Due: ${item['due']}', style: TextStyle(color: item['due'].toString().contains('Overdue') ? AppColors.criticalRed : Colors.grey, fontSize: 11)),
                        ],
                      ),
                      if (status != 'APPROVED') ...[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.criticalRed,
                                side: const BorderSide(color: AppColors.criticalRed),
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () => _handleAction(item, 'REJECT'),
                              child: const Text('Reject', style: TextStyle(fontSize: 11)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.verifiedGreen,
                                foregroundColor: Colors.white,
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () => _handleAction(item, 'APPROVE'),
                              child: const Text('Approve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String title, Color c) {
    return Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c));
  }
}

// ---------------------------------------------------------------------------
// 17. EXCEPTION OVERRIDE SCREEN (Jetpack Compose: ExceptionOverrideScreen.kt)
// ---------------------------------------------------------------------------

class ExceptionOverrideFullScreen extends StatefulWidget {
  const ExceptionOverrideFullScreen({super.key});

  @override
  State<ExceptionOverrideFullScreen> createState() => _ExceptionOverrideFullScreenState();
}

class _ExceptionOverrideFullScreenState extends State<ExceptionOverrideFullScreen> {
  // selectedTab, 1: All Exceptions, 2: Override Matrix, 3: Analytics

  final List<Map<String, dynamic>> _exceptions = [
    {
      'id': 'EX-042',
      'titleEn': 'Night Pouring Noise Exemption Permit',
      'category': 'Environmental / Municipality',
      'risk': 'HIGH',
      'costAed': 45000.0,
      'expiry': 'Expires in 6 hours',
      'status': 'ACTIVE_OVERRIDE',
      'authorizedBy': 'Dubai Municipality & Project Director',
    },
    {
      'id': 'EX-038',
      'titleEn': 'C40 Concrete Slump Tolerance +25mm Acceptance',
      'category': 'Quality / Materials',
      'risk': 'MEDIUM',
      'costAed': 0.0,
      'expiry': 'Temporary (Batch DXB-77291)',
      'status': 'ACTIVE_OVERRIDE',
      'authorizedBy': 'Resident Engineer (Dar)',
    },
    {
      'id': 'EX-029',
      'titleEn': 'Overweight Heavy Haulage Transport Permit',
      'category': 'Logistics & Traffic',
      'risk': 'CRITICAL',
      'costAed': 120000.0,
      'expiry': 'Expired Yesterday',
      'status': 'POST_ACTION_REVIEW',
      'authorizedBy': 'RTA & Police Escort',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Centralized Exception & Override Center', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Auto-expiring overrides, risk matrix & post-action reviews', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFF151F32),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Active: 4 Overrides', style: TextStyle(color: AppColors.cautionAmber, fontWeight: FontWeight.bold, fontSize: 11)),
                Text('Pending Review: 2', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                Text('Critical Risk: 3', style: TextStyle(color: AppColors.criticalRed, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _exceptions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final ex = _exceptions[i];
                final isCrit = ex['risk'] == 'CRITICAL';
                Color riskColor = isCrit ? AppColors.criticalRed : (ex['risk'] == 'HIGH' ? AppColors.cautionAmber : AppColors.verifiedGreen);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151F32),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ex['id'], style: const TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: riskColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                            child: Text(ex['risk'], style: TextStyle(color: riskColor, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(ex['titleEn'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Category: ${ex['category']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      const Divider(color: Color(0xFF1E293B), height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ex['expiry'], style: const TextStyle(color: AppColors.goldEmirates, fontSize: 11, fontWeight: FontWeight.bold)),
                          Text('Authorized: ${ex['authorizedBy']}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 18. AUTONOMOUS SITE AGENT (Jetpack Compose: AutonomousAgentControlScreen.kt)
// ---------------------------------------------------------------------------

class AutonomousAgentScreen extends StatefulWidget {
  const AutonomousAgentScreen({super.key});

  @override
  State<AutonomousAgentScreen> createState() => _AutonomousAgentScreenState();
}

class _AutonomousAgentScreenState extends State<AutonomousAgentScreen> {
  String _autopilotMode = 'SEMI_AUTONOMOUS'; // STANDBY, SEMI_AUTONOMOUS, FULL_AUTOPILOT
  bool _isExecutingCycle = false;
  bool _autoProgress = true;
  bool _autoWeatherHold = true;
  bool _autoManpower = true;
  bool _autoSlump = true;
  bool _autoCloudSync = true;

  final List<String> _consoleLogs = [
    '[07:00:02] Anemometer read 18.2 km/h... Below NCEMA 40 km/h hold threshold (OK)',
    '[07:01:15] Facial biometric turnstiles: 142 workers synchronized with WPS payroll database',
    '[07:02:40] Slump ticket DXB-77291 parsed: 155mm passed ASTM C94 tolerances',
    '[07:05:00] Drone 3D point cloud scan aligned with Autodesk BIM Revit model (99.1% match)',
  ];

  void _triggerCycle() async {
    setState(() => _isExecutingCycle = true);
    await Future.delayed(const Duration(milliseconds: 1600));
    setState(() {
      _isExecutingCycle = false;
      _consoleLogs.insert(0, '[${DateTime.now().toIso8601String().substring(11, 19)}] Autonomous shift cycle completed & synced to Firebase!');
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Autonomous shift cycle completed & synced to Firebase!'),
          backgroundColor: AppColors.verifiedGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151F32),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Autonomous Input Agent AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Controls all site inputs when you are away', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _isExecutingCycle ? null : _triggerCycle,
            icon: _isExecutingCycle
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentCyan))
                : const Icon(Icons.refresh, color: AppColors.accentCyan),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Mode Selector
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AUTOPILOT OPERATIONAL MODE', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  children: ['STANDBY', 'SEMI_AUTONOMOUS', 'FULL_AUTOPILOT'].map((mode) {
                    final sel = _autopilotMode == mode;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ChoiceChip(
                          label: Text(mode.replaceAll('_', ' '), style: TextStyle(fontSize: 9, color: sel ? Colors.black : Colors.white)),
                          selected: sel,
                          selectedColor: AppColors.accentCyan,
                          backgroundColor: const Color(0xFF1E293B),
                          onSelected: (_) => setState(() => _autopilotMode = mode),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Capabilities Toggles
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Autonomous Core Capabilities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                const SizedBox(height: 6),
                _switchTile('Auto Progress Logging (Vision & Audio)', _autoProgress, (v) => setState(() => _autoProgress = v)),
                _switchTile('Auto Weather Hold (NCEMA 40+ km/h)', _autoWeatherHold, (v) => setState(() => _autoWeatherHold = v)),
                _switchTile('Auto Manpower Reconciliation (Facial Biometrics)', _autoManpower, (v) => setState(() => _autoManpower = v)),
                _switchTile('Auto Material Slips OCR (ASTM C94 Slump)', _autoSlump, (v) => setState(() => _autoSlump = v)),
                _switchTile('Auto Cloud Sync (Firebase & SQLite)', _autoCloudSync, (v) => setState(() => _autoCloudSync = v)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Terminal Log Output
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF070B14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.terminal, color: AppColors.verifiedGreen, size: 16),
                    SizedBox(width: 8),
                    Text('Live Agent Action Log Stream', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const Divider(color: Color(0xFF1E293B), height: 16),
                ..._consoleLogs.map((log) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(log, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Colors.white70)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(String title, bool val, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11))),
          Switch(
            value: val,
            activeColor: AppColors.accentCyan,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
