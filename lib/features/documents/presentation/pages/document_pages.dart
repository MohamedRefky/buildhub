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

class _VaultScreenState extends State<VaultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _credentials = [
    {'title': 'Trade License', 'sub': 'DED-2019-884721', 'detail': 'Commercial Construction & Contracting', 'status': 'Valid until Dec 2026', 'icon': Icons.business, 'col': AppColors.accentCyan},
    {'title': 'TRN Number (5% VAT)', 'sub': '100485219100003', 'detail': 'UAE Federal Tax Authority Registered', 'status': 'Active Tax Reg', 'icon': Icons.receipt_long, 'col': AppColors.goldEmirates},
    {'title': 'ISO 9001:2015 Quality Mgmt', 'sub': 'BSI-QA-99021', 'detail': 'Certified Quality Management System', 'status': 'Valid until Mar 2027', 'icon': Icons.verified, 'col': AppColors.verifiedGreen},
    {'title': 'Dubai Municipality Approval', 'sub': 'Class A Contractor', 'detail': 'Unlimited Height & Civil Authorization', 'status': 'Active DM License', 'icon': Icons.engineering, 'col': Colors.purpleAccent},
    {'title': 'Bank Escrow Project Account', 'sub': 'ENBD –––– 4821', 'detail': 'Corporate Escrow Account (Dubai Law No. 8)', 'status': 'AED Escrow Active', 'icon': Icons.account_balance, 'col': AppColors.accentCyan},
  ];

  final List<Map<String, dynamic>> _members = [
    {'name': 'Eng. Abdelfattah', 'role': 'Project Director', 'type': 'Admin', 'project': 'Marina Tower', 'phone': '+971 50 111 2233'},
    {'name': 'Eng. Tariq Al-Mansoor', 'role': 'Lead Consultant (Dar Al-Handasah)', 'type': 'Consultant', 'project': 'Marina Tower', 'phone': '+971 50 222 3344'},
    {'name': 'Eng. Sara Ali', 'role': 'Senior QA/QC Manager', 'type': 'Engineer', 'project': 'Marina Tower', 'phone': '+971 50 333 4455'},
    {'name': 'Rajiv Kumar', 'role': 'MEP Project Coordinator', 'type': 'Field', 'project': 'Marina Tower', 'phone': '+971 50 444 5566'},
    {'name': 'Ali Hassan', 'role': 'Chief Safety HSE Officer', 'type': 'Safety', 'project': 'Marina Tower', 'phone': '+971 50 555 6677'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Vault & Credentials', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('Legal Licenses • Escrow • ISO • Authority Matrix', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentCyan,
          tabs: const [
            Tab(text: 'Company Credentials'),
            Tab(text: 'Team Members & Roles'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Credentials tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._credentials.map((c) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (c['col'] as Color).withValues(alpha: 0.15),
                        child: Icon(c['icon'] as IconData, color: c['col'] as Color),
                      ),
                      title: Text(c['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('${c['sub']} • ${c['detail']}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: (c['col'] as Color).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                        child: Text(c['status'] as String, style: TextStyle(color: c['col'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )),
            ],
          ),
          // Team members tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._members.map((m) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.white10, child: Icon(Icons.person, color: AppColors.accentCyan)),
                      title: Text(m['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('${m['role']} • ${m['project']}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                        child: Text(m['type'] as String, style: const TextStyle(color: AppColors.verifiedGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. RFI SUBMITTALS & TRACKER SCREEN
// ---------------------------------------------------------------------------

class RfiScreen extends StatelessWidget {
  const RfiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rfis = [
      {
        'no': 'RFI-2026-088',
        'title': 'Chilled water pipe clash at corridor ceiling axis F4',
        'disc': 'MEP / Architectural',
        'code': 'CODE B (Approved with Comments)',
        'sla': 'Turnaround: 3 Days (SLA Met)',
        'status': 'RESOLVED',
        'color': AppColors.verifiedGreen,
      },
      {
        'no': 'RFI-2026-089',
        'title': 'Additional rebar cover at cantilever balcony slab',
        'disc': 'Structural',
        'code': 'CODE A (Approved Without Comments)',
        'sla': 'Turnaround: 1 Day',
        'status': 'CLOSED',
        'color': AppColors.verifiedGreen,
      },
      {
        'no': 'RFI-2026-090',
        'title': 'Façade bracket anchor pull-out test load verification',
        'disc': 'Façade / Structural',
        'code': 'UNDER CONSULTANT REVIEW',
        'sla': 'SLA Deadline: In 24 Hours',
        'status': 'PENDING',
        'color': AppColors.cautionAmber,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('RFI & Technical Submittals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.accentCyan),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening AI RFI Generator')));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...rfis.map((rfi) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(rfi['no'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: (rfi['color'] as Color).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                            child: Text(rfi['status'] as String, style: TextStyle(color: rfi['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(rfi['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text('${rfi['disc']} • ${rfi['code']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(rfi['sla'] as String, style: const TextStyle(fontSize: 10, color: AppColors.accentCyan)),
                    ],
                  ),
                ),
              )),
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
// 5. TRAINING COURSES SCREEN
// ---------------------------------------------------------------------------

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {'title': 'Advanced Structural Post-Tensioning', 'inst': 'Dubai Engineering College', 'weeks': 8, 'students': 342, 'rating': 4.8, 'fee': 'AED 2,500'},
      {'title': 'MEP Systems Design & BIM Integration', 'inst': 'Emirates Technical Institute', 'weeks': 12, 'students': 289, 'rating': 4.9, 'fee': 'AED 3,200'},
      {'title': 'Project Management Professional (PMP) Construction', 'inst': 'Global PM Institute', 'weeks': 6, 'students': 412, 'rating': 4.7, 'fee': 'AED 1,850'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Professional Training & CPD')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...courses.map((c) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 6),
                      Text('${c['inst']} • ${c['weeks']} Weeks', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(c['fee'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                            onPressed: () {},
                            child: const Text('Enroll Now'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. GCC AUTHORITIES HUB SCREEN
// ---------------------------------------------------------------------------

class GccAuthoritiesHubScreen extends StatelessWidget {
  const GccAuthoritiesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authorities = [
      {'name': 'Dubai Municipality (DM)', 'role': 'Building Permits, NOCs & Final Completion Certificate', 'status': 'Connected (API Live)', 'col': AppColors.verifiedGreen},
      {'name': 'Roads & Transport Authority (RTA)', 'role': 'Right of Way (ROW) Permits & Traffic NOC', 'status': 'Connected (API Live)', 'col': AppColors.verifiedGreen},
      {'name': 'Dubai Electricity & Water Authority (DEWA)', 'role': 'Temporary Power Connection & Substation Approvals', 'status': 'Connected', 'col': AppColors.verifiedGreen},
      {'name': 'Dubai Civil Defense (DCD)', 'role': 'Fire & Life Safety Drawing Approvals', 'status': 'Inspection Scheduled', 'col': AppColors.cautionAmber},
      {'name': 'Trakhees / PCFC', 'role': 'Freezone Development Planning & Safety Permits', 'status': 'Compliant', 'col': AppColors.verifiedGreen},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('GCC Regulatory Authorities Hub')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...authorities.map((a) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (a['col'] as Color).withValues(alpha: 0.15),
                    child: Icon(Icons.account_balance, color: a['col'] as Color),
                  ),
                  title: Text(a['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(a['role'] as String),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: (a['col'] as Color).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(a['status'] as String, style: TextStyle(color: a['col'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. USER FILE MANAGER SCREEN
// ---------------------------------------------------------------------------

class UserFilesScreen extends StatelessWidget {
  const UserFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project File Manager & Documents')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _folder('01_Approved_Contract_Drawings', '48 Files • 240 MB'),
          _folder('02_Consultant_RFI_Transmittals', '92 Files • 85 MB'),
          _folder('03_Site_Daily_Photos_GPS', '342 Files • 1.2 GB'),
          _folder('04_Quality_MIR_Slump_Certificates', '120 Files • 95 MB'),
          _folder('05_Commercial_IPCs_Tax_Invoices', '24 Files • 45 MB'),
        ],
      ),
    );
  }

  Widget _folder(String name, String sub) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.folder, color: AppColors.goldEmirates),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. ENTERPRISE INTEGRATIONS & ERP
// ---------------------------------------------------------------------------

class IntegrationsScreen extends StatelessWidget {
  const IntegrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final integrations = [
      {'name': 'Oracle Primavera P6', 'desc': 'Schedule & baseline synchronizer', 'status': 'Connected'},
      {'name': 'SAP S/4HANA Construction', 'desc': 'ERP purchase orders & vendor ledger', 'status': 'Connected'},
      {'name': 'Autodesk Construction Cloud (ACC)', 'desc': 'BIM 360 models & drawing transmittals', 'status': 'Active'},
      {'name': 'Procore Technologies', 'desc': 'Submittals & site punch-list sync', 'status': 'Standby'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Enterprise ERP & Cloud Integrations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...integrations.map((i) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.cable, color: AppColors.accentCyan),
                  title: Text(i['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(i['desc']!),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(i['status']!, style: const TextStyle(color: AppColors.verifiedGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. ENTERPRISE REPORTS & AUDIT
// ---------------------------------------------------------------------------

class ReportsAuditScreen extends StatelessWidget {
  const ReportsAuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enterprise Reports & Audit Logs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: AppColors.criticalRed),
              title: const Text('Executive Monthly Progress Report (September 2026)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Contains EVM, S-Curves, QA/QC summary & HSE metrics'),
              trailing: const Icon(Icons.download),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.table_chart, color: AppColors.verifiedGreen),
              title: const Text('Commercial Audit & IPC Disbursement Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Reconciled against bank escrow accounts'),
              trailing: const Icon(Icons.download),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. TECHNICAL SPECIFICATIONS & PETROLEUM
// ---------------------------------------------------------------------------

class PetroleumSpecsScreen extends StatelessWidget {
  const PetroleumSpecsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final specs = [
      {'title': 'ADNOC Civil & Structural Engineering Standard DGS-1300', 'sub': 'High-salinity coastal foundation & cathodic protection'},
      {'title': 'Saudi Aramco SAES-Q-001 Foundation & Concrete Structures', 'sub': 'Durability design for severe ground conditions'},
      {'title': 'Epoxy Coated Rebar & Corrosion Inhibitor Standards', 'sub': 'ASTM A775 / BS 4449 marine environment requirements'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ADNOC & Petroleum Technical Specs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...specs.map((s) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.oil_barrel, color: AppColors.goldEmirates),
                  title: Text(s['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(s['sub']!),
                ),
              )),
        ],
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
// 11. AUTH & CLOUD SYNC SCREENS
// ---------------------------------------------------------------------------

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Corporate SSO & Identity')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: AppColors.accentCyan),
              const SizedBox(height: 16),
              const Text('Orion B Enterprise Authentication', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Signed in as Eng. Abdelfattah (Project Director)\nRole: Full Project Authority Matrix', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class CloudSyncScreen extends StatelessWidget {
  const CloudSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Cloud & Storage Sync')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_done, size: 80, color: AppColors.verifiedGreen),
            const SizedBox(height: 16),
            const Text('Cloud Storage Connected', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text('Real-time listeners active on project /projects/proj-01', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
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
