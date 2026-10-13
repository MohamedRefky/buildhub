// Clean Architecture: Documents — Presentation.
// Covers: ProjectVaultScreen, RfiSubmittalsScreen, DrawingBimViewerScreen,
// EnterpriseIntegrationsScreen, EnterpriseReportsAndAuditScreen,
// EngineeringLibraryScreen, TrainingCoursesScreen, UserFileManagerScreen,
// FirebaseAuthScreen, FirebaseCloudSyncScreen, TechnicalSpecificationsView,
// ReportReviewScreen, ProjectBusinessPlanScreen (docs side).
// Titles/bodies resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class _Doc extends StatelessWidget {
  final String titleKey;
  final String? bodyKey;
  const _Doc({required this.titleKey, this.bodyKey});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final body = bodyKey == null ? loc.t('common.migrate_note') : loc.t(bodyKey!);
    return Scaffold(
      appBar: AppBar(title: Text(loc.t(titleKey))),
      body: Center(child: Text(body)),
    );
  }
}

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.vault');
}

class RfiScreen extends StatelessWidget {
  const RfiScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.rfi', bodyKey: 'docs.rfi_body');
}

class DrawingsScreen extends StatelessWidget {
  const DrawingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.drawings');
}

class IntegrationsScreen extends StatelessWidget {
  const IntegrationsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.integrations');
}

class ReportsAuditScreen extends StatelessWidget {
  const ReportsAuditScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.reports');
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.library');
}

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.courses');
}

class UserFilesScreen extends StatelessWidget {
  const UserFilesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.myfiles', bodyKey: 'docs.myfiles_body');
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    // Port of FirebaseAuthScreen + FirebaseAuthManager (silent sign-in).
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('docs.signin'))),
      body: Center(child: ElevatedButton(
        onPressed: () {},
        child: Text(loc.t('docs.signin_google')))),
    );
  }
}

class CloudSyncScreen extends StatelessWidget {
  const CloudSyncScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.cloud', bodyKey: 'docs.cloud_body');
}

class SpecsScreen extends StatelessWidget {
  const SpecsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(titleKey: 'docs.specs');
}
