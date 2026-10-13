import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/service_entities.dart';

/// Reusable Service Card widget representing a service or capability in BuildHub.
class ServiceCard extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  Color _getBadgeColor(String badge) {
    final lower = badge.toLowerCase();
    if (lower.contains('ai') || lower.contains('gemini') || lower.contains('rag')) {
      return AppColors.accentCyan;
    }
    if (lower.contains('live') || lower.contains('verified') || lower.contains('green') || lower.contains('connect')) {
      return AppColors.verifiedGreen;
    }
    if (lower.contains('code') || lower.contains('dm') || lower.contains('anemometer') || lower.contains('wind') || lower.contains('alert')) {
      return AppColors.cautionAmber;
    }
    if (lower.contains('gcc') || lower.contains('gov') || lower.contains('fidic') || lower.contains('p6') || lower.contains('gold')) {
      return AppColors.goldEmirates;
    }
    return AppColors.accentSky;
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppColors.darkBorder.withValues(alpha: 0.65),
          width: 0.9,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Icon + Stacked Pill Badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: item.iconColor.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Icon(item.icon, size: 20, color: item.iconColor),
                  ),
                  const Spacer(),
                  if (item.badges.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: item.badges.take(2).map((badge) {
                        final color = _getBadgeColor(badge);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: color.withValues(alpha: 0.4),
                              width: 0.7,
                            ),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                loc.tr(item.titleAr, item.titleEn),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryDark,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Description
              Expanded(
                child: Text(
                  loc.tr(item.descAr, item.descEn),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondaryDark,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Bottom arrow
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: AppColors.accentCyan.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
