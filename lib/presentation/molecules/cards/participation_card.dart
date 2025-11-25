import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/entities.dart';

/// Card molecule displaying a single participation entry.
/// Shows participation type (positive/negative), description, date and optional session topic.
class ParticipationCard extends StatelessWidget {
  final Participation participation;
  final String description;
  final ProtocolSession? session;

  const ParticipationCard({
    super.key,
    required this.participation,
    required this.description,
    this.session,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd.MM.yyyy HH:mm').format(participation.date);
    final backgroundColor =
        participation.isPositive ? Colors.green.shade50 : Colors.red.shade50;

    // Build subtitle with date and optional session topic
    String subtitle = dateStr;
    if (session?.topic != null && session!.topic!.isNotEmpty) {
      subtitle += ' • ${session!.topic}';
    }

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: participation.isPositive ? Colors.green : Colors.red,
          child: Icon(
            participation.isPositive ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          description,
          style: TextStyle(
            color: participation.isPositive
                ? Colors.green.shade900
                : Colors.red.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: participation.isPositive
                ? Colors.green.shade700
                : Colors.red.shade700,
          ),
        ),
      ),
    );
  }
}
