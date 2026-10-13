// Shared UI: tower-crane wind safety card.
// Ports: TowerCraneWindWidget.kt — sustained/gust tiles, 0–50 gauge,
// triple-state regulatory banner, secondary metrics, simulation presets
// and optional HUB opener. Thresholds mirror the reference (km/h):
// caution ≥30 (gust ≥38), mandatory stop ≥38 (gust ≥45).
// Labels resolve from JSON; legacy windMs/allowed ctor preserved.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';

class CraneWindWidget extends StatelessWidget {
  final double windMs;
  final bool allowed;
  final String craneId;
  final double craneElevationMeters;
  final double gustMs;
  final int directionDegrees;
  final double tempC;
  final int humidity;
  final VoidCallback? onOpenHub;
  const CraneWindWidget({
    super.key,
    required this.windMs,
    required this.allowed,
    this.craneId = 'TC-01',
    this.craneElevationMeters = 185,
    this.gustMs = 0,
    this.directionDegrees = 315,
    this.tempC = 34.5,
    this.humidity = 52,
    this.onOpenHub,
  });

  double get _kmh => windMs * 3.6;
  double get _gustKmh => (gustMs == 0 ? windMs * 1.25 : gustMs) * 3.6;
  bool get _stop => _kmh >= 38 || _gustKmh >= 45;
  bool get _caution => !(_stop) && (_kmh >= 30 || _gustKmh >= 38);

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final bannerColor = _stop
        ? Colors.red
        : (_caution ? Colors.amber : Colors.green);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Row(children: [
            Icon(_stop ? Icons.warning : Icons.air,
                color: bannerColor),
            const SizedBox(width: 6),
            Expanded(
                child: Text(loc.t('widgets.crane_title'),
                    style: Theme.of(context).textTheme.titleSmall)),
            Text('[$craneId]'),
          ]),
          Text(loc.t('widgets.crane_code'),
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _SpeedTile(
                title: loc.t('widgets.crane_sustained'),
                value: _kmh,
                limit: loc.t('widgets.crane_max38'))),
            Expanded(child: _SpeedTile(
                title: loc.t('widgets.crane_gust'),
                value: _gustKmh,
                limit: loc.t('widgets.crane_max45'))),
          ]),
          const SizedBox(height: 8),
          _Gauge(kmh: _kmh),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0 ${loc.t('widgets.crane_calm')}',
                    style: Theme.of(context).textTheme.labelSmall),
                Text('30 ${loc.t('widgets.crane_caution')}',
                    style: Theme.of(context).textTheme.labelSmall),
                Text('38 ${loc.t('widgets.crane_stop_limit')}',
                    style: Theme.of(context).textTheme.labelSmall),
              ]),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: bannerColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              loc.t(_stop
                  ? 'widgets.crane_banner_stop'
                  : (_caution
                      ? 'widgets.crane_banner_caution'
                      : 'widgets.crane_banner_safe')),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 12, children: [
            Text('${loc.t('widgets.crane_jib')} $craneElevationMeters m'),
            Text('${loc.t('widgets.crane_dir')} $directionDegrees°'),
            Text('$tempC°C'),
            Text('$humidity%'),
          ]),
          if (!allowed)
            Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(loc.t('widgets.crane_stop'),
                    style: const TextStyle(color: Colors.red))),
          if (onOpenHub != null)
            TextButton(
                onPressed: onOpenHub,
                child: Text(loc.t('widgets.crane_open_hub'))),
        ]),
      ),
    );
  }
}

class _SpeedTile extends StatelessWidget {
  final String title;
  final double value;
  final String limit;
  const _SpeedTile(
      {required this.title, required this.value, required this.limit});
  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            Text(value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleLarge),
            Text(limit, style: Theme.of(context).textTheme.labelSmall),
          ]),
        ),
      );
}

class _Gauge extends StatelessWidget {
  final double kmh;
  const _Gauge({required this.kmh});
  @override
  Widget build(BuildContext context) {
    final ratio = (kmh / 50).clamp(0.0, 1.0);
    final color = kmh >= 38
        ? Colors.red
        : (kmh >= 30 ? Colors.amber : Colors.cyan);
    return LinearProgressIndicator(
        value: ratio,
        minHeight: 10,
        borderRadius: BorderRadius.circular(6),
        backgroundColor: Colors.grey.withValues(alpha: 0.25),
        valueColor: AlwaysStoppedAnimation(color));
  }
}
