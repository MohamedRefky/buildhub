// Shared UI: execution S-curve progress chart.
// Ports: ProjectProgressLineChart.kt — planned (PV, amber dashed) vs actual
// (EV, cyan) lines, tap-to-inspect tooltip, variance banner and milestone
// delivery checklist. Labels resolve from JSON.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class ProgressDataPoint {
  final String monthAr;
  final String monthEn;
  final double plannedPercent;
  final double actualPercent;
  final String milestoneAr;
  final String milestoneEn;
  const ProgressDataPoint({
    required this.monthAr, required this.monthEn,
    required this.plannedPercent, required this.actualPercent,
    required this.milestoneAr, required this.milestoneEn,
  });
}

const _defaultChecklist = [
  ('Excavation to -14m', false),
  ('Raft rebar inspection', true),
  ('Level 8 slab post-tensioning', false),
  ('Double glazed curtain wall', false),
  ('Floor tiling & screed', false),
  ('Final snagging / BCC', false),
];

class ProjectProgressChart extends StatefulWidget {
  final int currentCompletion;
  final List<ProgressDataPoint>? points;
  const ProjectProgressChart({
    super.key,
    required this.currentCompletion,
    this.points,
  });
  @override
  State<ProjectProgressChart> createState() => _ProjectProgressChartState();
}

class _ProjectProgressChartState extends State<ProjectProgressChart> {
  int _selected = -1;
  bool _showPlanned = true;
  bool _showActual = true;
  bool _showChecklist = false;
  late List<bool> _checks;

  @override
  void initState() {
    super.initState();
    _checks = _defaultChecklist.map((e) => e.$2).toList();
  }

  List<ProgressDataPoint> get _points {
    if (widget.points != null) return widget.points!;
    const months = [
      ('يناير', 'Jan', 'حفر وركائز', 'Piling'),
      ('فبراير', 'Feb', 'لبشة', 'Raft'),
      ('مارس', 'Mar', 'هيكل L10', 'Frame L10'),
      ('أبريل', 'Apr', 'واجهات+MEP', 'Facade+MEP'),
      ('مايو', 'May', 'تشطيبات', 'Finishing'),
      ('يونيو', 'Jun', 'تسليم+BCC', 'Handover'),
    ];
    const planned = [12.0, 28.0, 45.0, 62.0, 80.0, 96.0];
    final factor = widget.currentCompletion / 70;
    return [
      for (var i = 0; i < months.length; i++)
        ProgressDataPoint(
          monthAr: months[i].$1, monthEn: months[i].$2,
          plannedPercent: planned[i],
          actualPercent: (planned[i] * factor).clamp(0, 100),
          milestoneAr: months[i].$3, milestoneEn: months[i].$4,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final points = _points;
    final variance = points.isEmpty
        ? 0.0
        : points.last.actualPercent - points.last.plannedPercent;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.t('widgets.prog_title'),
                  style: Theme.of(context).textTheme.titleMedium),
              Text(loc.t('widgets.prog_sub'),
                  style: Theme.of(context).textTheme.labelSmall),
              Row(children: [
                FilterChip(
                    label: Text(loc.t('widgets.prog_actual')),
                    selected: _showActual,
                    onSelected: (v) =>
                        setState(() => _showActual = v)),
                const SizedBox(width: 8),
                FilterChip(
                    label: Text(loc.t('widgets.prog_planned')),
                    selected: _showPlanned,
                    onSelected: (v) =>
                        setState(() => _showPlanned = v)),
              ]),
              SizedBox(
                height: 200,
                child: LineChart(LineChartData(
                  minY: 0,
                  maxY: 100,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            getTitlesWidget: (v, _) => Text('${v.toInt()}%',
                                style: const TextStyle(fontSize: 9)))),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              final i = v.toInt();
                              if (i < 0 || i >= points.length) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                  loc.tr(points[i].monthAr,
                                      points[i].monthEn),
                                  style:
                                      const TextStyle(fontSize: 9));
                            })),
                  ),
                  lineTouchData: LineTouchData(
                      touchCallback: (e, r) {
                    if (r != null &&
                        r.lineBarSpots != null &&
                        r.lineBarSpots!.isNotEmpty) {
                      setState(() =>
                          _selected = r.lineBarSpots!.first.spotIndex);
                    }
                  }),
                  lineBarsData: [
                    if (_showActual)
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < points.length; i++)
                            FlSpot(i.toDouble(), points[i].actualPercent),
                        ],
                        isCurved: true,
                        color: Colors.cyan,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                            show: true,
                            color: Colors.cyan.withValues(alpha: 0.2)),
                      ),
                    if (_showPlanned)
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < points.length; i++)
                            FlSpot(i.toDouble(), points[i].plannedPercent),
                        ],
                        isCurved: true,
                        color: Colors.amber,
                        barWidth: 2,
                        dashArray: [6, 4],
                      ),
                  ],
                )),
              ),
              if (_selected >= 0 && _selected < points.length)
                _tooltip(context, loc, points[_selected]),
              const SizedBox(height: 6),
              _varianceBanner(context, loc, variance),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(
                    child: Text(
                        '${loc.t('widgets.prog_checklist')} '
                        '(${_checks.where((c) => c).length}/${_checks.length})')),
                TextButton(
                    onPressed: () =>
                        setState(() => _showChecklist = !_showChecklist),
                    child: Text(_showChecklist ? '−' : '+')),
              ]),
              if (_showChecklist)
                ...List.generate(
                    _defaultChecklist.length,
                    (i) => CheckboxListTile(
                        title: Text(_defaultChecklist[i].$1),
                        value: _checks[i],
                        onChanged: (v) => setState(
                            () => _checks[i] = v ?? false))),
            ]),
      ),
    );
  }

  Widget _tooltip(
      BuildContext context, AppLocalization loc, ProgressDataPoint p) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${loc.t('widgets.prog_stage')} ${loc.tr(p.monthAr, p.monthEn)} • ${loc.tr(p.milestoneAr, p.milestoneEn)}'),
              Text(
                  '${loc.t('widgets.prog_ev')}: ${p.actualPercent.toStringAsFixed(1)}% • '
                  '${loc.t('widgets.prog_pv')}: ${p.plannedPercent.toStringAsFixed(1)}%'),
            ]),
      ),
    );
  }

  Widget _varianceBanner(
      BuildContext context, AppLocalization loc, double variance) {
    final onTrack = variance >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (onTrack ? Colors.green : Colors.red)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        onTrack
            ? loc.t('widgets.prog_ontrack')
            : '${loc.t('widgets.prog_variance')}: ${variance.toStringAsFixed(1)}% • ${loc.t('widgets.prog_recovery')}',
      ),
    );
  }
}
