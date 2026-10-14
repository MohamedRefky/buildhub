// Clean Architecture: Finance — Authentic 1:1 Jetpack Compose Design Parity.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// 1. FinanceClaimsScreen.kt (Tabs: Burn Rate, IPC, VO, VAT, FIDIC Claims, Circular Marketplace)
// 2. BudgetBurnRateDashboard.kt (D3/Recharts canvas chart & real-time expenses)
// 3. ProjectFinanceSummaryCard.kt (3-column KPI, progress & UAE cost categories)
// 4. SmartPettyCashWalletScreen.kt (Luxury physical bank card, EMV chip, NFC, 6 categories & vouchers)
// 5. CostToCompleteScreen.kt (AI Profit Prediction, EVM analysis, Work Breakdown)
// 6. FinancialAiScreen.kt (Hero KPI, Fraud Detection, BNPL Credit, Micro-Insurance)
// 7. ProjectBusinessPlanScreen.kt (Baseline, Revenue & Cost Control, Financial Risk Radar)

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/shared/widgets/status_card.dart';

// ============================================================================
// 1. FINANCE CLAIMS & COMMERCIAL HUB (FinanceClaimsScreen.kt Parity)
// ============================================================================

class FinanceClaimsFullScreen extends StatefulWidget {
  const FinanceClaimsFullScreen({super.key});

  @override
  State<FinanceClaimsFullScreen> createState() => _FinanceClaimsFullScreenState();
}

