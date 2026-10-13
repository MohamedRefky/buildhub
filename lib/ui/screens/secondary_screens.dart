// Simple ports for secondary tabs (BuildNet, Orders, Account, Procurement, Safety, Finance, AI Copilot)
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
    return Center(child: Text(loc.tr('شبكة BuildNet المهنية', 'BuildNet Professional Network')));
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<BuildHubRepository>();
    if (repo.siteLogs.isEmpty) {
      return Center(child: Text(loc.tr('لا توجد طلبات بعد', 'No orders yet')));
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
        ListTile(title: Text(loc.tr('اللغة', 'Language')),
          trailing: TextButton(onPressed: onToggleLanguage, child: Text(loc.tr('English', 'العربية')))),
        ListTile(title: Text(loc.tr('وضع الشمس', 'Sunlight mode')),
          trailing: Switch(value: Theme.of(context).brightness == Brightness.light,
            onChanged: (_) => onToggleSunlight())),
        ListTile(title: Text(loc.tr('المشروع', 'Project')),
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
        Text(loc.tr('الاعتمادات والتصاريح', 'Submittals & Permits'),
            style: Theme.of(context).textTheme.titleMedium),
        ...repo.submittals.map((s) => ListTile(
          title: Text(loc.tr(s.titleAr, s.titleEn)),
          subtitle: Text('${s.submittalNo} • ${s.reviewCode}'),
        )),
        if (repo.submittals.isEmpty)
          Text(loc.tr('لا اعتمادات مسجلة — مربوط بـ Firestore لاحقاً', 'No submittals — wire to Firestore later')),
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
          subtitle: Text(loc.tr('حظر الظهيرة ساري ١٢:٣٠ - ٣:٠٠', 'Midday break 12:30-3:00')),
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
        Text(loc.tr('المالية والمطالبات FIDIC', 'Finance & FIDIC Claims'),
            style: Theme.of(context).textTheme.titleMedium),
        Text('${loc.tr('الميزانية', 'Budget')}: ${loc.formatAed(p.budgetAed)}'),
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
        child: Text(
          loc.tr('المساعد الذكي — اربط GEMINI_API_KEY عبر --dart-define',
              'AI Copilot — pass GEMINI_API_KEY via --dart-define'),
          textAlign: TextAlign.center,
        ),
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
      return loc.tr(def.titleAr, def.titleEn);
    } catch (_) {
      return '${loc.tr('خدمة', 'Service')} #$tabId';
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
        child: Text(loc.tr(
          'شاشة رقم $tabId — تُنقل تدريجياً من النسخة Kotlin',
          'Screen #$tabId — migrate incrementally from Kotlin',
        ), textAlign: TextAlign.center),
      ),
    );
  }
}
