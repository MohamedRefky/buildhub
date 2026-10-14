// Clean Architecture: SitePulse — Presentation.
// Comprehensive port of:
// - CmMorningDashboardView.kt (Morning Briefing, SPI/CPI, Planned Activities, Blockers)
// - SitePulseCommercialPlatformViews.kt (Ask My Project AI search, EVM, IPCs, Cash Flow)
// - SitePulseFieldQualityViews.kt (Concrete Batches, ASTM C94 90-min, Cube Tests, Snags & NCRs)
// - SitePulseDecisionSupportScreen.kt (7 Sub-Tabs: Predictive Delays, Knowledge Graph, EVM, Materials, GIS Map, Risk Radar, Voice AI)
// - SitePulseMasterPlatformViews.kt & SitePulseOsViews.kt (Executive KPIs, Authority Permits)
// - SitePulseUniversalAddDialog.kt integration.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/features/sitepulse/data/repositories/sitepulse_repository.dart';
import 'package:buildhub/shared/widgets/sitepulse_add_dialog.dart';

// =========================================================================
// 1. MAIN S COMMON SITE PULSE SCREEN (5 TABS)
// =========================================================================
class SitePulseScreen extends StatefulWidget {
  const SitePulseScreen({super.key});

  static const tabKeys = [
    'sp.tab_morning',
    'sp.tab_commercial',
    'sp.tab_quality',
    'sp.tab_decisions',
    'sp.tab_reports',
  ];

  @override
  State<SitePulseScreen> createState() => _SitePulseScreenState();
}

class _SitePulseScreenState extends State<SitePulseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final repo = context.read<SitePulseRepository>();
    _tabController = TabController(
      length: SitePulseScreen.tabKeys.length,
      vsync: this,
      initialIndex: repo.initialTab.clamp(0, SitePulseScreen.tabKeys.length - 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SitePulseRepository>();
    final tabs = SitePulseScreen.tabKeys.map(loc.t).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.hub, size: 18, color: AppColors.accentCyan),
                const SizedBox(width: 6),
                Text(loc.t('sp.command'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const Text('Dubai Creek Harbour Tower Phase 2 • #BH-DXB-2026',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.verifiedGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wb_sunny, size: 14, color: AppColors.goldEmirates),
                SizedBox(width: 4),
                Text('38°C • 14 km/h', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldEmirates)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('SitePulse: All notifications synced with cloud server.')),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MorningDashboardView(),
          SitePulseCommercialView(),
          SitePulseFieldQualityView(),
          SitePulseDecisionScreen(),
          SitePulseMasterView(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => showDialog(
          context: context,
          builder: (_) => UniversalSitePulseAddDialog(
            onSubmit: (category, values) {
              final title = values['sp.f_title'] ?? values['sp.f_desc'] ?? 'Site Update';
              final zone = values['sp.f_zone'] ?? 'Zone 1';
              repo.addSnag('${category.name.toUpperCase()}: $title', zone);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged ${category.name}: $title at $zone')),
              );
            },
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Entry / إدخال جديد'),
      ),
    );
  }
}

// =========================================================================
// 2. CM MORNING DASHBOARD VIEW (Port of CmMorningDashboardView.kt)
// =========================================================================
class MorningDashboardView extends StatefulWidget {
  const MorningDashboardView({super.key});

  @override
  State<MorningDashboardView> createState() => _MorningDashboardViewState();
}

class _MorningDashboardViewState extends State<MorningDashboardView> {
  bool _isWhatChangedExpanded = false;
  String _selectedZone = 'ALL';
  String _selectedDiscipline = 'ALL';
  String _selectedStatus = 'ALL';

