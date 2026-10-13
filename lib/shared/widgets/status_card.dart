// Shared UI: project health status card + Bh atoms.
// Ports: StatusCard.kt (health types × severity evaluator) + BhComponents.kt
// (BhStatusChip, BhKpiTile). All labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

enum HealthIndicatorType { overallProgress, todaysProgress, openBlockers, overdueActions }

enum HealthSeverity { onTrack, attentionRequired, critical }

class HealthSeverityEvaluator {
  const HealthSeverityEvaluator();

  HealthSeverity evaluateProgress(double actual, double planned) {
    final gap = actual - planned;
    if (gap >= -2) return HealthSeverity.onTrack;
    if (gap >= -6) return HealthSeverity.attentionRequired;
    return HealthSeverity.critical;
  }

  HealthSeverity evaluateBlockers(int open, int criticalCount) {
    if (criticalCount > 0 || open > 5) return HealthSeverity.critical;
    if (open > 0) return HealthSeverity.attentionRequired;
    return HealthSeverity.onTrack;
  }

  HealthSeverity evaluateOverdueActions(int count) {
    if (count > 5) return HealthSeverity.critical;
    if (count > 0) return HealthSeverity.attentionRequired;
    return HealthSeverity.onTrack;
  }
}

String _severityKey(HealthSeverity s) => switch (s) {
      HealthSeverity.onTrack => 'widgets.sev_ontrack',
      HealthSeverity.attentionRequired => 'widgets.sev_attention',
      HealthSeverity.critical => 'widgets.sev_critical',
    };

String _severityEmoji(HealthSeverity s) => switch (s) {
      HealthSeverity.onTrack => '🟢',
      HealthSeverity.attentionRequired => '🟠',
      HealthSeverity.critical => '🔴',
    };

Color _severityColor(HealthSeverity s) => switch (s) {
      HealthSeverity.onTrack => Colors.green,
      HealthSeverity.attentionRequired => Colors.amber,
      HealthSeverity.critical => Colors.red,
    };

String _typeKey(HealthIndicatorType t) => switch (t) {
      HealthIndicatorType.overallProgress => 'widgets.health_progress',
      HealthIndicatorType.todaysProgress => 'widgets.health_today',
      HealthIndicatorType.openBlockers => 'widgets.health_blockers',
      HealthIndicatorType.overdueActions => 'widgets.health_overdue',
    };

IconData _typeIcon(HealthIndicatorType t) => switch (t) {
      HealthIndicatorType.overallProgress => Icons.timeline,
      HealthIndicatorType.todaysProgress => Icons.today,
      HealthIndicatorType.openBlockers => Icons.warning_amber,
      HealthIndicatorType.overdueActions => Icons.schedule,
    };

/// Full health card (reference parity). The legacy title/value/color
/// constructor is preserved for existing callers.
class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final String subtitle;
  final HealthIndicatorType? type;
  final HealthSeverity? severity;
  final double? progressRatio;
  final VoidCallback? onTap;
  const StatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.subtitle = '',
    this.type,
    this.severity,
    this.progressRatio,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final sev = severity;
    final resolvedTitle =
        type != null ? loc.t(_typeKey(type!)) : title;
    final resolvedColor = sev != null ? _severityColor(sev) : color;
    final card = Card(
      color: resolvedColor.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (type != null) ...[
              Icon(_typeIcon(type!), size: 18),
              const SizedBox(width: 6),
            ],
            Expanded(child: Text(resolvedTitle)),
            if (sev != null)
              Text('${_severityEmoji(sev)} ${loc.t(_severityKey(sev))}'),
          ]),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          if (progressRatio != null) ...[
            const SizedBox(height: 6),
            LinearProgressIndicator(value: progressRatio!.clamp(0.0, 1.0)),
          ],
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
          ],
        ]),
      ),
    );
    if (onTap == null) return card;
    return InkWell(onTap: onTap, child: card);
  }
}

enum BhStatusType { verified, caution, critical, info, neutral }

Color _bhColor(BhStatusType s) => switch (s) {
      BhStatusType.verified => Colors.green,
      BhStatusType.caution => Colors.amber,
      BhStatusType.critical => Colors.red,
      BhStatusType.info => Colors.cyan,
      BhStatusType.neutral => Colors.grey,
    };

/// Small icon + label chip (BhComponents.kt parity).
class BhStatusChip extends StatelessWidget {
  final String label;
  final BhStatusType status;
  final IconData icon;
  const BhStatusChip({
    super.key,
    required this.label,
    this.status = BhStatusType.info,
    this.icon = Icons.info_outline,
  });
  @override
  Widget build(BuildContext context) {
    final color = _bhColor(status);
    return Chip(
      avatar: Icon(icon, size: 14, color: color),
      label: Text(label),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
    );
  }
}

/// KPI tile card (BhComponents.kt parity).
class BhKpiTile extends StatelessWidget {
  final String title;
  final String value;
  final String subValue;
  final IconData icon;
  final BhStatusType status;
  final VoidCallback? onTap;
  const BhKpiTile({
    super.key,
    required this.title,
    required this.value,
    this.subValue = '',
    required this.icon,
    this.status = BhStatusType.info,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, color: _bhColor(status)),
                const SizedBox(width: 6),
                Expanded(child: Text(title)),
              ]),
              const SizedBox(height: 4),
              Text(value,
                  style: Theme.of(context).textTheme.titleLarge),
              if (subValue.isNotEmpty)
                Text(subValue,
                    style: Theme.of(context).textTheme.labelSmall),
            ]),
      ),
    );
    if (onTap == null) return card;
    return InkWell(onTap: onTap, child: card);
  }
}
