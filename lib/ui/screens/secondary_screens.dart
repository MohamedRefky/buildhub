// Simple ports for secondary tabs (BuildNet, Orders, Account, Procurement, Safety, Finance, AI Copilot)
// Static labels via loc.t() (JSON); entity data via loc.tr() (DB-driven).
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localization.dart';
import '../../data/repository/buildhub_repository.dart';
import '../screens/all_services_screen.dart';

class BuildNetScreen extends StatelessWidget {
  const BuildNetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Center(child: Text(loc.t('bn.network_full')));
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    if (repo.siteLogs.isEmpty) {
      return Center(child: Text(loc.t('ord.empty')));
    }
    return ListView(children: repo.siteLogs.map((l) =>
      ListTile(title: Text(loc.tr(l.summaryAr, l.summaryEn)), subtitle: Text(l.dateStr))).toList());
  }
}

class AccountScreen extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleSunlight;
  const AccountScreen({super.key, required this.onToggleLanguage, required this.onToggleSunlight});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(title: Text(loc.t('acct.language')),
          trailing: TextButton(
            onPressed: onToggleLanguage,
            child: Text(loc.isArabic
                ? loc.t('acct.to_english')
                : loc.t('acct.to_arabic')))),
        ListTile(title: Text(loc.t('acct.sunlight')),
          trailing: Switch(value: Theme.of(context).brightness == Brightness.light,
            onChanged: (_) => onToggleSunlight())),
        ListTile(title: Text(loc.t('acct.project')),
          subtitle: Text(loc.tr(
            context.read<BuildHubRepository>().currentProject.nameAr,
            context.read<BuildHubRepository>().currentProject.nameEn))),
      ],
    );
  }
}

class ProcurementScreen extends StatelessWidget {
  const ProcurementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(loc.t('proc.submittals_permits'),
            style: Theme.of(context).textTheme.titleMedium),
        ...repo.submittals.map((s) => ListTile(
          title: Text(loc.tr(s.titleAr, s.titleEn)),
          subtitle: Text('${s.submittalNo} • ${s.reviewCode}'),
        )),
        if (repo.submittals.isEmpty)
          Text(loc.t('proc.no_submittals')),
      ],
    );
  }
}

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
        Card(child: ListTile(
          leading: const Icon(Icons.thermostat),
          title: Text('${h.ambientTempC}°C • WBGT ${h.wbgtTempC}'),
          subtitle: Text(loc.t('safe.midday')),
        )),
        ...repo.safetyTickets.map((t) => ListTile(
          title: Text(loc.tr(t.titleAr, t.titleEn)),
          subtitle: Text(t.ticketNo),
        )),
      ],
    );
  }
}

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
        Text(loc.t('fin.title'),
            style: Theme.of(context).textTheme.titleMedium),
        Text('${loc.t('fin.budget')}: ${loc.formatAed(p.budgetAed)}'),
        ...repo.claims.map((c) => ListTile(
          title: Text(loc.tr(c.titleAr, c.titleEn)),
          subtitle: Text('${c.noticeNo} • ${c.subClause}'),
        )),
      ],
    );
  }
}

class AiCopilotScreen extends StatelessWidget {
  const AiCopilotScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(loc.t('ai.wire_gemini'), textAlign: TextAlign.center),
      ),
    );
  }
}

// Fallback for the other ~60 native screens (VendorVerification, WeatherBrain,
// GeoAttendance, RiskHeatMap, ProjectVault, SitePulse, ...).
class GenericServiceScreen extends StatelessWidget {
  final int tabId;
  final String? serviceId;
  final VoidCallback onBack;
  const GenericServiceScreen({super.key, required this.tabId, this.serviceId, required this.onBack});

  String _resolveTitle(AppLocalization loc) {
    try {
      final def = allServices.firstWhere((s) => s.targetTab == tabId);
      return loc.t(def.titleKey);
    } catch (_) {
      return '${loc.t('common.service')} #$tabId';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
        title: Text(_resolveTitle(loc)),
      ),
      body: Center(
        child: Text(loc.t('common.migrate_note'), textAlign: TextAlign.center),
      ),
    );
  }
}
