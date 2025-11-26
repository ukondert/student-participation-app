import 'negative_behavior.dart';
import 'participation.dart';
import 'protocol_session.dart';

/// View model combining participation data with related entities for display.
/// This reduces UI complexity by pre-joining related data.
class ParticipationWithDetails {
  final Participation participation;
  final String description;
  final ProtocolSession? session;
  final NegativeBehavior? behavior;

  ParticipationWithDetails({
    required this.participation,
    required this.description,
    this.session,
    this.behavior,
  });

  factory ParticipationWithDetails.fromJson(Map<String, dynamic> json) {
    return ParticipationWithDetails(
      participation: Participation.fromJson(
          json['participation'] as Map<String, dynamic>),
      description: json['description'] as String,
      session: json['session'] != null
          ? ProtocolSession.fromJson(json['session'] as Map<String, dynamic>)
          : null,
      behavior: json['behavior'] != null
          ? NegativeBehavior.fromJson(json['behavior'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participation': participation.toJson(),
      'description': description,
      'session': session?.toJson(),
      'behavior': behavior?.toJson(),
    };
  }
}
