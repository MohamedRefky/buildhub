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

class ReportWarning {
  final String message;
  final bool blocking;
  const ReportWarning({required this.message, this.blocking = false});
}

class ReportLine {
  final String text;
  final double confidence;
  final bool aiGenerated;
  const ReportLine({
    required this.text,
    this.confidence = 1.0,
    this.aiGenerated = false,
  });
}

/// Port of ReportReviewScreen.kt: warnings banner + activity lines +
/// blocking-aware sign button.
class ReportReviewScreen extends StatelessWidget {
  final String date;
  final String status;
  final List<ReportWarning> warnings;
  final List<ReportLine> lines;
  final VoidCallback? onSign;
  final VoidCallback? onBack;
  const ReportReviewScreen({
    super.key,
    this.date = '',
    this.status = 'DRAFT',
    this.warnings = const [],
    this.lines = const [],
    this.onSign,
    this.onBack,
  });
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final blocked = warnings.any((w) => w.blocking);
    return Scaffold(
      appBar: AppBar(
        leading: onBack == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack),
        title: Text(loc.t('docs.review_title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${loc.t('docs.review_date')} $date | '
              '${loc.t('docs.review_status')} $status'),
          if (warnings.isNotEmpty)
            Card(
              color: Colors.amber.withValues(alpha: 0.15),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: warnings
                        .map((w) => Text('⚠️ ${w.message}'))
                        .toList()),
              ),
            ),
          const SizedBox(height: 8),
          Text(loc.t('docs.review_lines'),
              style: Theme.of(context).textTheme.titleSmall),
          ...lines.map((l) => Card(
                color: l.confidence < 0.7
                    ? Colors.amber.withValues(alpha: 0.12)
                    : null,
                child: ListTile(
                  title: Text(l.text),
                  subtitle: Row(children: [
                    if (l.aiGenerated)
                      const Chip(
                          label: Text('AI'),
                          visualDensity:
                              VisualDensity.compact),
                    if (l.confidence < 0.7)
                      Chip(
                          label:
                              Text(loc.t('docs.review_low_conf')),
                          visualDensity:
                              VisualDensity.compact),
                  ]),
                ),
              )),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: blocked ? null : onSign,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green),
            child: Text(loc.t('docs.review_sign')),
          ),
        ],
      ),
    );
  }
}

class DrawingPin {
  final String id;
  final String title;
  final String type;
  final String status;
  final double xRatio;
  final double yRatio;
  final String discipline;
  const DrawingPin({
    required this.id, required this.title, required this.type,
    required this.status, required this.xRatio, required this.yRatio,
    this.discipline = '',
  });
}

/// Port of DrawingPinRecordScreen.kt: CAD-grid canvas with tappable
/// RFI/SNAG/NCR pins, type filter and pin list.
class DrawingPinRecordScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const DrawingPinRecordScreen({super.key, this.onBack});
  @override
  State<DrawingPinRecordScreen> createState() =>
      _DrawingPinRecordScreenState();
}

class _DrawingPinRecordScreenState
    extends State<DrawingPinRecordScreen> {
  static const _seed = [
    DrawingPin(id: 'RFI-042', title: 'RFI-042', type: 'RFI',
        status: 'OPEN', xRatio: 0.3, yRatio: 0.4, discipline: 'Structural'),
    DrawingPin(id: 'SNAG-102', title: 'SNAG-102', type: 'SNAG',
        status: 'OPEN', xRatio: 0.6, yRatio: 0.3, discipline: 'Finishing'),
    DrawingPin(id: 'NCR-005', title: 'NCR-005', type: 'NCR',
        status: 'OPEN', xRatio: 0.5, yRatio: 0.7, discipline: 'Concrete'),
    DrawingPin(id: 'RFI-043', title: 'RFI-043', type: 'RFI',
        status: 'CLOSED', xRatio: 0.75, yRatio: 0.6, discipline: 'Facade'),
  ];

  String _filter = 'ALL';
  String? _selectedId;
  final List<DrawingPin> _pins = List.of(_seed);

  Color _pinColor(String type) => switch (type) {
        'RFI' => Colors.cyan,
        'SNAG' => Colors.amber,
        'NCR' => Colors.red,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final visible = _filter == 'ALL'
        ? _pins
        : _pins.where((p) => p.type == _filter).toList();
    final selected = visible.where((p) => p.id == _selectedId).firstOrNull;
    return Scaffold(
      appBar: AppBar(
        leading: widget.onBack == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack),
        title: Text(loc.t('docs.pin_title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(loc.t('docs.pin_plan')),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: ['ALL', 'RFI', 'SNAG', 'NCR']
                    .map((f) => Padding(
                        padding:
                            const EdgeInsetsDirectional.only(end: 6),
                        child: ChoiceChip(
                            label: Text(f),
                            selected: _filter == f,
                            onSelected: (_) => setState(
                                () => _filter = f))))
                    .toList()),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (ctx, constraints) {
            final w = constraints.maxWidth;
            const h = 280.0;
            return GestureDetector(
              onTapDown: (d) {
                final dx =
                    (d.localPosition.dx / w).clamp(0.0, 1.0);
                final dy =
                    (d.localPosition.dy / h).clamp(0.0, 1.0);
                setState(() {
                  final id = 'PIN-${_pins.length + 1}';
                  _pins.add(DrawingPin(
                      id: id, title: id, type: 'RFI',
                      status: 'OPEN', xRatio: dx, yRatio: dy));
                  _selectedId = id;
                });
              },
              child: SizedBox(
                width: w,
                height: h,
                child: Stack(children: [
                  CustomPaint(
                      size: Size(w, h),
                      painter: const _CadGrid()),
                  for (final p in visible)
                    Positioned(
                      left: p.xRatio * w - 12,
                      top: p.yRatio * h - 12,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedId = p.id),
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor:
                                _pinColor(p.type),
                            child: Text(p.type.characters.first,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11))),
                      ),
                    ),
                ]),
              ),
            );
          }),
          const SizedBox(height: 8),
          if (selected != null)
            Card(
                child: ListTile(
              title: Text(selected.title),
              subtitle: Text(
                  '${loc.t('docs.pin_type')} ${selected.type} | '
                  '${selected.discipline}'),
              trailing: Text(
                  '${loc.t('docs.pin_status')} ${selected.status}'),
            ))
          else
            Text(
                '${loc.t('docs.pin_all')} (${visible.length})'),
          ...visible.map((p) => ListTile(
                leading: CircleAvatar(
                    backgroundColor: _pinColor(p.type),
                    child: Text(p.type.characters.first)),
                title: Text(p.title),
                subtitle: Text(p.discipline),
                onTap: () =>
                    setState(() => _selectedId = p.id),
              )),
        ],
      ),
    );
  }
}

class _CadGrid extends CustomPainter {
  const _CadGrid();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRect(Offset.zero & size, bg);
    final grid = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
      final x = size.width * i / 5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
