// Shared UI: budget burn-rate dashboard.
// Ports: BudgetBurnRateDashboard.kt — monthly burn bar chart + trend line
// (tab 0) and live expense stream with quick-add dialog (tab 1).
// Labels resolve from JSON; amounts format via [fmt].
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class MonthlyBurnRecord {
  final String monthAr;
  final String monthEn;
  final double budgetAllocationAed;
  final double actualBurnAed;
  final String driverAr;
  final String driverEn;
  const MonthlyBurnRecord({
    required this.monthAr, required this.monthEn,
    required this.budgetAllocationAed, required this.actualBurnAed,
    required this.driverAr, required this.driverEn,
  });
}

class RealtimeExpense {
  final String id;
  final String descriptionAr;
  final String descriptionEn;
  final String categoryAr;
  final String categoryEn;
  final double amountAed;
  final String timestamp;
  final String statusKey;
  final bool isAnomaly;
  const RealtimeExpense({
    required this.id, required this.descriptionAr,
    required this.descriptionEn, required this.categoryAr,
    required this.categoryEn, required this.amountAed,
    required this.timestamp, required this.statusKey,
    this.isAnomaly = false,
  });
}

const _defaultBurn = [
  MonthlyBurnRecord(monthAr: 'يناير', monthEn: 'Jan',
      budgetAllocationAed: 8000000, actualBurnAed: 7400000,
      driverAr: 'الركائز', driverEn: 'Piling'),
  MonthlyBurnRecord(monthAr: 'فبراير', monthEn: 'Feb',
      budgetAllocationAed: 8200000, actualBurnAed: 8100000,
      driverAr: 'اللبشة', driverEn: 'Raft'),
  MonthlyBurnRecord(monthAr: 'مارس', monthEn: 'Mar',
      budgetAllocationAed: 8500000, actualBurnAed: 8900000,
      driverAr: 'الهيكل', driverEn: 'Structure'),
  MonthlyBurnRecord(monthAr: 'أبريل', monthEn: 'Apr',
      budgetAllocationAed: 8800000, actualBurnAed: 8600000,
      driverAr: 'الواجهات', driverEn: 'Glazing'),
  MonthlyBurnRecord(monthAr: 'مايو', monthEn: 'May',
      budgetAllocationAed: 9000000, actualBurnAed: 8700000,
      driverAr: 'الكهروميكانيكا', driverEn: 'MEP'),
  MonthlyBurnRecord(monthAr: 'يونيو', monthEn: 'Jun',
      budgetAllocationAed: 9200000, actualBurnAed: 9100000,
      driverAr: 'التشطيبات', driverEn: 'Finishing'),
];

class BudgetBurnRateDashboard extends StatefulWidget {
  final double totalBudget;
  final double totalSpent;
  final String Function(double) fmt;
  final List<MonthlyBurnRecord> records;
  final List<RealtimeExpense> initialExpenses;
  final void Function(RealtimeExpense expense)? onAddExpense;
  const BudgetBurnRateDashboard({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
    required this.fmt,
    this.records = _defaultBurn,
    this.initialExpenses = const [],
    this.onAddExpense,
  });
  @override
  State<BudgetBurnRateDashboard> createState() =>
      _BudgetBurnRateDashboardState();
}

