// Clean Architecture: Safety & Site Quality — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// SiteSafetyScreen, SafetyQrPassportScreen, QrCodeScannerScreen,
// SiteProgressCameraScreen.

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/features/home/domain/entities/home_entities.dart';
import 'package:buildhub/features/safety/data/repositories/safety_repository.dart';

// ---------------------------------------------------------------------------
// 1. SITE SAFETY & HSE CONTROL SCREEN
// ---------------------------------------------------------------------------

class SafetyFullScreen extends StatelessWidget {
  final List<SafetyTicket> tickets;
  final HeatStressReading? heat;
  const SafetyFullScreen({super.key, this.tickets = const [], this.heat});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SafetyRepository>();
    final h = heat ?? const HeatStressReading(ambientTempC: 42, wbgtTempC: 31.8);

    final recentIncidents = [
      {'title': 'Worker observed working at height (Level 11) without dual lanyard hooked', 'type': 'VIOLATION', 'severity': 'CRITICAL', 'date': 'Today 09:15 AM'},
      {'title': 'Concrete pump pipeline clamp loose during pump priming', 'type': 'NEAR MISS', 'severity': 'MAJOR', 'date': 'Yesterday 04:30 PM'},
      {'title': 'Trip hazard from scrap rebar bundles cleared in corridor F4', 'type': 'RESOLVED', 'severity': 'LOW', 'date': 'Yesterday 11:00 AM'},
    ];

    final workerPassports = [
      {'name': 'Rajiv Kumar', 'id': 'DXB-SAF-44102', 'cert': 'First Aid & CPR Certified', 'expiry': 'Valid until Oct 2027', 'status': 'VALID'},
      {'name': 'Suresh Babu', 'id': 'DXB-SAF-99412', 'cert': 'Working at Height / Scaffolding Certified', 'expiry': 'Valid until Jan 2027', 'status': 'VALID'},
      {'name': 'Ramesh Prasad', 'id': 'DXB-SAF-11029', 'cert': 'Confined Space & Gas Testing', 'expiry': 'Expired 3 Days Ago', 'status': 'EXPIRED'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HSE Site Safety & Compliance', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('MOHRE Regulations • WBGT Heat Stress • Digital Passports', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Midday & Heat Stress Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.criticalRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.criticalRed),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: AppColors.criticalRed, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ambient: ${h.ambientTempC}°C • WBGT: ${h.wbgtTempC}°C (Extreme)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.criticalRed)),
                      Text(loc.t('safe.midday'), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Crane Wind Limits Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.air, color: AppColors.accentCyan),
              title: Text('${loc.t('safe.wind')}: ${repo.wind.windSpeedMs} m/s (Gusts: 38 km/h)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text(loc.tr(repo.wind.adviceAr, repo.wind.adviceEn)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.cautionAmber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                child: const Text('CAUTION', style: TextStyle(color: AppColors.cautionAmber, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Incident Reports
          const Text('Recent Safety Incidents & Near-Misses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          ...recentIncidents.map((inc) {
            final isCrit = inc['severity'] == 'CRITICAL';
            final isMaj = inc['severity'] == 'MAJOR';
            final col = isCrit ? AppColors.criticalRed : isMaj ? AppColors.cautionAmber : AppColors.verifiedGreen;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(isCrit ? Icons.report : isMaj ? Icons.warning : Icons.check_circle, color: col),
                title: Text(inc['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                subtitle: Text('${inc['type']} • ${inc['date']}'),
                trailing: Text(inc['severity']!, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            );
          }),
          const SizedBox(height: 16),

          // Worker Safety Passports
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Worker Safety Passports (QR)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScannerFullScreen()));
                },
                child: const Text('Scan Worker QR'),
              ),
            ],
          ),
          ...workerPassports.map((wp) {
            final isValid = wp['status'] == 'VALID';
            final col = isValid ? AppColors.verifiedGreen : AppColors.criticalRed;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: col.withValues(alpha: 0.15), child: Icon(Icons.badge, color: col)),
                title: Text(wp['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('${wp['id']} • ${wp['cert']}\n${wp['expiry']}'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: col.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(wp['status']!, style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.bold)),
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
