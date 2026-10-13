import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localization.dart';
import '../features/ai/presentation/pages/ai_pages.dart';
import '../features/buildnet/presentation/pages/buildnet_pages.dart';
import '../features/documents/presentation/pages/document_pages.dart';
import '../features/finance/presentation/pages/finance_pages.dart';
import '../features/home/presentation/pages/dashboard_page.dart';
import '../features/home/presentation/pages/legacy_pages.dart';
import '../features/home/presentation/pages/services_page.dart';
import '../features/procurement/presentation/pages/procurement_pages.dart';
import '../features/safety/presentation/pages/safety_pages.dart';
import '../features/siteops/presentation/pages/siteops_pages.dart';
import '../features/sitepulse/presentation/pages/sitepulse_pages.dart';
import '../features/vendors/presentation/pages/vendor_pages.dart';

/// Central navigation coordinator for BuildHub.
/// Maps tab identifiers (from services catalog and native references) to
/// their dedicated feature screens in Clean Architecture.
class AppRouter {
  AppRouter._();

  static const String home = '/';

  /// Builds the appropriate feature screen widget for a given [tabId].
  static Widget buildScreenForTab(
    BuildContext context,
    int tabId, {
    void Function(int tab)? onNavigate,
  }) {
    final loc = context.read<AppLocalization>();

    switch (tabId) {
      case 0:
        return DashboardScreen(
          onNavigateToTab: onNavigate ?? (t) => openService(context, t),
        );
      case 1:
        return AllServicesScreen(
          onSelect: onNavigate ?? (t) => openService(context, t),
        );
      case 2:
        return const BuildNetHubScreen();
      case 3:
        return const OrdersProcurementScreen();
      case 4:
        return const AiCopilotFullScreen();
      case 5:
        return Scaffold(
          appBar: AppBar(title: Text(loc.t('screen.procurement'))),
          body: const ProcurementScreen(),
        );
      case 6:
        return const SafetyFullScreen();
      case 7:
        return const FinanceClaimsFullScreen();
      case 9:
        return const AiCopilotFullScreen();
      case 10:
        return const UserFilesScreen();
      case 11:
        return const AuthScreen();
      case 12:
        return const GccAuthoritiesHubScreen();
      case 13:
        return const OpenMarketScreen();
      case 14:
        return const GpsLocatorScreen();
      case 15:
        return const MachineryMarketScreen();
      case 16:
        return const GccTendersScreen();
      case 17:
        return const SuppliersDirectoryScreen();
      case 18:
        return const GanttBaselineScreen();
      case 19:
        return const PredictiveDelayFullScreen();
      case 20:
        return const MarketIntelScreen();
      case 21:
        return const AiLegalScreen();
      case 22:
        return const QuotationComparisonScreen();
      case 23:
        return const LibraryScreen();
      case 24:
        return const CoursesScreen();
      case 25:
        return const CostToCompleteFullScreen();
      case 26:
        return const SiteTalkFullScreen();
      case 27:
        return const VaultScreen();
      case 28:
        return const GeoAttendanceFullScreen();
      case 29:
        return const RfiScreen();
      case 32:
        return const DrawingsScreen();
      case 33:
        return const IntegrationsScreen();
      case 34:
        return const DailyReportFullScreen();
      case 35:
        return const WeatherFullScreen();
      case 36:
        return const AskTheSiteScreenFull();
      case 37:
        return const EsgScreen();
      case 38:
        return const WelfareScreen();
      case 40:
        return const FinancialAiFullScreen();
      case 41:
        return const OfflineSyncScreen();
      case 42:
        return const AiSuperintendentScreen();
      case 43:
        return const AutonomousAgentScreen();
      case 44:
        return const ActivityEntryScreen();
      case 45:
        return const CloudSyncScreen();
      case 46:
        return const ProgressCameraScreen();
      case 47:
        return const OrionTacticalCopilotScreen();
      case 48:
        return const RiskHeatMapFullScreen();
      case 49:
        return const BusinessPlanFullScreen();
      case 50:
        return const SitePulseScreen();
      case 51:
        return const PetroleumSpecsScreen();
      case 52:
        return const PettyCashFullScreen();
      case 53:
        return const GreenWalletScreen();
      case 54:
        return const ApprovalEngineFullScreen();
      case 55:
        return const ExceptionOverrideFullScreen();
      case 56:
        return const RoadmapScreen();
      case 57:
        return const BaselineSuiteScreen();
      case 58:
        return const ApprovedVendorManagementScreen();
      case 59:
        return const VendorVerificationScreen();
      default:
        return GenericServiceScreen(
          tabId: tabId,
          onBack: () => Navigator.of(context).pop(),
        );
    }
  }

  /// Pushes the requested service screen onto the navigation stack.
  static Future<T?> openService<T>(BuildContext context, int tabId) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        builder: (ctx) => buildScreenForTab(ctx, tabId),
      ),
    );
  }
}
