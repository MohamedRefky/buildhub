// Clean Architecture: Documents — Presentation.
// Covers: ProjectVaultScreen, RfiSubmittalsScreen, DrawingBimViewerScreen,
// EnterpriseIntegrationsScreen, EnterpriseReportsAndAuditScreen,
// EngineeringLibraryScreen, TrainingCoursesScreen, UserFileManagerScreen,
// FirebaseAuthScreen, FirebaseCloudSyncScreen, TechnicalSpecificationsView,
// ReportReviewScreen, ProjectBusinessPlanScreen (docs side).
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class _Doc extends StatelessWidget {
  final String ar; final String en; final String body;
  const _Doc({required this.ar, required this.en, this.body = ''});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.tr(ar, en))),
      body: Center(child: Text(body.isEmpty
        ? loc.tr('يُنقل من النسخة Kotlin تدريجياً', 'Migrate incrementally from Kotlin')
        : body)),
    );
  }
}

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'خزنة المشروع', en: 'Project Vault');
}

class RfiScreen extends StatelessWidget {
  const RfiScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'طلبات المعلومات RFI', en: 'RFI Submittals',
        body: 'RfiWorkflowEngine • statuses OPEN/CLOSED');
}

class DrawingsScreen extends StatelessWidget {
  const DrawingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'المخططات و BIM', en: 'Drawings & BIM');
}

class IntegrationsScreen extends StatelessWidget {
  const IntegrationsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'تكاملات المؤسسات', en: 'Enterprise Integrations');
}

class ReportsAuditScreen extends StatelessWidget {
  const ReportsAuditScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'التقارير والتدقيق', en: 'Reports & Audit');
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'المكتبة الهندسية', en: 'Engineering Library');
}

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'الدورات التدريبية', en: 'Training Courses');
}

class UserFilesScreen extends StatelessWidget {
  const UserFilesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'ملفاتي السحابية', en: 'My Cloud Files',
        body: 'FirebaseUserStorageService • per-user storage');
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    // Port of FirebaseAuthScreen + FirebaseAuthManager (silent sign-in).
    return Scaffold(
      appBar: AppBar(title: Text(loc.tr('تسجيل الدخول', 'Sign in'))),
      body: Center(child: ElevatedButton(
        onPressed: () {},
        child: Text(loc.tr('دخول بجوجل', 'Sign in with Google')))),
    );
  }
}

class CloudSyncScreen extends StatelessWidget {
  const CloudSyncScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'المزامنة السحابية', en: 'Cloud Sync',
        body: 'FirebaseAccountSyncService • OfflineFirstRepository');
}

class SpecsScreen extends StatelessWidget {
  const SpecsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Doc(ar: 'المواصفات الفنية', en: 'Technical Specs');
}
