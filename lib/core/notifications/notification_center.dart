// Clean Architecture: core notification center.
// Ports: SystemNotificationCenter.kt — unified deduplicated notifications
// (SHA-256 content hash) aggregated from approvals, certificates and delays.
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

enum NotificationCategory {
  approvalPending,
  rfqQuotation,
  scheduleDelay,
  certificateExpiry,
  riskOverride,
}

class SystemNotificationItem {
  final String id;
  final NotificationCategory category;
  final String titleAr;
  final String titleEn;
  final String messageAr;
  final String messageEn;
  final String sourceId;
  final String deduplicationHash;
  final String timestamp;
  final bool isRead;
  const SystemNotificationItem({
    required this.id, required this.category,
    required this.titleAr, required this.titleEn,
    required this.messageAr, required this.messageEn,
    required this.sourceId, required this.deduplicationHash,
    required this.timestamp, this.isRead = false,
  });

  SystemNotificationItem read() => SystemNotificationItem(
        id: id, category: category,
        titleAr: titleAr, titleEn: titleEn,
        messageAr: messageAr, messageEn: messageEn,
        sourceId: sourceId, deduplicationHash: deduplicationHash,
        timestamp: timestamp, isRead: true,
      );
}

class NotificationCenter extends ChangeNotifier {
  final List<SystemNotificationItem> _notifications = [];
  final Set<String> _hashes = {};

  List<SystemNotificationItem> get notifications =>
      List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  static String generateHash(List<String> parts) =>
      sha256.convert(utf8.encode(parts.join('|'))).toString();

  bool _add(SystemNotificationItem item) {
    if (_hashes.contains(item.deduplicationHash)) return false;
    _hashes.add(item.deduplicationHash);
    _notifications.add(item);
    return true;
  }

  /// Aggregates pending approvals, expiring certificates and schedule
  /// delays. Sources are plain maps to stay decoupled from repositories:
  /// approvals [{id,titleAr,titleEn,status}], certificates
  /// [{id,titleAr,titleEn,expiryDate}], delayedActivities
  /// [{id,nameAr,nameEn,progressPercent,durationDays}].
  void syncAndDeduplicateNotifications({
    List<Map<String, dynamic>> approvals = const [],
    List<Map<String, dynamic>> certificates = const [],
    List<Map<String, dynamic>> delayedActivities = const [],
  }) {
    var changed = false;
    for (final a in approvals) {
      final status = '${a['status'] ?? ''}';
      if (status == 'pending' || status == 'submitted' || status == 'underReview') {
        changed |= _add(SystemNotificationItem(
          id: 'notif-appr-${a['id']}', category: NotificationCategory.approvalPending,
          titleAr: 'اعتماد معلق: ${a['titleAr'] ?? ''}',
          titleEn: 'Pending approval: ${a['titleEn'] ?? ''}',
          messageAr: 'يتطلب مراجعة واعتماد', messageEn: 'Requires review',
          sourceId: '${a['id']}',
          deduplicationHash: generateHash(['appr', '${a['id']}', status]),
          timestamp: DateTime.now().toIso8601String(),
        ));
      }
    }
    for (final c in certificates) {
      changed |= _add(SystemNotificationItem(
        id: 'notif-cert-${c['id']}', category: NotificationCategory.certificateExpiry,
        titleAr: 'شهادة قاربت الانتهاء: ${c['titleAr'] ?? ''}',
        titleEn: 'Certificate expiring: ${c['titleEn'] ?? ''}',
        messageAr: 'الانتهاء: ${c['expiryDate'] ?? ''}',
        messageEn: 'Expiry: ${c['expiryDate'] ?? ''}',
        sourceId: '${c['id']}',
        deduplicationHash: generateHash(['cert', '${c['id']}', '${c['expiryDate']}']),
        timestamp: DateTime.now().toIso8601String(),
      ));
    }
    for (final d in delayedActivities) {
      final progress = (d['progressPercent'] as num? ?? 100).toInt();
      final duration = (d['durationDays'] as num? ?? 0).toInt();
      if (progress < 100 && duration > 30) {
        changed |= _add(SystemNotificationItem(
          id: 'notif-delay-${d['id']}', category: NotificationCategory.scheduleDelay,
          titleAr: 'تأخير نشاط: ${d['nameAr'] ?? ''}',
          titleEn: 'Activity delayed: ${d['nameEn'] ?? ''}',
          messageAr: 'التقدم $progress% ومدة تتجاوز 30 يوماً',
          messageEn: 'Progress $progress% past 30-day duration',
          sourceId: '${d['id']}',
          deduplicationHash: generateHash(['delay', '${d['id']}', '$progress']),
          timestamp: DateTime.now().toIso8601String(),
        ));
      }
    }
    if (changed) notifyListeners();
  }

  void markAsRead(String notificationId) {
    final i = _notifications.indexWhere((n) => n.id == notificationId);
    if (i == -1) return;
    _notifications[i] = _notifications[i].read();
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _hashes.clear();
    notifyListeners();
  }
}
