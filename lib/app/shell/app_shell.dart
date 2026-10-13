// Clean Architecture: App shell — port of BuildHubSuperApp (MainActivity.kt).
// Bottom nav 5 tabs; inner routing table mirrors MainActivity selectedTabIndex 0..58.
// Includes BhTopAppBar, project switcher modal, new project creation, and industrial UI.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../features/siteops/data/services/offline_sync.dart';
import '../../shared/widgets/offline_status.dart';
import '../../features/home/data/repositories/buildhub_repository.dart';
import '../../features/home/domain/entities/home_entities.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OfflineScope>().startMonitoring();
      context.read<OfflineSyncManager>().startMonitoring();
    });
  }

  void _showProjectSwitchDialog(BuildContext context, BuildHubRepository repo) {
    final loc = context.read<AppLocalization>();
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDlgState) {
            return AlertDialog(
              backgroundColor: AppColors.darkSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.darkBorder, width: 0.8),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.tr('اختيار مشروع العمل', 'Select Active Project'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.white54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showAddProjectDialog(context, repo);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentCyan,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(
                        loc.tr('+ إضافة مشروع جديد', '+ Create New Project'),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: repo.projects.map((proj) {
                            final isSelected = proj.id == repo.currentProject.id;
                            final name = loc.isArabic ? proj.nameAr : proj.nameEn;
                            final locText = loc.isArabic ? proj.locationAr : proj.locationEn;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accentCyan.withValues(alpha: 0.12)
                                    : AppColors.darkCard,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accentCyan
                                      : AppColors.darkBorder,
                                  width: isSelected ? 1.5 : 0.8,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  repo.selectProject(proj.id);
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        loc.tr('تم تفعيل المشروع: $name', 'Active project: $name'),
                                      ),
                                      backgroundColor: AppColors.darkCardElevated,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected
                                                    ? AppColors.accentCyan
                                                    : Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withValues(alpha: 0.06),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    proj.code,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.accentCyan,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    locText,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white60,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${(proj.budgetAed / 1000000).toStringAsFixed(0)}M AED • ${proj.completionPercent}%',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white38,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColors.accentCyan,
                                          size: 22,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    loc.tr('إغلاق', 'Close'),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddProjectDialog(BuildContext context, BuildHubRepository repo) {
    final loc = context.read<AppLocalization>();
    final nameArCtrl = TextEditingController();
    final nameEnCtrl = TextEditingController();
    final budgetCtrl = TextEditingController(text: '15000000');
    final locationCtrl = TextEditingController(text: 'Dubai, UAE');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.darkBorder, width: 0.8),
          ),
          title: Text(
            loc.tr('إضافة مشروع جديد', 'Add New Project'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameArCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: loc.tr('اسم المشروع (بالعربية)', 'Project Name (Arabic)'),
                    labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                    hintText: 'برج الخليج التجاري...',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameEnCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: loc.tr('اسم المشروع (بالإنجليزية)', 'Project Name (English)'),
                    labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                    hintText: 'Business Bay Tower...',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: budgetCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: loc.tr('الميزانية المعتمدة (AED)', 'Approved Budget (AED)'),
                    labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: loc.tr('الموقع', 'Location'),
                    labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(loc.tr('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                final budget = double.tryParse(budgetCtrl.text) ?? 15000000.0;
                final codeNum = 100 + (DateTime.now().millisecond % 900);
                final newProj = Project(
                  id: 'prj-${DateTime.now().millisecondsSinceEpoch}',
                  nameAr: nameArCtrl.text.trim().isNotEmpty
                      ? nameArCtrl.text.trim()
                      : (nameEnCtrl.text.trim().isNotEmpty ? nameEnCtrl.text.trim() : 'مشروع جديد'),
                  nameEn: nameEnCtrl.text.trim().isNotEmpty
                      ? nameEnCtrl.text.trim()
                      : 'New Project',
                  code: 'SND-$codeNum',
                  clientAr: 'حكومة دبي',
                  clientEn: 'Dubai Government',
                  locationAr: locationCtrl.text.trim().isNotEmpty ? locationCtrl.text.trim() : 'دبي، الإمارات',
                  locationEn: locationCtrl.text.trim().isNotEmpty ? locationCtrl.text.trim() : 'Dubai, UAE',
                  budgetAed: budget,
                  spentAed: budget * 0.1,
                  completionPercent: 10,
                  daysRemaining: 240,
                  cpi: 1.02,
                  spi: 0.99,
                );
                repo.addProject(newProj);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      loc.tr('تم حفظ وتفعيل المشروع بنجاح', 'Project created and activated successfully'),
                    ),
                    backgroundColor: AppColors.darkCardElevated,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(loc.tr('حفظ المشروع', 'Save Project')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    final isOffline = context.watch<OfflineScope>().isOffline;

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
    final currentProject = repo.currentProject;
    final projectName = loc.isArabic ? currentProject.nameAr : currentProject.nameEn;

    return PopScope(
      canPop: isTopLevel,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          go(1);
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62),
        child: Container(
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
              child: isTopLevel
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: Logo & Project Switcher
                        Expanded(
                          child: InkWell(
                            onTap: () => _showProjectSwitchDialog(context, repo),
                            borderRadius: BorderRadius.circular(10),
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
                              onPressed: widget.onToggleSunlight,
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
                              onTap: widget.onToggleLanguage,
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
                    )
                  : Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => go(1),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: widget.onToggleSunlight,
                          icon: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentCyan.withValues(alpha: 0.12),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.light_mode_outlined,
                              size: 16,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: widget.onToggleLanguage,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accentCyan.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.accentCyan.withValues(alpha: 0.3),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              loc.isArabic ? 'EN' : 'عربي',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          OfflineNoticeBanner(
            onViewCacheDetails: () => showDialog(
              context: context,
              builder: (_) => const OfflineCacheInfoDialog(),
            ),
          ),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: isTopLevel
          ? Container(
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
                  selectedIndex: _navIndex(tab),
                  onDestinationSelected: (i) => go([0, 1, 22, 27, 9][i]),
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
            )
          : null,
      ),
    );
  }

  /// BottomNav highlight mapping — mirrors MainActivity.kt isSelected rules:
  /// Services lights for site tabs, Commercial for trade tabs,
  /// Documents for docs tabs, Copilot for AI tabs.
  int _navIndex(int t) {
    if (t == 0) return 0;
    if ({1, 6, 14, 26, 28, 34, 35, 38, 41, 42, 43, 44, 46, 50, 51}.contains(t)) {
      return 1;
    }
    if ({3, 5, 7, 22, 25}.contains(t)) return 2;
    if ({12, 23, 27, 29, 32, 33, 37}.contains(t)) return 3;
    if ({9, 21, 36}.contains(t)) return 4;
    return 1;
  }
}
