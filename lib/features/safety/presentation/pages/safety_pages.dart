// Clean Architecture: Safety & Site Quality — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// SiteSafetyScreen, SafetyQrPassportScreen, QrCodeScannerScreen,
// SiteProgressCameraScreen.

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/features/home/domain/entities/home_entities.dart';

// ---------------------------------------------------------------------------
// 1. SITE SAFETY & HSE CONTROL SCREEN
// ---------------------------------------------------------------------------

class SafetyFullScreen extends StatefulWidget {
  final List<SafetyTicket> tickets;
  final HeatStressReading? heat;
  final int initialSection;
  const SafetyFullScreen({super.key, this.tickets = const [], this.heat, this.initialSection = 0});

  @override
  State<SafetyFullScreen> createState() => _SafetyFullScreenState();
}

class _SafetyFullScreenState extends State<SafetyFullScreen> {
  late int _selectedSection;

  final List<Map<String, dynamic>> _hseTickets = [
    {
      'id': 'TKT-SAF-089',
      'title': 'Worker observed working at height (Level 11) without dual lanyard hooked',
      'category': 'Working at Height',
      'severity': 'CRITICAL',
      'status': 'OPEN',
      'assignee': 'Eng. Tariq (Consultant)',
      'location': 'Level 11 - Grid F4',
      'date': 'Today 09:15 AM',
    },
    {
      'id': 'TKT-SAF-088',
      'title': 'Concrete pump pipeline clamp loose during pump priming',
      'category': 'Plant & Machinery',
      'severity': 'MAJOR',
      'status': 'IN_PROGRESS',
      'assignee': 'Suresh Babu (Foreman)',
      'location': 'Ground Pump Station',
      'date': 'Yesterday 04:30 PM',
    },
    {
      'id': 'TKT-SAF-087',
      'title': 'Scrap rebar bundles blocking emergency evacuation corridor',
      'category': 'Housekeeping',
      'severity': 'MINOR',
      'status': 'RESOLVED',
      'assignee': 'Ali Hassan (Safety Officer)',
      'location': 'Basement 1 Exit',
      'date': 'Yesterday 11:00 AM',
    },
  ];

