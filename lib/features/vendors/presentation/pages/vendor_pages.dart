// Clean Architecture: Vendors — Presentation.
// Covers Kotlin: VendorVerificationScreen, VendorVerificationHubScreen,
// ApprovedVendorManagementScreen, SuppliersCompaniesDirectoryScreen,
// GCCAuthoritiesHubScreen, GccTendersAiScreen.
// Titles resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/vendors/data/repositories/vendors_repository.dart';
import 'package:buildhub/features/vendors/domain/entities/vendor_entities.dart';

String _statusKey(ApprovedVendorStatus s) => switch (s) {
      ApprovedVendorStatus.draft => 'ven.status_draft',
      ApprovedVendorStatus.submitted => 'ven.status_submitted',
      ApprovedVendorStatus.verified => 'ven.status_verified',
      ApprovedVendorStatus.rejected => 'ven.status_rejected',
    };

class _Shell extends StatelessWidget {
  final String titleKey;
  final Widget child;
  const _Shell({required this.titleKey, required this.child});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t(titleKey))),
      body: child,
    );
  }
}

class VendorVerificationScreen extends StatelessWidget {
  const VendorVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<VendorsRepository>();
    return _Shell(
      titleKey: 'ven.verify',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: repo.vendors.map((v) {
          final loc = context.read<AppLocalization>();
          return Card(
            child: ListTile(
              title: Text(loc.tr(v.companyNameAr.isEmpty ? v.companyName : v.companyNameAr, v.companyName)),
              subtitle: Text('${v.category} • ${v.tradeLicenseNumber}'),
              trailing: Icon(
                v.isVerified ? Icons.verified : Icons.pending,
                color: v.isVerified ? Colors.green : Colors.amber,
              ),
            ),
          );
        }).toList(),
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
    final repo = context.watch<VendorsRepository>();
    return _Shell(
      titleKey: 'ven.manage',
      child: ListView(
        children: repo.vendors.map((v) {
          final loc = context.read<AppLocalization>();
          return SwitchListTile(
            title: Text(loc.tr(v.companyNameAr.isEmpty ? v.companyName : v.companyNameAr, v.companyName)),
            subtitle: Text(loc.t(_statusKey(v.status))),
            value: v.isVerified,
            onChanged: (val) => repo.setVerified(v.id, val),
          );
        }).toList(),
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
      titleKey: 'ven.directory',
      child: Center(child: Text(loc.t('ven.wire_vendors'))),
    );
  }
}

class GccAuthoritiesHubScreen extends StatelessWidget {
  const GccAuthoritiesHubScreen({super.key});
  static const authorityKeys = [
    'ven.auth_dm',
    'ven.auth_rta',
    'ven.auth_dewa',
    'ven.auth_cd',
  ];
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Shell(
      titleKey: 'ven.auth_hub',
      child: ListView(
        children: authorityKeys.map((k) => ListTile(
          leading: const Icon(Icons.account_balance),
          title: Text(loc.t(k)),
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
      titleKey: 'ven.tenders',
      child: Center(child: Text(loc.t('ven.no_tenders'))),
    );
  }
}