class _BudgetBurnRateDashboardState extends State<BudgetBurnRateDashboard> {
  int _tab = 0;
  int _selectedMonth = -1;
  late List<RealtimeExpense> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = List.of(widget.initialExpenses);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final avgBurn = widget.records.isEmpty
        ? 0.0
        : widget.records.map((r) => r.actualBurnAed).reduce((a, b) => a + b) /
            widget.records.length;
    final velocity = widget.totalBudget == 0
        ? 0.0
        : widget.totalSpent / widget.totalBudget * 100;
    final runway = avgBurn <= 0
        ? 0
        : ((widget.totalBudget - widget.totalSpent) / avgBurn).floor();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.t('widgets.burn_title'),
                  style: Theme.of(context).textTheme.titleMedium),
              Text(loc.t('widgets.burn_sub'),
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: [
                  ButtonSegment(
                      value: 0, label: Text(loc.t('widgets.burn_chart_tab'))),
                  ButtonSegment(
                      value: 1,
                      label: Text(
                          '${loc.t('widgets.burn_feed_tab')} (${_expenses.length})')),
                ],
                selected: {_tab},
                onSelectionChanged: (s) =>
                    setState(() => _tab = s.first),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _BurnKpi(
                    title: loc.t('widgets.burn_monthly'),
                    value: widget.fmt(avgBurn),
                    sub: loc.t('widgets.burn_avg'))),
                Expanded(child: _BurnKpi(
                    title: loc.t('widgets.burn_velocity'),
                    value: '${velocity.toStringAsFixed(1)}%',
                    sub: loc.t(velocity <= 100
                        ? 'widgets.burn_safe'
                        : 'widgets.burn_over'))),
                Expanded(child: _BurnKpi(
                    title: loc.t('widgets.burn_runway'),
                    value: '$runway ${loc.t('widgets.burn_months')}',
                    sub: loc.t('widgets.burn_months_cover'))),
              ]),
              const SizedBox(height: 8),
              if (_tab == 0) _chart(context, loc) else _feed(context, loc),
            ]),
      ),
    );
  }

  Widget _chart(BuildContext context, AppLocalization loc) {
    final maxY = widget.records.fold<double>(
        0, (m, r) => m > r.budgetAllocationAed ? m : r.budgetAllocationAed);
    return Column(children: [
      SizedBox(
        height: 200,
        child: BarChart(BarChartData(
          maxY: maxY * 1.15,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (v, _) => Text(
                        '${(v / 1000000).toStringAsFixed(1)}M',
                        style: const TextStyle(fontSize: 9)))),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 || i >= widget.records.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                          loc.tr(widget.records[i].monthAr,
                              widget.records[i].monthEn),
                          style: const TextStyle(fontSize: 9));
                    })),
          ),
          barTouchData: BarTouchData(
              touchCallback: (e, r) {
            if (r != null && r.spot != null) {
              setState(() => _selectedMonth = r.spot!.touchedBarGroupIndex);
            }
          }),
          barGroups: [
            for (var i = 0; i < widget.records.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                    toY: widget.records[i].budgetAllocationAed,
                    color: Colors.amber.withValues(alpha: 0.45),
                    width: 14),
                BarChartRodData(
                    toY: widget.records[i].actualBurnAed,
                    color: widget.records[i].actualBurnAed >
                            widget.records[i].budgetAllocationAed
                        ? Colors.red
                        : Colors.cyan,
                    width: 8),
              ]),
          ],
        )),
      ),
      Text('${loc.t('widgets.burn_actual')} • ${loc.t('widgets.burn_ceiling')}',
          style: Theme.of(context).textTheme.labelSmall),
      Text(loc.t('widgets.burn_tap'),
          style: Theme.of(context).textTheme.labelSmall),
      if (_selectedMonth >= 0 &&
          _selectedMonth < widget.records.length) ...[
        const SizedBox(height: 6),
        _monthDetail(context, loc, widget.records[_selectedMonth]),
      ],
    ]);
  }

  Widget _monthDetail(
      BuildContext context, AppLocalization loc, MonthlyBurnRecord r) {
    final over = r.actualBurnAed - r.budgetAllocationAed;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${loc.t('widgets.burn_month_details')} ${loc.tr(r.monthAr, r.monthEn)}'),
              Text(
                  '${over >= 0 ? '+' : ''}${widget.fmt(over)} '
                  '(${loc.t(over >= 0 ? 'widgets.burn_over_by' : 'widgets.burn_saved')})'),
              Text(
                  '${loc.t('widgets.burn_driver')} ${loc.tr(r.driverAr, r.driverEn)}'),
              Text(
                  '${loc.t('widgets.burn_budget')} ${widget.fmt(r.budgetAllocationAed)} • '
                  '${loc.t('widgets.burn_actual_lbl')} ${widget.fmt(r.actualBurnAed)}'),
            ]),
      ),
    );
  }

  Widget _feed(BuildContext context, AppLocalization loc) {
    return Column(children: [
      Row(children: [
        Expanded(child: Text(loc.t('widgets.burn_stream'),
            style: Theme.of(context).textTheme.titleSmall)),
        ElevatedButton(
            onPressed: () => _showQuickAdd(context, loc),
            child: Text(loc.t('widgets.burn_log'))),
      ]),
      ..._expenses.map((e) => ListTile(
            title: Text(loc.tr(e.descriptionAr, e.descriptionEn)),
            subtitle: Text(loc.tr(e.categoryAr, e.categoryEn)),
            trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.fmt(e.amountAed),
                      style: TextStyle(
                          color: e.isAnomaly ? Colors.red : null)),
                  Text(loc.t(e.statusKey),
                      style: Theme.of(context).textTheme.labelSmall),
                ]),
          )),
    ]);
  }

  Future<void> _showQuickAdd(BuildContext context, AppLocalization loc) async {
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.t('widgets.burn_quick_title')),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                  labelText: loc.t('widgets.burn_desc'))),
          TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: loc.t('widgets.burn_amount'))),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(loc.t('common.cancel'))),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(loc.t('widgets.burn_save'))),
        ],
      ),
    );
    if (ok == true && descCtrl.text.isNotEmpty) {
      final expense = RealtimeExpense(
        id: const Uuid().v4(),
        descriptionAr: descCtrl.text,
        descriptionEn: descCtrl.text,
        categoryAr: '',
        categoryEn: '',
        amountAed: double.tryParse(amountCtrl.text) ?? 0,
        timestamp: DateTime.now().toIso8601String(),
        statusKey: 'widgets.burn_approved',
      );
      setState(() => _expenses.add(expense));
      widget.onAddExpense?.call(expense);
    }
  }
}

class _BurnKpi extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  const _BurnKpi(
      {required this.title, required this.value, required this.sub});
  @override
  Widget build(BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            Text(value, style: Theme.of(context).textTheme.titleSmall),
            Text(sub, style: Theme.of(context).textTheme.labelSmall),
          ]);
}
