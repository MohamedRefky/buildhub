// Clean Architecture: DashboardScreen
// Complete port of Kotlin DashboardScreen.kt
// Industrial Dark Theme, Currency Switcher (AED/SAR/USD), SitePulse Command Banner,
// Project Hero Card with CPI/SPI, Module 882 Financial Breakdown, Cashflow Trends,
// Tower Crane Wind Anemometer, Daily Site Logs, Gemini AI Chat launcher, and Live Alerts.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/buildhub_repository.dart';
import '../../domain/entities/home_entities.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int tab) onNavigateToTab;

  const DashboardScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCurrency = 'AED';
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  double get currencyRate {
    switch (selectedCurrency) {
      case 'SAR':
        return 1.02;
      case 'USD':
        return 0.272;
      default:
        return 1.0;
    }
  }

  String formatMoney(double aedAmount) {
    final converted = aedAmount * currencyRate;
    if (converted >= 1000000) {
      return '${(converted / 1000000).toStringAsFixed(1)}M $selectedCurrency';
    } else if (converted >= 1000) {
      return '${(converted / 1000).toStringAsFixed(0)}K $selectedCurrency';
    }
    return '${converted.toStringAsFixed(0)} $selectedCurrency';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showAddLogDialog(BuildContext context, BuildHubRepository repo) {
    final loc = context.read<AppLocalization>();
    final noteController = TextEditingController();
    String category = 'FIELD_NOTE';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkBorder),
          ),
          title: Text(
            loc.tr('إضافة تقرير موقع يومي جديد', 'Add New Daily Site Log'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: loc.tr('اكتب ملاحظة الموقع، حالة الأعمال، أو معوقات الصب...', 'Enter site observation, work status, delays...'),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(
                  labelText: loc.tr('التصنيف', 'Category'),
                ),
                dropdownColor: AppColors.darkCard,
                items: [
                  DropdownMenuItem(value: 'FIELD_NOTE', child: Text(loc.tr('ملاحظة ميدانية', 'Field Note'))),
                  DropdownMenuItem(value: 'CONCRETE_POUR', child: Text(loc.tr('محضر صب خرسانة', 'Concrete Pour'))),
                  DropdownMenuItem(value: 'SAFETY_HAZARD', child: Text(loc.tr('ملاحظة سلامة HSE', 'Safety Hazard'))),
                  DropdownMenuItem(value: 'WEATHER_HOLD', child: Text(loc.tr('توقف طقس ورياح', 'Weather Hold'))),
                ],
                onChanged: (v) {
                  if (v != null) setDlgState(() => category = v);
                },
              ),
            ],
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
                if (noteController.text.trim().isNotEmpty) {
                  final now = DateTime.now();
                  final timeStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
                  repo.addSiteLog(DailySiteLog(
                    id: 'log-${DateTime.now().millisecondsSinceEpoch}',
                    projectId: repo.currentProject.id,
                    dateStr: timeStr,
                    timestamp: timeStr,
                    summaryAr: noteController.text.trim(),
                    summaryEn: noteController.text.trim(),
                    note: noteController.text.trim(),
                    category: category,
                    author: 'Eng. Abdelfattah',
                    manpower: 45,
                    equipmentCount: 8,
                  ));
                  Navigator.pop(ctx);
                }
              },
              child: Text(loc.tr('حفظ في السجل', 'Save Log')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    final scheme = Theme.of(context).colorScheme;
    final p = repo.currentProject;
    final remainingBudget = p.budgetAed - p.spentAed;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // 1. Header: Welcome + Currency Switcher + Notifications
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.tr('مرحباً بك في', 'Welcome to'),
                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                ),
                const Text(
                  'Orion B',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimaryDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Currency Switcher
                InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedCurrency == 'AED') {
                        selectedCurrency = 'SAR';
                      } else if (selectedCurrency == 'SAR') {
                        selectedCurrency = 'USD';
                      } else {
                        selectedCurrency = 'AED';
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accentCyan.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedCurrency,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentCyan,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.swap_horiz, size: 14, color: AppColors.accentCyan),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Notification Bell with Badge (3)
                InkWell(
                  onTap: () => widget.onNavigateToTab(1),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.notifications_outlined, size: 20, color: scheme.onSurface),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.criticalRed,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 2. Real-time Search Input
        TextField(
          controller: searchController,
          onChanged: (val) => setState(() => searchQuery = val),
          decoration: InputDecoration(
            hintText: loc.tr('ابحث في الفواتير، الموردين، المشاريع...', 'Search invoices, suppliers, projects...'),
            prefixIcon: Icon(Icons.search, size: 20, color: scheme.onSurfaceVariant),
            filled: true,
            fillColor: scheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentCyan, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 3. SitePulse™ CM Command Center Quick Access Banner
        InkWell(
          onTap: () => widget.onNavigateToTab(50),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.engineering, color: Colors.black, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'SitePulse™ CM Command Center',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.verifiedGreen.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              loc.tr('غرفة العمليات', 'LIVE'),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.verifiedGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loc.tr('ماذا يحدث بموقعي اليوم؟ ما الذي يوقفنا؟ من المسؤول؟', 'What is happening, what is stopping us, who is responsible?'),
                        style: TextStyle(fontSize: 10.5, color: scheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.accentCyan),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 4. Quick Enterprise Shortcuts (6 items: 2 rows of 3)
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildShortcut(loc.tr('اسأل الموقع', 'Ask Site'), Icons.search, AppColors.accentCyan, () => widget.onNavigateToTab(36))),
                const SizedBox(width: 8),
                Expanded(child: _buildShortcut(loc.tr('الطيار الآلي', 'Autopilot'), Icons.smart_toy, AppColors.goldEmirates, () => widget.onNavigateToTab(43))),
                const SizedBox(width: 8),
                Expanded(child: _buildShortcut(loc.tr('+ تقرير نشاط', '+ Activity'), Icons.add_circle_outline, AppColors.verifiedGreen, () => widget.onNavigateToTab(44))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildShortcut(loc.tr('كاميرا الموقع', 'Camera'), Icons.photo_camera, const Color(0xFFFF9800), () => widget.onNavigateToTab(46))),
                const SizedBox(width: 8),
                Expanded(child: _buildShortcut(loc.tr('وظائف وتأجير', 'Jobs/Leasing'), Icons.work, AppColors.goldEmirates, () => widget.onNavigateToTab(2))),
                const SizedBox(width: 8),
                Expanded(child: _buildShortcut(loc.tr('فايربيس', 'Firebase'), Icons.cloud_sync, AppColors.accentCyan, () => widget.onNavigateToTab(45))),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        // 5. Active Project Hero Card
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.accentCyan.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project title + Complete chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.tr(p.nameAr, p.nameEn),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${p.code} • ${loc.tr(p.locationAr, p.locationEn)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.verifiedGreen.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        '${p.completionPercent}% ${loc.tr("مكتمل", "Complete")}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.verifiedGreen,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Linear Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: p.completionPercent / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.darkSurface,
                    valueColor: const AlwaysStoppedAnimation(AppColors.accentCyan),
                  ),
                ),

                const SizedBox(height: 12),

                // CPI / SPI indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${loc.tr("مؤشر التكلفة", "CPI")}: ',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                        ),
                        Text(
                          '${p.cpi}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: p.cpi >= 1.0 ? AppColors.verifiedGreen : AppColors.criticalRed,
                          ),
                        ),
                        Text(
                          p.cpi >= 1.0 ? ' (${loc.tr("ضمن الميزانية", "Under Budget")})' : ' (${loc.tr("تجاوز", "Over")})',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${loc.tr("مؤشر الجدول", "SPI")}: ',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                        ),
                        Text(
                          '${p.spi}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: p.spi >= 1.0 ? AppColors.verifiedGreen : AppColors.cautionAmber,
                          ),
                        ),
                        Text(
                          p.spi >= 1.0 ? ' (${loc.tr("متقدم", "Ahead")})' : ' (${loc.tr("تأخير طفيف", "Minor Delay")})',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Budget, Spent, Remaining Metrics
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem(loc.tr('الميزانية', 'Budget'), formatMoney(p.budgetAed), AppColors.accentSky),
                      _buildMetricItem(loc.tr('المنصرف', 'Spent'), formatMoney(p.spentAed), AppColors.cautionAmber),
                      _buildMetricItem(loc.tr('المتبقي', 'Remaining'), formatMoney(remainingBudget), AppColors.verifiedGreen),
                      _buildMetricItem(loc.tr('الأيام', 'Days Left'), '${p.daysRemaining}', AppColors.accentCyan),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Local Persistence Status Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.storage, size: 13, color: AppColors.accentCyan),
                          const SizedBox(width: 6),
                          Text(
                            loc.tr('تخزين محلي مؤمن: SQLite Offline-First', 'Local Persistence: SQLite Offline-First'),
                            style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark),
                          ),
                        ],
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.verifiedGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 6. Module 882 Financial Overview & Key Metrics Card
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.goldEmirates.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.tr('التحكم المالي والتدفقات (Module 882)', 'Financial Control & Cash Flow'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    Text(
                      selectedCurrency,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldEmirates,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2x2 Financial Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildFinBox(loc.tr('التكلفة المخططة', 'Planned Cost'), formatMoney(165000000), AppColors.accentSky),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFinBox(loc.tr('التكلفة الفعلية', 'Actual Cost'), formatMoney(142500000), AppColors.cautionAmber),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildFinBox(loc.tr('التدفق الداخلي', 'Cash In'), formatMoney(98500000), AppColors.verifiedGreen),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFinBox(loc.tr('رصيد الضريبة ٥٪', 'VAT Balance 5%'), formatMoney(342500), AppColors.goldEmirates),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Spending Breakdown by Category
                Text(
                  loc.tr('توزيع النفقات حسب الفئة (Module 882)', 'Spending Breakdown by Category'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(height: 8),

                // Stacked Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 8,
                    child: Row(
                      children: const [
                        Expanded(flex: 50, child: ColoredBox(color: AppColors.accentCyan)),
                        Expanded(flex: 30, child: ColoredBox(color: AppColors.goldEmirates)),
                        Expanded(flex: 20, child: ColoredBox(color: AppColors.verifiedGreen)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLegendItem(loc.tr('المواد (٥٠٪)', 'Materials (50%)'), AppColors.accentCyan),
                    _buildLegendItem(loc.tr('العمالة (٣٠٪)', 'Labor (30%)'), AppColors.goldEmirates),
                    _buildLegendItem(loc.tr('مقاولو باطن (٢٠٪)', 'Subcontractors (20%)'), AppColors.verifiedGreen),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 7. Tower Crane Wind Speed Monitoring Dashboard Widget (Dubai Code 11.4 & MoHRE)
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: AppColors.cautionAmber.withValues(alpha: 0.35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.cautionAmber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.cautionAmber.withValues(alpha: 0.4)),
                  ),
                  child: const Icon(Icons.air, color: AppColors.cautionAmber, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            loc.tr('مراقبة رياح الرافعات البرجية', 'Tower Crane Wind Radar'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.verifiedGreen.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              loc.tr('آمن ٢٤ كم/س', 'Safe 24 km/h'),
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loc.tr('الرافعة TC-01 (ارتفاع ١٨٥م) • الحد المسموح: ٣٨ كم/س', 'Crane TC-01 (185m elev) • 38 km/h MOHRE limit'),
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => widget.onNavigateToTab(6),
                  child: Text(loc.tr('تفاصيل', 'Details')),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 8. Daily Site Log & Note Capture Widget
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: AppColors.darkBorder.withValues(alpha: 0.8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event_note, size: 18, color: AppColors.accentCyan),
                        const SizedBox(width: 8),
                        Text(
                          loc.tr('سجل الموقع والملاحظات اليومية', 'Daily Site Logs & Notes'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.accentCyan, size: 22),
                      tooltip: loc.tr('إضافة تقرير', 'Add Log'),
                      onPressed: () => _showAddLogDialog(context, repo),
                    ),
                  ],
                ),
                if (repo.siteLogs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      loc.tr('لا توجد تقارير مسجلة اليوم. اضغط (+) لإضافة ملاحظة أو محضر صب.', 'No logs recorded today. Tap (+) to add note or pour record.'),
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                    ),
                  )
                else
                  ...repo.siteLogs.take(3).map((log) => Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            log.category,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.accentCyan),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.note,
                                style: const TextStyle(fontSize: 11, color: AppColors.textPrimaryDark),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${log.timestamp.isNotEmpty ? log.timestamp : log.dateStr} • ${log.author}',
                                style: const TextStyle(fontSize: 9, color: AppColors.textMutedDark),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 9. Gemini AI Construction & HSE Chat Launcher Card
        InkWell(
          onTap: () => widget.onNavigateToTab(9),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.smart_toy, color: AppColors.accentCyan, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.tr('شات المساعد الهندسي الذكي (Gemini AI)', 'Construction & HSE AI Chat (Gemini)'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loc.tr(
                          'استفسر عن حالة المشروع، الميزانية، أو اشتراطات حظر الظهيرة والسلامة',
                          'Query project progress, delays, budget, or HSE regulations',
                        ),
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondaryDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.accentCyan),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 10. Live Critical Alerts Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.criticalRed),
                const SizedBox(width: 6),
                Text(
                  loc.tr('التنبيهات الحرجة الحالية', 'Current Critical Alerts'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Text(
              '${repo.alerts.where((a) => !a.isResolved).length} ${loc.tr("تنبيه نشط", "Active")}',
              style: const TextStyle(fontSize: 11, color: AppColors.criticalRed, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),

        ...repo.alerts.where((a) => !a.isResolved).map((alert) {
          final isCritical = alert.severity == AlertSeverity.critical;
          final color = isCritical ? AppColors.criticalRed : AppColors.cautionAmber;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.45)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.tr(alert.titleAr, alert.titleEn),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loc.tr(alert.detailAr, alert.detailEn),
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondaryDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.dateStr,
                        style: const TextStyle(fontSize: 9, color: AppColors.textMutedDark),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: color,
                  ),
                  onPressed: () => repo.resolveAlert(alert.id),
                  child: Text(loc.tr('حل', 'Resolve')),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildShortcut(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.6)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondaryDark)),
      ],
    );
  }

  Widget _buildFinBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondaryDark)),
      ],
    );
  }
}
