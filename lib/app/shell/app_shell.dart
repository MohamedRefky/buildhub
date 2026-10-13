// Clean Architecture: App shell — port of BuildHubSuperApp (MainActivity.kt).
// Bottom nav 5 tabs; inner routing table mirrors MainActivity selectedTabIndex 0..58.
// All titles come from assets/lang JSON via loc.t() — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localization.dart';
import '../../features/home/presentation/pages/dashboard_page.dart';
import '../../features/home/presentation/pages/services_page.dart';
import '../../features/home/presentation/pages/legacy_pages.dart';
import '../../features/vendors/presentation/pages/vendor_pages.dart';
import '../../features/procurement/presentation/pages/procurement_pages.dart';
import '../../features/finance/presentation/pages/finance_pages.dart';
import '../../features/safety/presentation/pages/safety_pages.dart';
import '../../features/ai/presentation/pages/ai_pages.dart';
import '../../features/documents/presentation/pages/document_pages.dart';
import '../../features/siteops/presentation/pages/siteops_pages.dart';
import '../../features/sitepulse/presentation/pages/sitepulse_pages.dart';
import '../../features/buildnet/presentation/pages/buildnet_pages.dart';

class AppShell extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleSunlight;
  const AppShell({super.key, required this.onToggleLanguage, required this.onToggleSunlight});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 1; // Services, like MainActivity.kt
  void go(int t) => setState(() => tab = t);

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    late final Widget body;
    late final String title;
    switch (tab) {
      case 0:
        body = DashboardScreen(onNavigateToTab: go);
        title = loc.t('screen.dashboard');
      case 1:
        body = AllServicesScreen(onSelect: go);
        title = loc.t('screen.services');
      case 2:
        body = const BuildNetHubScreen();
        title = loc.t('bn.hub');
      case 3:
        body = const OrdersProcurementScreen();
        title = loc.t('screen.orders');
      case 4:
        body = const AiCopilotFullScreen();
        title = loc.t('nav.copilot');
      case 5:
        body = const ProcurementScreen();
        title = loc.t('screen.procurement');
      case 6:
        body = const SafetyFullScreen();
        title = loc.t('screen.safety');
      case 7:
        body = const FinanceClaimsFullScreen();
        title = loc.t('screen.finance');
      case 9:
        body = const AiCopilotFullScreen();
        title = loc.t('nav.copilot');
      case 10:
        body = const UserFilesScreen();
        title = loc.t('screen.myfiles');
      case 11:
        body = const AuthScreen();
        title = loc.t('screen.auth');
      case 12:
        body = const GccAuthoritiesHubScreen();
        title = loc.t('screen.authorities');
      case 13:
        body = const OpenMarketScreen();
        title = loc.t('screen.market');
      case 14:
        body = const GpsLocatorScreen();
        title = loc.t('screen.gps');
      case 15:
        body = const MachineryMarketScreen();
        title = loc.t('screen.equipment');
      case 16:
        body = const GccTendersScreen();
        title = loc.t('screen.tenders');
      case 17:
        body = const SuppliersDirectoryScreen();
        title = loc.t('screen.suppliers');
      case 18:
        body = const GanttBaselineScreen();
        title = loc.t('screen.gantt');
      case 19:
        body = const PredictiveDelayFullScreen();
        title = loc.t('screen.delay');
      case 20:
        body = const MarketIntelScreen();
        title = loc.t('screen.intel');
      case 21:
        body = const AiLegalScreen();
        title = loc.t('screen.legal');
      case 22:
        body = const QuotationComparisonScreen();
        title = loc.t('screen.quotes');
      case 23:
        body = const LibraryScreen();
        title = loc.t('screen.library');
      case 24:
        body = const CoursesScreen();
        title = loc.t('screen.courses');
      case 25:
        body = const CostToCompleteFullScreen();
        title = loc.t('screen.cost');
      case 26:
        body = const SiteTalkFullScreen();
        title = loc.t('screen.talk');
      case 27:
        body = const VaultScreen();
        title = loc.t('screen.vault');
      case 28:
        body = const GeoAttendanceFullScreen();
        title = loc.t('screen.attendance');
      case 29:
        body = const RfiScreen();
        title = loc.t('screen.rfi');
      case 32:
        body = const DrawingsScreen();
        title = loc.t('screen.drawings');
      case 33:
        body = const IntegrationsScreen();
        title = loc.t('screen.integrations');
      case 34:
        body = const DailyReportFullScreen();
        title = loc.t('screen.daily');
      case 35:
        body = const WeatherFullScreen();
        title = loc.t('screen.weather');
      case 36:
        body = const AskTheSiteScreenFull();
        title = loc.t('screen.ask');
      case 37:
        body = const EsgScreen();
        title = loc.t('screen.esg');
      case 38:
        body = const WelfareScreen();
        title = loc.t('screen.welfare');
      case 40:
        body = const FinancialAiFullScreen();
        title = loc.t('screen.finai');
      case 41:
        body = const OfflineSyncScreen();
        title = loc.t('screen.offline');
      case 42:
        body = const AiSuperintendentScreen();
        title = loc.t('screen.super');
      case 43:
        body = const AutonomousAgentScreen();
        title = loc.t('screen.agent');
      case 44:
        body = const ActivityEntryScreen();
        title = loc.t('screen.activities');
      case 45:
        body = const CloudSyncScreen();
        title = loc.t('screen.cloud');
      case 46:
        body = const ProgressCameraScreen();
        title = loc.t('screen.camera');
      case 47:
        body = const OrionTacticalCopilotScreen();
        title = loc.t('screen.tactical');
      case 48:
        body = const RiskHeatMapFullScreen();
        title = loc.t('screen.risk');
      case 49:
        body = const BusinessPlanFullScreen();
        title = loc.t('screen.bizplan');
      case 50:
        body = const SitePulseScreen();
        title = loc.t('screen.command');
      case 51:
        body = const PetroleumSpecsScreen();
        title = loc.t('specs.hub_title');
      case 52:
        body = const PettyCashFullScreen();
        title = loc.t('screen.pettycash');
      case 53:
        body = const GreenWalletScreen();
        title = loc.t('screen.green');
      case 54:
        body = const ApprovalEngineFullScreen();
        title = loc.t('screen.approval');
      case 55:
        body = const ExceptionOverrideFullScreen();
        title = loc.t('screen.override');
      case 56:
        body = const RoadmapScreen();
        title = loc.t('screen.roadmap');
      case 57:
        body = const BaselineSuiteScreen();
        title = loc.t('screen.baseline');
      case 58:
        body = const ApprovedVendorManagementScreen();
        title = loc.t('screen.vendors');
      case 59:
        body = const VendorVerificationScreen();
        title = loc.t('ven.verify');
      default:
        body = GenericServiceScreen(tabId: tab, onBack: () => go(1));
        title = loc.t('common.service');
    }

    final isTopLevel = [0, 1, 2, 3, 4].contains(tab);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(icon: const Icon(Icons.light_mode),
            onPressed: widget.onToggleSunlight,
            tooltip: loc.t('acct.sunlight')),
          TextButton(onPressed: widget.onToggleLanguage,
            child: Text(loc.t('common.lang_toggle'),
              style: const TextStyle(color: Colors.white))),
        ],
      ),
      body: body,
      bottomNavigationBar: isTopLevel
          ? NavigationBar(
              selectedIndex: _navIndex(tab),
              onDestinationSelected: (i) => go([0, 1, 22, 27, 9][i]),
              destinations: [
                NavigationDestination(icon: const Icon(Icons.dashboard),
                  label: loc.t('nav.home')),
                NavigationDestination(icon: const Icon(Icons.apps),
                  label: loc.t('nav.services')),
                NavigationDestination(icon: const Icon(Icons.receipt),
                  label: loc.t('nav.commercial')),
                NavigationDestination(icon: const Icon(Icons.description),
                  label: loc.t('nav.docs')),
                NavigationDestination(icon: const Icon(Icons.smart_toy),
                  label: loc.t('nav.copilot')),
              ],
            )
          : null,
    );
  }

  /// BottomNav highlight mapping — mirrors MainActivity.kt isSelected rules:
  /// Services lights for site tabs, Commercial for trade tabs,
  /// Documents for docs tabs, Copilot for AI tabs.
  int _navIndex(int t) {
    if (t == 0) return 0;
    if ({1, 6, 14, 26, 28, 34, 35, 38, 41, 42, 43, 44, 46, 50, 51}
        .contains(t)) {
      return 1;
    }
    if ({3, 5, 7, 22, 25}.contains(t)) return 2;
    if ({12, 23, 27, 29, 32, 33, 37}.contains(t)) return 3;
    if ({9, 21, 36}.contains(t)) return 4;
    return 1;
  }
}
