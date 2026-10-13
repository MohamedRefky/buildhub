// Clean Architecture: Finance — Presentation.
// Covers: FinanceClaimsScreen, FinancialAiScreen, CostToCompleteScreen,
// SmartPettyCashWalletScreen, ProjectBusinessPlanScreen.
// Titles/bodies resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/finance/data/finance_repository.dart';

class _Shell extends StatelessWidget {
  final String titleKey;
  final Widget child;
  const _Shell({required this.titleKey, required this.child});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(appBar: AppBar(title: Text(loc.t(titleKey))), body: child);
  }
}

class FinanceClaimsFullScreen extends StatelessWidget {
  const FinanceClaimsFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<FinanceRepository>();
    return _Shell(titleKey: 'fin.fidic',
      child: repo.claims.isEmpty
        ? Center(child: Text(loc.t('fin.no_claims')))
        : ListView(children: repo.claims.map((c) =>
          ListTile(title: Text(loc.tr(c.titleAr, c.titleEn)),
            subtitle: Text('${c.noticeNo} • ${c.subClause}'))).toList()));
  }
}

class FinancialAiFullScreen extends StatelessWidget {
  const FinancialAiFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Shell(titleKey: 'fin.finai_title',
      child: Center(child: Text(loc.t('fin.finai_body'))));
  }
}

class CostToCompleteFullScreen extends StatelessWidget {
  const CostToCompleteFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Shell(titleKey: 'fin.cost_title',
      child: Center(child: Text(loc.t('fin.cost_body'))));
  }
}

class PettyCashFullScreen extends StatelessWidget {
  const PettyCashFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<FinanceRepository>();
    return _Shell(titleKey: 'fin.petty_title',
      child: ListView(children: repo.wallets.map((w) =>
        ListTile(title: Text(w.holderName),
          trailing: Text(loc.formatAed(w.balanceAed)))).toList()));
  }
}

class BusinessPlanFullScreen extends StatelessWidget {
  const BusinessPlanFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return _Shell(titleKey: 'fin.biz_title',
      child: Center(child: Text(loc.t('fin.biz_body'))));
  }
}
