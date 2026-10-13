// Shared UI: generic status card (title + value).
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const StatusCard({super.key, required this.title, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Card(
    color: color.withValues(alpha: 0.12),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.labelSmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ]),
    ),
  );
}
