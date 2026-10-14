// Shared UI: project health status card + Bh atoms.
// Ports: StatusCard.kt (health types × severity evaluator) + BhComponents.kt
// (BhStatusChip, BhKpiTile). All labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/core/theme/app_colors.dart';

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
      BhStatusType.verified => AppColors.verifiedGreen,
      BhStatusType.caution => AppColors.cautionAmber,
      BhStatusType.critical => AppColors.criticalRed,
      BhStatusType.info => AppColors.accentCyan,
      BhStatusType.neutral => AppColors.textSecondaryDark,
    };

IconData _bhDefaultIcon(BhStatusType s) => switch (s) {
      BhStatusType.verified => Icons.check_circle,
      BhStatusType.caution => Icons.warning,
      BhStatusType.critical => Icons.error,
      BhStatusType.info => Icons.info,
      BhStatusType.neutral => Icons.help_outline,
    };

/// Small icon + label chip matching BhComponents.kt
class BhStatusChip extends StatelessWidget {
  final String label;
  final BhStatusType status;
  final IconData? icon;

  const BhStatusChip({
    super.key,
    required this.label,
    this.status = BhStatusType.info,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = _bhColor(status);
    final iconData = icon ?? _bhDefaultIcon(status);
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// KPI tile card matching BhComponents.kt BhKpiTile
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
    final iconColor = _bhColor(status);
    final card = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryDark,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 17, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryDark,
            ),
          ),
          if (subValue.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subValue,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: card,
    );
  }
}

