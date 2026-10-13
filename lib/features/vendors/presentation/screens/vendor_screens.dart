// Clean Architecture: Vendors — Presentation.
// Covers Kotlin: VendorVerificationScreen, VendorVerificationHubScreen,
// ApprovedVendorManagementScreen, SuppliersCompaniesDirectoryScreen,
// GCCAuthoritiesHubScreen, GccTendersAiScreen.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/vendors/data/vendors_repository.dart';

class _Shell extends StatelessWidget {
  final String ar;
  final String en;
  final Widget child;
  const _Shell({required this.ar, required this.en, required this.child});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.tr(ar, en))),
      body: child,
    );
  }
}

class VendorVerificationScreen extends StatelessWidget {
  const VendorVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<VendorsRepository>();
    return _Shell(
      ar: 'توثيق الموردين', en: 'Vendor Verification',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: repo.vendors.map((v) => Card(
          child: ListTile(
            title: Text(loc.tr(v.companyNameAr.isEmpty ? v.companyName : v.companyNameAr, v.companyName)),
            subtitle: Text('${v.category} • ${v.tradeLicenseNumber}'),
            trailing: Icon(
              v.isVerified ? Icons.verified : Icons.pending,
              color: v.isVerified ? Colors.green : Colors.amber,
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class VendorVerificationHubScreen extends StatelessWidget {
  const VendorVerificationHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const VendorVerificationScreen();
  }
}

class ApprovedVendorManagementScreen extends StatelessWidget {
  const ApprovedVendorManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<VendorsRepository>();
    return _Shell(
      ar: 'إدارة الموردين المعتمدين', en: 'Approved Vendors',
      child: ListView(
        children: repo.vendors.map((v) => SwitchListTile(
          title: Text(loc.tr(v.companyNameAr.isEmpty ? v.companyName : v.companyNameAr, v.companyName)),
          subtitle: Text(v.status.name),
          value: v.isVerified,
          onChanged: (val) => repo.setVerified(v.id, val),
        )).toList(),
      ),
    );
  }
}

class SuppliersDirectoryScreen extends StatelessWidget {
  const SuppliersDirectoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Shell(
      ar: 'دليل الموردين والشركات', en: 'Suppliers Directory',
      child: Center(child: Text(loc.tr('اربط Firestore مجموعة vendors', 'Wire Firestore vendors collection'))),
    );
  }
}

class GccAuthoritiesHubScreen extends StatelessWidget {
  const GccAuthoritiesHubScreen({super.key});
  static const authorities = [
    ('بلدية دبي', 'Dubai Municipality'),
    ('هيئة الطرق والمواصلات', 'RTA'),
    ('هيئة كهرباء ومياه دبي', 'DEWA'),
    ('الدفاع المدني', 'Civil Defense'),
  ];
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Shell(
      ar: 'بوابة الجهات الحكومية', en: 'Authorities Hub',
      child: ListView(
        children: authorities.map((a) => ListTile(
          leading: const Icon(Icons.account_balance),
          title: Text(loc.tr(a.$1, a.$2)),
        )).toList(),
      ),
    );
  }
}

class GccTendersScreen extends StatelessWidget {
  const GccTendersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Shell(
      ar: 'مناقصات الخليج بالذكاء الاصطناعي', en: 'GCC Tenders AI',
      child: Center(child: Text(loc.tr('لا مناقصات — فعّل المزامنة', 'No tenders — enable sync'))),
    );
  }
}
