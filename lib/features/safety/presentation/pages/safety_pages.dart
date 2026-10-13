// Clean Architecture: Safety — Presentation.
// Covers: SiteSafetyScreen, SafetyQrPassportScreen, QrCodeScannerScreen,
// SiteProgressCameraScreen.
// Titles/notes resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/safety/data/safety_repository.dart';

class SafetyFullScreen extends StatelessWidget {
  const SafetyFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SafetyRepository>();
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

class QrScannerFullScreen extends StatelessWidget {
  const QrScannerFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    // Port of QrCodeScannerScreen: use mobile_scanner MobileScanner widget here.
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('safe.qr_scanner'))),
      body: Center(child: Text(loc.t('safe.scanner_note'))),
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
