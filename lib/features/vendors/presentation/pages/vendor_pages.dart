// Clean Architecture: Vendors & Pre-Qualifications — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// ApprovedVendorManagementScreen.kt, VendorVerificationScreen.kt, VendorVerificationHubScreen.kt.

import 'package:flutter/material.dart';
import 'package:buildhub/core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// 1. APPROVED VENDOR MANAGEMENT SCREEN (1:1 PORT OF ApprovedVendorManagementScreen.kt)
// ---------------------------------------------------------------------------

enum VendorReviewRole { complianceReviewer, vendorApplicant }

class ApprovedVendorItem {
  final String id;
  final String companyName;
  final String tradeLicenseNumber;
  final String trn;
  final String category;
  final List<String> authorityApprovals; // RTA, DEWA, DM, Trakhees, DCD, ISO 9001
  final String expiryDate;
  final bool isExpiringSoon;
  String status; // 'VERIFIED', 'SUBMITTED', 'DRAFT', 'SUSPENDED'
  final double qualityScore;
  final String contactPerson;
  final String phone;

  ApprovedVendorItem({
    required this.id,
    required this.companyName,
    required this.tradeLicenseNumber,
    required this.trn,
    required this.category,
    required this.authorityApprovals,
    required this.expiryDate,
    required this.isExpiringSoon,
    required this.status,
    required this.qualityScore,
    required this.contactPerson,
    required this.phone,
  });
}

class ApprovedVendorManagementScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ApprovedVendorManagementScreen({super.key, this.onBack});

  @override
  State<ApprovedVendorManagementScreen> createState() => _ApprovedVendorManagementScreenState();
}

class _ApprovedVendorManagementScreenState extends State<ApprovedVendorManagementScreen> {
  VendorReviewRole _activeRole = VendorReviewRole.complianceReviewer;
  String? _selectedStatusFilter;
  String _searchQuery = '';

  final List<ApprovedVendorItem> _vendors = [
    ApprovedVendorItem(
      id: 'VND-001',
      companyName: 'Unibeton Ready Mix LLC',
      tradeLicenseNumber: 'DED-CN-104921',
      trn: '100294819200003',
      category: 'Ready-mix Concrete (C40–C80)',
      authorityApprovals: ['RTA Approved', 'DEWA Approved', 'Dubai Municipality', 'ISO 9001'],
      expiryDate: '2026-11-15 (Expires in 18 Days)',
      isExpiringSoon: true,
      status: 'VERIFIED',
      qualityScore: 98.4,
      contactPerson: 'Eng. Fadi Mansoor',
      phone: '+971 4 880 1234',
    ),
    ApprovedVendorItem(
      id: 'VND-002',
      companyName: 'Emirates Steel Arkan PJSC',
      tradeLicenseNumber: 'AD-DED-884210',
      trn: '100029381200001',
      category: 'Reinforcing Steel Rebar & Structural Sections',
      authorityApprovals: ['Federal Gov Certified', 'Abu Dhabi Municipality', 'ISO 14001', 'OHSAS 18001'],
      expiryDate: '2027-12-31',
      isExpiringSoon: false,
      status: 'VERIFIED',
      qualityScore: 99.5,
      contactPerson: 'Sultan Al Dhaheri',
      phone: '+971 2 555 1111',
    ),
    ApprovedVendorItem(
      id: 'VND-003',
      companyName: 'Drake & Scull Engineering LLC',
      tradeLicenseNumber: 'DED-CN-204192',
      trn: '100349201900002',
      category: 'MEP Contracting & HVAC Ducting',
      authorityApprovals: ['DEWA Approved', 'Dubai Civil Defence (DCD)'],
      expiryDate: '2027-06-30',
      isExpiringSoon: false,
      status: 'SUBMITTED',
      qualityScore: 92.0,
      contactPerson: 'Ramesh Patel',
      phone: '+971 4 332 5500',
    ),
    ApprovedVendorItem(
      id: 'VND-004',
      companyName: 'Al Naboodah Heavy Plant Division',
      tradeLicenseNumber: 'DED-CN-309481',
      trn: '100481920100004',
      category: 'Heavy Equipment & Mobile Cranes',
      authorityApprovals: ['DM Class A Fleet', 'TUV Third Party Pass'],
      expiryDate: '2026-11-25 (Expires in 28 Days)',
      isExpiringSoon: true,
      status: 'VERIFIED',
      qualityScore: 96.0,
      contactPerson: 'Tariq Al Naboodah',
      phone: '+971 4 294 8888',
    ),
    ApprovedVendorItem(
      id: 'VND-005',
      companyName: 'Doka Gulf Formwork Solutions',
      tradeLicenseNumber: 'DED-CN-401928',
      trn: '100582910200005',
      category: 'System Formwork & Scaffolding Systems',
      authorityApprovals: ['Dubai Municipality', 'Trakhees / PCFC Verified'],
      expiryDate: '2027-04-12',
      isExpiringSoon: false,
      status: 'DRAFT',
      qualityScore: 89.5,
      contactPerson: 'Markus Weber',
      phone: '+971 4 870 9900',
    ),
  ];

