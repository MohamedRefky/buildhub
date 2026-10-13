// Shared UI: daily site-log card.
// Ports: DailySiteLogCard.kt — header + add button + search + category
// filters + counter + list (first 5) + empty state + add dialog with
// weather snapshot, voice note and photo note. Labels resolve from JSON.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/home/domain/entities/home_entities.dart';
import 'voice_recording_section.dart';

const logCategories = [
  'ALL',
  'PROGRESS',
  'SAFETY',
  'INSPECTION',
  'WEATHER',
  'GENERAL',
];

String _categoryKey(String c) => switch (c) {
      'PROGRESS' => 'widgets.log_progress',
      'SAFETY' => 'widgets.log_safety',
      'INSPECTION' => 'widgets.log_inspection',
      'WEATHER' => 'widgets.log_weather',
      'GENERAL' => 'widgets.log_general',
      _ => 'widgets.log_all',
    };

class DailySiteLogCard extends StatefulWidget {
  final String projectId;
  final List<DailySiteLog> logs;
  final void Function(DailySiteLog log) onAddLog;
  final void Function(String id) onDeleteLog;
  const DailySiteLogCard({
    super.key,
    required this.projectId,
    required this.logs,
    required this.onAddLog,
    required this.onDeleteLog,
  });
  @override
  State<DailySiteLogCard> createState() => _DailySiteLogCardState();
}

class _DailySiteLogCardState extends State<DailySiteLogCard> {
  String _query = '';
  String _filter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final q = _query.trim().toLowerCase();
    final filtered = widget.logs.where((l) {
      final matchesFilter = _filter == 'ALL' || l.category == _filter;
      final matchesQuery = q.isEmpty ||
          l.summaryAr.toLowerCase().contains(q) ||
          l.summaryEn.toLowerCase().contains(q) ||
          l.note.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList();
    final shown = filtered.take(5).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Text(loc.t('widgets.log_title'),
                        style:
                            Theme.of(context).textTheme.titleMedium)),
                ElevatedButton(
                    onPressed: () => _showAddDialog(context, loc),
                    child: Text(loc.t('widgets.log_add'))),
              ]),
              Text(loc.t('widgets.log_sub'),
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: loc.t('widgets.log_search'),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                  spacing: 6,
                  children: logCategories
                      .map((c) => FilterChip(
                          label: Text(loc.t(_categoryKey(c))),
                          selected: _filter == c,
                          onSelected: (_) =>
                              setState(() => _filter = c)))
                      .toList()),
              const SizedBox(height: 4),
              Text(
                  '${loc.t('widgets.log_shown')} (${shown.length}/${filtered.length})',
                  style: Theme.of(context).textTheme.labelSmall),
              if (shown.isEmpty)
                Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(loc.t('widgets.log_empty')))
              else
                ...shown.map((l) => _LogItemCard(
                    log: l,
                    onDelete: () => widget.onDeleteLog(l.id))),
            ]),
      ),
    );
  }

  Future<void> _showAddDialog(
      BuildContext context, AppLocalization loc) async {
    final noteCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    var category = 'PROGRESS';
    var attachWeather = true;
    var photoAttached = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          title: Text(loc.t('widgets.log_dialog_title')),
          content: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${loc.t('widgets.log_date')} ${DateTime.now().toIso8601String().substring(0, 16).replaceAll('T', ' ')}'),
                  CheckboxListTile(
                      title: Text(loc.t('widgets.log_weather_line')),
                      value: attachWeather,
                      onChanged: (v) => setDialog(
                          () => attachWeather = v ?? true)),
                  Text(loc.t('widgets.log_category')),
                  Wrap(
                      spacing: 6,
                      children: logCategories
                          .where((c) => c != 'ALL')
                          .map((c) => ChoiceChip(
                              label: Text(loc.t(_categoryKey(c))),
                              selected: category == c,
                              onSelected: (_) =>
                                  setDialog(() => category = c)))
                          .toList()),
                  TextField(
                      controller: noteCtrl,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: loc.t('widgets.log_hint'))),
                  VoiceRecordingSection(
                      onTranscriptReady: (t) => setDialog(
                          () => noteCtrl.text = '${noteCtrl.text} $t')),
                  Row(children: [
                    Expanded(
                        child: Text(photoAttached
                            ? loc.t('widgets.log_photo_done')
                            : loc.t('widgets.log_photo'))),
                    IconButton(
                        icon: Icon(photoAttached
                            ? Icons.check_circle
                            : Icons.camera_alt),
                        onPressed: () =>
                            setDialog(() => photoAttached = true)),
                  ]),
                  TextField(
                      controller: authorCtrl,
                      decoration: InputDecoration(
                          labelText: loc.t('widgets.log_engineer'))),
                ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(loc.t('common.cancel'))),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(loc.t('widgets.log_save'))),
          ],
        ),
      ),
    );
    if (ok == true && noteCtrl.text.trim().isNotEmpty) {
      widget.onAddLog(DailySiteLog(
        id: const Uuid().v4(),
        projectId: widget.projectId,
        dateStr: DateTime.now().toIso8601String().substring(0, 10),
        timestamp: DateTime.now().toIso8601String(),
        summaryAr: noteCtrl.text.trim(),
        summaryEn: noteCtrl.text.trim(),
        note: noteCtrl.text.trim(),
        category: category,
        author: authorCtrl.text.trim(),
        photoUri: photoAttached ? 'attached://photo' : '',
        weatherSnapshot: attachWeather ? '42°C • 56% RH • Midday 12:30-3:00' : '',
        manpower: 0,
        equipmentCount: 0,
      ));
    }
  }
}

class _LogItemCard extends StatelessWidget {
  final DailySiteLog log;
  final VoidCallback onDelete;
  const _LogItemCard({required this.log, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Chip(label: Text(loc.t(_categoryKey(log.category)))),
            const Spacer(),
            Text(log.timestamp.isEmpty ? log.dateStr : log.timestamp,
                style: Theme.of(context).textTheme.labelSmall),
            IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: onDelete),
          ]),
          Text(loc.tr(log.summaryAr, log.summaryEn)),
          if (log.weatherSnapshot.isNotEmpty)
            Text('☀️ ${log.weatherSnapshot}',
                style: Theme.of(context).textTheme.labelSmall),
          if (log.photoUri.isNotEmpty)
            Chip(
                avatar: const Icon(Icons.photo, size: 14),
                label: Text(loc.t('widgets.log_photo_verified'))),
          Row(children: [
            Expanded(
                child: Text(
                    '${log.author} • ${loc.t('widgets.log_verified')}',
                    style: Theme.of(context).textTheme.labelSmall)),
          ]),
        ]),
      ),
    );
  }
}