class _FinanceClaimsFullScreenState extends State<FinanceClaimsFullScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'التحكم المالي والمطالبات',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'FIDIC 2026',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentCyan),
                  ),
                ),
              ],
            ),
            const Text(
              'Finance & Commercial Hub • Al Sahab Residential Tower (PRJ-DXB-001)',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.accentCyan,
          indicatorWeight: 3,
          labelColor: AppColors.accentCyan,
          unselectedLabelColor: AppColors.textSecondaryDark,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
          tabs: const [
            Tab(text: 'استهلاك الميزانية D3/Recharts'),
            Tab(text: 'مستخلصات IPC'),
            Tab(text: 'أوامر تغييرية VO'),
            Tab(text: 'ضريبة 5% VAT'),
            Tab(text: 'مطالبات FIDIC (3)'),
            Tab(text: 'سوق التدوير والضمان'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBurnRateDashboardTab(),
          const _IpcGeneratorSection(),
          const _VariationOrdersSection(),
          const _VatEngineSection(),
          const _FidicClaimClockSection(),
          const _CircularMarketplaceSection(),
        ],
      ),
    );
  }

  Widget _buildBurnRateDashboardTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: const [
        _BudgetBurnRateDashboardWidget(),
        SizedBox(height: 14),
        _ProjectFinanceSummaryCardWidget(),
        SizedBox(height: 40),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 1.1 Budget Burn Rate Dashboard (BudgetBurnRateDashboard.kt Parity)
// ----------------------------------------------------------------------------

class _MonthlyBurnRecord {
  final String monthAr;
  final String monthEn;
  final double budgetAllocationAed;
  final double actualBurnAed;
  final String majorExpenseItemAr;
  final String majorExpenseItemEn;

  const _MonthlyBurnRecord({
    required this.monthAr,
    required this.monthEn,
    required this.budgetAllocationAed,
    required this.actualBurnAed,
    required this.majorExpenseItemAr,
    required this.majorExpenseItemEn,
  });
}

class _RealtimeExpense {
  final String id;
  final String descriptionAr;
  final String descriptionEn;
  final String categoryAr;
  final String categoryEn;
  final double amountAed;
  final String timestamp;
  final String status;
  final bool isAnomaly;

  const _RealtimeExpense({
    required this.id,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.amountAed,
    required this.timestamp,
    required this.status,
    this.isAnomaly = false,
  });
}

class _BudgetBurnRateDashboardWidget extends StatefulWidget {
  const _BudgetBurnRateDashboardWidget();

  @override
  State<_BudgetBurnRateDashboardWidget> createState() => _BudgetBurnRateDashboardWidgetState();
}

class _BudgetBurnRateDashboardWidgetState extends State<_BudgetBurnRateDashboardWidget> {
  int _selectedSubTab = 0; // 0: Burn Rate Chart, 1: Live Expenses
  int? _selectedMonthIndex;

  final List<_MonthlyBurnRecord> _burnRecords = const [
    _MonthlyBurnRecord(
      monthAr: 'يناير',
      monthEn: 'Jan',
      budgetAllocationAed: 5800000.0,
      actualBurnAed: 5200000.0,
      majorExpenseItemAr: 'حفر وأوتاد الخرسانة الأساسية',
      majorExpenseItemEn: 'Piling & Substructure',
    ),
    _MonthlyBurnRecord(
      monthAr: 'فبراير',
      monthEn: 'Feb',
      budgetAllocationAed: 6200000.0,
      actualBurnAed: 6100000.0,
      majorExpenseItemAr: 'جدران وقواعد القبو الخرساني',
      majorExpenseItemEn: 'Basement Walls & Core',
    ),
    _MonthlyBurnRecord(
      monthAr: 'مارس',
      monthEn: 'Mar',
      budgetAllocationAed: 7500000.0,
      actualBurnAed: 7900000.0,
      majorExpenseItemAr: 'صب بلاطة الطابق الأرضي خرسانة مسلحة',
      majorExpenseItemEn: 'Ground Floor Slab Concrete',
    ),
    _MonthlyBurnRecord(
      monthAr: 'أبريل',
      monthEn: 'Apr',
      budgetAllocationAed: 8000000.0,
      actualBurnAed: 8450000.0,
      majorExpenseItemAr: 'توريد حديد التسليح وأعمال MEP',
      majorExpenseItemEn: 'Rebar Procurement & MEP',
    ),
    _MonthlyBurnRecord(
      monthAr: 'مايو',
      monthEn: 'May',
      budgetAllocationAed: 8500000.0,
      actualBurnAed: 8200000.0,
      majorExpenseItemAr: 'أعمدة الأبراج ومصاعد الرفع الإنشائية',
      majorExpenseItemEn: 'Tower Cores & Lift Shafts',
    ),
    _MonthlyBurnRecord(
      monthAr: 'يونيو',
      monthEn: 'Jun',
      budgetAllocationAed: 9000000.0,
      actualBurnAed: 8950000.0,
      majorExpenseItemAr: 'واجهات الزجاج المزدوج والألومنيوم',
      majorExpenseItemEn: 'Glazing & Facade Installation',
    ),
  ];

  late List<_RealtimeExpense> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = [
      const _RealtimeExpense(
        id: 'EXP-8891',
        descriptionAr: 'خرسانة جاهزة عالية المقاومة (Readymix C50)',
        descriptionEn: 'High-Strength Readymix Concrete (C50)',
        categoryAr: 'خرسانة',
        categoryEn: 'Concrete',
        amountAed: 245000.0,
        timestamp: 'منذ 12 دقيقة',
        status: 'تم التوريد',
      ),
      const _RealtimeExpense(
        id: 'EXP-8892',
        descriptionAr: 'كابلات جهد متوسط معتمدة (DEWA Approved)',
        descriptionEn: 'DEWA Approved Medium-Voltage Cables',
        categoryAr: 'كهروميكانيك',
        categoryEn: 'MEP',
        amountAed: 185000.0,
        timestamp: 'منذ 45 دقيقة',
        status: 'تم التوريد',
      ),
      const _RealtimeExpense(
        id: 'EXP-8893',
        descriptionAr: 'اختبارات مقاومة الحريق واعتماد الدفاع المدني (DCD)',
        descriptionEn: 'Fire Resistance Testing & DCD Certification',
        categoryAr: 'اشتراطات',
        categoryEn: 'Statutory',
        amountAed: 42000.0,
        timestamp: 'منذ ساعتين',
        status: 'معتمد',
      ),
      const _RealtimeExpense(
        id: 'EXP-8894',
        descriptionAr: 'تأجير مضخة خرسانية ليلية إضافية (تجاوز معدل)',
        descriptionEn: 'Emergency Overnight Concrete Pump Rental',
        categoryAr: 'معدات',
        categoryEn: 'Equipment',
        amountAed: 68000.0,
        timestamp: 'منذ 4 ساعات',
        status: 'تجاوز طارئ',
        isAnomaly: true,
      ),
      const _RealtimeExpense(
        id: 'EXP-8895',
        descriptionAr: 'توريد حديد تسليح 16مم و 25مم (Emirates Steel)',
        descriptionEn: '16mm & 25mm Rebar Delivery (Emirates Steel)',
        categoryAr: 'مواد بناء',
        categoryEn: 'Materials',
        amountAed: 530000.0,
        timestamp: 'اليوم 08:30 ص',
        status: 'تم التوريد',
      ),
      const _RealtimeExpense(
        id: 'EXP-8896',
        descriptionAr: 'دفعة مقاول باطن أعمال العزل المائي (Sika)',
        descriptionEn: 'Waterproofing Subcontractor Payment (Sika)',
        categoryAr: 'عزل',
        categoryEn: 'Waterproofing',
        amountAed: 92000.0,
        timestamp: 'أمس',
        status: 'تم الصرف',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final totalBurn = _burnRecords.fold(0.0, (acc, r) => acc + r.actualBurnAed);
    final totalAllocated = _burnRecords.fold(0.0, (acc, r) => acc + r.budgetAllocationAed);
    final avgMonthlyBurn = totalBurn / _burnRecords.length;
    final burnVelocityPct = totalAllocated > 0 ? ((totalBurn / totalAllocated) * 100).toInt() : 100;
    const totalBudget = 145000000.0;
    const totalSpent = 89200000.0;
    final remainingBudget = (totalBudget - totalSpent).clamp(0.0, double.infinity);
    final monthsRunway = avgMonthlyBurn > 0 ? (remainingBudget / avgMonthlyBurn).toInt() : 12;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.45)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.bar_chart, color: AppColors.accentCyan, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'معدل استهلاك الميزانية (Burn Rate)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'D3 / Recharts',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.accentCyan),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Real-Time Project Expense Incurrence & Burn Velocity',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Sub-navigation Tabs: Chart vs Stream
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _selectedSubTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedSubTab == 0 ? AppColors.accentCyan : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timeline,
                            size: 16,
                            color: _selectedSubTab == 0 ? AppColors.darkBackground : AppColors.textPrimaryDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'منحنى الاستهلاك (Chart)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _selectedSubTab == 0 ? AppColors.darkBackground : AppColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _selectedSubTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedSubTab == 1 ? AppColors.accentCyan : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 16,
                            color: _selectedSubTab == 1 ? AppColors.darkBackground : AppColors.textPrimaryDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'المصاريف الحية (${_expenses.length})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _selectedSubTab == 1 ? AppColors.darkBackground : AppColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Burn Rate KPI Stats Row
          Row(
            children: [
              Expanded(
                child: _buildMiniKpiCard(
                  title: 'معدل الحرق الشهري',
                  subTitle: 'Avg Burn / Month',
                  val: '${(avgMonthlyBurn / 1000000).toStringAsFixed(1)}M AED',
                  valColor: AppColors.accentCyan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniKpiCard(
                  title: 'سرعة الاستهلاك',
                  subTitle: burnVelocityPct <= 100 ? 'Safe Pace' : 'Accelerated',
                  val: '$burnVelocityPct%',
                  valColor: burnVelocityPct > 105 ? AppColors.criticalRed : AppColors.verifiedGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniKpiCard(
                  title: 'رصيد التشغيل',
                  subTitle: 'Runway to BCC',
                  val: '$monthsRunway شهر',
                  valColor: AppColors.cautionAmber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (_selectedSubTab == 0) ...[
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.accentCyan, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 4),
                    const Text('Actual Burn (AED)', style: TextStyle(fontSize: 11, color: AppColors.textPrimaryDark)),
                    const SizedBox(width: 12),
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.cautionAmber.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 4),
                    const Text('Budget Ceiling', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                  ],
                ),
                const Text(
                  'المس أي عمود للتفاصيل',
                  style: TextStyle(fontSize: 10, color: AppColors.accentCyan),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // D3/Recharts SVG/Canvas Bar & Trend Hybrid Chart
            GestureDetector(
              onTapDown: (details) {
                const paddingLeft = 45.0;
                const paddingRight = 15.0;
                final box = context.findRenderObject() as RenderBox?;
                final totalWidth = box?.size.width ?? 350.0;
                final chartWidth = totalWidth - paddingLeft - paddingRight;
                final slotWidth = chartWidth / _burnRecords.length;
                final localX = details.localPosition.dx - paddingLeft;
                if (localX >= 0 && localX <= chartWidth) {
                  final idx = (localX / slotWidth).floor().clamp(0, _burnRecords.length - 1);
                  setState(() {
                    _selectedMonthIndex = _selectedMonthIndex == idx ? null : idx;
                  });
                }
              },
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: CustomPaint(
                  painter: _BurnRateChartPainter(
                    records: _burnRecords,
                    selectedIndex: _selectedMonthIndex,
                  ),
                ),
              ),
            ),

            // Active Month Inspection Card if selected
            if (_selectedMonthIndex != null) ...[
              const SizedBox(height: 10),
              _buildMonthInspectionCard(_burnRecords[_selectedMonthIndex!]),
            ],
          ] else ...[
            // Real-Time Expense Stream
            ..._expenses.map((exp) => _buildExpenseItem(exp)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _showAddExpenseDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: AppColors.darkBackground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 44),
              ),
              icon: const Icon(Icons.add_circle, size: 18),
              label: const Text('+ إضافة مصروف فوري للموقع / Add Live Expense', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniKpiCard({required String title, required String subTitle, required String val, required Color valColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 4),
          Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: valColor)),
          Text(subTitle, style: const TextStyle(fontSize: 9, color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }

  Widget _buildMonthInspectionCard(_MonthlyBurnRecord r) {
    final variance = r.actualBurnAed - r.budgetAllocationAed;
    final isOver = variance > 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isOver ? AppColors.criticalRed.withValues(alpha: 0.5) : AppColors.accentCyan.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${r.monthAr} (${r.monthEn}) • تفاصيل الصرف',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimaryDark),
              ),
              BhStatusChip(
                label: isOver ? '+${(variance / 1000).toStringAsFixed(0)}K تجاوز' : 'ضمن المخطط',
                status: isOver ? BhStatusType.critical : BhStatusType.verified,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الميزانية: ${(r.budgetAllocationAed / 1000000).toStringAsFixed(2)}M AED', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
              Text('الفعلي: ${(r.actualBurnAed / 1000000).toStringAsFixed(2)}M AED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isOver ? AppColors.criticalRed : AppColors.accentCyan)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'البند الأساسي: ${r.majorExpenseItemAr} (${r.majorExpenseItemEn})',
            style: const TextStyle(fontSize: 11, color: AppColors.accentSky),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(_RealtimeExpense exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: exp.isAnomaly ? AppColors.criticalRed : AppColors.darkBorder.withValues(alpha: 0.3),
          width: exp.isAnomaly ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(exp.id, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                  ),
                  const SizedBox(width: 6),
                  Text(exp.categoryAr, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                ],
              ),
              if (exp.isAnomaly)
                const BhStatusChip(label: '⚠️ تنبيه شذوذ Anomaly', status: BhStatusType.critical)
              else
                BhStatusChip(label: exp.status, status: BhStatusType.verified),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            exp.descriptionAr,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${exp.amountAed.toStringAsFixed(0)} AED',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: exp.isAnomaly ? AppColors.criticalRed : AppColors.accentCyan,
                ),
              ),
              Text(exp.timestamp, style: const TextStyle(fontSize: 10, color: AppColors.textMutedDark)),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog() {
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text('تسجيل مصروف فوري بالموقع', style: TextStyle(color: AppColors.textPrimaryDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descCtrl,
              style: const TextStyle(color: AppColors.textPrimaryDark),
              decoration: const InputDecoration(labelText: 'وصف المصروف', labelStyle: TextStyle(color: AppColors.textSecondaryDark)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimaryDark),
              decoration: const InputDecoration(labelText: 'المبلغ (AED)', labelStyle: TextStyle(color: AppColors.textSecondaryDark)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: AppColors.darkBackground),
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text) ?? 50000.0;
              setState(() {
                _expenses.insert(
                  0,
                  _RealtimeExpense(
                    id: 'EXP-${1000 + math.Random().nextInt(8999)}',
                    descriptionAr: descCtrl.text.isEmpty ? 'مصروف خرساني طارئ بالموقع' : descCtrl.text,
                    descriptionEn: 'Emergency Site Incidental Expense',
                    categoryAr: 'موقع',
                    categoryEn: 'Site',
                    amountAed: amt,
                    timestamp: 'الآن',
                    status: 'قيد الاعتماد',
                  ),
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('حفظ المصروف'),
          ),
        ],
      ),
    );
  }
}

class _BurnRateChartPainter extends CustomPainter {
  final List<_MonthlyBurnRecord> records;
  final int? selectedIndex;

  _BurnRateChartPainter({required this.records, this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    const paddingLeft = 40.0;
    const paddingRight = 15.0;
    const paddingTop = 20.0;
    const paddingBottom = 30.0;
    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;
    const maxAmount = 10000000.0; // 10M AED ceiling

    final gridPaint = Paint()
      ..color = AppColors.darkBorder.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw horizontal dashed grid lines (0M, 2.5M, 5M, 7.5M, 10M)
    final gridSteps = [0.0, 2500000.0, 5000000.0, 7500000.0, 10000000.0];
    for (final step in gridSteps) {
      final y = paddingTop + chartHeight - ((step / maxAmount) * chartHeight);
      canvas.drawLine(Offset(paddingLeft, y), Offset(size.width - paddingRight, y), gridPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: '${(step / 1000000).toStringAsFixed(1)}M',
          style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(4, y - 6));
    }

    final slotWidth = chartWidth / records.length;
    final barWidth = slotWidth * 0.42;
    final trendPoints = <Offset>[];

    for (var i = 0; i < records.length; i++) {
      final record = records[i];
      final slotCenterX = paddingLeft + (i * slotWidth) + (slotWidth / 2);

      // 1. Budget Ceiling Bar (Amber semi-transparent)
      final budgetBarHeight = ((record.budgetAllocationAed / maxAmount) * chartHeight).clamp(4.0, chartHeight);
      final budgetBarY = paddingTop + chartHeight - budgetBarHeight;
      final budgetPaint = Paint()
        ..color = AppColors.cautionAmber.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(slotCenterX - (barWidth / 2), budgetBarY, barWidth, budgetBarHeight),
          const Radius.circular(4),
        ),
        budgetPaint,
      );

      // 2. Actual Burn Bar (Cyan or Red if over budget)
      final isOver = record.actualBurnAed > record.budgetAllocationAed;
      final barColor = isOver ? AppColors.criticalRed : AppColors.accentCyan;
      final actualBarHeight = ((record.actualBurnAed / maxAmount) * chartHeight).clamp(4.0, chartHeight);
      final actualBarY = paddingTop + chartHeight - actualBarHeight;
      final isSelected = selectedIndex == i;

      final actualPaint = Paint()
        ..color = isSelected ? barColor : barColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(slotCenterX - (barWidth / 2), actualBarY, barWidth, actualBarHeight),
          const Radius.circular(4),
        ),
        actualPaint,
      );

      if (isSelected) {
        final strokePaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(slotCenterX - (barWidth / 2) - 2, actualBarY - 2, barWidth + 4, actualBarHeight + 4),
            const Radius.circular(6),
          ),
          strokePaint,
        );
      }

      trendPoints.add(Offset(slotCenterX, actualBarY));

      // 3. Month label
      final monthTp = TextPainter(
        text: TextSpan(
          text: record.monthEn,
          style: TextStyle(
            color: isSelected ? AppColors.accentCyan : AppColors.textSecondaryDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      monthTp.paint(canvas, Offset(slotCenterX - (monthTp.width / 2), size.height - paddingBottom + 8));
    }

    // 4. Trend Line connecting points
    if (trendPoints.length > 1) {
      final linePath = Path()..moveTo(trendPoints[0].dx, trendPoints[0].dy);
      for (var i = 1; i < trendPoints.length; i++) {
        final prev = trendPoints[i - 1];
        final curr = trendPoints[i];
        final cX = (prev.dx + curr.dx) / 2;
        linePath.cubicTo(cX, prev.dy, cX, curr.dy, curr.dx, curr.dy);
      }
      final trendPaint = Paint()
        ..color = AppColors.accentCyan.withValues(alpha: 0.7)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawPath(linePath, trendPaint);

      for (final pt in trendPoints) {
        canvas.drawCircle(pt, 3.5, Paint()..color = Colors.white);
        canvas.drawCircle(pt, 2, Paint()..color = AppColors.accentCyan);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BurnRateChartPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex || oldDelegate.records != records;
}

// ----------------------------------------------------------------------------
// 1.2 Project Finance Summary Card (ProjectFinanceSummaryCard.kt Parity)
// ----------------------------------------------------------------------------

class _ProjectFinanceSummaryCardWidget extends StatefulWidget {
  const _ProjectFinanceSummaryCardWidget();

  @override
  State<_ProjectFinanceSummaryCardWidget> createState() => _ProjectFinanceSummaryCardWidgetState();
}

class _ProjectFinanceSummaryCardWidgetState extends State<_ProjectFinanceSummaryCardWidget> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    const totalBudget = 145000000.0;
    const totalSpent = 89200000.0;
    final remaining = totalBudget - totalSpent;
    final spendRatio = totalSpent / totalBudget;
    final spendPct = (spendRatio * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.verifiedGreen.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.payments, color: AppColors.verifiedGreen, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ملخص مالية المشروع والتكاليف',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Approved Budget vs. Actual Incurred',
                            style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const BhStatusChip(label: 'ضمن الميزانية', status: BhStatusType.verified),
            ],
          ),
          const SizedBox(height: 14),

          // 3 KPI Cards
          Row(
            children: [
              Expanded(
                child: _buildSummarySubCard(
                  label: 'الميزانية المعتمدة',
                  dotColor: AppColors.accentCyan,
                  amount: '${(totalBudget / 1000000).toStringAsFixed(1)}M AED',
                  subText: 'Contract Base',
                  amountColor: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummarySubCard(
                  label: 'المنصرف الفعلي',
                  dotColor: AppColors.cautionAmber,
                  amount: '${(totalSpent / 1000000).toStringAsFixed(1)}M AED',
                  subText: '$spendPct% utilized',
                  amountColor: AppColors.cautionAmber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummarySubCard(
                  label: 'الرصيد المتبقي',
                  dotColor: AppColors.verifiedGreen,
                  amount: '${(remaining / 1000000).toStringAsFixed(1)}M AED',
                  subText: 'In Escrow Acc.',
                  amountColor: AppColors.verifiedGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('نسبة استهلاك الميزانية (Utilization Ratio)', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
              Text('$spendPct% (متبقي ${100 - spendPct}%)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: spendRatio,
              minHeight: 8,
              backgroundColor: AppColors.darkSurface,
              color: AppColors.accentCyan,
            ),
          ),
          const SizedBox(height: 12),

          // Toggle Expand Cost Categories
          InkWell(
            onTap: () => setState(() => _showDetails = !_showDetails),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تفصيل حزم تكاليف البناء (Cost Breakdown)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accentCyan),
                ),
                Icon(_showDetails ? Icons.expand_less : Icons.expand_more, color: AppColors.accentCyan, size: 20),
              ],
            ),
          ),

          if (_showDetails) ...[
            const SizedBox(height: 10),
            _buildCostCategoryRow('الأعمال الإنشائية والخرسانة المسلحة', 'Structural & Concrete', 0.40, 0.38, AppColors.accentCyan, Icons.apartment),
            _buildCostCategoryRow('الكهروميكانيك والتكييف (MEP)', 'MEP & HVAC Engineering', 0.25, 0.22, AppColors.accentSky, Icons.electric_bolt),
            _buildCostCategoryRow('التشطيبات المعمارية والواجهات', 'Architectural & Facade', 0.20, 0.16, AppColors.cautionAmber, Icons.layers),
            _buildCostCategoryRow('الاستشارات والرسوم الحكومية', 'Consultancy & Statutory', 0.15, 0.14, AppColors.verifiedGreen, Icons.account_balance),
          ],
        ],
      ),
    );
  }

  Widget _buildSummarySubCard({
    required String label,
    required Color dotColor,
    required String amount,
    required String subText,
    required Color amountColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondaryDark), maxLines: 1),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: amountColor), maxLines: 1),
          Text(subText, style: const TextStyle(fontSize: 9, color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }

  Widget _buildCostCategoryRow(String titleAr, String titleEn, double budgetRatio, double spentRatio, Color col, IconData ic) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(ic, color: col, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleAr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                  Text(titleEn, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondaryDark)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${(spentRatio * 100).toInt()}% من ${(budgetRatio * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: col)),
                Text('${(145 * spentRatio).toStringAsFixed(1)}M AED', style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondaryDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// 1.3 IPC Generator Section (FinanceClaimsScreen.kt Parity)
// ----------------------------------------------------------------------------

class _IpcGeneratorSection extends StatefulWidget {
  const _IpcGeneratorSection();

  @override
  State<_IpcGeneratorSection> createState() => _IpcGeneratorSectionState();
}

class _IpcGeneratorSectionState extends State<_IpcGeneratorSection> {
  final _grossCtrl = TextEditingController(text: '48500000');
  final _retentionCtrl = TextEditingController(text: '10');
  final _previousCtrl = TextEditingController(text: '42100000');
  final _advanceCtrl = TextEditingController(text: '850000');
  bool _isGenerated = false;

  @override
  Widget build(BuildContext context) {
    final gross = double.tryParse(_grossCtrl.text) ?? 48500000.0;
    final retentionPct = (double.tryParse(_retentionCtrl.text) ?? 10.0) / 100.0;
    final previous = double.tryParse(_previousCtrl.text) ?? 42100000.0;
    final advance = double.tryParse(_advanceCtrl.text) ?? 850000.0;

    final retentionAmount = gross * retentionPct;
    final netCertified = gross - retentionAmount - advance;
    final currentPaymentDue = (netCertified - previous).clamp(0.0, double.infinity);
    final vatAmount = currentPaymentDue * 0.05;
    final totalPayable = currentPaymentDue + vatAmount;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // Input Card
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt_long, color: AppColors.accentCyan),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'شهادة الدفع المرحلية (IPC) - عقد فيديك الكتاب الأحمر',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'FIDIC Cl. 14.3 interim valuation with retention & VAT auto-computation',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
              ),
              const SizedBox(height: 14),

              _buildField('إجمالي الأعمال المنجزة التراكمي (Gross Valuation AED)', _grossCtrl),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildField('نسبة الاستقطاع %', _retentionCtrl)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildField('استرداد الدفعة المقدمة (AED)', _advanceCtrl)),
                ],
              ),
              const SizedBox(height: 10),
              _buildField('المبالغ المصروفة السابقة (Previous Certified AED)', _previousCtrl),
              const SizedBox(height: 14),

              ElevatedButton.icon(
                onPressed: () => setState(() => _isGenerated = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentCyan,
                  foregroundColor: AppColors.darkBackground,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(double.infinity, 44),
                ),
                icon: const Icon(Icons.check_circle, size: 18),
                label: const Text('إصدار مسودة مستخلص IPC #08 رسمي', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Valuation Summary Breakdown Card
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ملخص مستحق الدفع (Valuation Breakdown)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 12),
              _ipcRow('إجمالي العمل المنجز (Gross Work)', 'AED ${_formatAed(gross)}'),
              _ipcRow('خصم الاستقطاع (Retention 10%)', '- AED ${_formatAed(retentionAmount)}', color: AppColors.cautionAmber),
              _ipcRow('استرداد الدفعة المقدمة (Advance Recovery)', '- AED ${_formatAed(advance)}', color: AppColors.cautionAmber),
              _ipcRow('خصم المستخلصات السابقة (Previous)', '- AED ${_formatAed(previous)}', color: AppColors.textSecondaryDark),
              const Divider(color: AppColors.darkBorder),
              _ipcRow('صافي المستحق قبل الضريبة (Net Payable)', 'AED ${_formatAed(currentPaymentDue)}', color: AppColors.accentCyan, isBold: true),
              _ipcRow('ضريبة القيمة المضافة 5% (UAE VAT)', '+ AED ${_formatAed(vatAmount)}', color: AppColors.verifiedGreen),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('الإجمالي المستحق للصرف شامل الضريبة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                    Text('AED ${_formatAed(totalPayable)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.accentCyan)),
                  ],
                ),
              ),

              if (_isGenerated) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: AppColors.verifiedGreen, size: 16),
                      SizedBox(width: 6),
                      Text('تم توثيق مسودة المستخلص بختم توقيع رقمي مشفر (Token Stamp)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.darkBorder)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _ipcRow(String label, String val, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondaryDark)),
          Text(val, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: color ?? AppColors.textPrimaryDark)),
        ],
      ),
    );
  }

  
}

