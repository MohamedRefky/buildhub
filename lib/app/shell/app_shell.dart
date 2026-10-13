// Clean Architecture: AppShell
// Root navigation shell for BuildHub SuperApp.
// Manages the 5 core bottom navigation tabs with persistent IndexedStack state,
// top-level industrial app bar, offline sync banner, and delegates sub-service
// routes to AppRouter.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../features/siteops/data/services/offline_sync.dart';
import '../../shared/widgets/offline_status.dart';
import '../../features/home/presentation/pages/dashboard_page.dart';
import '../../features/home/presentation/pages/services_page.dart';
import '../../features/procurement/presentation/pages/procurement_pages.dart';
import '../../features/documents/presentation/pages/document_pages.dart';
import '../../features/ai/presentation/pages/ai_pages.dart';
import '../app_router.dart';
import './widgets/bh_top_app_bar.dart';

class AppShell extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleSunlight;

  const AppShell({
    super.key,
    required this.onToggleLanguage,
    required this.onToggleSunlight,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// Active root tab index:
  /// 0: Dashboard, 1: Services, 2: Commercial, 3: Documents, 4: Copilot
  int _currentIndex = 1; // Default to Services view matching native experience

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OfflineScope>().startMonitoring();
      context.read<OfflineSyncManager>().startMonitoring();
    });
  }

  /// Handles navigation requests either by switching primary tabs or
  /// delegating to AppRouter for secondary/sub-service screens.
  void _handleNavigation(int tabId) {
    switch (tabId) {
      case 0:
        setState(() => _currentIndex = 0);
        break;
      case 1:
        setState(() => _currentIndex = 1);
        break;
      case 22:
        setState(() => _currentIndex = 2);
        break;
      case 27:
        setState(() => _currentIndex = 3);
        break;
      case 4:
      case 9:
        setState(() => _currentIndex = 4);
        break;
      default:
        // Any sub-service tab (5..59) is pushed onto the navigation stack
        AppRouter.openService(context, tabId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: BhTopAppBar(
        onToggleLanguage: widget.onToggleLanguage,
        onToggleSunlight: widget.onToggleSunlight,
      ),
      body: Column(
        children: [
          OfflineNoticeBanner(
            onViewCacheDetails: () => showDialog(
              context: context,
              builder: (_) => const OfflineCacheInfoDialog(),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                DashboardScreen(onNavigateToTab: _handleNavigation),
                AllServicesScreen(onSelect: _handleNavigation),
                const QuotationComparisonScreen(),
                const VaultScreen(),
                const AiCopilotFullScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          border: Border(
            top: BorderSide(
              color: AppColors.darkBorder.withValues(alpha: 0.5),
              width: 0.8,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) => setState(() => _currentIndex = index),
            backgroundColor: AppColors.darkSurface,
            indicatorColor: AppColors.accentCyan.withValues(alpha: 0.20),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard_rounded, color: AppColors.accentCyan),
                label: loc.t('nav.home'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.apps_outlined),
                selectedIcon: const Icon(Icons.apps_rounded, color: AppColors.accentCyan),
                label: loc.t('nav.services'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.accentCyan),
                label: loc.t('nav.commercial'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.folder_outlined),
                selectedIcon: const Icon(Icons.folder_shared_rounded, color: AppColors.accentCyan),
                label: loc.t('nav.docs'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.smart_toy_outlined),
                selectedIcon: const Icon(Icons.smart_toy_rounded, color: AppColors.accentCyan),
                label: loc.t('nav.copilot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
