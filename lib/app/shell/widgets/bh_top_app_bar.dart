import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/home/data/repositories/buildhub_repository.dart';
import '../../../features/home/presentation/widgets/project_switch_dialog.dart';
import '../../../shared/widgets/offline_status.dart';

/// Top application bar for BuildHub SuperApp.
/// Displays active project selector, SQLite sync / offline badge,
/// sunlight mode toggle, and language switcher.
class BhTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleSunlight;

  const BhTopAppBar({
    super.key,
    required this.onToggleLanguage,
    required this.onToggleSunlight,
  });

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    final isOffline = context.watch<OfflineScope>().isOffline;
    final currentProject = repo.currentProject;
    final projectName = loc.isArabic ? currentProject.nameAr : currentProject.nameEn;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.darkBorder.withValues(alpha: 0.4),
            width: 0.8,
          ),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Logo & Project Switcher
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => ProjectSwitchDialog.show(context),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.accentCyan.withValues(alpha: 0.35),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.apartment_rounded,
                          color: AppColors.accentCyan,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Orion B',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (_) => const OfflineCacheInfoDialog(),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isOffline
                                          ? AppColors.cautionAmber.withValues(alpha: 0.15)
                                          : AppColors.verifiedGreen.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isOffline
                                            ? AppColors.cautionAmber.withValues(alpha: 0.4)
                                            : AppColors.verifiedGreen.withValues(alpha: 0.4),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isOffline
                                                ? AppColors.cautionAmber
                                                : AppColors.verifiedGreen,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isOffline ? 'Offline' : 'SQLite Sync',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isOffline
                                                ? AppColors.cautionAmber
                                                : AppColors.verifiedGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    projectName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accentCyan,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.accentCyan,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right: Sunlight & Language Quick Toggles
              Row(
                children: [
                  IconButton(
                    onPressed: onToggleSunlight,
                    tooltip: loc.t('acct.sunlight'),
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentCyan.withValues(alpha: 0.12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.light_mode_outlined,
                        size: 17,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onToggleLanguage,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.accentCyan.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        loc.isArabic ? 'EN' : 'عربي',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
