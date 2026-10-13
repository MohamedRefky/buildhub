// Clean Architecture: Safety — Presentation.
// Covers: SiteSafetyScreen, SafetyQrPassportScreen, QrCodeScannerScreen,
// SiteProgressCameraScreen.
// Titles/notes resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/home/domain/entities/home_entities.dart';
import 'package:buildhub/features/safety/data/repositories/safety_repository.dart';

/// Port of SiteSafetyScreen.kt sections: HSE tickets, passports & QR,
/// heat-stress & midday, crane wind.
class SafetyFullScreen extends StatelessWidget {
  final List<SafetyTicket> tickets;
  final HeatStressReading? heat;
  const SafetyFullScreen({super.key, this.tickets = const [], this.heat});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SafetyRepository>();
    final h = heat ??
        const HeatStressReading(ambientTempC: 42, wbgtTempC: 31.8);
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('safe.hse'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(
            leading: const Icon(Icons.air),
            title: Text('${loc.t('safe.wind')}: ${repo.wind.windSpeedMs} m/s'),
            subtitle: Text(loc.tr(repo.wind.adviceAr, repo.wind.adviceEn)),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.thermostat),
            title: Text(
                '${loc.t('safe.heat_title')}: ${h.ambientTempC}°C • WBGT ${h.wbgtTempC}'),
            subtitle: Text(loc.t('safe.midday')),
          )),
          ...tickets.map((t) => ListTile(
                leading: const Icon(Icons.report_problem),
                title: Text(loc.tr(t.titleAr, t.titleEn)),
                subtitle: Text(t.ticketNo),
              )),
          ...repo.passports.map((p) => ListTile(
            title: Text(loc.tr(p.nameAr, p.nameEn)),
            subtitle: Text(p.idOrPlateNumber),
          )),
        ],
      ),
    );
  }
}

class QrPassportScreen extends StatelessWidget {
  final String payload;
  const QrPassportScreen({super.key, this.payload = 'BUILDHUB-UAE:SAFETY:LAB-1082'});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('safe.qr_passport'))),
      body: Center(child: QrImageView(data: payload, size: 220)),
    );
  }
}

class QrScannerFullScreen extends StatefulWidget {
  const QrScannerFullScreen({super.key});
  @override
  State<QrScannerFullScreen> createState() => _QrScannerFullScreenState();
}

/// Port of QrCodeScannerScreen.kt: live scanner for goods receiving.
/// Scanned codes surface in a localized result dialog.
class _QrScannerFullScreenState extends State<QrScannerFullScreen> {
  String? _lastCode;
  bool _dialogOpen = false;

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code == _lastCode || _dialogOpen) return;
    _lastCode = code;
    _dialogOpen = true;
    final loc = context.read<AppLocalization>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.t('safe.scan_result')),
        content: Text(code),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.t('common.cancel'))),
        ],
      ),
    ).then((_) => _dialogOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('safe.qr_scanner'))),
      body: Column(children: [
        Expanded(
            child: MobileScanner(
                onDetect: (c) => _onDetect(context, c))),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(loc.t('safe.scanner_note'),
              textAlign: TextAlign.center),
        ),
      ]),
    );
  }
}

class ProgressCameraScreen extends StatelessWidget {
  const ProgressCameraScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('safe.camera_title'))),
      body: Center(child: Text(loc.t('safe.camera_note'))),
    );
  }
}
