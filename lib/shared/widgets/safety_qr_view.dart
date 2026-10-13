// Shared UI: safety QR code view.
// Ports: SafetyQrCodeView.kt — qr_flutter rendering inside a
// category-colored frame with centered category badge. Category styling
// arrives as plain params so shared/ stays decoupled from features.
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SafetyQrView extends StatelessWidget {
  final String payload;
  final double size;
  final Color frameColor;
  final Color finderColor;
  final IconData badgeIcon;
  final bool showBadge;
  const SafetyQrView({
    super.key,
    required this.payload,
    this.size = 160,
    this.frameColor = Colors.green,
    this.finderColor = const Color(0xFF065F46),
    this.badgeIcon = Icons.person,
    this.showBadge = true,
  });
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: frameColor, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(alignment: Alignment.center, children: [
          QrImageView(
            data: payload,
            size: size,
            eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square, color: finderColor),
            dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF0F172A)),
          ),
          if (showBadge)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Icon(badgeIcon, color: frameColor, size: 22),
            ),
        ]),
      );
}
