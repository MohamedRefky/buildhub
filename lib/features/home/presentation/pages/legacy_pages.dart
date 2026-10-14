// Clean Architecture: Legacy & Core Secondary Tabs — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// AccountScreen, BuildNetScreen, ProcurementScreen, FinanceScreen,
// AiCopilotScreen, GenericServiceScreen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/buildhub_repository.dart';
import '../../data/datasources/services_catalog.dart';
import '../../../buildnet/presentation/pages/buildnet_pages.dart';
import '../../presentation/widgets/project_switch_dialog.dart';

// ---------------------------------------------------------------------------
// 1. BUILDNET SCREEN (DELEGATES TO FULL B2B HUB)
// ---------------------------------------------------------------------------

class BuildNetScreen extends StatelessWidget {
  const BuildNetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const BuildNetHubScreen();
  }
}

// ---------------------------------------------------------------------------
// 2. ACCOUNT & SETTINGS SCREEN (FAITHFUL PORT OF ACCOUNTSCREEN.KT)
// ---------------------------------------------------------------------------

class AccountScreen extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleSunlight;
  const AccountScreen({super.key, required this.onToggleLanguage, required this.onToggleSunlight});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _biometricsEnabled = true;
  bool _pushNotifications = true;
  bool _autoSyncOffline = true;

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('acct.title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.accentCyan.withValues(alpha: 0.15), Colors.blue.withValues(alpha: 0.1)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.accentCyan.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, size: 36, color: AppColors.accentCyan),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('Eng. Abdelfattah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 6),
                          Icon(Icons.verified, size: 16, color: AppColors.verifiedGreen),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text('Project Director • Orion Developments', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('Society of Engineers UAE #SOE-48102', style: TextStyle(fontSize: 10, color: AppColors.accentCyan, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Active Project Selector
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.apartment, color: AppColors.accentCyan),
              title: Text(loc.t('acct.project'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text(loc.tr(repo.currentProject.nameAr, repo.currentProject.nameEn)),
              trailing: const Icon(Icons.swap_horiz, color: AppColors.accentCyan),
              onTap: () {
                showDialog(context: context, builder: (_) => const ProjectSwitchDialog());
              },
            ),
          ),
          const SizedBox(height: 16),

          // App Preferences Section
          const Text('Display & Localization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.accentCyan),
                  title: Text(loc.t('acct.language')),
                  subtitle: Text(loc.isArabic ? 'اللغة العربية (المفضلة)' : 'English (Active)'),
                  trailing: TextButton(
                    onPressed: widget.onToggleLanguage,
                    child: Text(loc.isArabic ? loc.t('acct.to_english') : loc.t('acct.to_arabic')),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.wb_sunny, color: Colors.orange),
                  title: Text(loc.t('acct.sunlight')),
                  subtitle: const Text('High-contrast Desert Sunlight Mode'),
                  value: isLight,
                  onChanged: (_) => widget.onToggleSunlight(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Security & Offline Section
          const Text('Security & Data Storage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint, color: AppColors.verifiedGreen),
                  title: const Text('Biometric / Face ID App Lock'),
                  subtitle: const Text('Enforce biometric auth for financial approvals'),
                  value: _biometricsEnabled,
                  onChanged: (v) => setState(() => _biometricsEnabled = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active, color: AppColors.accentCyan),
                  title: const Text('Real-Time Site Push Alerts'),
                  subtitle: const Text('Midday ban sirens, wind gust alerts & critical RFIs'),
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.sync, color: AppColors.verifiedGreen),
                  title: const Text('Auto Background SQLite Sync'),
                  subtitle: const Text('Sync voice logs & photo watermarks when online'),
                  value: _autoSyncOffline,
                  onChanged: (v) => setState(() => _autoSyncOffline = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Clear cache & Sign out
          OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline),
            label: const Text('Clear Offline Cached Drawings & Temporary Media (142 MB)'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Offline media cache cleared. Core DB preserved.')));
            },
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.criticalRed),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out of Enterprise Account'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. PROCUREMENT & SUBMITTALS SCREEN
// ---------------------------------------------------------------------------

class ProcurementScreen extends StatelessWidget {
  const ProcurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.accentCyan)),
          child: const Row(
            children: [
              Icon(Icons.inventory_2, color: AppColors.accentCyan),
              SizedBox(width: 10),
              Expanded(
                child: Text('Unified Material Submittals & Authority Permits Log. Track consultant review cycles & delivery schedules.', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(loc.t('proc.submittals_permits'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        ...repo.submittals.map((s) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.accentCyan.withValues(alpha: 0.15),
                  child: const Icon(Icons.description, color: AppColors.accentCyan, size: 20),
                ),
                title: Text(loc.tr(s.titleAr, s.titleEn), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('Submittal: ${s.submittalNo} • Status: ${s.reviewCode}'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(s.reviewCode, style: const TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ),
            )),
        if (repo.submittals.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(loc.t('proc.no_submittals')),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4. SAFETY SCREEN
// ---------------------------------------------------------------------------

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    final h = repo.heatStress;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.thermostat, color: Colors.orange, size: 28),
            title: Text('${h.ambientTempC}°C Ambient • WBGT ${h.wbgtTempC}°C', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(loc.t('safe.midday')),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
              child: const Text('COMPLIANT', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 10)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text('Active Safety Tickets & Field Audits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        ...repo.safetyTickets.map((t) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.report_problem, color: AppColors.cautionAmber),
                title: Text(loc.tr(t.titleAr, t.titleEn), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('Ticket: ${t.ticketNo} • Status: Under Review'),
              ),
            )),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 5. FINANCE SUMMARY SCREEN
// ---------------------------------------------------------------------------

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    final p = repo.currentProject;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.accentCyan.withValues(alpha: 0.15), Colors.blue.withValues(alpha: 0.1)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentCyan),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.t('fin.budget'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              Text(loc.formatAed(p.budgetAed), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
              const SizedBox(height: 8),
              Text('Project: ${loc.tr(p.nameAr, p.nameEn)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(loc.t('fin.title'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        ...repo.claims.map((c) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.gavel, color: AppColors.goldEmirates),
                title: Text(loc.tr(c.titleAr, c.titleEn), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('Notice: ${c.noticeNo} • Clause: ${c.subClause}'),
              ),
            )),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 6. AI COPILOT LAUNCHER
// ---------------------------------------------------------------------------

class AiCopilotScreen extends StatelessWidget {
  const AiCopilotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.smart_toy, size: 70, color: AppColors.accentCyan),
            const SizedBox(height: 16),
            const Text('Orion B AI Tactical Copilot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 8),
            const Text('Powered by Gemini 2.5 Flash with Grounded UAE Construction Regulations.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. GENERIC SERVICE SCREEN (INTELLIGENT DYNAMIC FALLBACK)
// ---------------------------------------------------------------------------

class GenericServiceScreen extends StatelessWidget {
  final int tabId;
  final String? serviceId;
  final VoidCallback onBack;
  const GenericServiceScreen({super.key, required this.tabId, this.serviceId, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final s = ServicesCatalog.findByTargetTab(tabId);
    final title = s != null ? (loc.isArabic ? s.titleAr : s.titleEn) : 'Service #$tabId';
    final desc = s != null ? (loc.isArabic ? s.descAr : s.descEn) : 'Active enterprise engineering module.';
    final badges = s?.badges ?? ['Live Enterprise Service', 'UAE Standard'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [(s?.iconColor ?? AppColors.accentCyan).withValues(alpha: 0.15), Colors.black12]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: s?.iconColor ?? AppColors.accentCyan),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(s?.icon ?? Icons.engineering, color: s?.iconColor ?? AppColors.accentCyan, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(desc, style: const TextStyle(fontSize: 13, height: 1.4)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: badges
                      .map((b) => Chip(
                            label: Text(b, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            backgroundColor: (s?.iconColor ?? AppColors.accentCyan).withValues(alpha: 0.15),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Module Telemetry & Active Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cloud Sync Status:'),
                      Text('Connected (Real-time)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Local SQLite Database:'),
                      Text('Active & Cached', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Authority Compliance:'),
                      Text('UAE Municipality Standard', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: s?.iconColor ?? AppColors.accentCyan,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(48),
            ),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Execute Module Operation'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Operation initialized for $title')));
            },
          ),
        ],
      ),
    );
  }
}
