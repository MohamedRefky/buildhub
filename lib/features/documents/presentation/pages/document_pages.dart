// Clean Architecture: Documents & Engineering — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// ProjectVaultScreen, RfiSubmittalsScreen, DrawingBimViewerScreen,
// EnterpriseIntegrationsScreen, EnterpriseReportsAndAuditScreen,
// EngineeringLibraryScreen, TrainingCoursesScreen, UserFileManagerScreen,
// FirebaseAuthScreen, FirebaseCloudSyncScreen, TechnicalSpecificationsView,
// ReportReviewScreen, DrawingPinRecordScreen, GCCAuthoritiesHubScreen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// 1. PROJECT VAULT SCREEN
// ---------------------------------------------------------------------------

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  int _selectedTab = 1; // 0: Company, 1: Projects, 2: Members

  final List<Map<String, dynamic>> _credentials = [
    {
      'title': 'Trade License',
      'subtitle': 'DED-2019-884721',
      'detail': 'Commercial Construction & Contracting',
      'expiry': 'Valid until Dec 2026',
      'icon': Icons.business,
      'color': AppColors.accentCyan,
    },
    {
      'title': 'TRN Number (VAT)',
      'subtitle': '100485219100003',
      'detail': 'UAE Federal Tax Authority Registered',
      'expiry': 'Active Tax Reg',
      'icon': Icons.receipt_long,
      'color': const Color(0xFFFFA726),
    },
    {
      'title': 'ISO 9001:2015',
      'subtitle': 'Quality Management',
      'detail': 'Certified Quality Management System',
      'expiry': 'Valid until Mar 2027',
      'icon': Icons.verified,
      'color': AppColors.verifiedGreen,
    },
    {
      'title': 'Dubai Municipality Approval',
      'subtitle': 'Class A Contractor',
      'detail': 'High-rise & Heavy Civil Authorization',
      'expiry': 'Active Status',
      'icon': Icons.engineering,
      'color': const Color(0xFF9C27B0),
    },
    {
      'title': 'Bank Account',
      'subtitle': 'ENBD ---- 4821',
      'detail': 'Primary Corporate Escrow Account',
      'expiry': 'AED Currency',
      'icon': Icons.account_balance,
      'color': AppColors.accentCyan,
    },
  ];

  final List<Map<String, dynamic>> _projects = [
    {
      'code': 'PRJ-2026-001',
      'titleEn': 'Marina Tower',
      'titleAr': 'برج المارينا',
      'budget': 'AED 42.5M',
      'members': 14,
      'phase': 'Structural',
      'status': 'نشط',
    },
    {
      'code': 'PRJ-2026-002',
      'titleEn': 'Business Bay Office Complex',
      'titleAr': 'مجمع مكاتب الخليج التجاري',
      'budget': 'AED 28.1M',
      'members': 9,
      'phase': 'Foundation',
      'status': 'نشط',
    },
    {
      'code': 'PRJ-2026-003',
      'titleEn': 'JBR Retail Podium',
      'titleAr': 'بوديوم JBR التجاري',
      'budget': 'AED 8.3M',
      'members': 6,
      'phase': 'Handover',
      'status': 'مكتمل',
    },
  ];

  final List<Map<String, dynamic>> _members = [
    {
      'name': 'Eng. Khalid Al Mansoori',
      'role': 'Project Manager',
      'roleType': 'Admin',
      'project': 'PRJ-2026-001',
      'time': '14:28',
    },
    {
      'name': 'Ahmed Al Rashidi',
      'role': 'Site Engineer',
      'roleType': 'Engineer',
      'project': 'PRJ-2026-001',
      'time': '14:25',
    },
    {
      'name': 'Fatima Al Zaabi',
      'role': 'Accountant',
      'roleType': 'Finance',
      'project': 'PRJ-2026-001',
      'time': '12:00',
    },
    {
      'name': 'Rajiv Kumar',
      'role': 'MEP Foreman',
      'roleType': 'Field',
      'project': 'PRJ-2026-001',
      'time': '12:30',
    },
    {
      'name': 'Ali Hassan',
      'role': 'Safety Officer',
      'roleType': 'Field',
      'project': 'PRJ-2026-001',
      'time': '10:15',
    },
  ];

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
            const Text(
              'Project Vault',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Al Mansoori Construction Co.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.verifiedGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 13, color: AppColors.verifiedGreen),
                SizedBox(width: 4),
                Text(
                  'AES-256',
                  style: TextStyle(color: AppColors.verifiedGreen, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          // Company Profile Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'AM',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.accentCyan),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Al Mansoori Construction Co.',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Trade License: DED-2019-884721 • TRN: 100485219100003',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(color: AppColors.darkBorder.withValues(alpha: 0.4), height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('2', 'Active Projects', AppColors.accentCyan),
                    _buildStatCol('6', 'Total Members', Colors.white),
                    _buildStatCol('AES-256', 'Vault Status', AppColors.verifiedGreen),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Account Hierarchy Navigation Cards
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account Hierarchy',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildHierarchyNavCard(
                      title: 'Company',
                      icon: Icons.business,
                      isSelected: _selectedTab == 0,
                      onTap: () => setState(() => _selectedTab = 0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildHierarchyNavCard(
                      title: 'Projects',
                      icon: Icons.folder,
                      isSelected: _selectedTab == 1,
                      onTap: () => setState(() => _selectedTab = 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildHierarchyNavCard(
                      title: 'Members',
                      icon: Icons.group,
                      isSelected: _selectedTab == 2,
                      onTap: () => setState(() => _selectedTab = 2),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tab Content
          if (_selectedTab == 0) ..._buildCompanyCredentials(),
          if (_selectedTab == 1) ..._buildProjectsList(),
          if (_selectedTab == 2) ..._buildMembersList(),
        ],
      ),
    );
  }

  Widget _buildStatCol(String val, String label, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildHierarchyNavCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.18) : AppColors.darkCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accentCyan : AppColors.darkBorder.withValues(alpha: 0.5),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCompanyCredentials() {
    return _credentials.map((cred) {
      final col = cred['color'] as Color;
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: col.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(cred['icon'] as IconData, color: col, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cred['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cred['subtitle'] as String,
                    style: const TextStyle(fontSize: 12, color: AppColors.accentCyan),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cred['detail'] as String,
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cred['expiry'] as String,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen),
                ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildProjectsList() {
    return _projects.map((proj) {
      final isActive = proj['status'] == 'نشط';
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  proj['code'] as String,
                  style: const TextStyle(fontSize: 11, color: AppColors.accentCyan, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.verifiedGreen.withValues(alpha: 0.18) : Colors.white10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    proj['status'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.verifiedGreen : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${proj['titleEn']} (${proj['titleAr']})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Divider(color: AppColors.darkBorder.withValues(alpha: 0.3), height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Budget', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(proj['budget'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Members', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text('${proj['members']} Members', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Phase', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(proj['phase'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildMembersList() {
    return _members.map((member) {
      Color roleCol;
      switch (member['roleType']) {
        case 'Admin':
          roleCol = const Color(0xFFFF5252);
          break;
        case 'Engineer':
          roleCol = AppColors.accentCyan;
          break;
        case 'Finance':
          roleCol = const Color(0xFFFFA726);
          break;
        default:
          roleCol = AppColors.verifiedGreen;
          break;
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.accentCyan, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${member['role']} • ${member['project']}',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: roleCol.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    member['roleType'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: roleCol,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member['time'] as String,
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}

// ---------------------------------------------------------------------------
// 2. RFI SUBMITTALS & TRACKER SCREEN (1:1 PARITY WITH RfiSubmittalsScreen.kt)
// ---------------------------------------------------------------------------

class RfiScreen extends StatefulWidget {
  const RfiScreen({super.key});

  @override
  State<RfiScreen> createState() => _RfiScreenState();
}

class _RfiScreenState extends State<RfiScreen> {
  int _selectedTab = 0; // 0: RFIs, 1: Material Submittals
  String _searchQuery = '';
  String? _selectedDiscipline;
  final TextEditingController _searchCtrl = TextEditingController();

  final List<Map<String, dynamic>> _rfis = [
    {
      'id': '1',
      'no': 'RFI-STR-042',
      'title': 'Clarification on Rebar Lapping at Column Grid C4 Transfer Slab',
      'discipline': 'Structural',
      'status': 'PENDING_CONSULTANT',
      'submittedDate': '2026-09-24',
      'dueDate': '2026-09-28',
      'slaText': 'Turnaround: 4 Days (SLA Active)',
      'assignee': 'Eng. Tariq Al Maktoum (Lead Structural Consultant)',
      'code': 'CODE B',
      'specRef': 'DBC 2023 Chapter 4 - Structural Concrete',
    },
    {
      'id': '2',
      'no': 'RFI-MEP-018',
      'title': 'Chilled Water Pipe Routing Clash with Fire Sprinkler Main Level 3',
      'discipline': 'MEP',
      'status': 'OVERDUE',
      'submittedDate': '2026-09-18',
      'dueDate': '2026-09-25',
      'slaText': 'SLA Overdue by 48 Hours',
      'assignee': 'Dar Al-Handasah MEP Supervision',
      'code': 'CODE C (Revise & Resubmit)',
      'specRef': 'ASHRAE 90.1 & NFPA 13 Fire Suppression',
    },
    {
      'id': '3',
      'no': 'RFI-ARC-089',
      'title': 'Façade Double-Glazed Glass Panel Thermal Insulation & Acoustic Spec',
      'discipline': 'Architectural',
      'status': 'APPROVED',
      'submittedDate': '2026-09-20',
      'dueDate': '2026-09-23',
      'slaText': 'Approved within 3 Days',
      'assignee': 'Lead Architect Studio Dubai',
      'code': 'CODE A (Approved Without Comments)',
      'specRef': 'Al Sa\'fat Dubai Green Building Specs',
    },
    {
      'id': '4',
      'no': 'RFI-CIV-005',
      'title': 'Excavation Dewatering Discharge Connection to Municipality Storm Line',
      'discipline': 'Civil',
      'status': 'PENDING_CONSULTANT',
      'submittedDate': '2026-09-25',
      'dueDate': '2026-09-30',
      'slaText': 'Turnaround: 5 Days (Pending DM NOC)',
      'assignee': 'Dubai Municipality Drainage Dept',
      'code': 'UNDER REVIEW',
      'specRef': 'DM Environmental Drainage Standard 102',
    },
  ];

  final List<Map<String, dynamic>> _submittals = [
    {
      'id': '101',
      'no': 'MAT-STR-014',
      'title': 'High-Yield Deformed Steel Rebar Grade B500B (Emirates Steel)',
      'discipline': 'Structural',
      'status': 'APPROVED',
      'submittedDate': '2026-09-12',
      'dueDate': '2026-09-19',
      'slaText': 'Full Mill Certificate & CARES Approved',
      'assignee': 'Senior Resident Engineer',
      'code': 'CODE A',
      'specRef': 'BS 4449 / ASTM A615 Grade 60',
    },
    {
      'id': '102',
      'no': 'MAT-MEP-033',
      'title': 'Daikin Variable Refrigerant Volume (VRV IV) Heat Recovery Units',
      'discipline': 'MEP',
      'status': 'PENDING_CONSULTANT',
      'submittedDate': '2026-09-22',
      'dueDate': '2026-09-29',
      'slaText': 'Awaiting DEWA Energy Efficiency Tag',
      'assignee': 'KEO International Consultants',
      'code': 'UNDER REVIEW',
      'specRef': 'DEWA Efficiency Standard 2024',
    },
    {
      'id': '103',
      'no': 'MAT-FIN-008',
      'title': 'Crema Marfil Polished Natural Marble Tiles 600x600 for Lobby',
      'discipline': 'Architectural',
      'status': 'APPROVED',
      'submittedDate': '2026-09-15',
      'dueDate': '2026-09-21',
      'slaText': 'Mock-up Approved On-Site',
      'assignee': 'Interior Design Consultant',
      'code': 'CODE B',
      'specRef': 'Architectural Finishes Spec Section 09300',
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showCreateDialog() {
    final titleCtrl = TextEditingController();
    final specCtrl = TextEditingController();
    String discipline = 'Structural';
    String urgency = 'Normal';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.add_circle, color: AppColors.accentCyan, size: 20),
                const SizedBox(width: 8),
                Text(
                  _selectedTab == 0 ? 'Create New Technical RFI' : 'New Material Submittal',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: _selectedTab == 0 ? 'RFI Subject / Clarification Query' : 'Material Title & Brand',
                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: discipline,
                            dropdownColor: const Color(0xFF1E293B),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: const InputDecoration(
                              labelText: 'Discipline',
                              labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                              border: OutlineInputBorder(),
                            ),
                            items: ['Structural', 'MEP', 'Architectural', 'Civil', 'Façade']
                                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                .toList(),
                            onChanged: (v) => setDlgState(() => discipline = v ?? 'Structural'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: urgency,
                            dropdownColor: const Color(0xFF1E293B),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: const InputDecoration(
                              labelText: 'Urgency SLA',
                              labelStyle: TextStyle(color: Colors.grey, fontSize: 11),
                              border: OutlineInputBorder(),
                            ),
                            items: ['Normal (5 Days)', 'Urgent (48 Hours)', 'Critical Site Stoppage']
                                .map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 10))))
                                .toList(),
                            onChanged: (v) => setDlgState(() => urgency = v ?? 'Normal'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: specCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Specification / Contract Clause Reference',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.attach_file, color: AppColors.accentCyan, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'DWG Drawing Markup & Site Photo attached (2.4 MB)',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentCyan,
                  foregroundColor: const Color(0xFF0B192C),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.verifiedGreen,
                      content: Text('Transmitted to Consultant with immutable timestamp & SLA countdown.'),
                    ),
                  );
                },
                child: const Text('Submit Officially', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return AppColors.verifiedGreen;
      case 'OVERDUE':
        return AppColors.criticalRed;
      case 'PENDING_CONSULTANT':
      case 'UNDER REVIEW':
        return AppColors.cautionAmber;
      default:
        return AppColors.accentCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _selectedTab == 0 ? _rfis : _submittals;
    final filtered = list.where((item) {
      final matchesDisc = _selectedDiscipline == null || item['discipline'] == _selectedDiscipline;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          (item['no'] as String).toLowerCase().contains(q) ||
          (item['title'] as String).toLowerCase().contains(q) ||
          (item['discipline'] as String).toLowerCase().contains(q) ||
          (item['assignee'] as String).toLowerCase().contains(q);
      return matchesDisc && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('RFIs & Technical Submittals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              'Consultant approval tracking & response logs',
              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.accentCyan),
            tooltip: 'New RFI / Submittal',
            onPressed: _showCreateDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          // Tab Switcher and Search
          Container(
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FilterChip(
                        selected: _selectedTab == 0,
                        label: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.question_answer, size: 14),
                            SizedBox(width: 6),
                            Text('RFIs (14 Active)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        selectedColor: AppColors.accentCyan,
                        backgroundColor: const Color(0xFF1E293B),
                        labelStyle: TextStyle(color: _selectedTab == 0 ? const Color(0xFF0B192C) : Colors.white70),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        onSelected: (val) => setState(() => _selectedTab = 0),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilterChip(
                        selected: _selectedTab == 1,
                        label: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2, size: 14),
                            SizedBox(width: 6),
                            Text('Material Submittals (28)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        selectedColor: AppColors.accentCyan,
                        backgroundColor: const Color(0xFF1E293B),
                        labelStyle: TextStyle(color: _selectedTab == 1 ? const Color(0xFF0B192C) : Colors.white70),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        onSelected: (val) => setState(() => _selectedTab = 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Search Box
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search by RFI #, title, assignee, code...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: const Icon(Icons.search, color: AppColors.accentCyan, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accentCyan)),
                  ),
                ),
              ],
            ),
          ),

          // Discipline Filter Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                _buildDiscChip('All Disciplines', null),
                _buildDiscChip('Structural', 'Structural'),
                _buildDiscChip('MEP', 'MEP'),
                _buildDiscChip('Architectural', 'Architectural'),
                _buildDiscChip('Civil', 'Civil'),
              ],
            ),
          ),

          // List of Cards
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('No records matched your criteria', style: TextStyle(color: Colors.grey))),
            )
          else
            ...filtered.map((item) => _buildRfiCard(item)),
        ],
      ),
    );
  }

  Widget _buildDiscChip(String label, String? disc) {
    final isSelected = _selectedDiscipline == disc;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selectedColor: AppColors.accentCyan,
        backgroundColor: const Color(0xFF1E293B),
        labelStyle: TextStyle(color: isSelected ? const Color(0xFF0B192C) : Colors.white70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (val) => setState(() => _selectedDiscipline = val ? disc : null),
      ),
    );
  }

  Widget _buildRfiCard(Map<String, dynamic> item) {
    final statusColor = _getStatusColor(item['status'] as String);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151F32),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Number, Discipline & Status
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
                    child: Text(
                      item['no'] as String,
                      style: const TextStyle(color: AppColors.accentCyan, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item['discipline'] as String,
                    style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item['status'] as String,
                  style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            item['title'] as String,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, height: 1.3),
          ),
          const SizedBox(height: 6),

          // Code & Spec Ref
          Row(
            children: [
              Text(
                item['code'] as String,
                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Colors.grey, fontSize: 10)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item['specRef'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // SLA & Assignee
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.person_pin, color: AppColors.accentCyan, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['assignee'] as String,
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item['slaText'] as String,
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. DRAWINGS & BIM 3D VIEWER SCREEN
// ---------------------------------------------------------------------------

class DrawingsScreen extends StatefulWidget {
  const DrawingsScreen({super.key});

  @override
  State<DrawingsScreen> createState() => _DrawingsScreenState();
}

class _DrawingsScreenState extends State<DrawingsScreen> {
  int _tab = 0; // 0: 2D Drawings, 1: 3D BIM Viewer
  String _selectedDiscipline = 'ALL';

  final List<Map<String, dynamic>> _drawings = [
    {'code': 'STR-101', 'title': 'Foundation & Piles General Layout', 'disc': 'Structural', 'rev': 'Rev C', 'date': '2026-09-20', 'author': 'Dar Al-Handasah'},
    {'code': 'MEP-202', 'title': 'Level 12 HVAC & Chilled Water Routing', 'disc': 'MEP', 'rev': 'Rev B', 'date': '2026-09-22', 'author': 'WSP Middle East'},
    {'code': 'ARC-305', 'title': 'Tower Elevation & Façade Glazing Details', 'disc': 'Architectural', 'rev': 'Rev D', 'date': '2026-09-24', 'author': 'Aedas Architects'},
    {'code': 'STR-114', 'title': 'Level 12 Zone B Slab Reinforcement Details', 'disc': 'Structural', 'rev': 'Rev B', 'date': '2026-09-27', 'author': 'Dar Al-Handasah'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Drawings & BIM 3D Viewer', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('IFC 3D Models • Revisions • Pin Markups', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('2D CAD Drawings')),
                ButtonSegment(value: 1, label: Text('3D BIM Model (IFC)')),
              ],
              selected: {_tab},
              onSelectionChanged: (s) => setState(() => _tab = s.first),
            ),
          ),
          Expanded(
            child: _tab == 0 ? _build2dDrawings() : _build3dBimViewer(),
          ),
        ],
      ),
    );
  }

  Widget _build2dDrawings() {
    final filtered = _drawings.where((d) => _selectedDiscipline == 'ALL' || d['disc'] == _selectedDiscipline).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['ALL', 'Structural', 'MEP', 'Architectural']
                .map((d) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(d),
                        selected: _selectedDiscipline == d,
                        onSelected: (_) => setState(() => _selectedDiscipline = d),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        ...filtered.map((d) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: AppColors.criticalRed),
                title: Text('${d['code']}: ${d['title']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('${d['disc']} • ${d['rev']} • ${d['author']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.pin_drop, color: AppColors.accentCyan),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DrawingPinRecordScreen()));
                  },
                ),
              ),
            )),
      ],
    );
  }

  Widget _build3dBimViewer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle, border: Border.all(color: AppColors.accentCyan)),
              child: const Icon(Icons.view_in_ar, size: 70, color: AppColors.accentCyan),
            ),
            const SizedBox(height: 20),
            const Text('Marina Tower 3D BIM Model (IFC 4.3)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Clash detection active • 4 Active BIM layers loaded:\nConcrete Shell, MEP Chilled Water, Curtain Wall, Rebar Mesh', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
              icon: const Icon(Icons.open_in_full),
              label: const Text('Open Interactive 3D Model'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Launching WebGL 3D BIM Viewer engine...')));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. ENGINEERING LIBRARY & CODES SCREEN
// ---------------------------------------------------------------------------

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = [
      {'title': 'Dubai Building Code (DBC 2021)', 'sub': 'Dubai Municipality Official Regulations', 'type': 'PDF • 840 Pages', 'cat': 'Building Codes'},
      {'title': 'Abu Dhabi International Building Code (ADIBC)', 'sub': 'Department of Municipalities and Transport', 'type': 'PDF • 920 Pages', 'cat': 'Building Codes'},
      {'title': 'ACI 305R Guide to Hot Weather Concreting', 'sub': 'American Concrete Institute Standard', 'type': 'PDF • 48 Pages', 'cat': 'Concrete Standards'},
      {'title': 'DEWA Regulations for Electrical Installations', 'sub': 'Dubai Electricity & Water Authority Edition 2022', 'type': 'PDF • 312 Pages', 'cat': 'MEP Codes'},
      {'title': 'Civil Defense UAE Fire & Life Safety Code', 'sub': 'Ministry of Interior UAE Fire Code', 'type': 'PDF • 1,450 Pages', 'cat': 'Life Safety'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Engineering Library & Standards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...docs.map((d) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: AppColors.accentCyan),
                  title: Text(d['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('${d['sub']} • ${d['type']}'),
                  trailing: const Icon(Icons.download),
                  onTap: () {},
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. TRAINING COURSES SCREEN (1:1 PARITY WITH TrainingCoursesScreen.kt)
// ---------------------------------------------------------------------------

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All Courses', 'Structural', 'MEP', 'Project Mgmt'];

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Advanced Structural Post-Tensioning & High-Rise Design',
      'institution': 'Dubai Engineering College',
      'instructor': 'Dr. Ahmed Hassan (PE, CEng)',
      'durationWeeks': 8,
      'studentsCount': 342,
      'rating': 4.8,
      'fee': 'AED 2,500',
      'category': 'Structural',
      'cpdCredits': '40 CPD / PDU',
      'badge': 'Accredited by Society of Engineers UAE',
    },
    {
      'title': 'MEP Systems Design & BIM 360 Clash Coordination',
      'institution': 'Emirates Technical Institute',
      'instructor': 'Eng. Sara Ali (BIM Lead)',
      'durationWeeks': 12,
      'studentsCount': 289,
      'rating': 4.9,
      'fee': 'AED 3,200',
      'category': 'MEP',
      'cpdCredits': '60 CPD',
      'badge': 'DEWA & ASHRAE Endorsed Curriculum',
    },
    {
      'title': 'Project Management Professional (PMP) Construction EPC',
      'institution': 'Global PM Institute Dubai',
      'instructor': 'Dr. Tariq Al-Mansoor (PMP, PMI-RMP)',
      'durationWeeks': 6,
      'studentsCount': 412,
      'rating': 4.7,
      'fee': 'AED 1,850',
      'category': 'Project Mgmt',
      'cpdCredits': '35 PDU',
      'badge': 'PMI Authorized Training Partner (ATP)',
    },
    {
      'title': 'FIDIC Red Book 2017 & UAE Commercial Claims Mastery',
      'institution': 'Dubai Legal & Arbitration Centre',
      'instructor': 'Adv. Ziad Qasim (FIDIC Adjudicator)',
      'durationWeeks': 4,
      'studentsCount': 195,
      'rating': 4.9,
      'fee': 'AED 2,900',
      'category': 'Project Mgmt',
      'cpdCredits': '24 CPD',
      'badge': 'DIAC Accredited Dispute Syllabus',
    },
  ];

  void _enrollCourse(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.school, color: AppColors.accentCyan, size: 22),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Enroll & Add to CPD Passport',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text('${course['institution']} • ${course['instructor']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Course Tuition Fee', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text(course['fee'] as String, style: const TextStyle(color: AppColors.accentCyan, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('PDU / Credits Earned', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text(course['cpdCredits'] as String, style: const TextStyle(color: AppColors.goldEmirates, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: const Color(0xFF0B192C),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.verifiedGreen,
                  content: Text('Enrolled in ${course['title']}! Added to Orion CPD Passport.'),
                ),
              );
            },
            child: const Text('Confirm Enrollment', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategoryIndex == 0
        ? _courses
        : _courses.where((c) => c['category'] == _categories[_selectedCategoryIndex]).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Professional Training & CPD Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Accredited Engineering Courses & PMP Certification', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          // Category selector chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: List.generate(_categories.length, (idx) {
                final isSelected = _selectedCategoryIndex == idx;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(_categories[idx], style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selectedColor: AppColors.accentCyan,
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(color: isSelected ? const Color(0xFF0B192C) : Colors.white70),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (val) => setState(() => _selectedCategoryIndex = idx),
                  ),
                );
              }),
            ),
          ),

          // Course Cards
          ...filtered.map((course) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF151F32),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                            color: AppColors.accentCyan.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            course['category'] as String,
                            style: const TextStyle(color: AppColors.accentCyan, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.goldEmirates, size: 13),
                            const SizedBox(width: 3),
                            Text(
                              '${course['rating']} (${course['studentsCount']} enrolled)',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course['title'] as String,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, height: 1.3),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course['institution']} • Instructor: ${course['instructor']}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '📜 ${course['badge']}',
                      style: const TextStyle(color: AppColors.goldEmirates, fontSize: 10),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${course['durationWeeks']} Weeks • ${course['cpdCredits']}',
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            Text(
                              course['fee'] as String,
                              style: const TextStyle(color: AppColors.accentCyan, fontSize: 14, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentCyan,
                            foregroundColor: const Color(0xFF0B192C),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.school, size: 14),
                          label: const Text('Enroll Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () => _enrollCourse(course),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. GCC AUTHORITIES HUB SCREEN (1:1 PARITY WITH GCCAuthoritiesHubScreen.kt)
// ---------------------------------------------------------------------------

class GccAuthoritiesHubScreen extends StatefulWidget {
  const GccAuthoritiesHubScreen({super.key});

  @override
  State<GccAuthoritiesHubScreen> createState() => _GccAuthoritiesHubScreenState();
}

class _GccAuthoritiesHubScreenState extends State<GccAuthoritiesHubScreen> {
  String _selectedCountryCode = 'UAE';

  final List<Map<String, dynamic>> _countries = [
    {'code': 'UAE', 'label': '🇦🇪 UAE (الإمارات)', 'authoritiesCount': 8, 'vendorsCount': 1286},
    {'code': 'KSA', 'label': '🇸🇦 KSA (السعودية)', 'authoritiesCount': 12, 'vendorsCount': 2450},
    {'code': 'QAT', 'label': '🇶🇦 Qatar (قطر)', 'authoritiesCount': 6, 'vendorsCount': 890},
    {'code': 'KWT', 'label': '🇰🇼 Kuwait (الكويت)', 'authoritiesCount': 5, 'vendorsCount': 620},
    {'code': 'BHR', 'label': '🇧🇭 Bahrain (البحرين)', 'authoritiesCount': 4, 'vendorsCount': 430},
    {'code': 'OMN', 'label': '🇴🇲 Oman (عُمان)', 'authoritiesCount': 5, 'vendorsCount': 510},
  ];

  final Map<String, List<Map<String, dynamic>>> _authoritiesByCountry = {
    'UAE': [
      {
        'abbr': 'DM',
        'nameAr': 'بلدية دبي',
        'nameEn': 'Dubai Municipality',
        'cat': 'Municipal Authority',
        'vendors': 340,
        'code': 'Dubai Building Code (DBC 2023)',
        'scope': 'Building Permits, NOCs, Green Concrete & Final Completion Certificates',
        'status': 'Connected (API Live)',
      },
      {
        'abbr': 'RTA',
        'nameAr': 'هيئة الطرق والمواصلات - دبي',
        'nameEn': 'Roads & Transport Authority',
        'cat': 'Transport & Infrastructure',
        'vendors': 215,
        'code': 'RTA Standard Specification 2024',
        'scope': 'Right of Way (ROW) Permits, Traffic Impact Studies & Heavy Haul NOC',
        'status': 'Connected (API Live)',
      },
      {
        'abbr': 'DEWA',
        'nameAr': 'هيئة كهرباء ومياه دبي',
        'nameEn': 'Dubai Electricity & Water Authority',
        'cat': 'Utilities & Energy',
        'vendors': 190,
        'code': 'DEWA Substation Regulations Rev 7',
        'scope': 'Permanent & Temporary Power NOC, Solar Rooftop Grid Tie & Water Metering',
        'status': 'Connected (API Live)',
      },
      {
        'abbr': 'DCD',
        'nameAr': 'الدفاع المدني - دبي',
        'nameEn': 'Dubai Civil Defence',
        'cat': 'Life Safety & Fire Engineering',
        'vendors': 142,
        'code': 'UAE Fire & Life Safety Code 2018',
        'scope': 'Fire Alarm, Sprinkler Hydraulic Calculations & Cladding Fire Retardant Clearance',
        'status': 'Inspection Scheduled',
      },
      {
        'abbr': 'Trakhees',
        'nameAr': 'دائرة التخطيط والتطوير - تراخيص',
        'nameEn': 'Trakhees / PCFC',
        'cat': 'Freezone Authority',
        'vendors': 168,
        'code': 'Trakhees Building Regulations 2023',
        'scope': 'JAFZA, Palm Jumeirah & Waterfront Development Planning Approvals',
        'status': 'Active Gateway',
      },
      {
        'abbr': 'ADM',
        'nameAr': 'بلدية مدينة أبوظبي',
        'nameEn': 'Abu Dhabi City Municipality',
        'cat': 'Municipal Authority',
        'vendors': 231,
        'code': 'Estidama Pearl Rating System',
        'scope': 'BIM e-Permits, Infrastructure NOC & Estidama 2-Pearl Compliance',
        'status': 'Active Gateway',
      },
    ],
    'KSA': [
      {
        'abbr': 'MOMRAH',
        'nameAr': 'وزارة البلديات والإسكان',
        'nameEn': 'Ministry of Municipalities and Housing',
        'cat': 'Municipal Authority',
        'vendors': 820,
        'code': 'Saudi Building Code (SBC 1101)',
        'scope': 'Balady Platform Building Permits, Zoning Clearance & Contractor Classification',
        'status': 'Connected (API Live)',
      },
      {
        'abbr': 'ARAMCO',
        'nameAr': 'أرامكو السعودية',
        'nameEn': 'Saudi Aramco Engineering Standards',
        'cat': 'Energy & Industrial',
        'vendors': 640,
        'code': 'SAES-Q-001 Foundation & Concrete',
        'scope': 'Oil & Gas Civil Infrastructure, Cathodic Protection & Plant Security',
        'status': 'Approved Vendor List',
      },
    ],
  };

  void _showComplianceAuditDialog(Map<String, dynamic> auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.verified, color: AppColors.verifiedGreen, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Regulatory Compliance Audit: ${auth['abbr']}',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${auth['nameEn']} (${auth['nameAr']})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 2),
            Text('Standard: ${auth['code']}', style: const TextStyle(color: AppColors.accentCyan, fontSize: 11)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Project Audit Status: 100% COMPLIANT', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                  SizedBox(height: 4),
                  Text('• NOC Issuance: Approved (Permit # NOC-2026-8812)', style: TextStyle(color: Colors.white70, fontSize: 10)),
                  Text('• Structural Design Review: Passed without comments', style: TextStyle(color: Colors.white70, fontSize: 10)),
                  Text('• Pre-Qualified Suppliers: 100% contracted from approved list', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: const Color(0xFF0B192C)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(backgroundColor: AppColors.verifiedGreen, content: Text('Compliance certificate downloaded & stamped.')),
              );
            },
            child: const Text('Export Audit Report', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _authoritiesByCountry[_selectedCountryCode] ?? _authoritiesByCountry['UAE']!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GCC Regulatory Authorities Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Multi-Country Construction Compliance Directory', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          // Banner Card
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0C192E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.35)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Multi-Country Authority Verification',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Access verified suppliers approved by construction authorities across UAE, KSA, Qatar, and GCC countries.',
                  style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),

          // Stats Bar Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Column(
                  children: [
                    Text('8', style: TextStyle(color: AppColors.accentCyan, fontSize: 16, fontWeight: FontWeight.w900)),
                    Text('Authorities', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                Container(width: 1, height: 24, color: Colors.white12),
                const Column(
                  children: [
                    Text('1,286', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 16, fontWeight: FontWeight.w900)),
                    Text('Verified Vendors', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                Container(width: 1, height: 24, color: Colors.white12),
                const Column(
                  children: [
                    Text('7', style: TextStyle(color: AppColors.goldEmirates, fontSize: 16, fontWeight: FontWeight.w900)),
                    Text('GCC Countries', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Country Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: _countries.map((c) {
                final isSelected = c['code'] == _selectedCountryCode;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(c['label'] as String, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selectedColor: AppColors.accentCyan,
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(color: isSelected ? const Color(0xFF0B192C) : Colors.white70),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (val) => setState(() => _selectedCountryCode = c['code'] as String),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Authority Cards
          ...list.map((auth) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF151F32),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accentCyan.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                auth['abbr'] as String,
                                style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              auth['cat'] as String,
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            auth['status'] as String,
                            style: const TextStyle(color: AppColors.verifiedGreen, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      auth['nameEn'] as String,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      auth['nameAr'] as String,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      auth['scope'] as String,
                      style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '📜 Standard: ${auth['code']}',
                      style: const TextStyle(color: AppColors.goldEmirates, fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${auth['vendors']} Approved Vendors',
                          style: const TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.verified, size: 13, color: AppColors.accentCyan),
                          label: const Text('Compliance Audit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () => _showComplianceAuditDialog(auth),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. USER FILE MANAGER SCREEN (1:1 PARITY WITH UserFileManagerScreen.kt)
// ---------------------------------------------------------------------------

class UserFilesScreen extends StatefulWidget {
  const UserFilesScreen({super.key});

  @override
  State<UserFilesScreen> createState() => _UserFilesScreenState();
}

class _UserFilesScreenState extends State<UserFilesScreen> {
  String _selectedFilter = 'ALL';

  final List<Map<String, dynamic>> _files = [
    {
      'name': 'DBC_Structural_Foundation_Calculations_Rev3.pdf',
      'type': 'PDF',
      'size': '14.8 MB',
      'date': '2026-10-12 14:20',
      'encrypted': true,
      'category': 'Calculations & Permits',
    },
    {
      'name': 'Downtown_Tower_Level_14_HVAC_BIM_Coordination.dwg',
      'type': 'CAD',
      'size': '84.2 MB',
      'date': '2026-10-13 09:45',
      'encrypted': true,
      'category': 'CAD / BIM Models',
    },
    {
      'name': 'Concrete_C40_Cylinder_28Day_Compressive_Test_Report.pdf',
      'type': 'REPORTS',
      'size': '3.2 MB',
      'date': '2026-10-14 11:30',
      'encrypted': true,
      'category': 'QA/QC Inspection Reports',
    },
    {
      'name': 'Site_Drone_Photogrammetry_Excavation_Orthomosaic.jpg',
      'type': 'IMAGES',
      'size': '45.0 MB',
      'date': '2026-10-14 08:15',
      'encrypted': true,
      'category': 'Site Drone Imagery',
    },
    {
      'name': 'Dubai_Civil_Defence_Fire_Life_Safety_Approved_NOC.pdf',
      'type': 'PDF',
      'size': '6.4 MB',
      'date': '2026-10-11 16:00',
      'encrypted': true,
      'category': 'Authority NOCs',
    },
  ];

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.cloud_upload, color: AppColors.accentCyan, size: 22),
            SizedBox(width: 8),
            Text('Upload Document to Cloud', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3), style: BorderStyle.solid),
              ),
              child: const Column(
                children: [
                  Icon(Icons.insert_drive_file, color: AppColors.accentCyan, size: 36),
                  SizedBox(height: 8),
                  Text('Drag & Drop or Tap to Browse Files', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 4),
                  Text('Supports DWG, RVT, IFC, PDF, XLS, JPG (up to 500 MB)', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: const Color(0xFF0B192C)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(backgroundColor: AppColors.verifiedGreen, content: Text('File encrypted with AES-256 and uploaded to Firebase Storage!')),
              );
            },
            child: const Text('Start Encrypted Upload', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'ALL'
        ? _files
        : _files.where((f) => f['type'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Cloud File Storage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Secure file storage & metadata indexing via Firebase', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload, color: AppColors.accentCyan),
            onPressed: _showUploadDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          // Security Status Card
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock, color: AppColors.verifiedGreen, size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User Privacy & Security Rules Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Authenticated via Firebase UID: bh-usr-uae-2026', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Storage Quota Bar Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cloud Storage Quota', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('248.5 MB / 5.0 GB (5%)', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.05,
                  backgroundColor: const Color(0xFF1E293B),
                  color: AppColors.accentCyan,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _buildFilterChip('All Files (الكل)', 'ALL'),
                _buildFilterChip('PDF Permits', 'PDF'),
                _buildFilterChip('CAD / BIM', 'CAD'),
                _buildFilterChip('Inspection Reports', 'REPORTS'),
                _buildFilterChip('Site Images', 'IMAGES'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // File items
          ...filtered.map((file) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF151F32),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        file['type'] == 'CAD'
                            ? Icons.architecture
                            : file['type'] == 'IMAGES'
                                ? Icons.image
                                : Icons.picture_as_pdf,
                        color: file['type'] == 'CAD'
                            ? AppColors.goldEmirates
                            : file['type'] == 'IMAGES'
                                ? AppColors.accentCyan
                                : AppColors.criticalRed,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file['name'] as String,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${file['size']} • ${file['date']} • ${file['category']}',
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: AppColors.accentCyan, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${file['name']} from Firebase Storage...')),
                        );
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isSelected = _selectedFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selectedColor: AppColors.accentCyan,
        backgroundColor: const Color(0xFF1E293B),
        labelStyle: TextStyle(color: isSelected ? const Color(0xFF0B192C) : Colors.white70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (val) => setState(() => _selectedFilter = key),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. ENTERPRISE INTEGRATIONS & ERP (1:1 PARITY WITH EnterpriseIntegrationsScreen.kt)
// ---------------------------------------------------------------------------

class IntegrationsScreen extends StatelessWidget {
  const IntegrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final integrations = [
      {
        'title': 'Oracle Primavera P6 & MS Project',
        'status': 'Live Bi-directional Sync (12m ago)',
        'desc': 'Baseline schedule linked to daily site progress and earned value management (EVM).',
        'icon': Icons.sync,
        'color': AppColors.verifiedGreen,
        'btn': 'Sync Schedule Baselines',
      },
      {
        'title': 'WhatsApp Business API & Email-to-RFI',
        'status': 'Connected & Listening',
        'desc': 'Automated site engineer voice memo transcribing, RFI transmittal, and subcontractor dispatch.',
        'icon': Icons.chat,
        'color': const Color(0xFF25D366),
        'btn': 'Test Webhook & Bot',
      },
      {
        'title': 'SAP S/4HANA Construction ERP',
        'status': 'Active Enterprise Connector',
        'desc': 'Purchase orders, GRN verification, subcontractor retentions & 5% VAT invoice clearance.',
        'icon': Icons.business,
        'color': AppColors.accentCyan,
        'btn': 'Reconcile POs & Invoices',
      },
      {
        'title': 'Autodesk Construction Cloud (ACC / BIM 360)',
        'status': 'Linked Model Version 8',
        'desc': 'Live IFC / DWG federated 3D model synchronization with site progress camera markups.',
        'icon': Icons.architecture,
        'color': AppColors.goldEmirates,
        'btn': 'Fetch Latest BIM Revision',
      },
      {
        'title': 'Dubai Municipality e-Permits & RTA NOC Gateway',
        'status': 'Gov API Synchronized',
        'desc': 'Direct automated compliance queries, inspection requests, and completion certificates.',
        'icon': Icons.account_balance,
        'color': AppColors.verifiedGreen,
        'btn': 'Refresh Municipal Status',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enterprise Integrations Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Primavera P6, WhatsApp Business, SAP & Gov APIs', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: integrations.map((item) {
          final col = item['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: col.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'] as IconData, color: col, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(item['status'] as String, style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item['desc'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: AppColors.accentCyan,
                      side: BorderSide(color: AppColors.accentCyan.withValues(alpha: 0.3)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.verifiedGreen,
                          content: Text('${item['btn']} triggered successfully!'),
                        ),
                      );
                    },
                    child: Text(item['btn'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. ENTERPRISE REPORTS & AUDIT (1:1 PARITY WITH EnterpriseReportsAndAuditScreen.kt)
// ---------------------------------------------------------------------------

class ReportsAuditScreen extends StatelessWidget {
  const ReportsAuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      {
        'title': 'Executive Monthly Progress Report (September 2026)',
        'desc': 'Contains EVM (SPI 1.04, CPI 1.08), S-Curves, QA/QC summary, and HSE metrics.',
        'format': 'PDF • 18.4 MB',
        'hash': 'SHA-256: 8f4b...392a (Immutable Blockchain Audit)',
      },
      {
        'title': 'Commercial Audit & IPC Disbursement Log',
        'desc': 'Reconciled against project bank escrow account under Dubai RERA Law 8.',
        'format': 'Excel / PDF • 6.2 MB',
        'hash': 'SHA-256: 4a12...990f (Audited by KPMG UAE)',
      },
      {
        'title': 'Comprehensive Site Safety & OSHAD Compliance Audit',
        'desc': 'Zero LTI across 1,840,000 man-hours. Heat stress mitigation protocols active.',
        'format': 'PDF • 9.8 MB',
        'hash': 'SHA-256: d91c...bb31 (Verified by Dubai Civil Defence)',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Enterprise Reports & Audit Logs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: reports.map((rep) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        rep['title'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: AppColors.accentCyan),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${rep['title']}...')),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  rep['desc'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(rep['format'] as String, style: const TextStyle(color: AppColors.accentCyan, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(rep['hash'] as String, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. TECHNICAL SPECIFICATIONS & PETROLEUM (1:1 PARITY WITH TechnicalSpecificationsView.kt)
// ---------------------------------------------------------------------------

class PetroleumSpecsScreen extends StatefulWidget {
  const PetroleumSpecsScreen({super.key});

  @override
  State<PetroleumSpecsScreen> createState() => _PetroleumSpecsScreenState();
}

class _PetroleumSpecsScreenState extends State<PetroleumSpecsScreen> {
  String _selectedJurisdiction = 'ALL';

  final List<Map<String, dynamic>> _specs = [
    {
      'code': 'DBC-2023-CH4',
      'title': 'Dubai Building Code 2023: Structural Concrete & Durability',
      'jurisdiction': 'DUBAI',
      'scope': 'Mandatory cover, w/c ratio, micro-silica and slag replacement for coastal structures.',
      'authority': 'Dubai Municipality',
      'rev': '2023 Edition',
    },
    {
      'code': 'ADNOC-DGS-1300',
      'title': 'ADNOC Civil & Structural Engineering Standard DGS-1300',
      'jurisdiction': 'ADNOC',
      'scope': 'High-salinity coastal foundation, cathodic protection & oil terminal loading blast resilience.',
      'authority': 'Abu Dhabi National Oil Company',
      'rev': 'Rev 4 (Active)',
    },
    {
      'code': 'SAES-Q-001',
      'title': 'Saudi Aramco SAES-Q-001 Foundation & Concrete Structures',
      'jurisdiction': 'SAUDI',
      'scope': 'Durability design for severe sabkha ground conditions and sulfate-resisting cement.',
      'authority': 'Saudi Aramco',
      'rev': '2024 Release',
    },
    {
      'code': 'DEWA-CIV-REV7',
      'title': 'DEWA 132/11 kV Substation Civil & Blast Protection Spec',
      'jurisdiction': 'DUBAI',
      'scope': 'Transformer blast firewall specifications, cable basement dewatering & oil basin containment.',
      'authority': 'Dubai Electricity & Water Authority',
      'rev': 'Rev 7.2',
    },
    {
      'code': 'OSHAD-SF-CoP',
      'title': 'Abu Dhabi OSHAD Safety Code of Practice for Deep Excavation',
      'jurisdiction': 'FEDERAL',
      'scope': 'Mandatory shoring design validation, third-party instrumentation & worker welfare shelter.',
      'authority': 'Abu Dhabi OSHAD Centre',
      'rev': 'CoP 29.0',
    },
  ];

  void _showAiSpecAuditor(Map<String, dynamic> spec) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollCtrl) {
          return ListView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.accentCyan, size: 20),
                      SizedBox(width: 8),
                      Text('Gemini AI Spec Auditor', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 8),
              Text(spec['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Authority: ${spec['authority']} • Code: ${spec['code']}', style: const TextStyle(color: AppColors.accentCyan, fontSize: 11)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF081220),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.25)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Project Spec Audit Findings:', style: TextStyle(color: AppColors.accentCyan, fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text(
                      '1. Concrete Durability: Project C40/50 mix matches minimum 70mm clear cover required for coastal splash zones.\n'
                      '2. Cement Replacement: 60% GGBS slag replacement complies with Green Building mandatory regulations.\n'
                      '3. Testing Frequency: ASTM C39 compressive cubes required every 50 m³ poured.',
                      style: TextStyle(color: Colors.white, fontSize: 11, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedJurisdiction == 'ALL'
        ? _specs
        : _specs.where((s) => s['jurisdiction'] == _selectedJurisdiction).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Technical Specs & Engineering Standards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Dubai DBC 2023, ADNOC, Aramco & DEWA Codes', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _buildChip('All Specs', 'ALL'),
                _buildChip('Dubai DBC 2023', 'DUBAI'),
                _buildChip('Abu Dhabi / ADNOC', 'ADNOC'),
                _buildChip('Saudi Aramco', 'SAUDI'),
                _buildChip('Federal / OSHAD', 'FEDERAL'),
              ],
            ),
          ),

          ...filtered.map((spec) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF151F32),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            spec['code'] as String,
                            style: const TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(spec['rev'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      spec['title'] as String,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spec['scope'] as String,
                      style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Authority: ${spec['authority']}', style: const TextStyle(color: AppColors.goldEmirates, fontSize: 10, fontWeight: FontWeight.bold)),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.auto_awesome, size: 13, color: AppColors.accentCyan),
                          label: const Text('AI Auditor', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () => _showAiSpecAuditor(spec),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String key) {
    final isSelected = _selectedJurisdiction == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selectedColor: AppColors.accentCyan,
        backgroundColor: const Color(0xFF1E293B),
        labelStyle: TextStyle(color: isSelected ? const Color(0xFF0B192C) : Colors.white70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (val) => setState(() => _selectedJurisdiction = key),
      ),
    );
  }
}

class SpecsScreen extends StatelessWidget {
  const SpecsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PetroleumSpecsScreen();
}

// ---------------------------------------------------------------------------
// 11. AUTH & CLOUD SYNC SCREENS (1:1 PARITY WITH FirebaseCloudSyncScreen.kt)
// ---------------------------------------------------------------------------

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Corporate SSO & Identity Matrix'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_person, size: 48, color: AppColors.accentCyan),
              ),
              const SizedBox(height: 20),
              const Text('Orion B Enterprise Authentication', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text('Active Session: Eng. Abdelfattah\nProject Director (Authority Level: Gate 0-12)', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.4)),
                ),
                child: const Text('BIOMETRIC & AES-256 ACTIVE', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CloudSyncScreen extends StatefulWidget {
  const CloudSyncScreen({super.key});

  @override
  State<CloudSyncScreen> createState() => _CloudSyncScreenState();
}

class _CloudSyncScreenState extends State<CloudSyncScreen> {
  bool _isSyncing = false;

  final List<Map<String, dynamic>> _collections = [
    {'name': 'projects', 'records': 14, 'status': 'Synced', 'color': AppColors.verifiedGreen},
    {'name': 'daily_reports', 'records': 186, 'status': 'Synced', 'color': AppColors.verifiedGreen},
    {'name': 'rfi_transmittals', 'records': 42, 'status': 'Synced', 'color': AppColors.verifiedGreen},
    {'name': 'site_photos_gps', 'records': 1240, 'status': 'Synced', 'color': AppColors.verifiedGreen},
    {'name': 'material_inspections', 'records': 88, 'status': 'Synced', 'color': AppColors.verifiedGreen},
  ];

  void _triggerManualSync() async {
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.verifiedGreen,
          content: Text('✓ All project documents, RFIs, and photos synced to Firebase Firestore!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Firebase Cloud Sync Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Connected to cloud.buildhub.ae', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentCyan))
                : const Icon(Icons.refresh, color: AppColors.accentCyan),
            onPressed: _isSyncing ? null : _triggerManualSync,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Main Connection Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF151F32),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan, width: 1.5),
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
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.verifiedGreen.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_circle, color: AppColors.verifiedGreen, size: 22),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cloud Account Connected', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('cloud.buildhub.ae', style: TextStyle(color: AppColors.accentCyan, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('ACTIVE', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Firestore Database ID:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    Text('buildhub-prod-uae-db', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Last Successful Sync:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    Text('Just now (Real-time stream)', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      foregroundColor: const Color(0xFF0B192C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.sync, size: 16),
                    label: const Text('Force Sync All to Firebase', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _isSyncing ? null : _triggerManualSync,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Collections Telemetry
          const Text('Synchronized Collections Telemetry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          ..._collections.map((col) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF151F32),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.folder_shared, color: AppColors.accentCyan, size: 18),
                        const SizedBox(width: 8),
                        Text(col['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${col['records']} records', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(col['status'] as String, style: const TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 9)),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 12. REPORT REVIEW SCREEN & DRAWING PIN RECORD SCREEN (RETAINED)
// ---------------------------------------------------------------------------

class ReportWarning {
  final String message;
  final bool blocking;
  const ReportWarning({required this.message, this.blocking = false});
}

class ReportLine {
  final String text;
  final double confidence;
  final bool aiGenerated;
  const ReportLine({
    required this.text,
    this.confidence = 1.0,
    this.aiGenerated = false,
  });
}

class ReportReviewScreen extends StatelessWidget {
  final String date;
  final String status;
  final List<ReportWarning> warnings;
  final List<ReportLine> lines;
  final VoidCallback? onSign;
  final VoidCallback? onBack;
  const ReportReviewScreen({
    super.key,
    this.date = '',
    this.status = 'DRAFT',
    this.warnings = const [],
    this.lines = const [],
    this.onSign,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final blocked = warnings.any((w) => w.blocking);
    return Scaffold(
      appBar: AppBar(
        leading: onBack == null ? null : IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
        title: Text(loc.t('docs.review_title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${loc.t('docs.review_date')} $date | ${loc.t('docs.review_status')} $status'),
          if (warnings.isNotEmpty)
            Card(
              color: Colors.amber.withValues(alpha: 0.15),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: warnings.map((w) => Text('⚠️ ${w.message}')).toList()),
              ),
            ),
          const SizedBox(height: 8),
          Text(loc.t('docs.review_lines'), style: Theme.of(context).textTheme.titleSmall),
          ...lines.map((l) => Card(
                color: l.confidence < 0.7 ? Colors.amber.withValues(alpha: 0.12) : null,
                child: ListTile(
                  title: Text(l.text),
                  subtitle: Row(children: [
                    if (l.aiGenerated) const Chip(label: Text('AI'), visualDensity: VisualDensity.compact),
                    if (l.confidence < 0.7) Chip(label: Text(loc.t('docs.review_low_conf')), visualDensity: VisualDensity.compact),
                  ]),
                ),
              )),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: blocked ? null : onSign,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(loc.t('docs.review_sign')),
          ),
        ],
      ),
    );
  }
}

class DrawingPin {
  final String id;
  final String title;
  final String type;
  final String status;
  final double xRatio;
  final double yRatio;
  final String discipline;
  const DrawingPin({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.xRatio,
    required this.yRatio,
    this.discipline = '',
  });
}

class DrawingPinRecordScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const DrawingPinRecordScreen({super.key, this.onBack});
  @override
  State<DrawingPinRecordScreen> createState() => _DrawingPinRecordScreenState();
}

class _DrawingPinRecordScreenState extends State<DrawingPinRecordScreen> {
  static const _seed = [
    DrawingPin(id: 'RFI-042', title: 'RFI-042', type: 'RFI', status: 'OPEN', xRatio: 0.3, yRatio: 0.4, discipline: 'Structural'),
    DrawingPin(id: 'SNAG-102', title: 'SNAG-102', type: 'SNAG', status: 'OPEN', xRatio: 0.6, yRatio: 0.3, discipline: 'Finishing'),
    DrawingPin(id: 'NCR-005', title: 'NCR-005', type: 'NCR', status: 'OPEN', xRatio: 0.5, yRatio: 0.7, discipline: 'Concrete'),
    DrawingPin(id: 'RFI-043', title: 'RFI-043', type: 'RFI', status: 'CLOSED', xRatio: 0.75, yRatio: 0.6, discipline: 'Facade'),
  ];

  String _filter = 'ALL';
  String? _selectedId;
  final List<DrawingPin> _pins = List.of(_seed);

  Color _pinColor(String type) => switch (type) {
        'RFI' => Colors.cyan,
        'SNAG' => Colors.amber,
        'NCR' => Colors.red,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final visible = _filter == 'ALL' ? _pins : _pins.where((p) => p.type == _filter).toList();
    final selected = visible.where((p) => p.id == _selectedId).firstOrNull;
    return Scaffold(
      appBar: AppBar(
        leading: widget.onBack == null ? null : IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
        title: Text(loc.t('docs.pin_title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(loc.t('docs.pin_plan')),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['ALL', 'RFI', 'SNAG', 'NCR']
                  .map((f) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 6),
                        child: ChoiceChip(label: Text(f), selected: _filter == f, onSelected: (_) => setState(() => _filter = f)),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (ctx, constraints) {
            final w = constraints.maxWidth;
            const h = 280.0;
            return GestureDetector(
              onTapDown: (d) {
                final dx = (d.localPosition.dx / w).clamp(0.0, 1.0);
                final dy = (d.localPosition.dy / h).clamp(0.0, 1.0);
                setState(() {
                  final id = 'PIN-${_pins.length + 1}';
                  _pins.add(DrawingPin(id: id, title: id, type: 'RFI', status: 'OPEN', xRatio: dx, yRatio: dy));
                  _selectedId = id;
                });
              },
              child: SizedBox(
                width: w,
                height: h,
                child: Stack(children: [
                  CustomPaint(size: Size(w, h), painter: const _CadGrid()),
                  for (final p in visible)
                    Positioned(
                      left: p.xRatio * w - 12,
                      top: p.yRatio * h - 12,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedId = p.id),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: _pinColor(p.type),
                          child: Text(p.type.characters.first, style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ),
                    ),
                ]),
              ),
            );
          }),
          const SizedBox(height: 8),
          if (selected != null)
            Card(
              child: ListTile(
                title: Text(selected.title),
                subtitle: Text('${loc.t('docs.pin_type')} ${selected.type} | ${selected.discipline}'),
                trailing: Text('${loc.t('docs.pin_status')} ${selected.status}'),
              ),
            )
          else
            Text('${loc.t('docs.pin_all')} (${visible.length})'),
          ...visible.map((p) => ListTile(
                leading: CircleAvatar(backgroundColor: _pinColor(p.type), child: Text(p.type.characters.first)),
                title: Text(p.title),
                subtitle: Text(p.discipline),
                onTap: () => setState(() => _selectedId = p.id),
              )),
        ],
      ),
    );
  }
}

class _CadGrid extends CustomPainter {
  const _CadGrid();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRect(Offset.zero & size, bg);
    final grid = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      final x = size.width * i / 5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
