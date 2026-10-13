// Clean Architecture: Finance — Presentation.
// Covers: FinanceClaimsScreen, FinancialAiScreen, CostToCompleteScreen,
// SmartPettyCashWalletScreen, ProjectBusinessPlanScreen.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/finance/data/finance_repository.dart';

class _Shell extends StatelessWidget {
  final String ar; final String en; final Widget child;
  const _Shell({required this.ar, required this.en, required this.child});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(appBar: AppBar(title: Text(loc.tr(ar, en))), body: child);
  }
}

class FinanceClaimsFullScreen extends StatelessWidget {
  const FinanceClaimsFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<FinanceRepository>();
    return _Shell(ar: 'المطالبات FIDIC', en: 'FIDIC Claims',
      child: repo.claims.isEmpty
        ? Center(child: Text(loc.tr('لا مطالبات — ٢٨ يوم مهلة الإشعار', 'No claims — 28-day notice window')))
        : ListView(children: repo.claims.map((c) =>
          ListTile(title: Text(loc.tr(c.titleAr, c.titleEn)),
            subtitle: Text('${c.noticeNo} • ${c.subClause}'))).toList()));
  }
}

class FinancialAiFullScreen extends StatelessWidget {
  const FinancialAiFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _Shell(ar: 'الذكاء المالي وكشف الاحتيال', en: 'Financial AI',
        child: const Center(child: Text('Fraud detection • wire Gemini')));
}

class CostToCompleteFullScreen extends StatelessWidget {
  const CostToCompleteFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _Shell(ar: 'التكلفة للإنجاز', en: 'Cost to Complete',
        child: const Center(child: Text('EVM: CPI/SPI • forecast')));
}

class PettyCashFullScreen extends StatelessWidget {
  const PettyCashFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<FinanceRepository>();
    return _Shell(ar: 'محفظة العهدة الذكية', en: 'Petty Cash Wallet',
      child: ListView(children: repo.wallets.map((w) =>
        ListTile(title: Text(w.holderName),
          trailing: Text('${w.balanceAed}'))).toList()));
  }
}

class BusinessPlanFullScreen extends StatelessWidget {
  const BusinessPlanFullScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _Shell(ar: 'خطة العمل المالية', en: 'Business Plan',
        child: const Center(child: Text('IRR / NPV / Payback')));
}
