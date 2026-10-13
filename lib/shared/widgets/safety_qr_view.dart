// Shared UI: safety QR code view.
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SafetyQrView extends StatelessWidget {
  final String payload;
  const SafetyQrView({super.key, required this.payload});
  @override
  Widget build(BuildContext context) =>
      QrImageView(data: payload, size: 160);
}