  final List<Map<String, dynamic>> _activities = [
    {
      'id': 'ACT-Z1',
      'zone': 'Zone 1',
      'title': 'Stormwater installation – 250 m',
      'titleAr': 'تركيب خط تصريف الأمطار – 250 م',
      'discipline': 'Stormwater',
      'qty': '250 m',
      'manpower': 18,
      'equipment': '2 excavators, 1 loader',
      'contractor': 'BuildHub Civil Works',
      'engineer': 'Eng. Abdelfattah Ibrahim',
      'status': 'ON_TRACK',
    },
    {
      'id': 'ACT-Z2',
      'zone': 'Zone 2',
      'title': 'Pump station excavation',
      'titleAr': 'حفر محطة الرفع والمضخات',
      'discipline': 'Civil / Structural',
      'qty': '450 m³',
      'manpower': 12,
      'equipment': '1 excavator, 2 dewatering pumps',
      'contractor': 'DeepFound Subcontracting',
      'engineer': 'Eng. Salem Al-Nuaimi',
      'status': 'AT_RISK',
    },
    {
      'id': 'ACT-Z3',
      'zone': 'Zone 3',
      'title': 'Sewer main pipeline installation',
      'titleAr': 'تركيب خط شبكة الصرف الصحي الرئيسي',
      'discipline': 'Sewer',
      'qty': '120 m',
      'manpower': 15,
      'equipment': '1 trencher rig, 1 mobile crane',
      'contractor': 'Fibrex Infrastructure',
      'engineer': 'Eng. Rami Kanaan',
      'status': 'DELAYED',
    },
    {
      'id': 'ACT-Z4',
      'zone': 'Zone 4',
      'title': 'Potable water network – 180 m',
      'titleAr': 'تمديد شبكة مياه الشرب – 180 م',
      'discipline': 'Potable Water',
      'qty': '180 m',
      'manpower': 14,
      'equipment': '1 crane, 1 loader',
      'contractor': 'HydroTech Contracting',
      'engineer': 'Eng. Ahmed Zaki',
      'status': 'ON_TRACK',
    },
    {
      'id': 'ACT-Z5',
      'zone': 'Zone 5',
      'title': 'Irrigation & Roads sub-base',
      'titleAr': 'طبقة الأساس للطرق وشبكة الري',
      'discipline': 'Roads',
      'qty': '350 m²',
      'manpower': 22,
      'equipment': '2 graders, 1 roller',
      'contractor': 'ABC Contracting',
      'engineer': 'Eng. Omar Al-Qadi',
      'status': 'ON_TRACK',
    },
  ];