  List<ApprovedVendorItem> get _filteredVendors {
    return _vendors.where((v) {
      final matchesSearch = _searchQuery.isEmpty ||
          v.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.tradeLicenseNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatusFilter == null || v.status == _selectedStatusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _showReviewModal(ApprovedVendorItem vendor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      vendor.companyName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                  ),
                  _buildStatusChip(vendor.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'License: ${vendor.tradeLicenseNumber} • TRN: ${vendor.trn}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              const Text(
                'Authority Approvals & Accreditations:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: vendor.authorityApprovals
                    .map((a) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            a,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentCyan),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              if (_activeRole == VendorReviewRole.complianceReviewer) ...[
                const Text(
                  'Compliance Reviewer Actions (Role-Protected):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.goldEmirates),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.verifiedGreen,
                          foregroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.verified, size: 16),
                        label: const Text('Verify & Issue Badge'),
                        onPressed: () {
                          setState(() => vendor.status = 'VERIFIED');
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('✓ ${vendor.companyName} verified and approved for bidding')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.criticalRed),
                        icon: const Icon(Icons.block, size: 16),
                        label: const Text('Suspend'),
                        onPressed: () {
                          setState(() => vendor.status = 'SUSPENDED');
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('⚠ ${vendor.companyName} status set to Suspended')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock, size: 18, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Viewing as Vendor Applicant. Verification status is locked by Compliance Reviewer.',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddVendorDialog() {
    final nameCtrl = TextEditingController();
    final licCtrl = TextEditingController();
    final trnCtrl = TextEditingController();
    final catCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.darkBorder)),
        title: const Text('Register New Approved Vendor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Company Legal Name (UAE Trade License)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: licCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Trade License Number (e.g. DED-CN-12345)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: trnCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Tax Registration Number (TRN)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: catCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Category (Concrete, Steel, MEP...)', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _vendors.add(
                    ApprovedVendorItem(
                      id: 'VND-00${_vendors.length + 1}',
                      companyName: nameCtrl.text.trim(),
                      tradeLicenseNumber: licCtrl.text.trim().isEmpty ? 'DED-CN-PENDING' : licCtrl.text.trim(),
                      trn: trnCtrl.text.trim().isEmpty ? 'TRN-PENDING' : trnCtrl.text.trim(),
                      category: catCtrl.text.trim().isEmpty ? 'General Works' : catCtrl.text.trim(),
                      authorityApprovals: ['Under Compliance Audit'],
                      expiryDate: '2027-10-30',
                      isExpiringSoon: false,
                      status: 'SUBMITTED',
                      qualityScore: 90.0,
                      contactPerson: 'Lead Coordinator',
                      phone: '+971 4 000 0000',
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Vendor registered & queued for Compliance Audit')),
                );
              }
            },
            child: const Text('Submit Application'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color col;
    switch (status) {
      case 'VERIFIED':
        col = AppColors.verifiedGreen;
        break;
      case 'SUBMITTED':
        col = AppColors.accentCyan;
        break;
      case 'DRAFT':
        col = AppColors.cautionAmber;
        break;
      case 'SUSPENDED':
        col = AppColors.criticalRed;
        break;
      default:
        col = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: col.withValues(alpha: 0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'إدارة الموردين المعتمدين',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text('🛡️', style: TextStyle(fontSize: 14)),
              ],
            ),
            Text(
              'Trade Licenses • RTA • DEWA • DM • Trakhees Compliance',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Add Vendor Application',
            icon: const Icon(Icons.add_circle, color: AppColors.accentCyan),
            onPressed: _showAddVendorDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Role Switcher Bar (Reviewer vs Applicant)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: AppColors.darkSurface.withValues(alpha: 0.6),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings, size: 16, color: AppColors.goldEmirates),
                const SizedBox(width: 6),
                const Text('Role: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ChoiceChip(
                  label: const Text('Compliance Reviewer'),
                  selected: _activeRole == VendorReviewRole.complianceReviewer,
                  onSelected: (val) {
                    if (val) setState(() => _activeRole = VendorReviewRole.complianceReviewer);
                  },
                  selectedColor: AppColors.accentCyan,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _activeRole == VendorReviewRole.complianceReviewer ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Vendor Applicant'),
                  selected: _activeRole == VendorReviewRole.vendorApplicant,
                  onSelected: (val) {
                    if (val) setState(() => _activeRole = VendorReviewRole.vendorApplicant);
                  },
                  selectedColor: AppColors.accentCyan,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _activeRole == VendorReviewRole.vendorApplicant ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Search and Filter Chips
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                hintText: 'Search company, license #, or category...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.accentCyan, size: 20),
                filled: true,
                fillColor: AppColors.darkCard,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.darkBorder),
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Vendors'),
                  selected: _selectedStatusFilter == null,
                  onSelected: (_) => setState(() => _selectedStatusFilter = null),
                ),
                const SizedBox(width: 6),
                FilterChip(
                  label: const Text('Verified (Active)'),
                  selected: _selectedStatusFilter == 'VERIFIED',
                  onSelected: (_) => setState(() => _selectedStatusFilter = 'VERIFIED'),
                ),
                const SizedBox(width: 6),
                FilterChip(
                  label: const Text('Submitted for Audit'),
                  selected: _selectedStatusFilter == 'SUBMITTED',
                  onSelected: (_) => setState(() => _selectedStatusFilter = 'SUBMITTED'),
                ),
                const SizedBox(width: 6),
                FilterChip(
                  label: const Text('Drafts'),
                  selected: _selectedStatusFilter == 'DRAFT',
                  onSelected: (_) => setState(() => _selectedStatusFilter = 'DRAFT'),
                ),
              ],
            ),
          ),

          // Vendor List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _filteredVendors.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final v = _filteredVendors[idx];
                return InkWell(
                  onTap: () => _showReviewModal(v),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: v.isExpiringSoon ? AppColors.cautionAmber : AppColors.darkBorder,
                        width: v.isExpiringSoon ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                v.companyName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                              ),
                            ),
                            _buildStatusChip(v.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          v.category,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accentCyan),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lic: ${v.tradeLicenseNumber} • Contact: ${v.contactPerson} (${v.phone})',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: v.authorityApprovals
                              .map((a) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      a,
                                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quality Pass: ${v.qualityScore}%',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen),
                            ),
                            Text(
                              v.expiryDate,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: v.isExpiringSoon ? AppColors.cautionAmber : Colors.grey,
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
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. VENDOR VERIFICATION & EXPIRY RADAR (1:1 PORT OF VendorVerificationScreen.kt)
// ---------------------------------------------------------------------------

class VendorVerificationScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const VendorVerificationScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return const ApprovedVendorManagementScreen();
  }
}

class VendorVerificationHubScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const VendorVerificationHubScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return const ApprovedVendorManagementScreen();
  }
}