  final List<Map<String, dynamic>> _workerPassports = [
    {
      'name': 'Rajiv Kumar',
      'id': 'DXB-SAF-44102',
      'company': 'Al Naboodah Steel',
      'cert': 'First Aid & CPR Certified',
      'expiry': 'Valid until Oct 2027',
      'status': 'VALID',
      'score': 98,
    },
    {
      'name': 'Suresh Babu',
      'id': 'DXB-SAF-99412',
      'company': 'Arabtec Formwork',
      'cert': 'Working at Height / Scaffolding Certified',
      'expiry': 'Valid until Jan 2027',
      'status': 'VALID',
      'score': 95,
    },
    {
      'name': 'Ramesh Prasad',
      'id': 'DXB-SAF-11029',
      'company': 'Drake & Scull MEP',
      'cert': 'Confined Space & Gas Testing',
      'expiry': 'Expired 3 Days Ago',
      'status': 'EXPIRED',
      'score': 74,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'HSE Site Safety & Compliance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'MOHRE Heat Stress • Passports • Crane Safety',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedSection == 0
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.criticalRed,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_alert),
              label: const Text('Report HSE Incident'),
              onPressed: () {
                _showAddIncidentDialog();
              },
            )
          : null,
      body: Column(
        children: [
          // Section Tabs Bar
          Container(
            color: AppColors.darkSurface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  _buildSectionTab(0, 'بلاغات السلامة HSE', Icons.warning),
                  _buildSectionTab(1, 'جوازات السلامة الرقمية QR', Icons.qr_code_scanner),
                  _buildSectionTab(2, 'محرك الإجهاد الحراري WBGT', Icons.thermostat),
                  _buildSectionTab(3, 'الحضور الجغرافي ونظام WPS', Icons.radar),
                  _buildSectionTab(4, 'التقرير اليومي الآلي DPR', Icons.description),
                  _buildSectionTab(5, 'سرعة الرياح ورافعات البرج', Icons.air),
                ],
              ),
            ),
          ),

          // Section Body
          Expanded(
            child: IndexedStack(
              index: _selectedSection,
              children: [
                _buildTicketsSection(),
                _buildPassportsSection(),
                _buildHeatStressSection(),
                _buildGeoAttendanceSection(),
                _buildDailyReportAutopilotSection(),
                _buildCraneWindSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTab(int index, String label, IconData icon) {
    final isSelected = _selectedSection == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedSection = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.accentCyan : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? AppColors.accentCyan : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 0: HSE TICKETS
  // ---------------------------------------------------------------------------
  Widget _buildTicketsSection() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        // Summary KPIs
        Row(
          children: [
            Expanded(
              child: _buildHseKpiCard('1 Critical', 'Requires Immediate Halt', AppColors.criticalRed),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildHseKpiCard('1 In Progress', 'Mitigation Underway', AppColors.cautionAmber),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildHseKpiCard('1 Resolved', 'Closed Out with Photos', AppColors.verifiedGreen),
            ),
          ],
        ),
        const SizedBox(height: 14),

        const Text('Active Safety Incident Tickets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
        const SizedBox(height: 8),

        ..._hseTickets.map((tkt) {
          final isCrit = tkt['severity'] == 'CRITICAL';
          final col = isCrit ? AppColors.criticalRed : (tkt['severity'] == 'MAJOR' ? AppColors.cautionAmber : AppColors.verifiedGreen);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: col.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tkt['id'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: col)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: col.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(tkt['severity'] as String, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 9)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(tkt['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(tkt['location'] as String, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const Spacer(),
                    Text(tkt['date'] as String, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: AppColors.darkBorder.withValues(alpha: 0.3), height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Assignee: ${tkt['assignee']}', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Update Status', style: TextStyle(fontSize: 11, color: AppColors.accentCyan)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHseKpiCard(String val, String label, Color col) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: col.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: col)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9, color: AppColors.textSecondary), maxLines: 1),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1: PASSPORTS SECTION
  // ---------------------------------------------------------------------------
  Widget _buildPassportsSection() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Digital Worker HSE Passports', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
              icon: const Icon(Icons.qr_code_scanner, size: 16),
              label: const Text('Scan QR'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScannerFullScreen()));
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._workerPassports.map((wp) {
          final isValid = wp['status'] == 'VALID';
          final col = isValid ? AppColors.verifiedGreen : AppColors.criticalRed;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: col.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.badge, color: col, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(wp['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      const SizedBox(height: 2),
                      Text('${wp['id']} • ${wp['company']}', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text(wp['cert'] as String, style: const TextStyle(fontSize: 11, color: AppColors.accentCyan)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: col.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(wp['status'] as String, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                    const SizedBox(height: 4),
                    Text('Score: ${wp['score']}%', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2: HEAT STRESS SECTION
  // ---------------------------------------------------------------------------
  Widget _buildHeatStressSection() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.criticalRed.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.criticalRed.withValues(alpha: 0.5)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.criticalRed, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'MOHRE Midday Work Ban Active',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.criticalRed),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Outdoor work under direct sunlight is strictly prohibited between 12:30 PM and 03:00 PM under UAE Federal Labor Law.',
                style: TextStyle(fontSize: 12, color: Colors.white, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Live Heat Stress Telemetry (WBGT)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHeatGauge('42.5°C', 'Ambient Dry Bulb', AppColors.cautionAmber),
                  _buildHeatGauge('31.8°C', 'WBGT Index', AppColors.criticalRed),
                  _buildHeatGauge('58%', 'Relative Humidity', AppColors.accentCyan),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Mandatory Work/Rest Cycle: 15 Minutes Rest per 45 Minutes Work with Electrolyte Hydration stations.',
                style: TextStyle(fontSize: 11, color: AppColors.goldEmirates),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeatGauge(String val, String label, Color col) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: col)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3: GEO-ATTENDANCE & WPS
  // ---------------------------------------------------------------------------
  Widget _buildGeoAttendanceSection() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Geofenced Site Perimeter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                    child: const Text('GPS LOCKED (150m)', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Al Wasl Tower Package 3 • Lat: 25.1972° N, Lon: 55.2744° E', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttendanceStat('148', 'Men On-Site', AppColors.accentCyan),
                  _buildAttendanceStat('100%', 'WPS Compliant', AppColors.verifiedGreen),
                  _buildAttendanceStat('0', 'Overtime Violations', Colors.white),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceStat(String val, String label, Color col) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: col)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 4: DAILY REPORT AUTOPILOT
  // ---------------------------------------------------------------------------
  Widget _buildDailyReportAutopilotSection() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI Daily Safety Autopilot Synthesis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
              const SizedBox(height: 6),
              Text('Autonomous synthesis of all gate scans, toolbox talks, and incident reports.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '• Toolbox Talk Conducted: "Heat Exhaustion Prevention & Hydration" (148 attendees)\n• Scaffolding Inspections: Passed for Zones A & B with 0 critical tags\n• First Aid Center: 2 minor dehydration treated with electrolytes\n• Status: Ready for Project Manager Digital Signature',
                  style: TextStyle(fontSize: 12, color: Colors.white, height: 1.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 5: CRANE WIND SECTION
  // ---------------------------------------------------------------------------
  Widget _buildCraneWindSection() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tower Crane Anemometer Telemetry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                    child: const Text('SAFE TO OPERATE', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('11.4 m/s', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.accentCyan)),
                      const SizedBox(height: 2),
                      Text('Current Wind Speed', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('15.0 m/s', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.cautionAmber)),
                      const SizedBox(height: 2),
                      Text('Mandatory Cut-Off Limit', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Safety Rule: When wind speed exceeds 15.0 m/s (54 km/h), crane operations must cease immediately, boom weathervaned, and hook parked.',
                style: TextStyle(fontSize: 11, color: AppColors.goldEmirates),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddIncidentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('Report HSE Incident', style: TextStyle(color: Colors.white)),
        content: const Text('New incident draft registered. Safety officer notified.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: AppColors.accentCyan)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. SAFETY QR PASSPORT SCREEN
// ---------------------------------------------------------------------------

class QrPassportScreen extends StatelessWidget {
  final String payload;
  const QrPassportScreen({super.key, this.payload = 'BUILDHUB-UAE:SAFETY:LAB-1082'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Official Worker Safety Passport')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      QrImageView(data: payload, size: 200),
                      const SizedBox(height: 16),
                      const Text('Worker ID: LAB-1082 (Rajiv Kumar)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      const Text('Trade: MEP Foreman • Drake & Scull', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: const Text('PASSPORT VERIFIED • MUNICIPALITY COMPLIANT', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. QR SCANNER FULL SCREEN
// ---------------------------------------------------------------------------

class QrScannerFullScreen extends StatefulWidget {
  const QrScannerFullScreen({super.key});
  @override
  State<QrScannerFullScreen> createState() => _QrScannerFullScreenState();
}

class _QrScannerFullScreenState extends State<QrScannerFullScreen> {
  String? _lastCode;
  bool _dialogOpen = false;

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code == _lastCode || _dialogOpen) return;
    _lastCode = code;
    _dialogOpen = true;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QR Code Scanned Successfully'),
        content: Text(code),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    ).then((_) => _dialogOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner (Goods & Safety)')),
      body: Column(
        children: [
          Expanded(child: MobileScanner(onDetect: (c) => _onDetect(context, c))),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Scan Material Delivery MIR QR, Worker Safety Badge, or Equipment Certificate', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. SITE PROGRESS CAMERA & AI WATERMARK SCREEN
// ---------------------------------------------------------------------------

class ProgressCameraScreen extends StatefulWidget {
  const ProgressCameraScreen({super.key});

  @override
  State<ProgressCameraScreen> createState() => _ProgressCameraScreenState();
}

class _ProgressCameraScreenState extends State<ProgressCameraScreen> {
  final List<Map<String, String>> _photos = [
    {
      'title': 'Level 12 Zone B Slab Rebar Inspection',
      'location': 'Level 12 – Axis F4 (25.1972° N, 55.2744° E)',
      'timestamp': '2026-09-28 10:15 AM',
      'tag': 'PRE-POUR QC',
      'aiScore': 'Rebar spacing compliant (200mm c/c)',
    },
    {
      'title': 'Concrete Slump Test Cube Casting',
      'location': 'Ground Pump Station 1 (25.1975° N, 55.2741° E)',
      'timestamp': '2026-09-28 08:30 AM',
      'tag': 'SLUMP 150MM',
      'aiScore': 'ASTM C94 verification passed',
    },
    {
      'title': 'Chilled Water Pipe Routing in Corridor',
      'location': 'Level 11 Corridor Axis C (25.1970° N, 55.2740° E)',
      'timestamp': '2026-09-27 03:45 PM',
      'tag': 'MEP CLASH RFI',
      'aiScore': 'Clash detected with architectural soffit',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Site Progress Camera & GPS Photos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('AI Watermark • GPS Coordinates • Plan Pinning', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo, color: AppColors.accentCyan),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Capturing photo with GPS & timestamp watermark...')));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._photos.map((p) => Card(
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Stack(
                          children: [
                            const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  'WATERMARK: ${p['timestamp']} • ${p['location']}',
                                  style: const TextStyle(color: AppColors.accentCyan, fontSize: 9, fontFamily: 'monospace'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                            child: Text(p['tag']!, style: const TextStyle(color: AppColors.accentCyan, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('AI Verification: ${p['aiScore']}', style: const TextStyle(fontSize: 11, color: AppColors.verifiedGreen)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