  final List<Map<String, dynamic>> _blockers = [
    {
      'id': 'BLK-01',
      'zone': 'Zone 3',
      'priority': 'CRITICAL',
      'title': 'DEWA 11kV live feeder duct clash with sewer pipeline',
      'titleAr': 'تعارض كابل كهرباء DEWA 11kV حي مع مسار خط الصرف الصحي',
      'impact': 'Halted trenching for 3 days; CPM schedule risk',
      'status': 'Open',
      'owner': 'Eng. Rami Kanaan',
    },
    {
      'id': 'BLK-02',
      'zone': 'Zone 2',
      'priority': 'HIGH',
      'title': 'Groundwater ingress exceeding pump rating at Pump Station',
      'titleAr': 'ارتفاع منسوب المياه الجوفية عن سعة مضخات النزح',
      'impact': 'Requires 2 additional 6-inch submersible pumps',
      'status': 'Escalated',
      'owner': 'Eng. Salem Al-Nuaimi',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'ON_TRACK':
        return AppColors.verifiedGreen;
      case 'AT_RISK':
        return AppColors.cautionAmber;
      case 'DELAYED':
      case 'CRITICAL':
        return AppColors.criticalRed;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    final filtered = _activities.where((a) {
      final matchesZone = _selectedZone == 'ALL' || a['zone'] == _selectedZone;
      final matchesDiscipline = _selectedDiscipline == 'ALL' || a['discipline'] == _selectedDiscipline;
      final matchesStatus = _selectedStatus == 'ALL' || a['status'] == _selectedStatus;
      return matchesZone && matchesDiscipline && matchesStatus;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Daily Intelligence Health Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny, color: AppColors.goldEmirates),
                        const SizedBox(width: 8),
                        Text(
                          loc.t('sp.morning'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('DAY 142 / 365', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.verifiedGreen)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(loc.t('sp.morning_sub'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 14),

                // Health Indicators Row (SPI, CPI, Manpower, Blockers)
                Row(
                  children: [
                    _buildKpiBadge('SPI', '0.93', AppColors.cautionAmber, 'Schedule (-7d)'),
                    const SizedBox(width: 8),
                    _buildKpiBadge('CPI', '0.97', AppColors.verifiedGreen, 'Cost (Good)'),
                    const SizedBox(width: 8),
                    _buildKpiBadge('Workers', '81', AppColors.accentCyan, '5 Gangs Site'),
                    const SizedBox(width: 8),
                    _buildKpiBadge('Blockers', '2', AppColors.criticalRed, '1 Critical'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // "What Changed Since Yesterday" Expandable Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            initiallyExpanded: _isWhatChangedExpanded,
            onExpansionChanged: (v) => setState(() => _isWhatChangedExpanded = v),
            leading: const Icon(Icons.history_toggle_off, color: AppColors.accentCyan),
            title: const Text('What Changed Since Yesterday / ما الذي تغير منذ الأمس',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('3 items updated • 1 new blocker reported', style: TextStyle(fontSize: 11, color: Colors.grey)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    _buildChangeItem(
                      icon: Icons.check_circle,
                      color: AppColors.verifiedGreen,
                      title: 'Zone 1 Stormwater: 250m pipeline successfully pressure tested & passed.',
                      time: 'Yesterday 17:30',
                    ),
                    const Divider(height: 14),
                    _buildChangeItem(
                      icon: Icons.warning_amber,
                      color: AppColors.criticalRed,
                      title: 'Zone 3: Excavation struck unmapped DEWA 11kV duct; work halted on Section C.',
                      time: 'Today 06:45',
                    ),
                    const Divider(height: 14),
                    _buildChangeItem(
                      icon: Icons.assignment_turned_in,
                      color: AppColors.accentCyan,
                      title: 'Consultant approved RFI-084 (Rebar lap length clarification) with Code B.',
                      time: 'Today 07:15',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Critical Blockers Alert Section
        Card(
          color: AppColors.criticalRed.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.criticalRed.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.report_problem, color: AppColors.criticalRed, size: 20),
                        SizedBox(width: 8),
                        Text('Site Blockers Requiring Immediate Action',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.criticalRed)),
                      ],
                    ),
                    Chip(
                      label: Text('2 Active', style: TextStyle(fontSize: 10, color: Colors.white)),
                      backgroundColor: AppColors.criticalRed,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ..._blockers.map((b) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: b['priority'] == 'CRITICAL' ? AppColors.criticalRed : AppColors.cautionAmber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${b['priority']} • ${b['zone']}',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text('Owner: ${b['owner']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(b['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(b['titleAr'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('⚠️ Impact: ${b['impact']}', style: const TextStyle(fontSize: 11, color: AppColors.criticalRed)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Escalated blocker ${b['id']} to Project Director & DEWA Liaison')),
                            ),
                            icon: const Icon(Icons.campaign, size: 14),
                            label: const Text('Escalate / تصعيد', style: TextStyle(fontSize: 11)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.verifiedGreen,
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () {
                              setState(() {
                                b['status'] = 'Resolved';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Blocker ${b['id']} marked as Resolved!')),
                              );
                            },
                            icon: const Icon(Icons.check, size: 14),
                            label: const Text('Resolve / حل', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Planned Activities Header & Filter Chips
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Today's Planned Activities / خطة أنشطة اليوم",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('${filtered.length} Workfronts', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),

        // Filter Bar (Zone)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['ALL', 'Zone 1', 'Zone 2', 'Zone 3', 'Zone 4', 'Zone 5'].map((z) {
              final isSel = _selectedZone == z;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(z, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : null)),
                  selected: isSel,
                  selectedColor: AppColors.primary,
                  onSelected: (_) => setState(() => _selectedZone = z),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 6),

        // Filter Bar (Discipline)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['ALL', 'Stormwater', 'Civil / Structural', 'Sewer', 'Potable Water', 'Roads'].map((d) {
              final isSel = _selectedDiscipline == d;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(d, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : null)),
                  selected: isSel,
                  selectedColor: AppColors.accentCyanDark,
                  onSelected: (_) => setState(() => _selectedDiscipline = d),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 6),

        // Filter Bar (Status)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['ALL', 'ON_TRACK', 'AT_RISK', 'DELAYED'].map((s) {
              final isSel = _selectedStatus == s;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(s, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : null)),
                  selected: isSel,
                  selectedColor: AppColors.cautionAmber,
                  onSelected: (_) => setState(() => _selectedStatus = s),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),

        // Planned Activities List
        ...filtered.map((act) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor(act['status']).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        act['status'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _statusColor(act['status']),
                        ),
                      ),
                    ),
                    Text('${act['zone']} • ${act['discipline']}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(act['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(act['titleAr'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people, size: 14, color: AppColors.accentCyan),
                    const SizedBox(width: 4),
                    Text('${act['manpower']} men', style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 14),
                    const Icon(Icons.straighten, size: 14, color: AppColors.goldEmirates),
                    const SizedBox(width: 4),
                    Text('Qty: ${act['qty']}', style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 14),
                    const Icon(Icons.engineering, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(act['engineer'], style: const TextStyle(fontSize: 11, overflow: TextOverflow.ellipsis))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.construction, size: 14, color: Colors.blueGrey),
                    const SizedBox(width: 4),
                    Expanded(child: Text('Equip: ${act['equipment']}', style: const TextStyle(fontSize: 11, color: Colors.grey))),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildKpiBadge(String label, String value, Color color, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(sub, style: const TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center, maxLines: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeItem({required IconData icon, required Color color, required String title, required String time}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 3. COMMERCIAL & CONTROLS VIEW (Port of SitePulseCommercialPlatformViews.kt)
// =========================================================================
class SitePulseCommercialView extends StatefulWidget {
  const SitePulseCommercialView({super.key});

  @override
  State<SitePulseCommercialView> createState() => _SitePulseCommercialViewState();
}

class _SitePulseCommercialViewState extends State<SitePulseCommercialView> {
  final TextEditingController _searchController = TextEditingController();
  String? _aiAnswer;
  List<String> _aiCitations = [];

  final Map<String, (String, List<String>)> _presetAnswers = {
    'Why is Zone 4 delayed?': (
      'Zone 4 potable water line experienced a 5-day delay due to pending DEWA tie-in inspection and late valve delivery from Danfoss UAE. A recovery schedule has been sequenced with weekend night shift.',
      ['RFI-082 (DEWA Tie-in)', 'PO-2026-441 (Danfoss Valves)', 'Daily Report #138']
    ),
    'Critical path blockers': (
      'The critical path is currently delayed by +8 calendar days due to Section C sewer trenching halting near DEWA 11kV duct. CPM variance requires immediate NOC approval.',
      ['Primavera P6 WBS 1.3.4', 'NOC Request #DEWA-9921', 'Site Blocker #BLK-01']
    ),
    'Payment status for Subcontractor ABC': (
      'Subcontractor ABC Contracting has been paid AED 2,150,000 to date across IPC-01 to IPC-05. IPC-06 for AED 410,000 has been verified by the commercial engineer and is pending finance clearance.',
      ['IPC-06 Subcontractor Schedule', 'ERP SAP S/4HANA Entry #8812', 'WPS Payroll Clearance']
    ),
    'Concrete slump test failures': (
      'All 8 concrete batches delivered in the past 48 hours passed ASTM C94 slump inspection (range 150-170 mm). Zero batches rejected; average 7-day cube strength is 38.4 MPa (exceeds 30 MPa design).',
      ['Concrete Log #C40-0928', 'Independent Lab Report #ACI-4421']
    ),
  };

  void _runQuery(String query) {
    setState(() {
      _searchController.text = query;
      if (_presetAnswers.containsKey(query)) {
        _aiAnswer = _presetAnswers[query]!.$1;
        _aiCitations = _presetAnswers[query]!.$2;
      } else {
        _aiAnswer = 'AI Synthesis for "$query": All relevant project records, BIM models, and site daily reports scanned. Project is operating within 97% of target cost baseline with 2 active critical path risks in Zone 3.';
        _aiCitations = ['Daily Report #142', 'EVM Analytics', 'FIDIC Submittals'];
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // AI "Ask My Project" Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.smart_toy, color: AppColors.accentCyan),
                    SizedBox(width: 8),
                    Text('AI Ask My Project / اسأل مشروعي الذكي',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Semantic search across RFIs, Daily Reports, ERP IPCs, and Primavera schedules:',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Why is Zone 4 delayed?',
                          hintStyle: const TextStyle(fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      onPressed: () {
                        if (_searchController.text.trim().isNotEmpty) {
                          _runQuery(_searchController.text.trim());
                        }
                      },
                      child: const Text('Ask / اسأل'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _presetAnswers.keys.map((q) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(q, style: const TextStyle(fontSize: 11)),
                        onPressed: () => _runQuery(q),
                      ),
                    )).toList(),
                  ),
                ),
                if (_aiAnswer != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: AppColors.accentCyan, size: 16),
                            SizedBox(width: 6),
                            Text('AI Synthesized Answer:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(_aiAnswer!, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 8),
                        const Text('Citations & Evidence Sources:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Wrap(
                          spacing: 6,
                          children: _aiCitations.map((c) => Chip(
                            label: Text(c, style: const TextStyle(fontSize: 9)),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // EVM Analytics Card
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loc.t('sp.comm_title'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Chip(
                      label: Text('EVM Standard', style: TextStyle(fontSize: 10)),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildEvmRow('Contract Budget (BAC)', 'AED 45,000,000', Colors.black87),
                _buildEvmRow(loc.t('sp.comm_ev_line'), 'AED 28,400,000', AppColors.verifiedGreen),
                _buildEvmRow(loc.t('sp.comm_ac_line'), 'AED 29,150,000', Colors.deepOrange),
                _buildEvmRow(loc.t('sp.comm_cpi_line'), '0.97 (Cost Variance: -AED 750,000)', AppColors.cautionAmber),
                _buildEvmRow(loc.t('sp.comm_eac_line'), 'AED 46,180,000 (+2.6% Overrun)', AppColors.criticalRed),
                const Divider(height: 20),
                _buildEvmRow(loc.t('sp.comm_variations'), 'AED 2,850,000 (4 Approved, 2 Pending)', AppColors.goldEmirates),
                _buildEvmRow(loc.t('sp.comm_cash'), 'AED 4,800,000 Escrow Reserve Safe', AppColors.verifiedGreen),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Interim Payment Certificates (IPC) Breakdown
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Interim Payment Certificates (IPC) & Cash Flow',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                _buildIpcTile('IPC-07 (Current Month)', 'AED 4,120,000', 'Submitted to Consultant - Day 14 of 28 SLA', AppColors.accentCyan),
                _buildIpcTile('IPC-06', 'AED 3,450,000', 'Certified by Employer & Paid via Escrow', AppColors.verifiedGreen),
                _buildIpcTile('IPC-05', 'AED 3,890,000', 'Paid 100% - 5% Retention Held', AppColors.verifiedGreen),
                _buildIpcTile('Cumulative Retention Held', 'AED 2,250,000', '5% statutory retention held in Escrow account', Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvmRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildIpcTile(String title, String amount, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(status, style: TextStyle(fontSize: 10, color: statusColor)),
            ],
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

// =========================================================================
// 4. FIELD QUALITY & TESTING VIEW (Port of SitePulseFieldQualityViews.kt)
// =========================================================================
class SitePulseFieldQualityView extends StatefulWidget {
  const SitePulseFieldQualityView({super.key});

  @override
  State<SitePulseFieldQualityView> createState() => _SitePulseFieldQualityViewState();
}

class _SitePulseFieldQualityViewState extends State<SitePulseFieldQualityView> with SingleTickerProviderStateMixin {
  late TabController _qualityTabController;

  final List<Map<String, dynamic>> _concreteBatches = [
    {
      'note': 'DN-2026-9912',
      'truck': 'DXB-55219',
      'supplier': 'Unibeton Ready Mix',
      'mix': 'C40/20 Micro-silica',
      'volume': 10.0,
      'slumpMm': 165,
      'batchTime': '08:15 AM',
      'remainingMin': 24,
      'pourLocation': 'Core Wall Level 14',
      'status': 'Passed (ASTM C94)',
      'isRejected': false,
    },
    {
      'note': 'DN-2026-9913',
      'truck': 'DXB-44102',
      'supplier': 'CEMEX UAE',
      'mix': 'C50/10 Self-Compacting',
      'volume': 9.5,
      'slumpMm': 160,
      'batchTime': '08:45 AM',
      'remainingMin': 54,
      'pourLocation': 'Columns Grid C-4',
      'status': 'Passed (ASTM C94)',
      'isRejected': false,
    },
    {
      'note': 'DN-2026-9908',
      'truck': 'DXB-88314',
      'supplier': 'National Ready Mix',
      'mix': 'C30 Sub-base lean',
      'volume': 12.0,
      'slumpMm': 110,
      'batchTime': '06:50 AM',
      'remainingMin': 0,
      'pourLocation': 'Section C blinding',
      'status': 'Expired / High Temp (ACI 305R)',
      'isRejected': true,
    },
  ];

  final List<Map<String, dynamic>> _cubeTests = [
    {
      'sampleCode': 'SMP-C40-0914',
      'pourDate': '2026-09-14',
      'element': 'Foundation Raft Zone A',
      'mix': 'C40/20',
      'cube7d': 32.4,
      'cube28d': 44.8,
      'reqMpa': 40.0,
      'status': 'Passed (112% of 28d spec)',
    },
    {
      'sampleCode': 'SMP-C50-0921',
      'pourDate': '2026-09-21',
      'element': 'Tower Shear Wall Level 11',
      'mix': 'C50/10',
      'cube7d': 41.2,
      'cube28d': null,
      'reqMpa': 50.0,
      'status': 'In Progress (7-Day 82% achieved)',
    },
  ];

  @override
  void initState() {
    super.initState();
    _qualityTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _qualityTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<SitePulseRepository>();

    return Column(
      children: [
        Container(
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: _qualityTabController,
            tabs: const [
              Tab(text: 'Concrete (ASTM C94)'),
              Tab(text: 'Cube Tests (MPa)'),
              Tab(text: 'Snags & NCRs'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _qualityTabController,
            children: [
              // Tab 1: Concrete Deliveries
              ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  const Text('Active Concrete Delivery Radar (90-Min ASTM C94 Rule)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  ..._concreteBatches.map((b) => Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${b['note']} • ${b['truck']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: (b['isRejected'] ? AppColors.criticalRed : AppColors.verifiedGreen).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  b['status'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: b['isRejected'] ? AppColors.criticalRed : AppColors.verifiedGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('${b['supplier']} • ${b['mix']} • ${b['volume']} m³', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.straighten, size: 14, color: AppColors.accentCyan),
                              const SizedBox(width: 4),
                              Text('Slump: ${b['slumpMm']} mm', style: const TextStyle(fontSize: 11)),
                              const SizedBox(width: 14),
                              const Icon(Icons.timer, size: 14, color: AppColors.goldEmirates),
                              const SizedBox(width: 4),
                              Text('Batch: ${b['batchTime']}', style: const TextStyle(fontSize: 11)),
                              const SizedBox(width: 14),
                              const Icon(Icons.hourglass_bottom, size: 14, color: AppColors.criticalRed),
                              const SizedBox(width: 4),
                              Text('Remaining: ${b['remainingMin']} min',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: b['isRejected'] ? AppColors.criticalRed : AppColors.verifiedGreen)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Pour: ${b['pourLocation']}', style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  )),
                ],
              ),

              // Tab 2: Cube Tests
              ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  const Text('Compressive Cube Strength Tests (BS EN 12390-3 / Dubai Code)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  ..._cubeTests.map((c) => Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(c['sampleCode'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(c['status'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${c['element']} • Pour Date: ${c['pourDate']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('7-Day Strength: ${c['cube7d']} MPa', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('28-Day: ${c['cube28d'] != null ? '${c['cube28d']} MPa' : 'Pending'}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                              Text('Spec: ${c['reqMpa']} MPa', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),

              // Tab 3: Snags & NCRs
              ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(loc.t('sp.quality_title'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('${repo.snags.length} Logged', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: const ListTile(
                      leading: Icon(Icons.bug_report, color: AppColors.cautionAmber),
                      title: Text('Snag #SN-104: Column base honeycomb C-12'),
                      subtitle: Text('Location: Level 12 Grid C • Assigned: Arabtec Formwork • Status: In Rectification'),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: const ListTile(
                      leading: Icon(Icons.verified, color: AppColors.verifiedGreen),
                      title: Text('Snag #SN-105: Rebar cover spacer blocks missing'),
                      subtitle: Text('Location: Slab Zone B • Assigned: Al Naboodah • Status: Closed & Approved'),
                    ),
                  ),
                  ...repo.snags.map((s) => Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: const Icon(Icons.assignment_late, color: AppColors.accentCyan),
                      title: Text(s['title'] ?? ''),
                      subtitle: Text('Location: ${s['location'] ?? ''} • Status: Under Review'),
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 5. DECISION SUPPORT & AUTOMATION SCREEN (Port of SitePulseDecisionSupportScreen.kt)
// =========================================================================
class SitePulseDecisionScreen extends StatefulWidget {
  const SitePulseDecisionScreen({super.key});

  @override
  State<SitePulseDecisionScreen> createState() => _SitePulseDecisionScreenState();
}

class _SitePulseDecisionScreenState extends State<SitePulseDecisionScreen> with SingleTickerProviderStateMixin {
  late TabController _decisionTabController;

  static const _subTabs = [
    'Predictive Delays',
    'Knowledge Graph',
    'Earned Value & Cost',
    'Materials & Prod',
    'GIS Site Map',
    'Risk Radar',
    'Voice & Meetings AI',
  ];

  @override
  void initState() {
    super.initState();
    _decisionTabController = TabController(length: _subTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _decisionTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-tabs bar
        Container(
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: _decisionTabController,
            isScrollable: true,
            tabs: _subTabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _decisionTabController,
            children: [
              // 0: Predictive Delays
              _buildPredictiveDelaysTab(),
              // 1: Knowledge Graph
              _buildKnowledgeGraphTab(),
              // 2: Earned Value & Cost
              _buildEvmTab(),
              // 3: Materials & Productivity
              _buildMaterialsTab(),
              // 4: GIS Site Map
              _buildGisMapTab(),
              // 5: Risk Radar
              _buildRiskRadarTab(),
              // 6: Voice & Meetings AI
              _buildVoiceAiTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPredictiveDelaysTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          color: AppColors.criticalRed.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.timeline, color: AppColors.criticalRed),
                    SizedBox(width: 8),
                    Text('Critical Path CPM Variance: +8 Calendar Days',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.criticalRed)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Driving Factor: Zone 3 Sewer main excavation is obstructed by DEWA 11kV live cables. Without immediate night shift mitigation, structural milestone Gate 4 will slip past November 15 deadline.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AI Proposed Recovery Action:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      const Text('• Re-sequence Section D in parallel with dewatering setup.\n• Mobilize acoustic night pour crew (20:00-04:00) recovering 5 float days.\n• Issue urgent DEWA bypass trenching notice under FIDIC 8.4 claim.',
                          style: TextStyle(fontSize: 11)),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('AI Recovery Package Dispatched to Consultant & DEWA Liaison')),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text('Execute Mitigation Workflow'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKnowledgeGraphTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Semantic Knowledge Graph / رسم العلاقات السببية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                const Text('Interconnected graph mapping site causes, RFIs, contractors, and schedule impacts:',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 14),
                _buildGraphNode('Contractor', 'Fibrex Infrastructure', Icons.business, AppColors.primary),
                _buildGraphLink('Assigned to work on'),
                _buildGraphNode('Workfront', 'Zone 3 Sewer Trenching', Icons.grid_view, AppColors.accentCyan),
                _buildGraphLink('Encountered blocker'),
                _buildGraphNode('Blocker', 'DEWA 11kV Cable Clash', Icons.warning, AppColors.criticalRed),
                _buildGraphLink('Triggered technical inquiry'),
                _buildGraphNode('RFI Submittal', 'RFI-088 (DEWA Cable Re-route)', Icons.description, AppColors.goldEmirates),
                _buildGraphLink('Generated CPM delay'),
                _buildGraphNode('Schedule Impact', '+8 Days on WBS 1.3.4 (FIDIC 20.1 Claim)', Icons.schedule, AppColors.criticalRed),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraphNode(String type, String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraphLink(String relation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Text(relation, style: const TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildEvmTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cumulative S-Curve Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 8),
                Text('Planned Value (PV): AED 29,800,000\nEarned Value (EV): AED 28,400,000\nActual Cost (AC): AED 29,150,000\n\nCost Variance (CV): -AED 750,000 (-2.6%)\nSchedule Variance (SV): -AED 1,400,000 (-4.7%)\nTo-Complete Performance Index (TCPI): 1.04',
                    style: TextStyle(fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialsTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Site Productivity & Materials Telemetry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 10),
                Text('• Rebar Cut & Bend Scrap Rate: 2.1% (Target < 3.5%)\n• Concrete Pump Pouring Rate: 42 m³ / gang-hour\n• Formwork Cycle Time: 4.2 days per typical tower floor\n• Diesel Generator Consumption: 180 L / 24 hr (100% solar hybrid)',
                    style: TextStyle(fontSize: 12, height: 1.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGisMapTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Geofenced GIS Site Map (200m Active Perimeter)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          '🗺️ GIS Map Satellite View\nLat: 25.1972° N, Long: 55.2744° E\nTower Crane 1 (45m radius) • Tower Crane 2 (55m radius)',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 30,
                        child: _mapPin('Zone 1: Active', AppColors.verifiedGreen),
                      ),
                      Positioned(
                        top: 60,
                        right: 40,
                        child: _mapPin('Zone 3: Blocker', AppColors.criticalRed),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 80,
                        child: _mapPin('Batching Gate A', AppColors.accentCyan),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _mapPin(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRiskRadarTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Project Risk Radar (ISO 31000)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 10),
                Text('1. [CRITICAL] DEWA 11kV cable clash (Prob: 90%, Impact: High, CPM: +8d)\n2. [HIGH] Summer Midday Stoppage compensation claims (Prob: 70%, Impact: Med, Cost: AED 280k)\n3. [MED] Reinforcement steel spot price fluctuation +4.5% (Prob: 50%, Impact: Med)',
                    style: TextStyle(fontSize: 12, height: 1.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceAiTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.mic, color: AppColors.accentCyan),
                    SizedBox(width: 8),
                    Text('Voice & Coordination Meeting AI Synthesis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Meeting: Daily 07:00 AM Site Standup • Attendees: Eng. Abdelfattah, Eng. Salem, Eng. Rami\n\nExtracted Action Items:\n• Eng. Rami: Submit urgent Section C bypass sketch to DEWA by 12:00 PM today.\n• Eng. Salem: Request 2 extra submersible pumps from DeepFound for Zone 2 pit.\n• Safety Team: Verify hydration stations for midday ban compliance.',
                  style: TextStyle(fontSize: 12, height: 1.6),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black87),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Action items dispatched to WhatsApp & email to attendees')),
                  ),
                  icon: const Icon(Icons.send, size: 16),
                  label: const Text('Dispatch Meeting Minutes to Engineers'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 6. MASTER & EXECUTIVE REPORTS VIEW (Port of SitePulseMasterPlatformViews.kt)
// =========================================================================
class SitePulseMasterView extends StatelessWidget {
  const SitePulseMasterView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.t('sp.master_title'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                const Text('Dubai Creek Harbour Tower Phase 2 • Executive Board Dashboard',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGauge('Progress', '68.2%', AppColors.verifiedGreen),
                    _buildGauge('Time Elapsed', '72.0%', AppColors.cautionAmber),
                    _buildGauge('Budget Spent', '64.7%', AppColors.accentCyan),
                  ],
                ),
                const Divider(height: 24),
                const Text('Regulatory & Authority Permits Status:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                _buildPermitRow('Dubai Municipality (DM) Building Permit', 'Active & Valid (BP-2025-998)', AppColors.verifiedGreen),
                _buildPermitRow('Civil Defense (DCD) Life Safety Approval', 'Approved (DCD-8812)', AppColors.verifiedGreen),
                _buildPermitRow('DEWA Permanent Power Connection', 'NOC Received • Sub-station in Progress', AppColors.cautionAmber),
                _buildPermitRow('RTA Road Access & Traffic Management', 'Valid until Dec 2026', AppColors.verifiedGreen),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating official Executive Monthly PDF Progress Report...')),
                  ),
                  icon: const Icon(Icons.picture_as_pdf, size: 16),
                  label: const Text('Export Executive Progress Report (PDF)'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGauge(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildPermitRow(String permit, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(permit, style: const TextStyle(fontSize: 12))),
          Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
        ],
      ),
    );
  }
}

// =========================================================================
// 7. SITE PULSE OS VIEW (Port of SitePulseOsViews.kt)
// =========================================================================
class SitePulseOsView extends StatelessWidget {
  const SitePulseOsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SitePulseScreen();
  }
}
