// Clean Architecture: App shell — port of BuildHubSuperApp (MainActivity.kt).
// Bottom nav 5 tabs; inner routing table mirrors MainActivity selectedTabIndex 0..58.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localization.dart';
import '../../ui/screens/dashboard_screen.dart';
import '../../ui/screens/all_services_screen.dart';
import '../../ui/screens/secondary_screens.dart';
import '../../features/vendors/presentation/screens/vendor_screens.dart';
import '../../features/procurement/presentation/screens/market_screens.dart';
import '../../features/finance/presentation/screens/finance_screens.dart';
import '../../features/safety/presentation/screens/safety_screens.dart';
import '../../features/ai/presentation/screens/ai_screens.dart';
import '../../features/documents/presentation/screens/document_screens.dart';
import '../../features/siteops/presentation/screens/siteops_screens.dart';
import '../../features/sitepulse/presentation/screens/sitepulse_screens.dart';
import '../../features/buildnet/presentation/screens/buildnet_screens.dart';

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
        title = loc.tr('الرئيسية', 'Home');
      case 1:
        body = AllServicesScreen(onSelect: go);
        title = loc.tr('الخدمات', 'Services');
      case 2:
        body = const BuildNetHubScreen();
        title = loc.tr('التجاري', 'Commercial');
      case 3:
        body = const OrdersScreen();
        title = loc.tr('المستندات', 'Documents');
      case 4:
        body = const AiCopilotFullScreen();
        title = loc.tr('المساعد الذكي', 'Copilot');
      case 5:
        body = const ProcurementScreen();
        title = loc.tr('التوريد', 'Procurement');
      case 6:
        body = const SafetyFullScreen();
        title = loc.tr('السلامة', 'Safety');
      case 7:
        body = const FinanceClaimsFullScreen();
        title = loc.tr('المالية', 'Finance');
      case 9:
        body = const AiCopilotFullScreen();
        title = loc.tr('المساعد', 'Copilot');
      case 10:
        body = const UserFilesScreen();
        title = loc.tr('ملفاتي', 'My Files');
      case 11:
        body = const AuthScreen();
        title = loc.tr('الدخول', 'Auth');
      case 12:
        body = const GccAuthoritiesHubScreen();
        title = loc.tr('الجهات', 'Authorities');
      case 13:
        body = const OpenMarketScreen();
        title = loc.tr('السوق', 'Market');
      case 14:
        body = const GpsLocatorScreen();
        title = loc.tr('GPS', 'GPS');
      case 15:
        body = const MachineryMarketScreen();
        title = loc.tr('المعدات', 'Equipment');
      case 16:
        body = const GccTendersScreen();
        title = loc.tr('المناقصات', 'Tenders');
      case 17:
        body = const SuppliersDirectoryScreen();
        title = loc.tr('الموردون', 'Suppliers');
      case 18:
        body = const GanttBaselineScreen();
        title = loc.tr('الجانت', 'Gantt');
      case 19:
        body = const PredictiveDelayFullScreen();
        title = loc.tr('التأخير', 'Delay');
      case 20:
        body = const MarketIntelScreen();
        title = loc.tr('السوق', 'Intel');
      case 21:
        body = const AiLegalScreen();
        title = loc.tr('القانوني', 'Legal');
      case 22:
        body = const QuotationComparisonScreen();
        title = loc.tr('العروض', 'Quotes');
      case 23:
        body = const LibraryScreen();
        title = loc.tr('المكتبة', 'Library');
      case 24:
        body = const CoursesScreen();
        title = loc.tr('الدورات', 'Courses');
      case 25:
        body = const CostToCompleteFullScreen();
        title = loc.tr('التكلفة', 'Cost');
      case 26:
        body = const SiteTalkFullScreen();
        title = loc.tr('التواصل', 'Talk');
      case 27:
        body = const VaultScreen();
        title = loc.tr('الخزنة', 'Vault');
      case 28:
        body = const GeoAttendanceFullScreen();
        title = loc.tr('الحضور', 'Attendance');
      case 29:
        body = const RfiScreen();
        title = loc.tr('RFI', 'RFI');
      case 32:
        body = const DrawingsScreen();
        title = loc.tr('المخططات', 'Drawings');
      case 33:
        body = const IntegrationsScreen();
        title = loc.tr('التكاملات', 'Integrations');
      case 34:
        body = const DailyReportFullScreen();
        title = loc.tr('اليومي', 'Daily');
      case 35:
        body = const WeatherFullScreen();
        title = loc.tr('الطقس', 'Weather');
      case 36:
        body = const AskTheSiteScreenFull();
        title = loc.tr('اسأل', 'Ask');
      case 37:
        body = const EsgScreen();
        title = loc.tr('ESG', 'ESG');
      case 38:
        body = const WelfareScreen();
        title = loc.tr('الرعاية', 'Welfare');
      case 40:
        body = const FinancialAiFullScreen();
        title = loc.tr('المالي', 'FinAI');
      case 41:
        body = const OfflineSyncScreen();
        title = loc.tr('الأوفلاين', 'Offline');
      case 43:
        body = const AutonomousAgentScreen();
        title = loc.tr('الوكيل', 'Agent');
      case 44:
        body = const ActivityEntryScreen();
        title = loc.tr('الأنشطة', 'Activities');
      case 45:
        body = const CloudSyncScreen();
        title = loc.tr('السحابة', 'Cloud');
      case 46:
        body = const ProgressCameraScreen();
        title = loc.tr('الكاميرا', 'Camera');
      case 47:
        body = const AiSuperintendentScreen();
        title = loc.tr('المشرف', 'Super');
      case 48:
        body = const RiskHeatMapFullScreen();
        title = loc.tr('المخاطر', 'Risk');
      case 49:
        body = const BusinessPlanFullScreen();
        title = loc.tr('الأعمال', 'BizPlan');
      case 50:
        body = const SitePulseScreen();
        title = loc.tr('القيادة', 'Command');
      case 52:
        body = const PettyCashFullScreen();
        title = loc.tr('العهدة', 'PettyCash');
      case 53:
        body = const GreenWalletScreen();
        title = loc.tr('الخضراء', 'Green');
      case 54:
        body = const ApprovalEngineFullScreen();
        title = loc.tr('الاعتماد', 'Approval');
      case 55:
        body = const ExceptionOverrideFullScreen();
        title = loc.tr('التجاوز', 'Override');
      case 56:
        body = const RoadmapScreen();
        title = loc.tr('الخارطة', 'Roadmap');
      case 57:
        body = const BaselineSuiteScreen();
        title = loc.tr('البيزلاين', 'Baseline');
      case 58:
        body = const ApprovedVendorManagementScreen();
        title = loc.tr('المعتمدون', 'Vendors');
      default:
        body = GenericServiceScreen(tabId: tab, onBack: () => go(1));
        title = loc.tr('خدمة', 'Service');
    }

    final isTopLevel = [0, 1, 2, 3, 4].contains(tab);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(icon: const Icon(Icons.light_mode),
            onPressed: widget.onToggleSunlight, tooltip: 'Sunlight'),
          TextButton(onPressed: widget.onToggleLanguage,
            child: Text(loc.tr('EN', 'عربي'),
              style: const TextStyle(color: Colors.white))),
        ],
      ),
      body: body,
      bottomNavigationBar: isTopLevel
          ? NavigationBar(
              selectedIndex: tab > 4 ? 1 : tab,
              onDestinationSelected: (i) => go(i),
              destinations: [
                NavigationDestination(icon: const Icon(Icons.dashboard),
                  label: loc.tr('الرئيسية', 'Home')),
                NavigationDestination(icon: const Icon(Icons.apps),
                  label: loc.tr('الخدمات', 'Services')),
                NavigationDestination(icon: const Icon(Icons.receipt),
                  label: loc.tr('التجاري', 'Commercial')),
                NavigationDestination(icon: const Icon(Icons.description),
                  label: loc.tr('المستندات', 'Docs')),
                NavigationDestination(icon: const Icon(Icons.smart_toy),
                  label: loc.tr('المساعد', 'Copilot')),
              ],
            )
          : null,
    );
  }
}
