// Clean Architecture: Safety — Presentation.
// Covers: SiteSafetyScreen, SafetyQrPassportScreen, QrCodeScannerScreen,
// SiteProgressCameraScreen.
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
      appBar: AppBar(title: Text(loc.tr('السلامة HSE', 'HSE Safety'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(
            leading: const Icon(Icons.air),
            title: Text('${loc.tr('الرياح', 'Wind')}: ${repo.wind.windSpeedMs} m/s'),
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
      appBar: AppBar(title: Text(loc.tr('جواز السلامة QR', 'Safety QR Passport'))),
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
      appBar: AppBar(title: Text(loc.tr('ماسح QR', 'QR Scanner'))),
      body: Center(child: Text(loc.tr(
        'اربط mobile_scanner هنا لاستلام المواد',
        'Wire mobile_scanner here for goods receiving'))),
    );
  }
}

class ProgressCameraScreen extends StatelessWidget {
  const ProgressCameraScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.tr('كاميرا تقدم الموقع', 'Site Camera'))),
      body: Center(child: Text(loc.tr(
        'التقاط CameraX → هنا image_picker/camera',
        'CameraX capture → use camera/image_picker here'))),
    );
  }
}