// ----------------------------------------------------------------------------
// 1.4 Variation Orders Section (VO Tracker in FinanceClaimsScreen.kt)
// ----------------------------------------------------------------------------

class _VariationOrdersSection extends StatelessWidget {
  const _VariationOrdersSection();

  @override
  Widget build(BuildContext context) {
    final voList = [
      {
        'id': 'VO-01',
        'title': 'ترقية الزجاج المزدوج والواجهات الحرارية المقاومة',
        'titleEn': 'Upgrade Double Glazing & Thermal Façade',
        'cost': 1850000.0,
        'days': 14,
        'clause': 'FIDIC Cl. 13.1',
        'status': 'معتمد من المالك Approved',
        'statusType': BhStatusType.verified,
      },
      {
        'id': 'VO-02',
        'title': 'تعديل مسار كابلات الجهد المتوسط التابعة لديوا (DEWA)',
        'titleEn': 'Rerouting Medium-Voltage DEWA Cables',
        'cost': 420000.0,
        'days': 21,
        'clause': 'FIDIC Cl. 13.3',
        'status': 'قيد مراجعة الاستشاري Under Review',
        'statusType': BhStatusType.caution,
      },
      {
        'id': 'VO-03',
        'title': 'إضافة نظام رشاشات إطفاء أوتوماتيكي بالقبو الإضافي',
        'titleEn': 'Automated Sprinkler Addition in Basement',
        'cost': 690000.0,
        'days': 7,
        'clause': 'FIDIC Cl. 13.2',
        'status': 'بانتظار اعتماد الدفاع المدني Pending DCD',
        'statusType': BhStatusType.critical,
      },
      {
        'id': 'VO-04',
        'title': 'إعادة تصميم رخام بهو الاستقبال والمصاعد الفاخرة',
        'titleEn': 'Lobby Luxury Marble Redesign',
        'cost': 1150000.0,
        'days': 0,
        'clause': 'FIDIC Cl. 13.1',
        'status': 'مسودة مقترحة Proposed Draft',
        'statusType': BhStatusType.info,
      },
    ];

    final totalCost = voList.fold(0.0, (acc, item) => acc + (item['cost'] as double));
    final totalDays = voList.fold(0, (acc, item) => acc + (item['days'] as int));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // Summary KPI Banner
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('إجمالي التكلفة الإضافية (Total Cost)', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                  const SizedBox(height: 4),
                  Text('AED ${_formatAed(totalCost)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                ],
              ),
              Container(width: 1, height: 30, color: AppColors.darkBorder),
              Column(
                children: [
                  const Text('تمديد الوقت الزمني (EOT)', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                  const SizedBox(height: 4),
                  Text('+$totalDays يوم (Days)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.cautionAmber)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        ...voList.map((vo) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(vo['id'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                      ),
                      const SizedBox(width: 6),
                      Text(vo['clause'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                    ],
                  ),
                  BhStatusChip(label: vo['status'] as String, status: vo['statusType'] as BhStatusType),
                ],
              ),
              const SizedBox(height: 8),
              Text(vo['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              Text(vo['titleEn'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('التكلفة: AED ${_formatAed(vo['cost'] as double)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                  Text(
                    'الجدول الزمني: +${vo['days']} يوم',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (vo['days'] as int) > 0 ? AppColors.cautionAmber : AppColors.verifiedGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 1.5 UAE 5% VAT Engine (VatEngineSection in FinanceClaimsScreen.kt)
// ----------------------------------------------------------------------------

class _VatEngineSection extends StatefulWidget {
  const _VatEngineSection();

  @override
  State<_VatEngineSection> createState() => _VatEngineSectionState();
}

class _VatEngineSectionState extends State<_VatEngineSection> {
  final _salesCtrl = TextEditingController(text: '12500000');
  final _purchasesCtrl = TextEditingController(text: '8400000');

  @override
  Widget build(BuildContext context) {
    final sales = double.tryParse(_salesCtrl.text) ?? 12500000.0;
    final purchases = double.tryParse(_purchasesCtrl.text) ?? 8400000.0;

    final outputVat = sales * 0.05;
    final inputVat = purchases * 0.05;
    final netVat = outputVat - inputVat;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long, color: AppColors.accentCyan),
                      SizedBox(width: 8),
                      Text(
                        'محرك ضريبة القيمة المضافة 5% (UAE VAT)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                      ),
                    ],
                  ),
                  BhStatusChip(label: 'FTA Ready', status: BhStatusType.verified),
                ],
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _salesCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'المبيعات والمستخلصات الخاضعة للضريبة (Taxable Sales AED)',
                  labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.darkSurface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _purchasesCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'المشتريات ومقاولو الباطن الخاضعة للضريبة (Purchases AED)',
                  labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.darkSurface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),

              // Summary Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _vatRow('ضريبة المخرجات المحصلة (Output VAT 5%):', 'AED ${_formatAed(outputVat)}'),
                    const SizedBox(height: 6),
                    _vatRow('ضريبة المدخلات القابلة للاسترداد (Recoverable Input VAT):', 'AED ${_formatAed(inputVat)}'),
                    const Divider(color: AppColors.darkBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('صافي الضريبة واجبة السداد للهيئة الاتحادية (FTA):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                        Text(
                          'AED ${_formatAed(netVat)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: netVat > 0 ? AppColors.criticalRed : AppColors.verifiedGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تصدير إقرار ضريبة القيمة المضافة PDF معتمد من الهيئة')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentCyan,
                  foregroundColor: AppColors.darkBackground,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(double.infinity, 44),
                ),
                icon: const Icon(Icons.calculate, size: 18),
                label: const Text('تصدير إقرار ضريبي جاهز للتدقيق (Audit-Ready PDF)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _vatRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
        Text(val, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 1.6 FIDIC Notice & Claim Clock Section (FinanceClaimsScreen.kt Parity)
// ----------------------------------------------------------------------------

class _FidicClaimClockSection extends StatelessWidget {
  const _FidicClaimClockSection();

  @override
  Widget build(BuildContext context) {
    final claims = [
      {
        'noticeNo': 'CLM-2026-04',
        'days': 5,
        'title': 'تأخر تسليم مساحة العمل في منطقة B من قبل صاحب العمل',
        'titleEn': 'Delay in Handover of Zone B Worksite by Employer',
        'subClause': 'Sub-Clause 20.1 & 8.4',
        'exposure': 2450000.0,
        'status': 'تم تقديم التفاصيل الكاملة',
      },
      {
        'noticeNo': 'CLM-2026-03',
        'days': 18,
        'title': 'ظروف جوية استثنائية غير متوقعة (فيضانات دبي)',
        'titleEn': 'Adverse Unforeseeable Climatic Conditions (Dubai Flood)',
        'subClause': 'Sub-Clause 20.1 & 19.1',
        'exposure': 1180000.0,
        'status': 'تم إرسال إخطار المطالبة الأولي',
      },
      {
        'noticeNo': 'CLM-2026-02',
        'days': 24,
        'title': 'تأخر غير اعتيادي في اعتمادات بلدية دبي للمخططات',
        'titleEn': 'Exceptional Delay in Municipality NOC Approvals',
        'subClause': 'Sub-Clause 20.1 & 8.5',
        'exposure': 680000.0,
        'status': 'قيد دراسة ومراجعة الاستشاري',
      },
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // Clock Banner
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cautionAmber),
          ),
          padding: const EdgeInsets.all(14),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.timer, color: AppColors.cautionAmber),
                  SizedBox(width: 8),
                  Text(
                    'ساعة إخطارات ومطالبات فيديك (FIDIC Clock M8)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                'تتبع دقيق لمهلة الـ 28 يوماً الإلزامية تحت بند فيديك 20.1 لحماية الحقوق وتجنب السقوط بالتقادم (Time-Bar).',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        ...claims.map((claim) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(claim['noticeNo'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                  BhStatusChip(
                    label: '${claim['days']} أيام قبل السقوط (Time-Bar)',
                    status: (claim['days'] as int) <= 7 ? BhStatusType.critical : BhStatusType.caution,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(claim['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              Text(claim['titleEn'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
              const SizedBox(height: 4),
              Text(claim['subClause'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accentSky)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('المبلغ المطالب به (AED Exposure)', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                      Text('AED ${_formatAed(claim['exposure'] as double)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.cautionAmber)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('الحالة القانونية', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                      Text(claim['status'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimaryDark)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// 1.7 Circular Marketplace & Escrow Section (FinanceClaimsScreen.kt Parity)
// ----------------------------------------------------------------------------

class _CircularMarketplaceSection extends StatelessWidget {
  const _CircularMarketplaceSection();

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'حديد تسليح عالي المقاومة فائض (Grade 60) - 45 طن',
        'category': 'مواد إنشائية Rebar',
        'location': 'دبي الجنوب (Dubai South)',
        'quantity': '45',
        'unit': 'طن',
        'price': 2150.0,
        'origPrice': 2650.0,
        'co2': 18200,
        'escrow': true,
      },
      {
        'title': 'خرسانة جاهزة C40 فائضة مع مبطئ شك (Retarded Batch)',
        'category': 'خرسانة جاهزة ReadyMix',
        'location': 'الخليج التجاري (Business Bay)',
        'quantity': '80',
        'unit': 'م³',
        'price': 220.0,
        'origPrice': 310.0,
        'co2': 6400,
        'escrow': true,
      },
      {
        'title': 'شدات معدنية للأعمدة والجدران (Peri Trio Formwork)',
        'category': 'شدات وقوالب المعدات',
        'location': 'القوز الصناعية (Al Quoz)',
        'quantity': '12',
        'unit': 'طقم',
        'price': 14000.0,
        'origPrice': 22000.0,
        'co2': 9800,
        'escrow': true,
      },
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.verifiedGreen),
          ),
          padding: const EdgeInsets.all(14),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.recycling, color: AppColors.verifiedGreen),
                  SizedBox(width: 8),
                  Text(
                    'سوق التدوير الدائري وخفض الانبعاثات (Escrow)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                'تبادل فائض مواد البناء والخرسانة والمعدات بين مشاريع الدولة. محمي بنظام حساب الضمان البنكي (Escrow) وحساب وفورات الكربون EPD.',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        ...items.map((it) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(it['category'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentSky)),
                  if (it['escrow'] as bool)
                    const Row(
                      children: [
                        Icon(Icons.lock, color: AppColors.verifiedGreen, size: 13),
                        SizedBox(width: 3),
                        Text('محمي بحساب الضمان Escrow', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(it['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 4),
              Text('📍 ${it['location']} • المتاح: ${it['quantity']} ${it['unit']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AED ${_formatAed(it['price'] as double)} / ${it['unit']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                      Text('السعر الأصلي: AED ${_formatAed(it['origPrice'] as double)}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('🌱 -${it['co2']} kg CO2', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                  ),
                ],
              ),
            ],
          ),
        )),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ============================================================================
// 2. SMART PETTY CASH WALLET SCREEN (SmartPettyCashWalletScreen.kt Parity)
// ============================================================================

class PettyCashFullScreen extends StatefulWidget {
  const PettyCashFullScreen({super.key});

  @override
  State<PettyCashFullScreen> createState() => _PettyCashFullScreenState();
}

class _PettyCashFullScreenState extends State<PettyCashFullScreen> {
  int _selectedCardIndex = 0;
  String? _selectedCategory;
  bool _showFullCardNumber = false;

  final List<Map<String, dynamic>> _engineerCards = [
    {
      'id': 'CARD-CM-01',
      'nameAr': 'م. عبدالفتاح إبراهيم البلوشي',
      'nameEn': 'Eng. Abdelfattah Ibrahim',
      'roleAr': 'مدير الموقع الإنشائي (Construction Manager)',
      'roleEn': 'Construction Manager',
      'cardNum': '4532  8819  2048  9123',
      'masked': '••••  ••••  ••••  9123',
      'expiry': '08/29',
      'cvv': '482',
      'limit': 12000.0,
      'spent': 7240.0,
      'isFrozen': false,
      'network': 'VISA CORPORATE PLATINUM',
      'gradient': const [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF0284C7)],
    },
    {
      'id': 'CARD-STR-02',
      'nameAr': 'م. أحمد الراشدي',
      'nameEn': 'Eng. Ahmed Al Rashidi',
      'roleAr': 'مهندس إنشائي أول (Senior Structural)',
      'roleEn': 'Senior Structural Engineer',
      'cardNum': '5241  6604  3912  4421',
      'masked': '••••  ••••  ••••  4421',
      'expiry': '11/28',
      'cvv': '319',
      'limit': 8000.0,
      'spent': 4650.0,
      'isFrozen': false,
      'network': 'MASTERCARD BUSINESS',
      'gradient': const [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF10B981)],
    },
    {
      'id': 'CARD-MEP-03',
      'nameAr': 'م. راجيف كومار',
      'nameEn': 'Eng. Rajiv Kumar',
      'roleAr': 'مهندس كهروميكانيك أول (Senior MEP)',
      'roleEn': 'Senior MEP Engineer',
      'cardNum': '4111  7890  1254  7734',
      'masked': '••••  ••••  ••••  7734',
      'expiry': '04/29',
      'cvv': '805',
      'limit': 6000.0,
      'spent': 3800.0,
      'isFrozen': false,
      'network': 'VISA CORPORATE',
      'gradient': const [Color(0xFF4C1D95), Color(0xFF6D28D9), Color(0xFF8B5CF6)],
    },
    {
      'id': 'CARD-HSE-04',
      'nameAr': 'طارق منصور',
      'nameEn': 'Tariq Mansoor',
      'roleAr': 'مسؤول الصحة والسلامة (HSE Officer)',
      'roleEn': 'HSE Safety Officer',
      'cardNum': '5412  3388  7741  1190',
      'masked': '••••  ••••  ••••  1190',
      'expiry': '09/27',
      'cvv': '552',
      'limit': 5000.0,
      'spent': 1225.0,
      'isFrozen': false,
      'network': 'MASTERCARD FLEET',
      'gradient': const [Color(0xFF7C2D12), Color(0xFFC2410C), Color(0xFFF97316)],
    },
  ];

  late List<Map<String, dynamic>> _vouchers;

  @override
  void initState() {
    super.initState();
    _vouchers = [
      {
        'id': 'TXN-01',
        'code': 'PCV-2026-0812',
        'title': 'استبدال عدد 2 أسطوانة غاز لمطبخ الموقع واستراحة المهندسين',
        'category': 'غاز',
        'emoji': '🔥',
        'vendor': 'شركة الإمارات لتوزيع الغاز ذ.م.م',
        'trn': '100284719200003',
        'amount': 260.0,
        'vat': 12.38,
        'method': 'NFC Contactless Wi-Fi',
        'time': 'اليوم 10:45 ص',
        'status': 'معتمد APPROVED',
      },
      {
        'id': 'TXN-02',
        'code': 'PCV-2026-0811',
        'title': 'طباعة عاجلة لمخططات إنشائية A0 (عطل في البلوتر المكتبي)',
        'category': 'مخططات',
        'emoji': '📑',
        'vendor': 'مركز الشروق للطباعة الهندسية - دبي',
        'trn': '100392817400003',
        'amount': 380.0,
        'vat': 18.10,
        'method': 'كاش مع إشعار مسح ضوئي',
        'time': 'اليوم 08:30 ص',
        'status': 'معتمد APPROVED',
      },
      {
        'id': 'TXN-03',
        'code': 'PCV-2026-0810',
        'title': 'تموين كافتيريا الموقع: شاي، سكر، حليب، مياه معدنية',
        'category': 'شاي وسكر',
        'emoji': '☕',
        'vendor': 'سوبرماركت المدينة إكسبريس - دبي',
        'trn': '100192847100003',
        'amount': 425.50,
        'vat': 20.26,
        'method': 'NFC Contactless Wi-Fi',
        'time': 'أمس 04:15 م',
        'status': 'معتمد APPROVED',
      },
      {
        'id': 'TXN-04',
        'code': 'PCV-2026-0809',
        'title': 'أقلام تمييز ومجلدات وملفات أرشفة عاجلة لأعمال الجودة',
        'category': 'قرطاسية',
        'emoji': '✏️',
        'vendor': 'مكتبة دبي الوطنية للتوزيع',
        'trn': '100482910300003',
        'amount': 295.0,
        'vat': 14.05,
        'method': 'كاش مع إشعار مسح ضوئي',
        'time': 'أمس 01:20 م',
        'status': 'معتمد APPROVED',
      },
      {
        'id': 'TXN-05',
        'code': 'PCV-2026-0808',
        'title': 'مستلزمات حقيبة إسعافات أولية عاجلة وشواخص تحذيرية',
        'category': 'أدوات طارئة',
        'emoji': '🛠️',
        'vendor': 'المعدات الطبية والسلامة LLC',
        'trn': '100582910400003',
        'amount': 540.0,
        'vat': 25.71,
        'method': 'NFC Contactless Wi-Fi',
        'time': '01 أكتوبر 2026',
        'status': 'معتمد APPROVED',
      },
      {
        'id': 'TXN-06',
        'code': 'PCV-2026-0807',
        'title': 'وقود وتزويد ديزل طارئ لسيارة بيك آب الموقع الفنية',
        'category': 'وقود',
        'emoji': '⛽',
        'vendor': 'محطة اينوك ENOC - القوز',
        'trn': '100982716300003',
        'amount': 220.0,
        'vat': 10.48,
        'method': 'NFC Contactless Wi-Fi',
        'time': '30 سبتمبر 2026',
        'status': 'معتمد APPROVED',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final activeCard = _engineerCards[_selectedCardIndex];
    const projectCap = 40000.0;
    final totalSpent = _vouchers.fold(0.0, (acc, v) => acc + (v['amount'] as double));
    final remainingPool = (projectCap - totalSpent).clamp(0.0, double.infinity);
    final totalVat = _vouchers.fold(0.0, (acc, v) => acc + (v['vat'] as double));

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('المحفظة الذكية للنثرية والبطاقات', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                SizedBox(width: 8),
                Text('💳', style: TextStyle(fontSize: 16)),
              ],
            ),
            Text('Smart Petty Cash & Engineer Corporate Cards • Dubai Marina', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.goldEmirates,
        foregroundColor: AppColors.darkBackground,
        onPressed: () => _showAddVoucherDialog(),
        icon: const Icon(Icons.camera_alt),
        label: const Text('+ مسح فاتورة / تسجيل مصروف', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        children: [
          // 1. Project Governance Pool Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.goldEmirates.withValues(alpha: 0.35)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('💰', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('حساب عهدة النثرية الميدانية (Pool)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                            Text('For urgent site incidental needs bypassing slow LPO', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('رقابة معتمدة', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 3 KPI Strip
                Row(
                  children: [
                    Expanded(
                      child: _buildPoolKpi('سقف العهدة الشهري', 'AED ${_formatAed(projectCap)}', AppColors.goldEmirates, 'Approved Cap'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPoolKpi('المنصرف الفعلي', 'AED ${_formatAed(totalSpent)}', AppColors.cautionAmber, '${((totalSpent / projectCap) * 100).toStringAsFixed(0)}% Used'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPoolKpi('الرصيد المتاح', 'AED ${_formatAed(remainingPool)}', AppColors.verifiedGreen, 'Available'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (totalSpent / projectCap).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: AppColors.darkSurface,
                    color: AppColors.accentCyan,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('استرداد ضريبة القيمة المضافة (5% VAT): AED ${_formatAed(totalVat)}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                    Text('${_vouchers.length} فواتير مسجلة', style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Engineer Selector Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('بطاقات المهندسين الذكية (Contactless Cards)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              Text('${_selectedCardIndex + 1} / ${_engineerCards.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
            ],
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _engineerCards.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final c = _engineerCards[i];
                final isSelected = i == _selectedCardIndex;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedCardIndex = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.goldEmirates : AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? AppColors.goldEmirates : AppColors.darkBorder.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Text('👷', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              c['nameAr'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.darkBackground : AppColors.textPrimaryDark,
                              ),
                            ),
                            Text(
                              'متاح: AED ${_formatAed((c['limit'] as double) - (c['spent'] as double))}',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.darkBackground : AppColors.verifiedGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // REALISTIC LUXURY CONTACTLESS CORPORATE BANK CARD UI
          _buildPhysicalBankCard(activeCard),
          const SizedBox(height: 16),

          // 3. Operational Categories
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('أبواب وبنود صرف النثرية الميدانية (Presets)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _categoryPill('الكل All', null),
                    _categoryPill('☕ شاي وسكر', 'شاي وسكر'),
                    _categoryPill('🔥 أسطوانات غاز', 'غاز'),
                    _categoryPill('📑 نسخ مخططات', 'مخططات'),
                    _categoryPill('✏️ قرطاسية وأقلام', 'قرطاسية'),
                    _categoryPill('🛠️ أدوات طارئة', 'أدوات طارئة'),
                    _categoryPill('⛽ وقود ونقليات', 'وقود'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Ledger & Vouchers List
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('سجل الفواتير وسندات الصرف الممسوحة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              Text('NFC Wi-Fi & Cash with TRN', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
            ],
          ),
          const SizedBox(height: 8),

          ..._vouchers
              .where((v) => _selectedCategory == null || v['category'] == _selectedCategory)
              .map((v) => _buildVoucherCard(v)),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPoolKpi(String label, String amount, Color col, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 2),
          Text(amount, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: col), maxLines: 1),
          Text(subtitle, style: const TextStyle(fontSize: 8, color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }

  Widget _buildPhysicalBankCard(Map<String, dynamic> card) {
    final gradient = card['gradient'] as List<Color>;
    final isFrozen = card['isFrozen'] as bool;
    final limit = card['limit'] as double;
    final spent = card['spent'] as double;
    final remaining = (limit - spent).clamp(0.0, double.infinity);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Brand + NFC Wi-Fi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('OrionB Corporate Pay', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                        child: const Text('PETTY CASH', style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                  const Text('Al Sahab Luxury Residential Tower • Dubai', style: TextStyle(fontSize: 9, color: Colors.white70)),
                ],
              ),
              const Row(
                children: [
                  Icon(Icons.wifi, color: Colors.white, size: 22),
                  SizedBox(width: 4),
                  Text('NFC', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Gold EMV Chip Graphic
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFDF79), Color(0xFFD4AF37), Color(0xFF996515)]),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF5A3E00), width: 0.8),
                ),
                child: Stack(
                  children: [
                    Center(child: Container(height: 1, color: const Color(0xFF5A3E00).withValues(alpha: 0.5))),
                    Center(child: Container(width: 1, color: const Color(0xFF5A3E00).withValues(alpha: 0.5))),
                  ],
                ),
              ),
              if (isFrozen)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.criticalRed, borderRadius: BorderRadius.circular(6)),
                  child: const Row(
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text('CARD FROZEN', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.verifiedGreen.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.5)),
                  ),
                  child: const Text('NFC TAP READY', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Card Number with Eye Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showFullCardNumber ? card['cardNum'] as String : card['masked'] as String,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace', letterSpacing: 2, color: Colors.white),
              ),
              IconButton(
                onPressed: () => setState(() => _showFullCardNumber = !_showFullCardNumber),
                icon: Icon(_showFullCardNumber ? Icons.visibility_off : Icons.visibility, color: Colors.white70, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Cardholder Name & Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CARDHOLDER:', style: TextStyle(fontSize: 8, color: Colors.white70)),
                  Text(card['nameAr'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(card['roleEn'] as String, style: const TextStyle(fontSize: 9, color: Colors.white70)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('EXPIRES:', style: TextStyle(fontSize: 8, color: Colors.white70)),
                  Text(card['expiry'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(card['network'] as String, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.goldEmirates)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Balance & Usage Strip
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('السقف الشهري', style: TextStyle(fontSize: 8.5, color: Colors.white70)),
                        Text('AED ${_formatAed(limit)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('المنصرف', style: TextStyle(fontSize: 8.5, color: Colors.white70)),
                        Text('AED ${_formatAed(spent)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.cautionAmber)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('الرصيد المتاح', style: TextStyle(fontSize: 8.5, color: Colors.white70)),
                        Text('AED ${_formatAed(remaining)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (spent / limit).clamp(0.0, 1.0),
                  minHeight: 4,
                  backgroundColor: Colors.white24,
                  color: AppColors.accentCyan,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3 Action Buttons Under the Card
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تفعيل الدفع اللاتلامسي NFC عبر شريحة الهاتف')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: AppColors.darkBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  icon: const Icon(Icons.contactless, size: 16),
                  label: const Text('دفع NFC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      card['isFrozen'] = !isFrozen;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(card['isFrozen'] ? 'تم تجميد البطاقة فوراً' : 'تم تفعيل البطاقة بنجاح')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  icon: Icon(isFrozen ? Icons.lock_open : Icons.lock, size: 15),
                  label: Text(isFrozen ? 'فك التجميد' : 'تجميد البطاقة', style: const TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryPill(String title, String? cat) {
    final isSelected = _selectedCategory == cat;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = cat),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentCyan : AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.accentCyan : AppColors.darkBorder.withValues(alpha: 0.3)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.darkBackground : AppColors.textPrimaryDark,
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherCard(Map<String, dynamic> v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(v['emoji'] as String, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(v['code'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                  ),
                ],
              ),
              BhStatusChip(label: v['status'] as String, status: BhStatusType.verified),
            ],
          ),
          const SizedBox(height: 6),
          Text(v['title'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.storefront, size: 12, color: AppColors.textSecondaryDark),
              const SizedBox(width: 4),
              Text(v['vendor'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('TRN: ', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
              Text(v['trn'] as String, style: const TextStyle(fontSize: 10, color: AppColors.accentSky, fontFamily: 'monospace')),
              const SizedBox(width: 10),
              Text('طريقة الدفع: ${v['method']}', style: const TextStyle(fontSize: 10, color: AppColors.textMutedDark)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المبلغ: AED ${_formatAed(v['amount'] as double)} (شامل ضريبة AED ${_formatAed(v['vat'] as double)})', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
              Text(v['time'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textMutedDark)),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddVoucherDialog() {
    final titleCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    final trnCtrl = TextEditingController(text: '100${math.Random().nextInt(8999999)}00003');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text('تسجيل إشعار نفقة ومسح فاتورة', style: TextStyle(color: AppColors.textPrimaryDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: AppColors.textPrimaryDark),
              decoration: const InputDecoration(labelText: 'بند الصرف (شاي / غاز / وقود / صيانة)', labelStyle: TextStyle(color: AppColors.textSecondaryDark)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amtCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimaryDark),
              decoration: const InputDecoration(labelText: 'المبلغ الإجمالي AED', labelStyle: TextStyle(color: AppColors.textSecondaryDark)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: trnCtrl,
              style: const TextStyle(color: AppColors.textPrimaryDark),
              decoration: const InputDecoration(labelText: 'الرقم الضريبي للمورد (TRN)', labelStyle: TextStyle(color: AppColors.textSecondaryDark)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: AppColors.darkBackground),
            onPressed: () {
              final amt = double.tryParse(amtCtrl.text) ?? 150.0;
              setState(() {
                _vouchers.insert(
                  0,
                  {
                    'id': 'TXN-0${_vouchers.length + 1}',
                    'code': 'PCV-2026-0${813 + _vouchers.length}',
                    'title': titleCtrl.text.isEmpty ? 'مصروف نثري عاجل بالموقع' : titleCtrl.text,
                    'category': 'أدوات طارئة',
                    'emoji': '🛠️',
                    'vendor': 'مورد محلي معتمد',
                    'trn': trnCtrl.text,
                    'amount': amt,
                    'vat': amt * 0.05,
                    'method': 'NFC Contactless Wi-Fi',
                    'time': 'الآن',
                    'status': 'معتمد APPROVED',
                  },
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('حفظ السند'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. COST TO COMPLETE SCREEN (CostToCompleteScreen.kt Parity)
// ============================================================================

class CostToCompleteFullScreen extends StatefulWidget {
  const CostToCompleteFullScreen({super.key});

  @override
  State<CostToCompleteFullScreen> createState() => _CostToCompleteFullScreenState();
}

class _CostToCompleteFullScreenState extends State<CostToCompleteFullScreen> {
  int _selectedProjectTab = 0; // 0: Marina, 1: Business

  final List<Map<String, dynamic>> _breakdowns = const [
    {'title': 'الأعمال الإنشائية (Structural Work)', 'amount': 'AED 5.2M', 'progress': 0.16, 'pct': '16%'},
    {'title': 'أعمال الكهروميكانيك (MEP Installation)', 'amount': 'AED 12.8M', 'progress': 0.40, 'pct': '40%'},
    {'title': 'أعمال التشطيبات (Finishing Works)', 'amount': 'AED 8.5M', 'progress': 0.27, 'pct': '27%'},
    {'title': 'الأعمال الخارجية والموقع (External Works)', 'amount': 'AED 3.2M', 'progress': 0.10, 'pct': '10%'},
    {'title': 'مخصص الطوارئ وحساب المخاطر (Contingency)', 'amount': 'AED 2.1M', 'progress': 0.07, 'pct': '7%'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        title: const Text('Cost-to-Complete AI & Profit Forecast', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        children: [
          // AI-Powered Profit Prediction Header Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cautionAmber.withValues(alpha: 0.5)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.cautionAmber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.lightbulb, color: AppColors.cautionAmber, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('توقع الأرباح الذكي (AI-Powered Profit Prediction)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                      Text('Real-time final cost prediction comparing actual spending vs remaining inventory', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Project Selector Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _selectedProjectTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedProjectTab == 0 ? AppColors.darkCard : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Marina Tower Project',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _selectedProjectTab == 0 ? AppColors.accentCyan : AppColors.textSecondaryDark,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _selectedProjectTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedProjectTab == 1 ? AppColors.darkCard : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Business Tower Project',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _selectedProjectTab == 1 ? AppColors.accentCyan : AppColors.textSecondaryDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Project Summary Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedProjectTab == 0 ? 'Marina Tower Construction' : 'Business Tower Commercial',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCol('قيمة العقد Contract', 'AED 185.0M', AppColors.textPrimaryDark),
                    _buildStatCol('المنصرف الفعلي Spent', 'AED 142.5M', AppColors.cautionAmber),
                    _buildStatCol('نسبة الإنجاز Progress', '77%', AppColors.verifiedGreen),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          const Text('تفاصيل التكلفة المتوقعة للإكمال (Work Breakdown)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 8),

          ..._breakdowns.map((b) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(b['title'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                    Text(b['amount'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (b['progress'] as double) / 0.5,
                  minHeight: 5,
                  backgroundColor: AppColors.darkCard,
                  color: AppColors.accentCyan,
                ),
              ],
            ),
          )),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCol(String title, String val, Color col) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: col)),
      ],
    );
  }
}

// ============================================================================
// 4. FINANCIAL AI SCREEN (FinancialAiScreen.kt Parity)
// ============================================================================

class FinancialAiFullScreen extends StatefulWidget {
  const FinancialAiFullScreen({super.key});

  @override
  State<FinancialAiFullScreen> createState() => _FinancialAiFullScreenState();
}

class _FinancialAiFullScreenState extends State<FinancialAiFullScreen> {
  int _selectedTab = 0; // 0: AI Forecast & Fraud, 1: BNPL & Trade Credit, 2: Micro-Insurance

  final List<Map<String, dynamic>> _fraudAlerts = const [
    {
      'id': 'FRD-2026-091',
      'title': 'كشف فاتورة توريد حديد تسليح مكررة بنسبة 99%',
      'titleEn': 'Duplicate Rebar Delivery Invoice Detected',
      'vendor': 'Emirates Steel Arkan PJSC',
      'amount': 142500.0,
      'riskScore': 94,
      'reason': 'تطابق 99% في وزن الحمولة والتوقيت وسند التسليم مع فاتورة تم سدادها قبل 4 أيام',
      'status': 'FLAGGED',
      'statusType': BhStatusType.critical,
    },
    {
      'id': 'FRD-2026-088',
      'title': 'قفزة غير اعتيادية في سعر لتر ديزل المعدات',
      'titleEn': 'Abnormal Diesel Fuel Unit Rate Spike',
      'vendor': 'ADNOC Distribution Site Tanker',
      'amount': 18400.0,
      'riskScore': 81,
      'reason': 'سعر اللتر يتجاوز التسعيرة الرسمية المعتمدة لوزارة الطاقة والصناعة بنسبة +28%',
      'status': 'BLOCKED',
      'statusType': BhStatusType.caution,
    },
    {
      'id': 'FRD-2026-074',
      'title': 'رقم ضريبي غير مسجل بفاتورة مقاول السقالات',
      'titleEn': 'Unregistered TRN on Scanned Subcontractor Bill',
      'vendor': 'Gulf Horizon Scaffolding LLC',
      'amount': 46000.0,
      'riskScore': 88,
      'reason': 'الرقم الضريبي الممسوح فشل في التحقق الإلكتروني مع قاعدة بيانات الهيئة الاتحادية للضرائب FTA',
      'status': 'RESOLVED',
      'statusType': BhStatusType.verified,
    },
  ];

  final List<Map<String, dynamic>> _bnplFacilities = const [
    {
      'id': 'BNPL-01',
      'supplier': 'Ready-Mix Concrete UAE Group',
      'limit': 500000.0,
      'used': 320000.0,
      'tenor': 90,
      'apr': 0.0,
      'status': 'ACTIVE',
    },
    {
      'id': 'BNPL-02',
      'supplier': 'Al Futtaim MEP & Electricals',
      'limit': 250000.0,
      'used': 85000.0,
      'tenor': 60,
      'apr': 0.0,
      'status': 'ACTIVE',
    },
    {
      'id': 'BNPL-03',
      'supplier': 'RAK Ceramics Tile & Cladding',
      'limit': 350000.0,
      'used': 0.0,
      'tenor': 120,
      'apr': 1.5,
      'status': 'ELIGIBLE',
    },
  ];

  final List<Map<String, dynamic>> _policies = const [
    {
      'no': 'MIC-DXB-9921',
      'asset': 'محرك وونش الرافعة البرجية #3 أثناء النقل',
      'insurer': 'Sukoon Insurance (Oman Insurance)',
      'coverage': 450000.0,
      'premium': 850.0,
      'valid': '2026-10-15',
      'status': 'COVERED',
    },
    {
      'no': 'MIC-DXB-9918',
      'asset': 'ألواح الخرسانة مسبقة الصنع (12 لوح على الطريق)',
      'insurer': 'Al Sagr National Insurance',
      'coverage': 280000.0,
      'premium': 420.0,
      'valid': '2026-09-30',
      'status': 'EXPIRING_SOON',
    },
    {
      'no': 'MIC-DXB-8874',
      'asset': 'مضخات نزح المياه الجوفية ضد الصدمات الكهربائية',
      'insurer': 'Abu Dhabi National Insurance (ADNIC)',
      'coverage': 120000.0,
      'premium': 310.0,
      'valid': '2026-12-31',
      'status': 'COVERED',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Financial AI & Fraud Protection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        children: [
          // Hero KPI Card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Financial Health Score', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        Text('96.4 / 100', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.verifiedGreen),
                      ),
                      child: const Text('A+ LOW RISK', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white10),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HeroStat('وفر الاحتيال', 'AED 206,900', Colors.white),
                    _HeroStat('تسهيلات ائتمانية', 'AED 1,100,000', AppColors.goldEmirates),
                    _HeroStat('أصول مؤمنة', 'AED 850,000', AppColors.accentCyan),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Tabs
          Container(
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _aiTabItem(0, 'مكافحة الاحتيال'),
                _aiTabItem(1, 'تسهيلات BNPL'),
                _aiTabItem(2, 'تأمين دقيق'),
              ],
            ),
          ),
          const SizedBox(height: 14),

          if (_selectedTab == 0) ...[
            // 6-Month Predictive Cash Flow Card
            Container(
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_up, color: AppColors.accentCyan),
                      SizedBox(width: 8),
                      Text('التدفق النقدي التنبئي لـ 6 أشهر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Based on Primavera P6 milestones, IPC cycles, and subcontracts', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _miniBar('أكتوبر', 0.75),
                      _miniBar('نوفمبر', 0.88),
                      _miniBar('ديسمبر', 0.65),
                      _miniBar('يناير', 0.92),
                      _miniBar('فبراير', 0.70),
                      _miniBar('مارس', 0.82),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            const Text('تنبيهات وتدقيق الاحتيال والتشوهات (Audit Alerts)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),

            ..._fraudAlerts.map((fa) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: (fa['statusType'] as BhStatusType) == BhStatusType.critical ? AppColors.criticalRed : Colors.white12),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(fa['id'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan)),
                      BhStatusChip(label: 'مخاطرة ${fa['riskScore']}%', status: fa['statusType'] as BhStatusType),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(fa['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('المورد: ${fa['vendor']}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(fa['reason'] as String, style: const TextStyle(fontSize: 11, color: AppColors.cautionAmber)),
                  const SizedBox(height: 6),
                  Text('المبلغ المرصود: AED ${_formatAed(fa['amount'] as double)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                ],
              ),
            )),
          ] else if (_selectedTab == 1) ...[
            ..._bnplFacilities.map((bnpl) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(bnpl['supplier'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      BhStatusChip(label: bnpl['status'] as String, status: BhStatusType.verified),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الحد الائتماني: AED ${_formatAed(bnpl['limit'] as double)}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                      Text('المستخدم: AED ${_formatAed(bnpl['used'] as double)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldEmirates)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('مهلة السداد: ${bnpl['tenor']} يوم • فائدة: ${bnpl['apr']}% APR', style: const TextStyle(fontSize: 11, color: AppColors.accentCyan)),
                ],
              ),
            )),
          ] else ...[
            ..._policies.map((p) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p['no'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan)),
                      BhStatusChip(label: p['status'] as String, status: BhStatusType.verified),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(p['asset'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('شركة التأمين: ${p['insurer']}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('التغطية: AED ${_formatAed(p['coverage'] as double)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                      Text('القسط: AED ${_formatAed(p['premium'] as double)}', style: const TextStyle(fontSize: 11, color: AppColors.goldEmirates)),
                    ],
                  ),
                ],
              ),
            )),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _aiTabItem(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentCyan : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.darkBackground : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniBar(String m, double ratio) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 60 * ratio,
          decoration: BoxDecoration(
            color: ratio > 0.85 ? AppColors.cautionAmber : AppColors.accentCyan,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 4),
        Text(m, style: const TextStyle(fontSize: 9, color: Colors.white60)),
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String title;
  final String val;
  final Color col;
  const _HeroStat(this.title, this.val, this.col);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.white60)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: col)),
      ],
    );
  }
}

// ============================================================================
// 5. PROJECT BUSINESS PLAN SCREEN (ProjectBusinessPlanScreen.kt Parity)
// ============================================================================

class BusinessPlanFullScreen extends StatefulWidget {
  const BusinessPlanFullScreen({super.key});

  @override
  State<BusinessPlanFullScreen> createState() => _BusinessPlanFullScreenState();
}

class _BusinessPlanFullScreenState extends State<BusinessPlanFullScreen> {
  int _selectedTab = 0; // 0: Baseline & Revenue, 1: Cost Categories, 2: Risk Radar

  @override
  Widget build(BuildContext context) {
    const contractValue = 145000000.0;
    const approvedVo = 3500000.0;
    const pendingVo = 1800000.0;
    const forecastFinalRevenue = contractValue + approvedVo;
    const costBudget = contractValue * 0.82;
    const actualCost = 31000000.0;
    const etc = 14200000.0;
    const forecastFinalCost = actualCost + etc;
    const netProfit = forecastFinalRevenue - forecastFinalCost;
    final marginPct = (netProfit / forecastFinalRevenue) * 100;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        title: const Text('Project Commercial Business Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        children: [
          // Sub-tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                _planTab(0, 'الخطة والإيراد'),
                _planTab(1, 'حزم التكاليف'),
                _planTab(2, 'مصفوفة المخاطر'),
              ],
            ),
          ),
          const SizedBox(height: 14),

          if (_selectedTab == 0) ...[
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('مؤشرات الجدوى والأرباح التقديرية (Baseline Profitability)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 12),
                  _planRow('قيمة العقد الأصلي (Original Contract)', 'AED ${_formatAed(contractValue)}'),
                  _planRow('أوامر تغييرية معتمدة (Approved VO)', '+ AED ${_formatAed(approvedVo)}', color: AppColors.verifiedGreen),
                  _planRow('أوامر تغييرية معلقة (Pending VO - FIDIC)', 'AED ${_formatAed(pendingVo)} (مفصولة)', color: AppColors.cautionAmber),
                  const Divider(color: AppColors.darkBorder),
                  _planRow('الإيراد النهائي المتوقع (Forecast Final Revenue)', 'AED ${_formatAed(forecastFinalRevenue)}', color: AppColors.accentCyan, isBold: true),
                  _planRow('الميزانية التقديرية للتكلفة (Cost Budget)', 'AED ${_formatAed(costBudget)}'),
                  _planRow('التكلفة المتوقعة عند الإكمال (Forecast Final Cost)', 'AED ${_formatAed(forecastFinalCost)}'),
                  const Divider(color: AppColors.darkBorder),
                  _planRow('صافي الربح المتوقع (Forecast Net Profit)', 'AED ${_formatAed(netProfit)}', color: AppColors.verifiedGreen, isBold: true),
                  _planRow('هامش الربح المتوقع (Forecast Profit Margin)', '${marginPct.toStringAsFixed(1)}%', color: AppColors.accentCyan, isBold: true),
                ],
              ),
            ),
          ] else if (_selectedTab == 1) ...[
            _buildCostCatCard('الأعمال الترابية والأساسات', 'Substructure & Piling', 18500000.0, 17800000.0, 400000.0),
            _buildCostCatCard('الهيكل الخرساني والكتلة الإنشائية', 'Superstructure Core & Concrete', 42000000.0, 12200000.0, 28500000.0),
            _buildCostCatCard('الأنظمة الكهروميكانيكية والحرائق', 'MEP & Fire Systems', 28000000.0, 1000000.0, 26500000.0),
            _buildCostCatCard('الواجهات والزجاج المزدوج', 'Façade & External Envelope', 16500000.0, 0.0, 16500000.0),
          ] else ...[
            _buildRiskCard('تذبذب أسعار حديد التسليح العالمية', 'Steel Rebar Global Price Spike', 'تأثير: AED 850,000', 'تفعيل الشراء المسبق بعقود تحوط Hedging', AppColors.cautionAmber),
            _buildRiskCard('مخاطر استيراد معدات التكييف الطويلة الأجل', 'MEP Long-Lead Import Currency Risk', 'تأثير: AED 420,000', 'تثبيت سعر صرف العملة واعتماد بديل محلي', AppColors.cautionAmber),
            _buildRiskCard('تأخر فحص بلدية دبي للمنطقة 2', 'Delayed Municipality Zone 2 NOC', 'تأثير: AED 290,000', 'تطبيق التوازي في التنفيذ بالتنسيق مع الاستشاري', AppColors.criticalRed),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _planTab(int idx, String title) {
    final isSelected = _selectedTab == idx;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = idx),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentCyan : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.darkBackground : AppColors.textPrimaryDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _planRow(String label, String val, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondaryDark)),
          Text(val, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: color ?? AppColors.textPrimaryDark)),
        ],
      ),
    );
  }

  Widget _buildCostCatCard(String ar, String en, double budget, double actual, double etc) {
    final forecast = actual + etc;
    final isExceeding = forecast > budget;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isExceeding ? AppColors.criticalRed.withValues(alpha: 0.5) : AppColors.darkBorder.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ar, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              BhStatusChip(label: isExceeding ? 'تجاوز محتمل' : 'ضمن المخطط', status: isExceeding ? BhStatusType.critical : BhStatusType.verified),
            ],
          ),
          Text(en, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الميزانية: ${(budget / 1000000).toStringAsFixed(1)}M', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
              Text('الفعلي: ${(actual / 1000000).toStringAsFixed(1)}M', style: const TextStyle(fontSize: 11, color: AppColors.cautionAmber)),
              Text('المتوقع: ${(forecast / 1000000).toStringAsFixed(1)}M', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isExceeding ? AppColors.criticalRed : AppColors.accentCyan)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskCard(String ar, String en, String impact, String action, Color col) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: col.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ar, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
              Text(impact, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: col)),
            ],
          ),
          Text(en, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 6),
          Text('الإجراء التصحيحي المقترح: $action', style: const TextStyle(fontSize: 11, color: AppColors.accentSky)),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Utilities
// ----------------------------------------------------------------------------

String _formatAed(double amount) {
  final parts = amount.toStringAsFixed(0).split('');
  final buffer = StringBuffer();
  var count = 0;
  for (var i = parts.length - 1; i >= 0; i--) {
    buffer.write(parts[i]);
    count++;
    if (count % 3 == 0 && i > 0) {
      buffer.write(',');
    }
  }
  return buffer.toString().split('').reversed.join();
}
